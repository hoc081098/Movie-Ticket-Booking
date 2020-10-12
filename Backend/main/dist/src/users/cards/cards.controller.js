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
exports.CardsController = void 0;
const openapi = require("@nestjs/swagger");
const common_1 = require("@nestjs/common");
const auth_guard_1 = require("../../auth/auth.guard");
const get_user_decorator_1 = require("../../auth/get-user.decorator");
const card_dto_1 = require("./card.dto");
const swagger_1 = require("@nestjs/swagger");
const users_service_1 = require("../users.service");
const dayjs = require("dayjs");
let CardsController = class CardsController {
    constructor(usersService) {
        this.usersService = usersService;
    }
    getCards(user) {
        return this.usersService.getCards(user);
    }
    addCard(userPayload, cardDto) {
        const current = dayjs();
        const currentYear = current.year() % 100;
        if (cardDto.exp_year < currentYear) {
            throw new common_1.BadRequestException('Invalid exp_year. exp_year must be equal to or greater than current year.');
        }
        const currentMonth = current.month() + 1;
        if (cardDto.exp_year === currentYear && cardDto.exp_month < currentMonth) {
            throw new common_1.BadRequestException('Invalid exp_month. exp_month must be equal to or greater than current month.');
        }
        return this.usersService.addCard(userPayload, cardDto);
    }
    removeCard(userPayload, cardId) {
        return this.usersService.removeCard(userPayload, cardId);
    }
};
__decorate([
    common_1.Get(),
    openapi.ApiResponse({ status: 200, type: [require("./card.dto").Card] }),
    __param(0, get_user_decorator_1.GetUser()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [get_user_decorator_1.UserPayload]),
    __metadata("design:returntype", Promise)
], CardsController.prototype, "getCards", null);
__decorate([
    common_1.Post(),
    openapi.ApiResponse({ status: 201, type: require("./card.dto").Card }),
    __param(0, get_user_decorator_1.GetUser()),
    __param(1, common_1.Body()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [get_user_decorator_1.UserPayload,
        card_dto_1.AddCardDto]),
    __metadata("design:returntype", void 0)
], CardsController.prototype, "addCard", null);
__decorate([
    common_1.Delete(':id'),
    openapi.ApiResponse({ status: 200 }),
    __param(0, get_user_decorator_1.GetUser()),
    __param(1, common_1.Param('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [get_user_decorator_1.UserPayload, String]),
    __metadata("design:returntype", Promise)
], CardsController.prototype, "removeCard", null);
CardsController = __decorate([
    swagger_1.ApiTags('cards'),
    common_1.UseGuards(auth_guard_1.AuthGuard),
    common_1.Controller('cards'),
    __metadata("design:paramtypes", [users_service_1.UsersService])
], CardsController);
exports.CardsController = CardsController;
//# sourceMappingURL=cards.controller.js.map