import {
  BadRequestException,
  Injectable,
  Logger,
  NotFoundException,
  UnprocessableEntityException
} from '@nestjs/common';
import { UserPayload } from '../auth/get-user.decorator';
import { CreateReservationDto, CreateReservationProductDto } from './reservation.dto';
import { CreateDocumentDefinition, Model, Types } from 'mongoose';
import { Reservation } from './reservation.schema';
import { InjectModel } from '@nestjs/mongoose';
import { UsersService } from '../users/users.service';
import { Product } from '../products/product.schema';
import { Ticket } from '../seats/ticket.schema';
import { checkCompletedLogin, checkStaffPermission, getSkipLimit } from '../common/utils';
import { Seat } from '../seats/seat.schema';
import { Stripe } from 'stripe';
import { AppGateway } from '../socket/app.gateway';
import { PromotionsService } from '../promotions/promotions.service';
import { Promotion } from '../promotions/promotion.schema';
import { User } from '../users/user.schema';
import { NotificationsService } from '../notifications/notifications.service';
import { MailerService } from '@nestjs-modules/mailer';
import { ShowTime } from '../show-times/show-time.schema';
import { Movie } from '../movies/movie.schema';
import { generateQRCode } from '../common/qrcode';
import { PaginationDto } from '../common/pagination.dto';

export type CreatedReservation =
    Omit<Reservation, 'show_time'>
    & { show_time: Omit<ShowTime, 'movie'> & { movie: Movie } };

@Injectable()
export class ReservationsService {
  private readonly logger = new Logger('ReservationsService');

  constructor(
      @InjectModel(Reservation.name) private readonly reservationModel: Model<Reservation>,
      @InjectModel(Product.name) private readonly productModel: Model<Product>,
      @InjectModel(Ticket.name) private readonly ticketModel: Model<Ticket>,
      @InjectModel(ShowTime.name) private readonly showTimeModel: Model<ShowTime>,
      private readonly usersService: UsersService,
      private readonly appGateway: AppGateway,
      private readonly promotionsService: PromotionsService,
      private readonly notificationsService: NotificationsService,
      private readonly mailerService: MailerService,
  ) {}

  async createReservation(
      userPayload: UserPayload,
      dto: CreateReservationDto,
  ): Promise<Reservation> {
    this.logger.debug(`createReservation: ${JSON.stringify(dto)}`);

    const user = checkCompletedLogin(userPayload);
    this.logger.debug(`[1] completed login`);

    const products = await this.checkProduct(dto.products);
    this.logger.debug(`[2] check product`);

    const card = await this.usersService.getCardById(userPayload, dto.pay_card_id);
    this.logger.debug(`[3] check card`);

    const ticketIds = dto.ticket_ids.map(id => new Types.ObjectId(id));
    const tickets = await this.checkSeats(ticketIds);
    this.logger.debug(`[4] check tickets`);

    const original_price = ReservationsService.calculateOriginalPrice(products, tickets);
    const { total_price, promotion } = await this.applyPromotionIfNeeded(original_price, dto.promotion_id, user);
    this.logger.debug(`[5] ${dto.promotion_id} ${original_price} -> ${total_price}`);

    const paymentIntent = await this.usersService.charge(
        card,
        total_price,
        'vnd',
    );
    this.logger.debug(`[6] charged`);

    const reservation = await this.saveAndUpdate({
      dto,
      total_price,
      user,
      paymentIntent,
      ticketIds,
      promotion,
      original_price,
    });
    const data: Record<string, Reservation> = ticketIds.reduce(
        (acc, e) => ({
          ...acc,
          [e.toHexString()]: reservation,
        }),
        {},
    );
    this.appGateway.server
        .to(`reservation:${dto.show_time_id}`)
        .emit('reserved', data);

    this.sendMailAndPushNotification({ user, reservation, dto, tickets });

    this.logger.debug(`[8] returns...`);
    return reservation;
  }

  private sendMailAndPushNotification(
      info: {
        user: User,
        reservation: CreatedReservation,
        dto: CreateReservationDto,
        tickets: Ticket[],
      }
  ) {
    const { user, reservation, dto, tickets } = info;
    this.logger.debug(`>>>>>>>>>>>>>> ${JSON.stringify(reservation)}`);

    this.notificationsService
        .pushNotification(user, reservation)
        .catch((e) => this.logger.debug(`Push notification error: ${e}`));

    generateQRCode(
        {
          reservation_id: reservation._id.toHexString(),
          show_time_id: reservation.show_time._id.toHexString(),
          ticket_ids: tickets.map(t => t._id.toHexString()),
          user_id: reservation.user._id.toHexString(),
        }
    ).then(qrcode =>
        this.mailerService.sendMail(
            {
              to: dto.email,
              subject: `Tickets for movie: ${reservation.show_time.movie.title}`,
              template: 'mail',
              context: { reservation: reservation.toJSON(), tickets: tickets.map(t => t.toJSON()) },
              attachments: [
                {
                  filename: 'qrcode.png',
                  content: qrcode.split('base64,')[1],
                  encoding: 'base64'
                } as any,
              ]
            }
        )
    ).then(() => this.logger.debug(`Send mail success`))
        .catch((e) => this.logger.debug(`Send mail failed: ${e}`));
  }

