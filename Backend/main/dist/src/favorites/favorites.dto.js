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
exports.FavoriteResponse = exports.ToggleFavoriteResponse = exports.ToggleFavoriteDto = void 0;
const openapi = require("@nestjs/swagger");
const class_validator_1 = require("class-validator");
class ToggleFavoriteDto {
    static _OPENAPI_METADATA_FACTORY() {
        return { movie_id: { required: true, type: () => String } };
    }
}
__decorate([
    class_validator_1.IsString(),
    class_validator_1.IsNotEmpty(),
    __metadata("design:type", String)
], ToggleFavoriteDto.prototype, "movie_id", void 0);
exports.ToggleFavoriteDto = ToggleFavoriteDto;
class ToggleFavoriteResponse {
    constructor(res) {
        Object.assign(this, res);
    }
    static _OPENAPI_METADATA_FACTORY() {
        return { movie: { required: true, type: () => require("../movies/movie.schema").Movie }, is_favorite: { required: true, type: () => Boolean } };
    }
}
exports.ToggleFavoriteResponse = ToggleFavoriteResponse;
class FavoriteResponse {
    constructor(res) {
        Object.assign(this, res);
    }
    static _OPENAPI_METADATA_FACTORY() {
        return { movie: { required: true, type: () => require("../movies/movie.schema").Movie }, is_favorite: { required: true, type: () => Boolean } };
    }
}
exports.FavoriteResponse = FavoriteResponse;
//# sourceMappingURL=favorites.dto.js.map