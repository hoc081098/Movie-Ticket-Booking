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
exports.MoviesController = void 0;
const openapi = require("@nestjs/swagger");
const common_1 = require("@nestjs/common");
const movie_db_service_1 = require("./movie-db/movie-db.service");
const movies_service_1 = require("./movies.service");
const utils_1 = require("../common/utils");
const swagger_1 = require("@nestjs/swagger");
const pagination_dto_1 = require("../common/pagination.dto");
const movie_dto_1 = require("./movie.dto");
const auth_guard_1 = require("../auth/auth.guard");
let MoviesController = class MoviesController {
    constructor(movieDbService, moviesService) {
        this.movieDbService = movieDbService;
        this.moviesService = moviesService;
        this.logger = new common_1.Logger('MoviesController');
    }
    seed({ query, page, year }) {
        return this.movieDbService.seed(query, page, year);
    }
    updateVideoUrl() {
        return this.movieDbService.updateVideoUrl();
    }
    async getNowShowingMovies(dto) {
        return this.moviesService.getNowShowingMovies(utils_1.getCoordinates(dto), dto);
    }
    async getComingSoonMovies(paginationDto) {
        return this.moviesService.getComingSoonMovies(paginationDto);
    }
    getDetail(id) {
        return this.moviesService.getDetail(id);
    }
};
__decorate([
    swagger_1.ApiOperation({ summary: 'PRIVATE' }),
    common_1.Post('seed'),
    openapi.ApiResponse({ status: 201 }),
    __param(0, common_1.Body()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], MoviesController.prototype, "seed", null);
__decorate([
    swagger_1.ApiOperation({ summary: 'PRIVATE' }),
    common_1.Post('update-video-url'),
    openapi.ApiResponse({ status: 201 }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], MoviesController.prototype, "updateVideoUrl", null);
__decorate([
    common_1.Get('now-playing'),
    openapi.ApiResponse({ status: 200, type: [require("./movie.schema").Movie] }),
    __param(0, common_1.Query()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [movie_dto_1.GetNowShowingMoviesDto]),
    __metadata("design:returntype", Promise)
], MoviesController.prototype, "getNowShowingMovies", null);
__decorate([
    common_1.Get('coming-soon'),
    openapi.ApiResponse({ status: 200, type: [require("./movie.schema").Movie] }),
    __param(0, common_1.Query()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [pagination_dto_1.PaginationDto]),
    __metadata("design:returntype", Promise)
], MoviesController.prototype, "getComingSoonMovies", null);
__decorate([
    common_1.Get(':id'),
    openapi.ApiResponse({ status: 200, type: require("./movie.schema").Movie }),
    __param(0, common_1.Param('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], MoviesController.prototype, "getDetail", null);
MoviesController = __decorate([
    swagger_1.ApiTags('movies'),
    common_1.UseGuards(auth_guard_1.AuthGuard),
    common_1.Controller('movies'),
    __metadata("design:paramtypes", [movie_db_service_1.MovieDbService,
        movies_service_1.MoviesService])
], MoviesController);
exports.MoviesController = MoviesController;
//# sourceMappingURL=movies.controller.js.map