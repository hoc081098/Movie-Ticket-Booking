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
exports.TheatresController = void 0;
const openapi = require("@nestjs/swagger");
const common_1 = require("@nestjs/common");
const theatres_service_1 = require("./theatres.service");
const auth_guard_1 = require("../auth/auth.guard");
const swagger_1 = require("@nestjs/swagger");
let TheatresController = class TheatresController {
    constructor(theatresService) {
        this.theatresService = theatresService;
    }
    seed() {
        return this.theatresService.seed();
    }
};
__decorate([
    swagger_1.ApiOperation({ summary: 'PRIVATE' }),
    common_1.Post('seed'),
    openapi.ApiResponse({ status: 201, type: Object }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", void 0)
], TheatresController.prototype, "seed", null);
TheatresController = __decorate([
    swagger_1.ApiTags('theatres'),
    common_1.UseGuards(auth_guard_1.AuthGuard),
    common_1.Controller('theatres'),
    __metadata("design:paramtypes", [theatres_service_1.TheatresService])
], TheatresController);
exports.TheatresController = TheatresController;
//# sourceMappingURL=theatres.controller.js.map