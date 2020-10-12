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
var WsGuard_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.WsGuard = void 0;
const common_1 = require("@nestjs/common");
const dist_1 = require("@aginix/nestjs-firebase-admin/dist");
let WsGuard = WsGuard_1 = class WsGuard {
    constructor(firebaseAuth) {
        this.firebaseAuth = firebaseAuth;
        this.logger = new common_1.Logger(WsGuard_1.name);
    }
    async canActivate(context) {
        var _a, _b;
        const client = context.switchToWs().getClient();
        const token = (_b = (_a = client.handshake) === null || _a === void 0 ? void 0 : _a.query) === null || _b === void 0 ? void 0 : _b.token;
        await this.decodeToken(token);
        return true;
    }
    async decodeToken(authHeaders) {
        this.logger.debug(`Headers: ${authHeaders}`);
        if (!authHeaders) {
            this.logger.error('Missing authHeaders');
            throw new common_1.UnauthorizedException();
        }
        const token = authHeaders.split(' ')[1];
        if (!token) {
            this.logger.error('Missing token');
            throw new common_1.UnauthorizedException();
        }
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
    }
};
WsGuard = WsGuard_1 = __decorate([
    common_1.Injectable(),
    __metadata("design:paramtypes", [dist_1.FirebaseAuthenticationService])
], WsGuard);
exports.WsGuard = WsGuard;
//# sourceMappingURL=ws.guard.js.map