"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppModule = void 0;
const common_1 = require("@nestjs/common");
const app_controller_1 = require("./app.controller");
const app_service_1 = require("./app.service");
const config_module_1 = require("./config/config.module");
const mongoose_1 = require("@nestjs/mongoose");
const config_service_1 = require("./config/config.service");
const auth_module_1 = require("./auth/auth.module");
const users_module_1 = require("./users/users.module");
const dist_1 = require("@aginix/nestjs-firebase-admin/dist");
const movies_module_1 = require("./movies/movies.module");
const categories_module_1 = require("./categories/categories.module");
const people_module_1 = require("./people/people.module");
const show_times_module_1 = require("./show-times/show-times.module");
const theatres_module_1 = require("./theatres/theatres.module");
const comments_module_1 = require("./comments/comments.module");
const seats_module_1 = require("./seats/seats.module");
const reservations_module_1 = require("./reservations/reservations.module");
const promotions_module_1 = require("./promotions/promotions.module");
const products_module_1 = require("./products/products.module");
const favorites_module_1 = require("./favorites/favorites.module");
const admin = require("firebase-admin");
const serve_static_1 = require("@nestjs/serve-static");
const path_1 = require("path");
const socket_module_1 = require("./socket/socket.module");
let AppModule = class AppModule {
};
AppModule = __decorate([
    common_1.Module({
        imports: [
            mongoose_1.MongooseModule.forRootAsync({
                imports: [config_module_1.ConfigModule],
                inject: [config_service_1.ConfigService],
                useFactory: (configService) => ({
                    uri: configService.get("MONGODB_URL"),
                    useFindAndModify: false,
                })
            }),
            dist_1.FirebaseAdminModule.forRootAsync({
                useFactory: () => ({
                    credential: admin.credential.applicationDefault(),
                }),
            }),
            serve_static_1.ServeStaticModule.forRoot({
                rootPath: path_1.join(__dirname, '..', '..', 'static'),
            }),
            config_module_1.ConfigModule,
            auth_module_1.AuthModule,
            users_module_1.UsersModule,
            movies_module_1.MoviesModule,
            categories_module_1.CategoriesModule,
            people_module_1.PeopleModule,
            show_times_module_1.ShowTimesModule,
            theatres_module_1.TheatresModule,
            comments_module_1.CommentsModule,
            common_1.HttpModule,
            seats_module_1.SeatsModule,
            reservations_module_1.ReservationsModule,
            promotions_module_1.PromotionsModule,
            products_module_1.ProductsModule,
            favorites_module_1.FavoritesModule,
            socket_module_1.SocketModule,
        ],
        controllers: [app_controller_1.AppController],
        providers: [
            app_service_1.AppService
        ],
    })
], AppModule);
exports.AppModule = AppModule;
//# sourceMappingURL=app.module.js.map