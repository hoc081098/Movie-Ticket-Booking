import { Injectable, Logger } from '@nestjs/common';
import { Model } from 'mongoose';
import { User } from './user.schema';
import { InjectModel } from '@nestjs/mongoose';
import { UpdateUserDto } from './update-user.dto';
import { UserPayload } from '../auth/get-user.decorator';
import { Location } from '../common/location.inteface';
import { Stripe } from 'stripe';
import { ConfigKey, ConfigService } from '../config/config.service';
import { AddCardDto, Card } from './cards/card.dto';

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
      @InjectModel(User.name) private readonly userModel: Model<User>,
      configService: ConfigService
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
    if (user.stripe_customer_id) {
      return this.findByUid(user.uid);
    }

    const customer = await this.stripe.customers.create({ email: user.email });

    return this.userModel.findOneAndUpdate(
        { uid: user.uid },
        { stripe_customer_id: customer.id },
        { new: true },
    ).exec();
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
    if (paymentMethod && paymentMethod.customer === userPayload.stripe_customer_id) {
      await this.stripe.paymentMethods.detach(paymentMethod.id);
    }
    return 'SUCCESS';
  }
}
