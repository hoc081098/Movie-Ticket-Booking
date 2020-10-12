"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
var UsersService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.UsersService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("mongoose");
const user_schema_1 = require("./user.schema");
const mongoose_2 = require("@nestjs/mongoose");
const stripe_1 = require("stripe");
const config_service_1 = require("../config/config.service");
const card_dto_1 = require("./cards/card.dto");
const dist_1 = require("@aginix/nestjs-firebase-admin/dist");
const utils_1 = require("../common/utils");
function paymentMethodToCardDto(paymentMethod) {
    const card = paymentMethod.card;
    return new card_dto_1.Card({
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
let UsersService = UsersService_1 = class UsersService {
    constructor(userModel, configService, firebaseAuthenticationService) {
        this.userModel = userModel;
        this.firebaseAuthenticationService = firebaseAuthenticationService;
        this.logger = new common_1.Logger('UsersService');
        this.stripe = new stripe_1.Stripe(configService.get("STRIPE_SECRET_API"), null);
    }
    findByUid(uid) {
        return this.userModel.findOne({ uid }).exec();
    }
    update(user, updateUserDto) {
        const update = Object.assign(Object.assign(Object.assign({}, updateUserDto), user), { 'is_completed': true });
        const numbers = updateUserDto.location;
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
            .findOneAndUpdate({ uid: user.uid }, update, { upsert: true, new: true })
            .exec();
    }
    async createStripeCustomerIfNeeded(user) {
        const entity = utils_1.checkCompletedLogin(user);
        if (entity.stripe_customer_id) {
            return entity;
        }
        const customer = await this.stripe.customers.create({ email: user.email });
        return this.userModel.findOneAndUpdate({ uid: user.uid }, { stripe_customer_id: customer.id }, { new: true }).exec();
    }
    static checkOwner(paymentMethod, userPayload) {
        if (!paymentMethod || !paymentMethod.customer) {
            return false;
        }
        if (typeof paymentMethod.customer === 'string') {
            if (paymentMethod.customer === userPayload.user_entity.stripe_customer_id) {
                return true;
            }
        }
        else if (paymentMethod.customer.id === userPayload.user_entity.stripe_customer_id) {
            return true;
        }
        return false;
    }
    async getCards(userPayload) {
        const user = await this.createStripeCustomerIfNeeded(userPayload);
        const paymentMethods = await this.stripe.paymentMethods.list({ customer: user.stripe_customer_id, type: 'card' });
        return paymentMethods.data.map(paymentMethodToCardDto);
    }
    async addCard(userPayload, cardDto) {
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
    async removeCard(userPayload, cardId) {
        const paymentMethod = await this.stripe.paymentMethods.retrieve(cardId);
        if (UsersService_1.checkOwner(paymentMethod, userPayload)) {
            await this.stripe.paymentMethods.detach(paymentMethod.id);
        }
        return 'SUCCESS';
    }
    async delete(uid) {
        const result = await this.userModel.findOneAndDelete({ uid });
        if (result == null) {
            throw new common_1.NotFoundException(`User with uid ${uid} not found`);
        }
        await this.firebaseAuthenticationService.deleteUser(uid);
        return result;
    }
    async getCardById(userPayload, cardId) {
        const paymentMethod = await this.stripe.paymentMethods.retrieve(cardId);
        if (UsersService_1.checkOwner(paymentMethod, userPayload)) {
            return paymentMethod;
        }
        throw new common_1.BadRequestException(`Invalid payment card: ${cardId}`);
    }
    charge(card, amount, currency) {
        return this.stripe.paymentIntents
            .create({
            amount,
            currency,
            confirm: true,
            payment_method: card.id,
            customer: typeof card.customer === 'string' ? card.customer : card.customer.id,
        })
            .catch(error => {
            this.logger.debug(`Charge ${amount}${currency} failed: ${JSON.stringify(error)}`);
            return Promise.reject(new common_1.HttpException('Charge failed. Please try again', common_1.HttpStatus.PAYMENT_REQUIRED));
        });
    }
    getAllUsers(dto) {
        const { limit, skip } = utils_1.getSkipLimit(dto);
        return this.userModel.find({})
            .sort({ createdAt: -1 })
            .skip(skip)
            .limit(limit)
            .exec();
    }
};
UsersService = UsersService_1 = __decorate([
    common_1.Injectable(),
    __param(0, mongoose_2.InjectModel(user_schema_1.User.name)),
    __metadata("design:paramtypes", [mongoose_1.Model,
        config_service_1.ConfigService,
        dist_1.FirebaseAuthenticationService])
], UsersService);
exports.UsersService = UsersService;
//# sourceMappingURL=users.service.js.map