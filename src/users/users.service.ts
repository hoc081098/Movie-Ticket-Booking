import { BadRequestException, HttpException, HttpStatus, Injectable, Logger, NotFoundException } from '@nestjs/common';
import { Model } from 'mongoose';
import { User } from './user.schema';
import { InjectModel } from '@nestjs/mongoose';
import { UpdateUserDto } from './update-user.dto';
import { UserPayload } from '../auth/get-user.decorator';
import { Location } from '../common/location.inteface';
import { Stripe } from 'stripe';
import { ConfigKey, ConfigService } from '../config/config.service';
import { AddCardDto, Card } from './cards/card.dto';
import { FirebaseAuthenticationService } from '@aginix/nestjs-firebase-admin/dist';
import { checkCompletedLogin, getSkipLimit } from '../common/utils';
import { PaginationDto } from '../common/pagination.dto';
import * as faker from 'faker';
import { defer, of, range } from 'rxjs';
import { catchError, concatMap, exhaustMap, ignoreElements, tap } from 'rxjs/operators';
import { Movie } from "../movies/movie.schema";
import dayjs = require('dayjs');
import { Theatre } from "../theatres/theatre.schema";

function paymentMethodToCardDto(paymentMethod: Stripe.PaymentMethod): Card {
  const card = paymentMethod.card;

  return new Card({
    brand: card.brand,
    card_holder_name: paymentMethod.billing_details.name,
    country: card.country,
    exp_month: card.exp_month,
    exp_year: card.exp_year,
    funding: card.funding,
    id: paymentMethod.id,
    last4: card.last4,
  });
}

@Injectable()
export class UsersService {
  private readonly stripe: Stripe;
  private readonly logger = new Logger('UsersService');

  constructor(
      @InjectModel(User.name) readonly userModel: Model<User>,
      @InjectModel(Movie.name) readonly movieModel: Model<Movie>,
      @InjectModel(Theatre.name) readonly theatreModel: Model<Theatre>,
      configService: ConfigService,
      private readonly firebaseAuthenticationService: FirebaseAuthenticationService,
  ) {
    this.stripe = new Stripe(
        configService.get(ConfigKey.STRIPE_SECRET_API),
        null
    );
  }

  findByUid(uid: string): Promise<User | undefined> {
    return this.userModel.findOne({ uid })
        .populate('theatre')
        .exec();
  }

  update(user: UserPayload, updateUserDto: UpdateUserDto): Promise<User> {
    const update: Omit<UpdateUserDto, 'location'>
        & UserPayload
        & { is_completed: boolean, location?: Location | number[], role: string } = {
      ...updateUserDto,
      ...user,
      'is_completed': true,
      role: 'USER',
    };

    const numbers: number[] = updateUserDto.location;
    if (numbers) {
      update.location = {
        type: 'Point',
        coordinates: [
          numbers[0],
          numbers[1]
        ],
      };
    }

    return this.userModel
        .findOneAndUpdate(
            { uid: user.uid },
            update as Partial<Pick<User, keyof User>>,
            { upsert: true, new: true }
        )
        .exec();
  }

  private async createStripeCustomerIfNeeded(user: UserPayload): Promise<User> {
    const entity = checkCompletedLogin(user);

    if (entity.stripe_customer_id) {
      return entity;
    }

    const customer = await this.stripe.customers.create({ email: user.email });

    return this.userModel.findOneAndUpdate(
        { uid: user.uid },
        { stripe_customer_id: customer.id },
        { new: true },
    ).exec();
  }

  private static checkOwner(paymentMethod: Stripe.PaymentMethod, userPayload: UserPayload): boolean {
    if (!paymentMethod || !paymentMethod.customer) {
      return false;
    }

    if (typeof paymentMethod.customer === 'string') {
      if (paymentMethod.customer === userPayload.user_entity.stripe_customer_id) {
        return true;
      }
    } else if (paymentMethod.customer.id === userPayload.user_entity.stripe_customer_id) {
      return true;
    }

    return false;
  }

  async getCards(userPayload: UserPayload): Promise<Card[]> {
    const user = await this.createStripeCustomerIfNeeded(userPayload);
    const paymentMethods = await this.stripe.paymentMethods.list({ customer: user.stripe_customer_id, type: 'card' });

    return paymentMethods.data.map(paymentMethodToCardDto);
  }

  async addCard(userPayload: UserPayload, cardDto: AddCardDto): Promise<Card> {
    const user = await this.createStripeCustomerIfNeeded(userPayload);
    this.logger.debug(`addCard ${JSON.stringify(user)} ${JSON.stringify(cardDto)}`);

    let paymentMethod = await this.stripe.paymentMethods.create({
      type: 'card',
      billing_details: {
        name: cardDto.card_holder_name,
      },
      card: {
        number: cardDto.number,
        exp_month: cardDto.exp_month,
        exp_year: cardDto.exp_year,
        cvc: cardDto.cvc,
      },
    });

    paymentMethod = await this.stripe.paymentMethods.attach(paymentMethod.id, { customer: user.stripe_customer_id });
    return paymentMethodToCardDto(paymentMethod);
  }

  async removeCard(userPayload: UserPayload, cardId: string): Promise<'SUCCESS'> {
    const paymentMethod = await this.stripe.paymentMethods.retrieve(cardId);
    if (UsersService.checkOwner(paymentMethod, userPayload)) {
      await this.stripe.paymentMethods.detach(paymentMethod.id);
    }
    return 'SUCCESS';
  }

