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
exports.MovieCategorySchema = exports.MovieCategory = void 0;
const openapi = require("@nestjs/swagger");
const mongoose_1 = require("mongoose");
const mongoose_2 = require("@nestjs/mongoose");
let MovieCategory = class MovieCategory extends mongoose_1.Document {
    static _OPENAPI_METADATA_FACTORY() {
        return { movie_id: { required: true, type: () => require("../../../../../../../../../mongoose").Schema.Types.ObjectId }, category_id: { required: true, type: () => require("../../../../../../../../../mongoose").Schema.Types.ObjectId } };
    }
};
__decorate([
    mongoose_2.Prop({
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'Movie',
        required: true,
    }),
    __metadata("design:type", mongoose_1.Schema.Types.ObjectId)
], MovieCategory.prototype, "movie_id", void 0);
__decorate([
    mongoose_2.Prop({
        type: mongoose_1.Schema.Types.ObjectId,
        ref: 'Category',
        required: true,
    }),
    __metadata("design:type", mongoose_1.Schema.Types.ObjectId)
], MovieCategory.prototype, "category_id", void 0);
MovieCategory = __decorate([
    mongoose_2.Schema({
        collection: 'movie_category',
        timestamps: true,
    })
], MovieCategory);
exports.MovieCategory = MovieCategory;
exports.MovieCategorySchema = mongoose_2.SchemaFactory.createForClass(MovieCategory);
//# sourceMappingURL=movie-category.schema.js.map