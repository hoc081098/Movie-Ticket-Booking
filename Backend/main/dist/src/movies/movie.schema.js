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
exports.MovieSchema = exports.Movie = void 0;
const openapi = require("@nestjs/swagger");
const mongoose_1 = require("mongoose");
const mongoose_2 = require("@nestjs/mongoose");
let Movie = class Movie extends mongoose_1.Document {
    static _OPENAPI_METADATA_FACTORY() {
        return { title: { required: true, type: () => String }, trailer_video_url: { required: false, type: () => String }, poster_url: { required: false, type: () => String }, overview: { required: false, type: () => String }, released_date: { required: true, type: () => Date }, duration: { required: true, type: () => Number }, directors: { required: true, type: () => [Object] }, actors: { required: true, type: () => [Object] }, original_language: { required: true, type: () => String }, age_type: { required: true, type: () => Object }, total_rate: { required: true, type: () => Number }, rate_star: { required: true, type: () => Number }, total_favorite: { required: true, type: () => Number }, is_active: { required: true, type: () => Boolean } };
    }
};
__decorate([
    mongoose_2.Prop({ required: true }),
    __metadata("design:type", String)
], Movie.prototype, "title", void 0);
__decorate([
    mongoose_2.Prop(),
    __metadata("design:type", String)
], Movie.prototype, "trailer_video_url", void 0);
__decorate([
    mongoose_2.Prop(),
    __metadata("design:type", String)
], Movie.prototype, "poster_url", void 0);
__decorate([
    mongoose_2.Prop(),
    __metadata("design:type", String)
], Movie.prototype, "overview", void 0);
__decorate([
    mongoose_2.Prop({ required: true }),
    __metadata("design:type", Date)
], Movie.prototype, "released_date", void 0);
__decorate([
    mongoose_2.Prop({ required: true }),
    __metadata("design:type", Number)
], Movie.prototype, "duration", void 0);
__decorate([
    mongoose_2.Prop({
        type: [
            {
                type: [mongoose_1.Schema.Types.ObjectId],
                ref: 'Person',
                required: true,
            }
        ],
        required: true,
    }),
    __metadata("design:type", Array)
], Movie.prototype, "directors", void 0);
__decorate([
    mongoose_2.Prop({
        type: [
            {
                type: [mongoose_1.Schema.Types.ObjectId],
                ref: 'Person',
                required: true,
            }
        ],
        required: true,
    }),
    __metadata("design:type", Array)
], Movie.prototype, "actors", void 0);
__decorate([
    mongoose_2.Prop({ required: true }),
    __metadata("design:type", String)
], Movie.prototype, "original_language", void 0);
__decorate([
    mongoose_2.Prop({
        type: String,
        enum: ['P', 'C13', 'C16', 'C18'],
        default: 'P',
        required: true,
    }),
    __metadata("design:type", String)
], Movie.prototype, "age_type", void 0);
__decorate([
    mongoose_2.Prop(),
    __metadata("design:type", Number)
], Movie.prototype, "total_rate", void 0);
__decorate([
    mongoose_2.Prop(),
    __metadata("design:type", Number)
], Movie.prototype, "rate_star", void 0);
__decorate([
    mongoose_2.Prop(),
    __metadata("design:type", Number)
], Movie.prototype, "total_favorite", void 0);
__decorate([
    mongoose_2.Prop({ default: true }),
    __metadata("design:type", Boolean)
], Movie.prototype, "is_active", void 0);
Movie = __decorate([
    mongoose_2.Schema({
        toJSON: {
            virtuals: true
        },
        timestamps: true,
    })
], Movie);
exports.Movie = Movie;
exports.MovieSchema = mongoose_2.SchemaFactory.createForClass(Movie);
exports.MovieSchema.virtual('categories', {
    ref: 'MovieCategory',
    localField: '_id',
    foreignField: 'movie_id',
});
//# sourceMappingURL=movie.schema.js.map