  private static calculateOriginalPrice(products: { product: Product; quantity: number }[], tickets: Ticket[]) {
    const price = tickets.reduce((acc, e) => acc + e.price, 0) +
        products.reduce((acc, e) => acc + e.product.price * e.quantity, 0);
    return Math.ceil(price);
  }

  private async saveAndUpdate(
      info: {
        dto: CreateReservationDto,
        total_price: number,
        user: User,
        paymentIntent: Stripe.PaymentIntent,
        ticketIds: any[],
        promotion: Promotion | null,
        original_price: number,
      }
  ): Promise<CreatedReservation> {
    const { dto, original_price, paymentIntent, user, total_price, ticketIds, promotion } = info;

    const session = await this.ticketModel.db.startSession();
    try {
      session.startTransaction();

      const doc: Omit<CreateDocumentDefinition<Reservation>, '_id'> = {
        email: dto.email,
        is_active: true,
        original_price,
        phone_number: dto.phone_number,
        products: dto.products.map(p => ({
          id: new Types.ObjectId(p.product_id),
          quantity: p.quantity,
        })),
        total_price,
        show_time: new Types.ObjectId(dto.show_time_id),
        user: user._id,
        payment_intent_id: paymentIntent.id,
      };
      if (promotion) {
        doc.promotion_id = promotion._id;
      }

      // eslint-disable-next-line @typescript-eslint/ban-ts-ignore
      // @ts-ignore
      let reservation = await this.reservationModel.create(
          // eslint-disable-next-line @typescript-eslint/ban-ts-ignore
          [doc], // @ts-ignore
          { session },
      ).then(v => v[0]);

      for (const id of ticketIds) {
        const updated = await this.ticketModel.findOneAndUpdate(
            { _id: id, reservation: null },
            { reservation: reservation._id },
            { session },
        );
        if (!updated) {
          throw new Error(`Ticket already reserved`);
        }
      }

      if (promotion) {
        await this.promotionsService.markUsed(promotion, user);
      }

      reservation = await reservation
          .populate('user')
          .populate({
            path: 'show_time',
            populate: [
              { path: 'movie' },
              { path: 'theatre' },
            ],
          })
          .execPopulate();

      await session.commitTransaction();
      session.endSession();

      this.logger.debug(`[7] done ${JSON.stringify(reservation)}`);
      return reservation;
    } catch (e) {
      await session.abortTransaction();
      session.endSession();

      this.logger.debug(`[7] error ${e}`);
      throw new UnprocessableEntityException(e.message ?? `Cannot create reservation`);
    }
  }

  private async checkProduct(products: CreateReservationProductDto[]): Promise<{ product: Product; quantity: number }[]> {
    const productWithQuantity: { product: Product, quantity: number }[] = [];

    for (const p of products) {
      const product = await this.productModel.findById(p.product_id);
      if (!product) {
        throw new NotFoundException(`Not found product with id: ${p.product_id}`);
      }
      productWithQuantity.push({ product, quantity: p.quantity });
    }

    return productWithQuantity;
  }

  private async checkSeats(ticketIds: any[]): Promise<Ticket[]> {
    // const invalidTickets = await this.ticketModel.find({
    //   $and: [
    //     { _id: { $in: ticketIds } },
    //     { reservation: { $ne: null } },
    //   ]
    // }).populate('seat');

    const tickets = await this.ticketModel.find({ _id: { $in: ticketIds } }).populate('seat');
    const invalidTickets = tickets.filter(t => !!t.reservation);

    if (invalidTickets.length > 0) {
      const seats = invalidTickets.map(t => {
        const seat = (t.seat as Seat);
        return `${seat.row}${seat.column}`;
      }).join(', ');

      throw new UnprocessableEntityException(`Tickets already reserved: ${seats}`);
    }

    return tickets;
  }

