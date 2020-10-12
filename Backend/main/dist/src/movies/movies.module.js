"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.MoviesModule = void 0;
const common_1 = require("@nestjs/common");
const movies_service_1 = require("./movies.service");
const movies_controller_1 = require("./movies.controller");
const mongoose_1 = require("@nestjs/mongoose");
const movie_schema_1 = require("./movie.schema");
const movie_category_schema_1 = require("./movie-category.schema");
const movie_db_service_1 = require("./movie-db/movie-db.service");
const config_module_1 = require("../config/config.module");
const category_schema_1 = require("../categories/category.schema");
const person_schema_1 = require("../people/person.schema");
const show_time_schema_1 = require("../show-times/show-time.schema");
const theatre_schema_1 = require("../theatres/theatre.schema");
const auth_module_1 = require("../auth/auth.module");
const users_module_1 = require("../users/users.module");
let MoviesModule = class MoviesModule {
};
MoviesModule = __decorate([
    common_1.Module({
        imports: [
            mongoose_1.MongooseModule.forFeature([
                {
                    name: movie_schema_1.Movie.name,
                    schema: movie_schema_1.MovieSchema,
                },
                {
                    name: movie_category_schema_1.MovieCategory.name,
                    schema: movie_category_schema_1.MovieCategorySchema,
                },
                {
                    name: category_schema_1.Category.name,
                    schema: category_schema_1.CategorySchema,
                },
                {
                    name: person_schema_1.Person.name,
                    schema: person_schema_1.PersonSchema,
                },
                {
                    name: show_time_schema_1.ShowTime.name,
                    schema: show_time_schema_1.ShowTimeSchema,
                },
                {
                    name: theatre_schema_1.Theatre.name,
                    schema: theatre_schema_1.TheatreSchema,
                }
            ]),
            common_1.HttpModule,
            config_module_1.ConfigModule,
            auth_module_1.AuthModule,
            users_module_1.UsersModule,
            config_module_1.ConfigModule,
        ],
        providers: [movies_service_1.MoviesService, movie_db_service_1.MovieDbService],
        controllers: [movies_controller_1.MoviesController]
    })
], MoviesModule);
exports.MoviesModule = MoviesModule;
//# sourceMappingURL=movies.module.js.map