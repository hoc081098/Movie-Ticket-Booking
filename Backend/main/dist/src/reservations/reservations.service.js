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
Object.defineProperty(exports, "__esModule", { value: true });
exports.ReservationsService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("mongoose");
const reservation_schema_1 = require("./reservation.schema");
const mongoose_2 = require("@nestjs/mongoose");
const users_service_1 = require("../users/users.service");
const product_schema_1 = require("../products/product.schema");
const ticket_schema_1 = require("../seats/ticket.schema");
const utils_1 = require("../common/utils");
const app_gateway_1 = require("../socket/app.gateway");
let ReservationsService = class ReservationsService {
    constructor(reservationModel, productModel, ticketModel, usersService, appGateway) {
        this.reservationModel = reservationModel;
        this.productModel = productModel;
        this.ticketModel = ticketModel;
        this.usersService = usersService;
        this.appGateway = appGateway;
        this.logger = new common_1.Logger('ReservationsService');
    }
    async createReservation(userPayload, dto) {
        this.logger.debug(`createReservation: ${JSON.stringify(dto)}`);
        utils_1.checkCompletedLogin(userPayload);
        this.logger.debug(`[PASSED] completed login`);
        await this.checkProduct(dto.products);
        this.logger.debug(`[PASSED] check product`);
        const card = await this.usersService.getCardById(userPayload, dto.pay_card_id);
        this.logger.debug(`[PASSED] check card`);
        const ticketIds = dto.ticket_ids.map(id => new mongoose_1.Types.ObjectId(id));
        await this.checkSeats(ticketIds);
        this.logger.debug(`[PASSED] check tickets`);
        const total_price = dto.original_price;
        const paymentIntent = await this.usersService.charge(card, total_price, 'vnd');
        this.logger.debug(`[PASSED] charge`);
        const reservation = await this.saveAndUpdate(dto, total_price, userPayload, paymentIntent, ticketIds);
        const data = ticketIds.reduce((acc, e) => (Object.assign(Object.assign({}, acc), { [e.toHexString()]: reservation.id })), {});
        this.appGateway.server
            .to(`reservation:${dto.show_time_id}`)
            .emit('reserved', data);
        return reservation;
    }
    async saveAndUpdate(dto, total_price, userPayload, paymentIntent, ticketIds) {
        var _a;
        try {
            const doc = {
                email: dto.email,
                is_active: true,
                original_price: dto.original_price,
                phone_number: dto.phone_number,
                products: dto.products.map(p => ({
                    id: new mongoose_1.Types.ObjectId(p.product_id),
                    quantity: p.quantity,
                })),
                total_price,
                show_time: new mongoose_1.Types.ObjectId(dto.show_time_id),
                user: userPayload.user_entity._id,
                payment_intent_id: paymentIntent.id,
            };
            const reservation = await this.reservationModel.create([doc]).then(v => v[0]);
            for (const id of ticketIds) {
                const updated = await this.ticketModel.findOneAndUpdate({ _id: id, reservation: null }, { reservation: reservation._id });
                if (!updated) {
                    throw new Error(`Ticket already reserved`);
                }
            }
            this.logger.debug(`[PASSED] done`);
            return reservation;
        }
        catch (e) {
            this.logger.debug(`[PASSED] error ${e}`);
            throw new common_1.UnprocessableEntityException((_a = e.message) !== null && _a !== void 0 ? _a : `Cannot create reservation`);
        }
    }
    async checkProduct(products) {
        for (const p of products) {
            if (!(await this.productModel.findById(p.product_id))) {
                throw new common_1.NotFoundException(`Not found product with id: ${p.product_id}`);
            }
        }
    }
    async checkSeats(ticketIds) {
        const invalidTickets = await this.ticketModel.find({
            $and: [
                { _id: { $in: ticketIds } },
                { reservation: { $ne: null } },
            ]
        }).populate('seat');
        if (invalidTickets.length > 0) {
            const seats = invalidTickets.map(t => {
                const seat = t.seat;
                return `${seat.row}${seat.column}`;
            }).join(', ');
            throw new common_1.UnprocessableEntityException(`Tickets already reserved: ${seats}`);
        }
    }
};
ReservationsService = __decorate([
    common_1.Injectable(),
    __param(0, mongoose_2.InjectModel(reservation_schema_1.Reservation.name)),
    __param(1, mongoose_2.InjectModel(product_schema_1.Product.name)),
    __param(2, mongoose_2.InjectModel(ticket_schema_1.Ticket.name)),
    __metadata("design:paramtypes", [mongoose_1.Model,
        mongoose_1.Model,
        mongoose_1.Model,
        users_service_1.UsersService,
        app_gateway_1.AppGateway])
], ReservationsService);
exports.ReservationsService = ReservationsService;
//# sourceMappingURL=reservations.service.js.map