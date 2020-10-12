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
exports.AuthGuard = void 0;
const common_1 = require("@nestjs/common");
const dist_1 = require("@aginix/nestjs-firebase-admin/dist");
const users_service_1 = require("../users/users.service");
const get_user_decorator_1 = require("./get-user.decorator");
const class_validator_1 = require("class-validator");
const fs = require("fs");
const config_service_1 = require("../config/config.service");
let written = false;
let AuthGuard = class AuthGuard {
    constructor(firebaseAuth, usersService, configService) {
        this.firebaseAuth = firebaseAuth;
        this.usersService = usersService;
        this.configService = configService;
        this.logger = new common_1.Logger('AuthGuard');
        this.logger.debug(`Created AuthGuard`);
    }
    async canActivate(context) {
        var _a, _b, _c, _d;
        const test = this.configService.get("TEST_AUTH_GUARD");
        if (test === 'USER' || test === 'ADMIN') {
            this.logger.debug(`>>> TEST ${test}`);
            const me = (_b = (_a = (await this.usersService.findByUid(test === 'USER' ? 'l9StgzQlR1h3XpaWCf3juyYgG772' : 'NePOX4o5zhPqLUlHR9IY8eigNd92'))) === null || _a === void 0 ? void 0 : _a.toJSON()) !== null && _b !== void 0 ? _b : {};
            context.switchToHttp().getRequest().user = new get_user_decorator_1.UserPayload(Object.assign(Object.assign({}, me), { user_entity: me }));
            return true;
        }
        const request = context.switchToHttp().getRequest();
        const decodedIdToken = await this.decodeToken(request);
        this.logger.debug(`Token: ${JSON.stringify(decodedIdToken)}`);
        let user;
        try {
            user = await this.usersService.findByUid(decodedIdToken.uid);
        }
        catch (e) {
            this.logger.error(`Error when finding user: ${e}`);
            throw new common_1.UnauthorizedException();
        }
        const merged = Object.assign(Object.assign(Object.assign({}, decodedIdToken), ((_c = user === null || user === void 0 ? void 0 : user.toObject()) !== null && _c !== void 0 ? _c : {})), { user_entity: user });
        const payload = new get_user_decorator_1.UserPayload(merged);
        try {
            const errors = await class_validator_1.validate(payload);
            this.logger.debug(`Errors: ${JSON.stringify(errors)} ${(_d = payload.user_entity) === null || _d === void 0 ? void 0 : _d._id}`);
            if (errors === null || errors === undefined || errors.length === 0) {
                request.user = payload;
                this.logger.debug(`Payload: ${JSON.stringify(payload)}`);
                return true;
            }
        }
        catch (e) {
            this.logger.error(`Error when validating payload: ${e}`);
            throw new common_1.UnauthorizedException();
        }
    }
    async decodeToken(request) {
        const authHeaders = request.headers.authorization;
        if (!authHeaders) {
            this.logger.error('Missing authHeaders');
            throw new common_1.UnauthorizedException();
        }
        const token = authHeaders.split(' ')[1];
        if (!token) {
            this.logger.error('Missing token');
            throw new common_1.UnauthorizedException();
        }
        this.debugToken(token);
        let decodedIdToken;
        try {
            decodedIdToken = await this.firebaseAuth.verifyIdToken(token);
        }
        catch (e) {
            this.logger.error(`Error when verifying token: ${e}`);
            throw new common_1.UnauthorizedException('Error when verifying token');
        }
        if (!(decodedIdToken === null || decodedIdToken === void 0 ? void 0 : decodedIdToken.uid)) {
            this.logger.error('Error: missing decodedIdToken or decodedIdToken.uid');
            throw new common_1.UnauthorizedException('Error invalid decoded token');
        }
        return decodedIdToken;
    }
    debugToken(token) {
        if (this.configService.get("WRITE_TOKEN_TO_FILE") !== 'true') {
            return;
        }
        if (written)
            return;
        written = true;
        fs.writeFile('./token.txt', token, {}, (error) => {
            if (error) {
                throw error;
            }
        });
    }
};
AuthGuard = __decorate([
    common_1.Injectable(),
    __metadata("design:paramtypes", [dist_1.FirebaseAuthenticationService,
        users_service_1.UsersService,
        config_service_1.ConfigService])
], AuthGuard);
exports.AuthGuard = AuthGuard;
//# sourceMappingURL=auth.guard.js.map