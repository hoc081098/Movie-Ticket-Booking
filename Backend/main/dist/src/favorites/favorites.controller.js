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
exports.FavoritesController = void 0;
const openapi = require("@nestjs/swagger");
const common_1 = require("@nestjs/common");
const auth_guard_1 = require("../auth/auth.guard");
const get_user_decorator_1 = require("../auth/get-user.decorator");
const pagination_dto_1 = require("../common/pagination.dto");
const favorites_service_1 = require("./favorites.service");
const swagger_1 = require("@nestjs/swagger");
const favorites_dto_1 = require("./favorites.dto");
let FavoritesController = class FavoritesController {
    constructor(favoritesService) {
        this.favoritesService = favoritesService;
    }
    checkFavorite(user, movieId) {
        return this.favoritesService.checkFavorite(user, movieId);
    }
    getAllFavorites(user, dto) {
        return this.favoritesService.getAllFavorites(user, dto);
    }
    toggleFavorite(user, dto) {
        return this.favoritesService.toggleFavorite(user, dto);
    }
};
__decorate([
    common_1.Get(':movie_id'),
    openapi.ApiResponse({ status: 200, type: require("./favorites.dto").FavoriteResponse }),
    __param(0, get_user_decorator_1.GetUser()),
    __param(1, common_1.Param('movie_id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [get_user_decorator_1.UserPayload, String]),
    __metadata("design:returntype", Promise)
], FavoritesController.prototype, "checkFavorite", null);
__decorate([
    common_1.Get(),
    openapi.ApiResponse({ status: 200, type: [require("../movies/movie.schema").Movie] }),
    __param(0, get_user_decorator_1.GetUser()),
    __param(1, common_1.Query()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [get_user_decorator_1.UserPayload,
        pagination_dto_1.PaginationDto]),
    __metadata("design:returntype", Promise)
], FavoritesController.prototype, "getAllFavorites", null);
__decorate([
    common_1.Post(),
    openapi.ApiResponse({ status: 201, type: require("./favorites.dto").ToggleFavoriteResponse }),
    __param(0, get_user_decorator_1.GetUser()),
    __param(1, common_1.Body()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [get_user_decorator_1.UserPayload,
        favorites_dto_1.ToggleFavoriteDto]),
    __metadata("design:returntype", Promise)
], FavoritesController.prototype, "toggleFavorite", null);
FavoritesController = __decorate([
    common_1.UseGuards(auth_guard_1.AuthGuard),
    swagger_1.ApiTags('favorites'),
    common_1.Controller('favorites'),
    __metadata("design:paramtypes", [favorites_service_1.FavoritesService])
], FavoritesController);
exports.FavoritesController = FavoritesController;
//# sourceMappingURL=favorites.controller.js.map