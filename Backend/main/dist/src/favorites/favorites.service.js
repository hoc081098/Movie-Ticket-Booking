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
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.FavoritesService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const movie_schema_1 = require("../movies/movie.schema");
const mongoose_2 = require("mongoose");
const utils_1 = require("../common/utils");
const dayjs = require("dayjs");
const favorites_dto_1 = require("./favorites.dto");
const users_service_1 = require("../users/users.service");
let FavoritesService = class FavoritesService {
    constructor(movieModel, usersService) {
        this.movieModel = movieModel;
        this.usersService = usersService;
        this.logger = new common_1.Logger('FavoritesService');
    }
    async getAllFavorites(userPayload, dto) {
        var _a;
        const favoriteMovieIds = (_a = utils_1.checkCompletedLogin(userPayload).favorite_movie_ids) !== null && _a !== void 0 ? _a : {};
        const ids = Object.keys(favoriteMovieIds);
        this.logger.debug(`favorite_movie_ids=${ids}`);
        const movies = await this.movieModel.find({ _id: { $in: ids } });
        const sorted = movies.sort((l, r) => {
            const lTime = dayjs(favoriteMovieIds[l._id]);
            const rTime = dayjs(favoriteMovieIds[r._id]);
            return -lTime.diff(rTime, 'millisecond');
        });
        const skipLimit = utils_1.getSkipLimit(dto);
        return sorted.slice(skipLimit.skip, skipLimit.skip + skipLimit.limit);
    }
    async toggleFavorite(userPayload, dto) {
        var _a;
        const { movie_id } = dto;
        const movie = await this.movieModel.findById(movie_id);
        if (!movie) {
            throw new common_1.NotFoundException(`Not found movie with id: ${movie_id}`);
        }
        const user = await this.usersService.findByUid(utils_1.checkCompletedLogin(userPayload).uid);
        const favorite_movie_ids = (_a = user.favorite_movie_ids) !== null && _a !== void 0 ? _a : {};
        let is_favorite;
        if (favorite_movie_ids[movie_id]) {
            delete favorite_movie_ids[movie_id];
            is_favorite = false;
        }
        else {
            favorite_movie_ids[movie_id] = new Date();
            is_favorite = true;
        }
        await this.usersService.userModel.updateOne({ _id: user._id }, { favorite_movie_ids });
        movie.total_favorite = Math.max(movie.total_favorite + (is_favorite ? 1 : -1), 0);
        await movie.save();
        return new favorites_dto_1.ToggleFavoriteResponse({ movie, is_favorite });
    }
    async checkFavorite(userPayload, movieId) {
        var _a;
        const user = await this.usersService.findByUid(utils_1.checkCompletedLogin(userPayload).uid);
        const movie = await this.movieModel.findById(movieId);
        if (!movie) {
            throw new common_1.NotFoundException(`Not found movie with id: ${movieId}`);
        }
        const is_favorite = !!((_a = user.favorite_movie_ids) !== null && _a !== void 0 ? _a : {})[movieId];
        return new favorites_dto_1.FavoriteResponse({ movie, is_favorite });
    }
};
FavoritesService = __decorate([
    common_1.Injectable(),
    __param(0, mongoose_1.InjectModel(movie_schema_1.Movie.name)),
    __metadata("design:paramtypes", [mongoose_2.Model,
        users_service_1.UsersService])
], FavoritesService);
exports.FavoritesService = FavoritesService;
//# sourceMappingURL=favorites.service.js.map