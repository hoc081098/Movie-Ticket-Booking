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
exports.TheatreSchema = exports.Theatre = void 0;
const openapi = require("@nestjs/swagger");
const mongoose_1 = require("mongoose");
const mongoose_2 = require("@nestjs/mongoose");
let Theatre = class Theatre extends mongoose_1.Document {
    static _OPENAPI_METADATA_FACTORY() {
        return { name: { required: true, type: () => String }, address: { required: true, type: () => String }, location: { required: true, type: () => Object }, phone_number: { required: true, type: () => String }, email: { required: false, type: () => String }, description: { required: true, type: () => String }, room_summary: { required: true, type: () => String }, opening_hours: { required: true, type: () => String }, rooms: { required: true, type: () => [String] }, is_active: { required: true, type: () => Boolean } };
    }
};
__decorate([
    mongoose_2.Prop({ required: true }),
    __metadata("design:type", String)
], Theatre.prototype, "name", void 0);
__decorate([
    mongoose_2.Prop({ required: true }),
    __metadata("design:type", String)
], Theatre.prototype, "address", void 0);
__decorate([
    mongoose_2.Prop({
        type: {
            type: String,
            enum: ['Point'],
            required: true,
        },
        coordinates: {
            type: [Number],
            required: true,
        }
    }),
    __metadata("design:type", Object)
], Theatre.prototype, "location", void 0);
__decorate([
    mongoose_2.Prop({ required: true }),
    __metadata("design:type", String)
], Theatre.prototype, "phone_number", void 0);
__decorate([
    mongoose_2.Prop(),
    __metadata("design:type", String)
], Theatre.prototype, "email", void 0);
__decorate([
    mongoose_2.Prop({ required: true }),
    __metadata("design:type", String)
], Theatre.prototype, "description", void 0);
__decorate([
    mongoose_2.Prop({ required: true }),
    __metadata("design:type", String)
], Theatre.prototype, "room_summary", void 0);
__decorate([
    mongoose_2.Prop({ required: true }),
    __metadata("design:type", String)
], Theatre.prototype, "opening_hours", void 0);
__decorate([
    mongoose_2.Prop({
        type: [String],
        required: true,
    }),
    __metadata("design:type", Array)
], Theatre.prototype, "rooms", void 0);
__decorate([
    mongoose_2.Prop({ default: true }),
    __metadata("design:type", Boolean)
], Theatre.prototype, "is_active", void 0);
Theatre = __decorate([
    mongoose_2.Schema({
        collection: 'theatres',
        timestamps: true,
    })
], Theatre);
exports.Theatre = Theatre;
exports.TheatreSchema = mongoose_2.SchemaFactory.createForClass(Theatre);
exports.TheatreSchema.index({ location: '2dsphere' });
//# sourceMappingURL=theatre.schema.js.map