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
exports.ShowTimeSchema = exports.ShowTime = void 0;
const openapi = require("@nestjs/swagger");
const mongoose_1 = require("mongoose");
const mongoose_2 = require("@nestjs/mongoose");
let ShowTime = class ShowTime extends mongoose_1.Document {
    static _OPENAPI_METADATA_FACTORY() {
        return { movie: { required: true, type: () => Object }, theatre: { required: true, type: () => Object }, room: { required: true, type: () => String }, start_time: { required: true, type: () => Date }, end_time: { required: true, type: () => Date }, is_active: { required: true, type: () => Boolean } };
    }
};
__decorate([
    mongoose_2.Prop({
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'Movie',
        required: true,
    }),
    __metadata("design:type", Object)
], ShowTime.prototype, "movie", void 0);
__decorate([
    mongoose_2.Prop({
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'Theatre',
        required: true,
    }),
    __metadata("design:type", Object)
], ShowTime.prototype, "theatre", void 0);
__decorate([
    mongoose_2.Prop({ required: true }),
    __metadata("design:type", String)
], ShowTime.prototype, "room", void 0);
__decorate([
    mongoose_2.Prop({ required: true }),
    __metadata("design:type", Date)
], ShowTime.prototype, "start_time", void 0);
__decorate([
    mongoose_2.Prop({ required: true }),
    __metadata("design:type", Date)
], ShowTime.prototype, "end_time", void 0);
__decorate([
    mongoose_2.Prop({ default: true }),
    __metadata("design:type", Boolean)
], ShowTime.prototype, "is_active", void 0);
ShowTime = __decorate([
    mongoose_2.Schema({
        collection: 'show_times',
        timestamps: true,
    })
], ShowTime);
exports.ShowTime = ShowTime;
exports.ShowTimeSchema = mongoose_2.SchemaFactory.createForClass(ShowTime);
//# sourceMappingURL=show-time.schema.js.map