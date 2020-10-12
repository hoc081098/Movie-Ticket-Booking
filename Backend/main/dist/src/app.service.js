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
exports.AppService = void 0;
const common_1 = require("@nestjs/common");
const dist_1 = require("@aginix/nestjs-firebase-admin/dist");
const config_service_1 = require("./config/config.service");
const rxjs_1 = require("rxjs");
const operators_1 = require("rxjs/operators");
let AppService = class AppService {
    constructor(httpService, firebaseAuth, configService) {
        this.httpService = httpService;
        this.firebaseAuth = firebaseAuth;
        this.configService = configService;
    }
    generateToken() {
        return rxjs_1.defer(() => this.firebaseAuth.createCustomToken('l9StgzQlR1h3XpaWCf3juyYgG772'))
            .pipe(operators_1.mergeMap(customToken => this.httpService.post(`https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyCustomToken?key=${this.configService.get("FIREBASE_API_KEY")}`, {
            token: customToken,
            returnSecureToken: true
        })), operators_1.map(response => response.data));
    }
};
AppService = __decorate([
    common_1.Injectable(),
    __metadata("design:paramtypes", [common_1.HttpService,
        dist_1.FirebaseAuthenticationService,
        config_service_1.ConfigService])
], AppService);
exports.AppService = AppService;
//# sourceMappingURL=app.service.js.map