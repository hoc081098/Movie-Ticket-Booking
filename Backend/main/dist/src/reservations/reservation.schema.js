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
Object.defineProperty(exports, "__esModule", { value: true });
exports.ReservationSchema = exports.Reservation = void 0;
const openapi = require("@nestjs/swagger");
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
let Reservation = class Reservation extends mongoose_2.Document {
    static _OPENAPI_METADATA_FACTORY() {
        return { user: { required: true, type: () => Object }, show_time: { required: true, type: () => Object }, phone_number: { required: true, type: () => String }, email: { required: true, type: () => String }, products: { required: true, type: () => [Object] }, original_price: { required: true, type: () => Number }, total_price: { required: true, type: () => Number }, promotion_id: { required: false, type: () => Object }, payment_intent_id: { required: true, type: () => String }, is_active: { required: true, type: () => Boolean } };
    }
};
__decorate([
    mongoose_1.Prop({
        type: mongoose_2.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    }),
    __metadata("design:type", Object)
], Reservation.prototype, "user", void 0);
__decorate([
    mongoose_1.Prop({
        type: mongoose_2.Schema.Types.ObjectId,
        ref: 'ShowTime',
        required: true,
    }),
    __metadata("design:type", Object)
], Reservation.prototype, "show_time", void 0);
__decorate([
    mongoose_1.Prop({ required: true }),
    __metadata("design:type", String)
], Reservation.prototype, "phone_number", void 0);
__decorate([
    mongoose_1.Prop({ required: true }),
    __metadata("design:type", String)
], Reservation.prototype, "email", void 0);
__decorate([
    mongoose_1.Prop({
        type: [
            {
                id: {
                    type: mongoose_2.Schema.Types.ObjectId,
                    ref: 'Product',
                    required: true,
                },
                quantity: {
                    type: Number,
                    required: true,
                },
            },
        ],
        required: true,
    }),
    __metadata("design:type", Array)
], Reservation.prototype, "products", void 0);
__decorate([
    mongoose_1.Prop({ required: true }),
    __metadata("design:type", Number)
], Reservation.prototype, "original_price", void 0);
__decorate([
    mongoose_1.Prop({ required: true }),
    __metadata("design:type", Number)
], Reservation.prototype, "total_price", void 0);
__decorate([
    mongoose_1.Prop({
        type: mongoose_2.Schema.Types.ObjectId,
        ref: 'Promotion',
    }),
    __metadata("design:type", Object)
], Reservation.prototype, "promotion_id", void 0);
__decorate([
    mongoose_1.Prop({ required: true }),
    __metadata("design:type", String)
], Reservation.prototype, "payment_intent_id", void 0);
__decorate([
    mongoose_1.Prop(),
    __metadata("design:type", Boolean)
], Reservation.prototype, "is_active", void 0);
Reservation = __decorate([
    mongoose_1.Schema({
        collection: 'reservations',
        timestamps: true,
    })
], Reservation);
exports.Reservation = Reservation;
exports.ReservationSchema = mongoose_1.SchemaFactory.createForClass(Reservation);
//# sourceMappingURL=reservation.schema.js.map