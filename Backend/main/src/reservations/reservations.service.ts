import { Injectable, Logger, NotFoundException, UnprocessableEntityException } from '@nestjs/common';
import { UserPayload } from '../auth/get-user.decorator';
import { CreateReservationDto } from './reservation.dto';
import { CreateDocumentDefinition, Model, Types } from 'mongoose';
import { Reservation } from './reservation.schema';
import { InjectModel } from '@nestjs/mongoose';
import { UsersService } from '../users/users.service';
import { Product } from '../products/product.schema';
import { Ticket } from '../seats/ticket.schema';
import { Seat } from 'src/seats/seat.schema';
import { checkCompletedLogin } from '../common/utils';

@Injectable()
export class ReservationsService {
  private readonly logger = new Logger('ReservationsService');

  constructor(
      @InjectModel(Reservation.name) private readonly reservationModel: Model<Reservation>,
      @InjectModel(Product.name) private readonly productModel: Model<Product>,
      @InjectModel(Ticket.name) private readonly ticketModel: Model<Ticket>,
      private readonly usersService: UsersService,
  ) {}

  async createReservation(
      userPayload: UserPayload,
      dto: CreateReservationDto,
  ): Promise<Reservation> {
    this.logger.debug(`createReservation: ${JSON.stringify(dto)}`);

    checkCompletedLogin(userPayload);
    this.logger.debug(`[PASSED] completed login`);

    for (const p of dto.products) {
      if (!(await this.productModel.findById(p.product_id))) {
        throw new NotFoundException(`Not found product with id: ${p.product_id}`);
      }
    }
    this.logger.debug(`[PASSED] check product`);

    const card = await this.usersService.getCardById(userPayload, dto.pay_card_id);
    this.logger.debug(`[PASSED] check card`);

    const ticketIds = dto.ticket_ids.map(id => new Types.ObjectId(id));
    const invalidTickets = await this.ticketModel.find({
      $and: [
        { _id: { $in: ticketIds } },
        { reservation: { $ne: null } },
      ]
    }).populate('seat');
    if (invalidTickets.length > 0) {
      const seats = invalidTickets.map(t => {
        const seat = (t.seat as Seat);
        return `${seat.row}${seat.column}`;
      }).join(', ');

      throw new UnprocessableEntityException(`Tickets already reserved: ${seats}`)
    }
    this.logger.debug(`[PASSED] check tickets`);

    //TODO: check price
    const total_price = dto.original_price;

    const paymentIntent = await this.usersService.charge(
        card,
        total_price,
        'vnd',
    );
    this.logger.debug(`[PASSED] charge`);

    const doc: Omit<CreateDocumentDefinition<Reservation>, '_id'> = {
      email: dto.email,
      is_active: true,
      original_price: dto.original_price,
      phone_number: dto.phone_number,
      products: dto.products.map(p => ({
        id: new Types.ObjectId(p.product_id),
        quantity: p.quantity,
      })),
      total_price,
      show_time: new Types.ObjectId(dto.show_time_id),
      user: userPayload.user_entity._id,
      payment_intent_id: paymentIntent.id,
    };
    const reservation = await this.reservationModel.create(doc);
    this.logger.debug(`[PASSED] create done`);

    await this.ticketModel.updateMany(
        { _id: { $in: ticketIds } },
        { reservation: reservation._id },
        {}
    ).exec();
    this.logger.debug(`[PASSED] done`);

    return reservation;
  }
}
