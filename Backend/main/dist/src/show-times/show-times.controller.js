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
exports.ShowTimesController = void 0;
const openapi = require("@nestjs/swagger");
const common_1 = require("@nestjs/common");
const show_times_service_1 = require("./show-times.service");
const swagger_1 = require("@nestjs/swagger");
const utils_1 = require("../common/utils");
const show_time_dto_1 = require("./show-time.dto");
const auth_guard_1 = require("../auth/auth.guard");
const location_dto_1 = require("../common/location.dto");
let ShowTimesController = class ShowTimesController {
    constructor(showTimesService) {
        this.showTimesService = showTimesService;
        this.logger = new common_1.Logger('ShowTimesController');
    }
    seed() {
        return this.showTimesService.seed();
    }
    async getShowTimesByMovieId(movieId, locationDto) {
        this.logger.debug(`getShowTimesByMovieId ${movieId} ${locationDto.lat}, ${locationDto.lng}`);
        const movieShowTimes = await this.showTimesService.getShowTimesByMovieId(movieId, utils_1.getCoordinates(locationDto));
        return movieShowTimes.map(doc => new show_time_dto_1.MovieAndTheatre(doc));
    }
};
__decorate([
    swagger_1.ApiOperation({ summary: 'PRIVATE' }),
    common_1.Post('seed'),
    openapi.ApiResponse({ status: 201 }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], ShowTimesController.prototype, "seed", null);
__decorate([
    common_1.Get('movies/:movie_id'),
    openapi.ApiResponse({ status: 200, type: [require("./show-time.dto").MovieAndTheatre] }),
    __param(0, common_1.Param('movie_id')),
    __param(1, common_1.Query()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, location_dto_1.LocationDto]),
    __metadata("design:returntype", Promise)
], ShowTimesController.prototype, "getShowTimesByMovieId", null);
ShowTimesController = __decorate([
    swagger_1.ApiTags('show-times'),
    common_1.UseGuards(auth_guard_1.AuthGuard),
    common_1.Controller('show-times'),
    __metadata("design:paramtypes", [show_times_service_1.ShowTimesService])
], ShowTimesController);
exports.ShowTimesController = ShowTimesController;
//# sourceMappingURL=show-times.controller.js.map