  private async applyPromotionIfNeeded(
      original_price: number,
      promotion_id: string | null | undefined,
      user: User
  ): Promise<{ total_price: number; promotion: Promotion | null }> {
    let total_price = original_price;
    let promotion: Promotion | null = null;

    if (promotion_id) {
      promotion = await this.promotionsService.checkValid(promotion_id, user);

      if (promotion) {
        total_price = total_price * (1 - promotion.discount);
      } else {
        throw new BadRequestException('Invalid promotion');
      }
    }

    return { total_price: Math.ceil(total_price), promotion };
  }

  async getReservations(userPayload: UserPayload, dto: PaginationDto) {
    const { _id } = checkCompletedLogin(userPayload);
    const { skip, limit } = getSkipLimit(dto);

    const results = await this.reservationModel.aggregate([
      { $match: { user: new Types.ObjectId(_id) } },
      { $sort: { createdAt: -1 } },
      { $skip: skip },
      { $limit: limit },
      {
        $lookup: {
          from: 'show_times',
          localField: 'show_time',
          foreignField: '_id',
          as: 'show_time',
        }
      },
      { $unwind: '$show_time' },
      {
        $lookup: {
          from: 'movies',
          localField: 'show_time.movie',
          foreignField: '_id',
          as: 'show_time.movie',
        }
      },
      { $unwind: '$show_time.movie' },
      {
        $lookup: {
          from: 'theatres',
          localField: 'show_time.theatre',
          foreignField: '_id',
          as: 'show_time.theatre',
        }
      },
      { $unwind: '$show_time.theatre' },
      {
        $lookup: {
          from: 'promotions',
          localField: 'promotion_id',
          foreignField: '_id',
          as: 'promotion_id',
        }
      },
      {
        $unwind: {
          path: '$promotion_id',
          preserveNullAndEmptyArrays: true,
        }
      },
      {
        $lookup: {
          from: 'products',
          localField: 'products.id',
          foreignField: '_id',
          as: 'product_objects',
        }
      },
      {
        $lookup: {
          from: 'tickets',
          localField: '_id',
          foreignField: 'reservation',
          as: 'tickets',
        }
      },
      {
        $lookup: {
          from: 'seats',
          localField: 'tickets.seat',
          foreignField: '_id',
          as: 'seats',
        },
      },
    ]).exec();

    return results.map(item => {

      item.products = item.product_objects?.map(prodObj => {
        return {
          product_id: prodObj,
          quantity: item.products.find(p => p.id.toHexString() === prodObj._id.toHexString()).quantity,
        };
      }) ?? [];
      delete item.product_objects;

      item.tickets = item.tickets?.map(ticket => {
        ticket.seat = item.seats.find(s => s._id.toHexString() === ticket.seat.toHexString());
        return ticket;
      }) ?? [];
      delete item.seats;

      return item;
    });

    // return await this.reservationModel
    //     .find({ user: _id })
    //     .sort({ createdAt: -1 })
    //     .skip(skip)
    //     .limit(limit)
    //     .populate({
    //       path: 'show_time',
    //       populate: [
    //         { path: 'movie' },
    //         { path: 'theatre' },
    //       ],
    //     })
    //     .populate({
    //       path: 'products',
    //       populate: 'id'
    //     })
    //     .populate('promotion_id')
    //     .exec();
  }

  async getQrCode(id: string, userPayload: UserPayload): Promise<string> {
    const reservation = await this.reservationModel.findById(id).populate('show_time');
    const tickets = await this.ticketModel.find({ reservation: reservation._id });

    return generateQRCode(
        {
          reservation_id: reservation._id.toHexString(),
          show_time_id: reservation.show_time._id.toHexString(),
          ticket_ids: tickets.map(t => t._id.toHexString()),
          user_id: checkCompletedLogin(userPayload)._id.toHexString(),
        }
    )
  }

  async seed() {
    const rs: Reservation[] = await this.reservationModel
        .find({}, { original_price: 1, total_price: 1 })
        .exec();

    return rs;

    // for (const r of rs) {
    //   if (Number.isSafeInteger(r.original_price) && Number.isSafeInteger(r.total_price)) {
    //     continue;
    //   }
    //
    //   this.logger.debug(r);
    //   await this.reservationModel.updateOne({_id: r._id}, {
    //     original_price: Math.ceil(r.original_price),
    //     total_price: Math.ceil(r.total_price),
    //   });
    // }
    //
    // return 'DONE';
  }

