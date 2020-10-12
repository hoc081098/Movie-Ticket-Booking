import { Model } from 'mongoose';
import { User } from './user.schema';
import { UpdateUserDto } from './update-user.dto';
import { UserPayload } from '../auth/get-user.decorator';
import { Stripe } from 'stripe';
import { ConfigService } from '../config/config.service';
import { AddCardDto, Card } from './cards/card.dto';
import { FirebaseAuthenticationService } from '@aginix/nestjs-firebase-admin/dist';
import { PaginationDto } from '../common/pagination.dto';
export declare class UsersService {
    readonly userModel: Model<User>;
    private readonly firebaseAuthenticationService;
    private readonly stripe;
    private readonly logger;
    constructor(userModel: Model<User>, configService: ConfigService, firebaseAuthenticationService: FirebaseAuthenticationService);
    findByUid(uid: string): Promise<User | undefined>;
    update(user: UserPayload, updateUserDto: UpdateUserDto): Promise<User>;
    private createStripeCustomerIfNeeded;
    private static checkOwner;
    getCards(userPayload: UserPayload): Promise<Card[]>;
    addCard(userPayload: UserPayload, cardDto: AddCardDto): Promise<Card>;
    removeCard(userPayload: UserPayload, cardId: string): Promise<'SUCCESS'>;
    delete(uid: string): Promise<User>;
    getCardById(userPayload: UserPayload, cardId: string): Promise<Stripe.PaymentMethod>;
    charge(card: Stripe.PaymentMethod, amount: number, currency: string): Promise<Stripe.PaymentIntent>;
    getAllUsers(dto: PaginationDto): Promise<User[]>;
}
