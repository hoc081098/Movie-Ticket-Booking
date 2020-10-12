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
exports.TicketSchema = exports.Ticket = void 0;
const openapi = require("@nestjs/swagger");
const mongoose_1 = require("mongoose");
const mongoose_2 = require("@nestjs/mongoose");
let Ticket = class Ticket extends mongoose_1.Document {
    static _OPENAPI_METADATA_FACTORY() {
        return { seat: { required: true, type: () => Object }, show_time: { required: true, type: () => Object }, reservation: { required: false, type: () => Object, nullable: true }, price: { required: true, type: () => Number }, is_active: { required: true, type: () => Boolean } };
    }
};
__decorate([
    mongoose_2.Prop({
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'Seat',
        required: true,
    }),
    __metadata("design:type", Object)
], Ticket.prototype, "seat", void 0);
__decorate([
    mongoose_2.Prop({
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'ShowTime',
        required: true,
    }),
    __metadata("design:type", Object)
], Ticket.prototype, "show_time", void 0);
__decorate([
    mongoose_2.Prop({
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'Reservation',
        default: null,
    }),
    __metadata("design:type", Object)
], Ticket.prototype, "reservation", void 0);
__decorate([
    mongoose_2.Prop({ required: true }),
    __metadata("design:type", Number)
], Ticket.prototype, "price", void 0);
__decorate([
    mongoose_2.Prop(),
    __metadata("design:type", Boolean)
], Ticket.prototype, "is_active", void 0);
Ticket = __decorate([
    mongoose_2.Schema({
        collection: 'tickets',
        timestamps: true,
    })
], Ticket);
exports.Ticket = Ticket;
exports.TicketSchema = mongoose_2.SchemaFactory.createForClass(Ticket);
//# sourceMappingURL=ticket.schema.js.map