  async getReservationsByShowTimeId(show_time_id: string, userPayload: UserPayload) {
    const showTime = await this.showTimeModel.findById(show_time_id);
    if (!showTime) {
      throw new NotFoundException();
    }
    checkStaffPermission(userPayload, showTime.theatre._id.toString());

    const results = await this.reservationModel.aggregate([
      { $match: { show_time: showTime._id } },
      { $sort: { createdAt: -1 } },
      {
        $lookup: {
          from: 'show_times',
          localField: 'show_time',
          foreignField: '_id',
          as: 'show_time',
        }
      },
      { $unwind: '$show_time' },
      {
        $lookup: {
          from: 'movies',
          localField: 'show_time.movie',
          foreignField: '_id',
          as: 'show_time.movie',
        }
      },
      { $unwind: '$show_time.movie' },
      {
        $lookup: {
          from: 'theatres',
          localField: 'show_time.theatre',
          foreignField: '_id',
          as: 'show_time.theatre',
        }
      },
      { $unwind: '$show_time.theatre' },
      {
        $lookup: {
          from: 'promotions',
          localField: 'promotion_id',
          foreignField: '_id',
          as: 'promotion_id',
        }
      },
      {
        $unwind: {
          path: '$promotion_id',
          preserveNullAndEmptyArrays: true,
        }
      },
      {
        $lookup: {
          from: 'products',
          localField: 'products.id',
          foreignField: '_id',
          as: 'product_objects',
        }
      },
      {
        $lookup: {
          from: 'tickets',
          localField: '_id',
          foreignField: 'reservation',
          as: 'tickets',
        }
      },
      {
        $lookup: {
          from: 'seats',
          localField: 'tickets.seat',
          foreignField: '_id',
          as: 'seats',
        },
      },
      {
        $lookup: {
          from: 'users',
          localField: 'user',
          foreignField: '_id',
          as: 'user',
        },
      },
      { $unwind: '$user' },
    ]).exec();

    return results.map(item => {

      item.products = item.product_objects?.map(prodObj => {
        return {
          product_id: prodObj,
          quantity: item.products.find(p => p.id.toHexString() === prodObj._id.toHexString()).quantity,
        };
      }) ?? [];
      delete item.product_objects;

      item.tickets = item.tickets?.map(ticket => {
        ticket.seat = item.seats.find(s => s._id.toHexString() === ticket.seat.toHexString());
        return ticket;
      }) ?? [];
      delete item.seats;

      return item;
    });
  }

  async getReservationById(userPayload: UserPayload, id: string) {
    const user = checkCompletedLogin(userPayload);

    const match = user.role === 'USER'
        ? {
          $and: [
            { _id: new Types.ObjectId(id) },
            { user: new Types.ObjectId(user.id) },
          ],
        }
        : { _id: new Types.ObjectId(id) };

    const results = await this.reservationModel.aggregate([
      {
        $match: match,
      },
      { $limit: 1 },
      {
        $lookup: {
          from: 'show_times',
          localField: 'show_time',
          foreignField: '_id',
          as: 'show_time',
        }
      },
      { $unwind: '$show_time' },
      {
        $lookup: {
          from: 'movies',
          localField: 'show_time.movie',
          foreignField: '_id',
          as: 'show_time.movie',
        }
      },
      { $unwind: '$show_time.movie' },
      {
        $lookup: {
          from: 'theatres',
          localField: 'show_time.theatre',
          foreignField: '_id',
          as: 'show_time.theatre',
        }
      },
      { $unwind: '$show_time.theatre' },
      {
        $lookup: {
          from: 'promotions',
          localField: 'promotion_id',
          foreignField: '_id',
          as: 'promotion_id',
        }
      },
      {
        $unwind: {
          path: '$promotion_id',
          preserveNullAndEmptyArrays: true,
        }
      },
      {
        $lookup: {
          from: 'products',
          localField: 'products.id',
          foreignField: '_id',
          as: 'product_objects',
        }
      },
      {
        $lookup: {
          from: 'tickets',
          localField: '_id',
          foreignField: 'reservation',
          as: 'tickets',
        }
      },
      {
        $lookup: {
          from: 'seats',
          localField: 'tickets.seat',
          foreignField: '_id',
          as: 'seats',
        },
      },
    ]).exec();

    const item = results?.[0];
    if (!item) {
      throw new NotFoundException(`Reservation with id ${id} not found`);
    }

    try {
      checkStaffPermission(userPayload, item.show_time.theatre._id.toString());
    } catch (e) {
      throw new BadRequestException(e.message);
    }

    item.products = item.product_objects?.map(prodObj => {
      return {
        product_id: prodObj,
        quantity: item.products.find(p => p.id.toHexString() === prodObj._id.toHexString()).quantity,
      };
    }) ?? [];
    delete item.product_objects;

    item.tickets = item.tickets?.map(ticket => {
      ticket.seat = item.seats.find(s => s._id.toHexString() === ticket.seat.toHexString());
      return ticket;
    }) ?? [];
    delete item.seats;

    return item;
  }
}