  async delete(uid: string): Promise<User> {
    const result = await this.userModel.findOneAndDelete({ uid, role: { $ne: 'ADMIN' } }).populate('theatre');

    if (result == null) {
      throw new NotFoundException(`User with uid ${uid} not found`);
    }

    await this.firebaseAuthenticationService.deleteUser(uid);
    return result;
  }

  async getCardById(userPayload: UserPayload, cardId: string): Promise<Stripe.PaymentMethod> {
    const paymentMethod = await this.stripe.paymentMethods.retrieve(cardId);
    if (UsersService.checkOwner(paymentMethod, userPayload)) {
      return paymentMethod;
    }
    throw new BadRequestException(`Invalid payment card: ${cardId}`);
  }

  charge(
      card: Stripe.PaymentMethod,
      amount: number,
      currency: string
  ): Promise<Stripe.PaymentIntent> {
    return this.stripe.paymentIntents
        .create({
          amount,
          currency,
          confirm: true,
          payment_method: card.id,
          customer: typeof card.customer === 'string' ? card.customer : card.customer.id,
        })
        .then(v => {
          this.logger.debug(`Charge ${amount}${currency} success`);
          return v;
        })
        .catch(error => {
          this.logger.debug(`Charge ${amount}${currency} failed: ${JSON.stringify(error)}`);
          return Promise.reject(new HttpException('Charge failed. Please try again', HttpStatus.PAYMENT_REQUIRED));
        });
  }

  getAllUsers(dto: PaginationDto): Promise<User[]> {
    const { limit, skip } = getSkipLimit(dto);

    return this.userModel.find({})
        .sort({ createdAt: -1 })
        .skip(skip)
        .limit(limit)
        .populate('theatre')
        .exec();
  }

  async blockUser(uid: string): Promise<User> {
    return await this.userModel.findOneAndUpdate(
        { uid, role: { $ne: 'ADMIN' } },
        { is_active: false },
        { new: true },
    )
        .populate('theatre')
        .exec();
  }

  updateFcmToken(user: User, fcmToken: string): Promise<User> {
    return this.userModel.findOneAndUpdate(
        { uid: user.uid },
        { $addToSet: { tokens: fcmToken } },
        { new: true },
    ).exec();
  }

  async seedUsers() {
    // Fix theatre_id
    const [allStaffs, theatres] = await Promise.all([
      this.userModel.find({ role: 'STAFF', theatre: null }),
      this.theatreModel.find({}),
    ]);
    this.logger.debug(allStaffs.length);
    this.logger.debug(theatres.length);

    let i = 0;
    for (const s of allStaffs) {
      i = (i + 1) % theatres.length;
      const theatre = theatres[i];
      await this.userModel.updateOne({ _id: s._id }, { theatre: theatre._id }).exec();
    }
    return this.userModel.find({});

    // Fix roles
    return this.userModel.updateMany({ role: null }, { role: 'USER' }).exec();

    // await this.userModel.updateMany({}, { favorite_movie_ids: {} }).exec();
    //
    // const users = await this.userModel
    //     .find({})
    //     .limit(50);
    // for (const user of users) {
    //   const ids = await this.movieModel.find({})
    //       .skip(Math.random() * 100)
    //       .limit(10);
    //   const favorite_movie_ids = ids.reduce((acc, e) => {
    //     return {
    //       ...acc,
    //       [e._id.toHexString()]: new Date(),
    //     }
    //   }, {});
    //   await this.userModel.updateOne({ uid: user.uid }, { favorite_movie_ids }).exec();
    //   for (const id of ids) {
    //     await this.movieModel.updateOne({ _id: id }, { $inc: { total_favorite: 1 } });
    //   }
    // }
    //
    // return;

    // seed users
    return range(0, 300).pipe(
        concatMap(() => {
          return defer(() =>
              this.firebaseAuthenticationService.createUser({
                email: faker.internet.email(),
                emailVerified: false,
                password: 'secretPassword',
                disabled: false,
              })
          ).pipe(
              exhaustMap(userRecord => this.update(
                  new UserPayload(
                      { uid: userRecord.uid, email: userRecord.email }),
                  {
                    address: 'Đà Nẵng City',
                    avatar: faker.internet.avatar(),
                    birthday: dayjs().year(1998)
                        .month(10)
                        .day(8)
                        .toDate(),
                    full_name: faker.name.findName(),
                    gender: 'MALE',
                    location: null,
                    phone_number: '0363438135',
                  }),
              ),
              tap({ error: console.log, next: console.log }),
              catchError((e) => of(e)),
          )
        }),
        ignoreElements(),
    );
  }

  async unblockUser(uid: string): Promise<User> {
    return await this.userModel.findOneAndUpdate(
        { uid, role: { $ne: 'ADMIN' } },
        { is_active: true },
        { new: true },
    )
        .populate('theatre')
        .exec();
  }

  async toStaffRole(uid: string, theatre_id: string): Promise<User> {
    const theatre = await this.theatreModel.findById(theatre_id);
    if (!theatre) {
      throw new BadRequestException(`Theatre not found`);
    }

    const updatedUser = await this.userModel.findOneAndUpdate(
        {
          uid, role: { $ne: 'ADMIN' },
          $or: [
            { is_active: null },
            { is_active: true },
          ]
        },
        { role: 'STAFF', theatre: theatre._id },
        { new: true },
    );
    if (!updatedUser) {
      throw new BadRequestException(`User is not found or user is blocked!`);
    }
    return updatedUser.populate('theatre').execPopulate();
  }

  async toUserRole(uid: string): Promise<User> {
    return await this.userModel.findOneAndUpdate(
        {
          uid,
          role: { $ne: 'ADMIN' },
        },
        { role: 'USER', theatre: null },
        { new: true },
    )
        .populate('theatre')
        .exec();
  }
}
