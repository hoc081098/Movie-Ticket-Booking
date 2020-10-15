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
      configService: ConfigService,
      private readonly firebaseAuthenticationService: FirebaseAuthenticationService,
  ) {
    this.stripe = new Stripe(
        configService.get(ConfigKey.STRIPE_SECRET_API),
        null
    );
  }

  findByUid(uid: string): Promise<User | undefined> {
    return this.userModel.findOne({ uid }).exec();
  }

  update(user: UserPayload, updateUserDto: UpdateUserDto): Promise<User> {
    const update: Omit<UpdateUserDto, 'location'>
        & UserPayload
        & { is_completed: boolean, location?: Location | number[] } = {
      ...updateUserDto,
      ...user,
      'is_completed': true,
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
    const result = await this.userModel.findOneAndDelete({ uid });

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
        .exec();
  }

  async blockUser(uid: string): Promise<User> {
    return await this.userModel.findOneAndUpdate(
        { uid },
        { is_active: false },
        { new: true },
    ).exec();
  }
}
