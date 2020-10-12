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
exports.SeatsController = void 0;
const openapi = require("@nestjs/swagger");
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const auth_guard_1 = require("../auth/auth.guard");
const seats_service_1 = require("./seats.service");
let SeatsController = class SeatsController {
    constructor(seatsService) {
        this.seatsService = seatsService;
    }
    seed({ id }) {
        return this.seatsService.seed(id);
    }
    seedTickets() {
        return this.seatsService.seedTickets();
    }
    getTicketsByShowTimeId(showTimeId) {
        return this.seatsService.getTicketsByShowTimeId(showTimeId);
    }
};
__decorate([
    swagger_1.ApiOperation({ summary: 'PRIVATE' }),
    common_1.Post('seed'),
    openapi.ApiResponse({ status: 201, type: [require("./seat.schema").Seat] }),
    __param(0, common_1.Body()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], SeatsController.prototype, "seed", null);
__decorate([
    swagger_1.ApiOperation({ summary: 'PRIVATE' }),
    common_1.Post('seed-tickets'),
    openapi.ApiResponse({ status: 201, type: [require("./ticket.schema").Ticket] }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], SeatsController.prototype, "seedTickets", null);
__decorate([
    swagger_1.ApiOperation({
        description: 'Populated seat'
    }),
    common_1.Get('tickets/show-times/:show_time_id'),
    openapi.ApiResponse({ status: 200, type: [require("./ticket.schema").Ticket] }),
    __param(0, common_1.Param('show_time_id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], SeatsController.prototype, "getTicketsByShowTimeId", null);
SeatsController = __decorate([
    swagger_1.ApiTags('seats'),
    common_1.UseGuards(auth_guard_1.AuthGuard),
    common_1.Controller('seats'),
    __metadata("design:paramtypes", [seats_service_1.SeatsService])
], SeatsController);
exports.SeatsController = SeatsController;
//# sourceMappingURL=seats.controller.js.map