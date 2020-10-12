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
exports.UsersController = void 0;
const openapi = require("@nestjs/swagger");
const common_1 = require("@nestjs/common");
const auth_guard_1 = require("../auth/auth.guard");
const users_service_1 = require("./users.service");
const get_user_decorator_1 = require("../auth/get-user.decorator");
const update_user_dto_1 = require("./update-user.dto");
const swagger_1 = require("@nestjs/swagger");
const roles_guard_1 = require("../auth/roles.guard");
const pagination_dto_1 = require("../common/pagination.dto");
const swagger_decorator_1 = require("../common/swagger.decorator");
let UsersController = class UsersController {
    constructor(usersService) {
        this.usersService = usersService;
        this.logger = new common_1.Logger('UsersController');
    }
    async me(uid) {
        this.logger.debug(`Get my profile: ${uid}`);
        const user = await this.usersService.findByUid(uid);
        if (!user) {
            throw new common_1.NotFoundException(`User with uid: ${uid} not found`);
        }
        return user;
    }
    async findById(uid) {
        const user = await this.usersService.findByUid(uid);
        if (!user) {
            throw new common_1.NotFoundException(`User with uid: ${uid} not found`);
        }
        return user;
    }
    update(user, updateUserDto) {
        this.logger.debug(`Update my profile: ${JSON.stringify(user)}, ${JSON.stringify(updateUserDto)}`);
        return this.usersService.update(user, updateUserDto);
    }
    delete(uid) {
        return this.usersService.delete(uid);
    }
    getAllUsers(dto) {
        return this.usersService.getAllUsers(dto);
    }
};
__decorate([
    common_1.Get('me'),
    common_1.UseGuards(auth_guard_1.AuthGuard),
    openapi.ApiResponse({ status: 200, type: require("./user.schema").User }),
    __param(0, get_user_decorator_1.GetUser('uid')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "me", null);
__decorate([
    common_1.Get(':uid'),
    openapi.ApiResponse({ status: 200, type: require("./user.schema").User }),
    __param(0, common_1.Param('uid')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "findById", null);
__decorate([
    common_1.Put('me'),
    common_1.UseGuards(auth_guard_1.AuthGuard),
    openapi.ApiResponse({ status: 200, type: require("./user.schema").User }),
    __param(0, get_user_decorator_1.GetUser()),
    __param(1, common_1.Body()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [get_user_decorator_1.UserPayload,
        update_user_dto_1.UpdateUserDto]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "update", null);
__decorate([
    swagger_decorator_1.ForAdmin(),
    common_1.UseGuards(auth_guard_1.AuthGuard, roles_guard_1.RolesGuard),
    roles_guard_1.Roles('ADMIN'),
    common_1.Delete(':uid'),
    openapi.ApiResponse({ status: 200, type: require("./user.schema").User }),
    __param(0, common_1.Param('uid')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], UsersController.prototype, "delete", null);
__decorate([
    swagger_decorator_1.ForAdmin(),
    common_1.UseGuards(auth_guard_1.AuthGuard, roles_guard_1.RolesGuard),
    roles_guard_1.Roles('ADMIN'),
    common_1.Get(),
    openapi.ApiResponse({ status: 200, type: [require("./user.schema").User] }),
    __param(0, common_1.Query()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [pagination_dto_1.PaginationDto]),
    __metadata("design:returntype", Promise)
], UsersController.prototype, "getAllUsers", null);
UsersController = __decorate([
    swagger_1.ApiTags('users'),
    common_1.Controller('users'),
    __metadata("design:paramtypes", [users_service_1.UsersService])
], UsersController);
exports.UsersController = UsersController;
//# sourceMappingURL=users.controller.js.map