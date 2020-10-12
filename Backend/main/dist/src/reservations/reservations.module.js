"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ReservationsModule = void 0;
const common_1 = require("@nestjs/common");
const reservations_controller_1 = require("./reservations.controller");
const reservations_service_1 = require("./reservations.service");
const mongoose_1 = require("@nestjs/mongoose");
const reservation_schema_1 = require("./reservation.schema");
const auth_module_1 = require("../auth/auth.module");
const users_module_1 = require("../users/users.module");
const config_module_1 = require("../config/config.module");
const product_schema_1 = require("../products/product.schema");
const ticket_schema_1 = require("../seats/ticket.schema");
const socket_module_1 = require("../socket/socket.module");
let ReservationsModule = class ReservationsModule {
};
ReservationsModule = __decorate([
    common_1.Module({
        imports: [
            socket_module_1.SocketModule,
            mongoose_1.MongooseModule.forFeature([
                {
                    name: reservation_schema_1.Reservation.name,
                    schema: reservation_schema_1.ReservationSchema,
                },
                {
                    name: product_schema_1.Product.name,
                    schema: product_schema_1.ProductSchema,
                },
                {
                    name: ticket_schema_1.Ticket.name,
                    schema: ticket_schema_1.TicketSchema,
                }
            ]),
            auth_module_1.AuthModule,
            users_module_1.UsersModule,
            config_module_1.ConfigModule,
        ],
        controllers: [reservations_controller_1.ReservationsController],
        providers: [reservations_service_1.ReservationsService]
    })
], ReservationsModule);
exports.ReservationsModule = ReservationsModule;
//# sourceMappingURL=reservations.module.js.map