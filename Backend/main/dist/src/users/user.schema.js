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
exports.UserSchema = exports.User = void 0;
const openapi = require("@nestjs/swagger");
const mongoose_1 = require("mongoose");
const mongoose_2 = require("@nestjs/mongoose");
let User = class User extends mongoose_1.Document {
    static _OPENAPI_METADATA_FACTORY() {
        return { uid: { required: true, type: () => String }, email: { required: true, type: () => String }, phone_number: { required: false, type: () => String }, full_name: { required: true, type: () => String }, gender: { required: true, type: () => Object }, avatar: { required: false, type: () => String }, address: { required: false, type: () => String }, birthday: { required: false, type: () => Date }, location: { required: false, type: () => Object }, role: { required: true, type: () => Object }, is_completed: { required: true, type: () => Boolean }, is_active: { required: true, type: () => Boolean }, stripe_customer_id: { required: false, type: () => String }, favorite_movie_ids: { required: false, type: () => Object, nullable: true } };
    }
};
__decorate([
    mongoose_2.Prop({ required: true }),
    __metadata("design:type", String)
], User.prototype, "uid", void 0);
__decorate([
    mongoose_2.Prop({ required: true }),
    __metadata("design:type", String)
], User.prototype, "email", void 0);
__decorate([
    mongoose_2.Prop(),
    __metadata("design:type", String)
], User.prototype, "phone_number", void 0);
__decorate([
    mongoose_2.Prop({ required: true }),
    __metadata("design:type", String)
], User.prototype, "full_name", void 0);
__decorate([
    mongoose_2.Prop({
        type: String,
        enum: ['MALE', 'FEMALE'],
        required: true,
        default: 'MALE',
    }),
    __metadata("design:type", String)
], User.prototype, "gender", void 0);
__decorate([
    mongoose_2.Prop(),
    __metadata("design:type", String)
], User.prototype, "avatar", void 0);
__decorate([
    mongoose_2.Prop(),
    __metadata("design:type", String)
], User.prototype, "address", void 0);
__decorate([
    mongoose_2.Prop(),
    __metadata("design:type", Date)
], User.prototype, "birthday", void 0);
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
], User.prototype, "location", void 0);
__decorate([
    mongoose_2.Prop({
        type: String,
        enum: ['ADMIN', 'ADMIN', 'STAFF'],
        required: true,
        default: 'USER',
    }),
    __metadata("design:type", String)
], User.prototype, "role", void 0);
__decorate([
    mongoose_2.Prop({ default: false }),
    __metadata("design:type", Boolean)
], User.prototype, "is_completed", void 0);
__decorate([
    mongoose_2.Prop({ default: true }),
    __metadata("design:type", Boolean)
], User.prototype, "is_active", void 0);
__decorate([
    mongoose_2.Prop(),
    __metadata("design:type", String)
], User.prototype, "stripe_customer_id", void 0);
__decorate([
    mongoose_2.Prop({
        type: mongoose_1.Schema.Types.Mixed,
        default: {},
    }),
    __metadata("design:type", Object)
], User.prototype, "favorite_movie_ids", void 0);
User = __decorate([
    mongoose_2.Schema({
        timestamps: true,
    })
], User);
exports.User = User;
exports.UserSchema = mongoose_2.SchemaFactory.createForClass(User);
exports.UserSchema.index({ uid: 1 });
//# sourceMappingURL=user.schema.js.map