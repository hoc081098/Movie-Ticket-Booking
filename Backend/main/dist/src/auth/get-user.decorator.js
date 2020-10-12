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
exports.GetUser = exports.UserPayload = void 0;
const common_1 = require("@nestjs/common");
const class_validator_1 = require("class-validator");
const user_schema_1 = require("../users/user.schema");
class UserPayload {
    constructor(payload) {
        this.uid = payload.uid;
        this.email = payload.email;
        this.user_entity = payload.user_entity;
    }
}
__decorate([
    class_validator_1.IsString(),
    class_validator_1.IsNotEmpty(),
    __metadata("design:type", String)
], UserPayload.prototype, "uid", void 0);
__decorate([
    class_validator_1.IsString(),
    class_validator_1.IsEmail(),
    __metadata("design:type", String)
], UserPayload.prototype, "email", void 0);
__decorate([
    class_validator_1.IsOptional(),
    __metadata("design:type", user_schema_1.User)
], UserPayload.prototype, "user_entity", void 0);
exports.UserPayload = UserPayload;
exports.GetUser = common_1.createParamDecorator((data, ctx) => {
    var _a;
    const req = ctx.switchToHttp().getRequest();
    return data && typeof data === 'string' ? (_a = req.user) === null || _a === void 0 ? void 0 : _a[data] : req.user;
});
//# sourceMappingURL=get-user.decorator.js.map