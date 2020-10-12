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
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CategoriesService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const category_schema_1 = require("./category.schema");
const mongoose_2 = require("mongoose");
const operators_1 = require("rxjs/operators");
const fromArray_1 = require("rxjs/internal/observable/fromArray");
const rxjs_1 = require("rxjs");
const config_service_1 = require("../config/config.service");
let CategoriesService = class CategoriesService {
    constructor(categoryMode, httpService, configService) {
        this.categoryMode = categoryMode;
        this.httpService = httpService;
        this.configService = configService;
        this.logger = new common_1.Logger('CategoriesService');
    }
    seed() {
        return rxjs_1.defer(() => this.categoryMode.estimatedDocumentCount())
            .pipe(operators_1.tap(count => this.logger.debug(`Count ${count}`)), operators_1.filter(count => count == 0), operators_1.mergeMap(() => this.httpService
            .get(`https://api.themoviedb.org/3/genre/movie/list?api_key=${this.configService.get("MOVIE_DB_API_KEY")}`)
            .pipe(operators_1.map(response => response.data.genres), operators_1.tap(cats => this.logger.debug(`GET ${JSON.stringify(cats)}`)), operators_1.mergeMap(cats => fromArray_1.fromArray(cats)), operators_1.concatMap(({ name }) => new this.categoryMode({ name }).save()), operators_1.toArray(), operators_1.tap(cats => this.logger.debug(`Saved ${JSON.stringify(cats)}`)))));
    }
};
CategoriesService = __decorate([
    common_1.Injectable(),
    __param(0, mongoose_1.InjectModel(category_schema_1.Category.name)),
    __metadata("design:paramtypes", [mongoose_2.Model,
        common_1.HttpService,
        config_service_1.ConfigService])
], CategoriesService);
exports.CategoriesService = CategoriesService;
//# sourceMappingURL=categories.service.js.map