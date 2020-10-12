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
exports.CommentSchema = exports.Comment = void 0;
const openapi = require("@nestjs/swagger");
const mongoose_1 = require("mongoose");
const mongoose_2 = require("@nestjs/mongoose");
let Comment = class Comment extends mongoose_1.Document {
    static _OPENAPI_METADATA_FACTORY() {
        return { content: { required: true, type: () => String }, rate_star: { required: true, type: () => Number }, user: { required: true, type: () => Object }, movie: { required: true, type: () => Object }, is_active: { required: true, type: () => Boolean } };
    }
};
__decorate([
    mongoose_2.Prop({ required: true }),
    __metadata("design:type", String)
], Comment.prototype, "content", void 0);
__decorate([
    mongoose_2.Prop({ required: true }),
    __metadata("design:type", Number)
], Comment.prototype, "rate_star", void 0);
__decorate([
    mongoose_2.Prop({
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    }),
    __metadata("design:type", Object)
], Comment.prototype, "user", void 0);
__decorate([
    mongoose_2.Prop({
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'Movie',
        required: true,
    }),
    __metadata("design:type", Object)
], Comment.prototype, "movie", void 0);
__decorate([
    mongoose_2.Prop({ default: true }),
    __metadata("design:type", Boolean)
], Comment.prototype, "is_active", void 0);
Comment = __decorate([
    mongoose_2.Schema({
        timestamps: true
    })
], Comment);
exports.Comment = Comment;
exports.CommentSchema = mongoose_2.SchemaFactory.createForClass(Comment);
//# sourceMappingURL=comment.schema.js.map