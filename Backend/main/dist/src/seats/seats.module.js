"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SeatsModule = void 0;
const common_1 = require("@nestjs/common");
const seats_controller_1 = require("./seats.controller");
const seats_service_1 = require("./seats.service");
const auth_module_1 = require("../auth/auth.module");
const users_module_1 = require("../users/users.module");
const mongoose_1 = require("@nestjs/mongoose");
const seat_schema_1 = require("./seat.schema");
const theatre_schema_1 = require("../theatres/theatre.schema");
const show_time_schema_1 = require("../show-times/show-time.schema");
const config_module_1 = require("../config/config.module");
const ticket_schema_1 = require("./ticket.schema");
let SeatsModule = class SeatsModule {
};
SeatsModule = __decorate([
    common_1.Module({
        imports: [
            mongoose_1.MongooseModule.forFeature([
                {
                    name: seat_schema_1.Seat.name,
                    schema: seat_schema_1.SeatSchema,
                },
                {
                    name: ticket_schema_1.Ticket.name,
                    schema: ticket_schema_1.TicketSchema,
                },
                {
                    name: theatre_schema_1.Theatre.name,
                    schema: theatre_schema_1.TheatreSchema,
                },
                {
                    name: show_time_schema_1.ShowTime.name,
                    schema: show_time_schema_1.ShowTimeSchema,
                }
            ]),
            auth_module_1.AuthModule,
            users_module_1.UsersModule,
            config_module_1.ConfigModule,
        ],
        controllers: [seats_controller_1.SeatsController],
        providers: [seats_service_1.SeatsService]
    })
], SeatsModule);
exports.SeatsModule = SeatsModule;
//# sourceMappingURL=seats.module.js.map