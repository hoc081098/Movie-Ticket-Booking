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
exports.SeatSchema = exports.Seat = void 0;
const openapi = require("@nestjs/swagger");
const mongoose_1 = require("mongoose");
const mongoose_2 = require("@nestjs/mongoose");
let Seat = class Seat extends mongoose_1.Document {
    static _OPENAPI_METADATA_FACTORY() {
        return { row: { required: true, type: () => String }, column: { required: true, type: () => Number }, count: { required: true, type: () => Number }, coordinates: { required: true }, theatre: { required: true, type: () => Object }, room: { required: true, type: () => String }, is_active: { required: true, type: () => Boolean } };
    }
};
__decorate([
    mongoose_2.Prop({ required: true }),
    __metadata("design:type", String)
], Seat.prototype, "row", void 0);
__decorate([
    mongoose_2.Prop({ required: true }),
    __metadata("design:type", Number)
], Seat.prototype, "column", void 0);
__decorate([
    mongoose_2.Prop({ required: true }),
    __metadata("design:type", Number)
], Seat.prototype, "count", void 0);
__decorate([
    mongoose_2.Prop({
        type: [Number],
        required: true,
    }),
    __metadata("design:type", Array)
], Seat.prototype, "coordinates", void 0);
__decorate([
    mongoose_2.Prop({
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'Theatre',
        required: true,
    }),
    __metadata("design:type", Object)
], Seat.prototype, "theatre", void 0);
__decorate([
    mongoose_2.Prop({ required: true }),
    __metadata("design:type", String)
], Seat.prototype, "room", void 0);
__decorate([
    mongoose_2.Prop({ default: true }),
    __metadata("design:type", Boolean)
], Seat.prototype, "is_active", void 0);
Seat = __decorate([
    mongoose_2.Schema({
        collection: 'seats',
        timestamps: true,
    })
], Seat);
exports.Seat = Seat;
exports.SeatSchema = mongoose_2.SchemaFactory.createForClass(Seat);
//# sourceMappingURL=seat.schema.js.map