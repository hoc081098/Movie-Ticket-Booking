"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ShowTimesModule = void 0;
const common_1 = require("@nestjs/common");
const show_times_controller_1 = require("./show-times.controller");
const show_times_service_1 = require("./show-times.service");
const mongoose_1 = require("@nestjs/mongoose");
const show_time_schema_1 = require("./show-time.schema");
const theatre_schema_1 = require("../theatres/theatre.schema");
const movie_schema_1 = require("../movies/movie.schema");
const auth_module_1 = require("../auth/auth.module");
const users_module_1 = require("../users/users.module");
const config_module_1 = require("../config/config.module");
let ShowTimesModule = class ShowTimesModule {
};
ShowTimesModule = __decorate([
    common_1.Module({
        imports: [
            mongoose_1.MongooseModule.forFeature([
                {
                    name: show_time_schema_1.ShowTime.name,
                    schema: show_time_schema_1.ShowTimeSchema,
                },
                {
                    name: theatre_schema_1.Theatre.name,
                    schema: theatre_schema_1.TheatreSchema,
                },
                {
                    name: movie_schema_1.Movie.name,
                    schema: movie_schema_1.MovieSchema,
                },
            ]),
            auth_module_1.AuthModule,
            users_module_1.UsersModule,
            config_module_1.ConfigModule,
        ],
        controllers: [show_times_controller_1.ShowTimesController],
        providers: [show_times_service_1.ShowTimesService]
    })
], ShowTimesModule);
exports.ShowTimesModule = ShowTimesModule;
//# sourceMappingURL=show-times.module.js.map