"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.TheatresModule = void 0;
const common_1 = require("@nestjs/common");
const theatres_controller_1 = require("./theatres.controller");
const theatres_service_1 = require("./theatres.service");
const mongoose_1 = require("@nestjs/mongoose");
const theatre_schema_1 = require("./theatre.schema");
const auth_module_1 = require("../auth/auth.module");
const users_module_1 = require("../users/users.module");
const config_module_1 = require("../config/config.module");
let TheatresModule = class TheatresModule {
};
TheatresModule = __decorate([
    common_1.Module({
        imports: [
            mongoose_1.MongooseModule.forFeature([
                {
                    name: theatre_schema_1.Theatre.name,
                    schema: theatre_schema_1.TheatreSchema,
                },
            ]),
            auth_module_1.AuthModule,
            users_module_1.UsersModule,
            config_module_1.ConfigModule,
        ],
        controllers: [theatres_controller_1.TheatresController],
        providers: [theatres_service_1.TheatresService]
    })
], TheatresModule);
exports.TheatresModule = TheatresModule;
//# sourceMappingURL=theatres.module.js.map