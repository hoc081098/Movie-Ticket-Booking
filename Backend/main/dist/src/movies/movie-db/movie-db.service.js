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
exports.MovieDbService = void 0;
const common_1 = require("@nestjs/common");
const config_service_1 = require("../../config/config.service");
const operators_1 = require("rxjs/operators");
const rxjs_1 = require("rxjs");
const movie_schema_1 = require("../movie.schema");
const mongoose_1 = require("mongoose");
const category_schema_1 = require("../../categories/category.schema");
const movie_category_schema_1 = require("../movie-category.schema");
const person_schema_1 = require("../../people/person.schema");
const fromArray_1 = require("rxjs/internal/observable/fromArray");
const mongoose_2 = require("@nestjs/mongoose");
const dayjs = require("dayjs");
let MovieDbService = class MovieDbService {
    constructor(httpService, configService, movieModel, categoryModel, movieCategoryModel, personModel) {
        this.httpService = httpService;
        this.configService = configService;
        this.movieModel = movieModel;
        this.categoryModel = categoryModel;
        this.movieCategoryModel = movieCategoryModel;
        this.personModel = personModel;
        this.logger = new common_1.Logger('MovieDbService');
        this.catDocByName = new Map();
        this.personByFullName = new Map();
        this.days = Array
            .from({ length: 7 * 5 }, (_, i) => i)
            .map(i => dayjs(new Date()).add(i - 7, 'day').toDate());
        this.dayCount = 0;
    }
    seed(query, page, year) {
        return this.search(query, page, year)
            .pipe(operators_1.map(res => res.results), operators_1.tap(results => this.logger.debug(`Search ${query} ${page} ${year} -> ${results.length} items`)), operators_1.mergeMap(results => fromArray_1.fromArray(results)), operators_1.map(movie => movie.id), operators_1.concatMap(id => rxjs_1.zip(this.detail(id), this.credits(id))
            .pipe(operators_1.mergeMap(([detail, credits]) => this.saveMovieDetail(detail, credits)))), operators_1.ignoreElements(), operators_1.tap({ complete: () => this.logger.debug('Saved done') }));
    }
    get apiKey() {
        return this.configService.get("MOVIE_DB_API_KEY");
    }
    search(query, page, year) {
        const url = `https://api.themoviedb.org/3/search/movie?api_key=${this.apiKey}&language=en-US&query=${query}&page=${page}&include_adult=false&year=${year}`;
        return this.httpService
            .get(url)
            .pipe(operators_1.map(response => response.data));
    }
    detail(movieId) {
        const url = `https://api.themoviedb.org/3/movie/${movieId}?api_key=${this.apiKey}&language=en-US&append_to_response=videos`;
        return this.httpService
            .get(url)
            .pipe(operators_1.map(response => response.data));
    }
    credits(movieId) {
        const url = `https://api.themoviedb.org/3/movie/${movieId}/credits?api_key=${this.apiKey}`;
        return this.httpService
            .get(url)
            .pipe(operators_1.map(response => response.data));
    }
    async getCategories(cats) {
        const categories = [];
        const catNames = cats.map(c => c.name);
        for (const name of catNames) {
            const cache = this.catDocByName.get(name);
            if (cache) {
                this.logger.debug(`Get category by '${name}' hits cache`);
                categories.push(cache);
                continue;
            }
            const found = await this.categoryModel.findOne({ name });
            if (!found) {
                throw Error(`Not found category by name: ${name}`);
            }
            this.logger.debug(`Get category by '${name}' found`);
            this.catDocByName.set(name, found);
            categories.push(found);
        }
        return categories;
    }
    async getPeople(peopleRaw) {
        const people = [];
        for (const p of peopleRaw) {
            const cache = this.personByFullName.get(p.name);
            if (cache) {
                this.logger.debug(`Get person by '${p.name}' hits cache`);
                people.push(cache);
                continue;
            }
            const found = await this.personModel.findOne({ full_name: p.name });
            if (found) {
                this.logger.debug(`Get person by '${p.name}' found`);
                this.personByFullName.set(p.name, found);
                people.push(found);
                continue;
            }
            const personDoc = {
                avatar: 'http://image.tmdb.org/t/p/w185' + p.profile_path,
                full_name: p.name,
                is_active: true
            };
            const created = await this.personModel.create(personDoc);
            this.logger.debug(`Get person by '${p.name}' created ${JSON.stringify(created)}`);
            this.personByFullName.set(p.name, created);
            people.push(created);
        }
        return people;
    }
    async saveMovieCategory(saved, categories) {
        for (const category of categories) {
            const movieCategory = {
                'category_id': category._id,
                'movie_id': saved._id,
            };
            await this.movieCategoryModel.findOneAndUpdate(movieCategory, movieCategory, { upsert: true });
        }
    }
    async saveMovieDetail(v, c) {
        var _a, _b;
        this.logger.debug('Start save movie detail');
        this.dayCount = (this.dayCount + 1) % this.days.length;
        const actors = await this.getPeople(c.cast.slice(0, 10));
        const directors = await this.getPeople(c.crew.filter(c => c.job === 'Director'));
        const videoKey = (_b = (_a = v.videos.results) === null || _a === void 0 ? void 0 : _a[0]) === null || _b === void 0 ? void 0 : _b.key;
        const movieDoc = {
            rate_star: 0,
            total_rate: 0,
            total_favorite: 0,
            age_type: 'P',
            title: v.title,
            trailer_video_url: videoKey ? `https://www.youtube.com/watch?v=${videoKey}` : null,
            poster_url: v.poster_path ? `https://image.tmdb.org/t/p/w342${v.poster_path}` : null,
            overview: v.overview,
            released_date: this.days[this.dayCount],
            duration: v.runtime,
            directors: directors.map(d => d._id),
            actors: actors.map(d => d._id),
            is_active: true,
            original_language: v.original_language
        };
        const saved = await this.movieModel.create(movieDoc);
        const categories = await this.getCategories(v.genres);
        await this.saveMovieCategory(saved, categories);
        this.logger.debug('End save movie detail');
    }
    ;
    updateVideoUrl() {
        return rxjs_1.defer(() => this.movieModel
            .find({
            $or: [
                { trailer_video_url: { $exists: false } },
                { trailer_video_url: null },
                { trailer_video_url: '' },
            ]
        })
            .sort({ createdAt: -1 }))
            .pipe(operators_1.tap(movies => this.logger.debug(`Start update video url ${movies.length}`)), operators_1.mergeMap(movies => rxjs_1.from(movies)), operators_1.concatMap((movie, index) => this.search(movie.title, 1, null)
            .pipe(operators_1.map(searchResults => { var _a; return (_a = searchResults.results[0]) === null || _a === void 0 ? void 0 : _a.id; }), operators_1.filter(id => !!id), operators_1.mergeMap(id => this.detail(id)), operators_1.mergeMap(async (v) => {
            var _a, _b;
            const videoKey = (_b = (_a = v.videos.results) === null || _a === void 0 ? void 0 : _a[0]) === null || _b === void 0 ? void 0 : _b.key;
            if (videoKey) {
                movie.trailer_video_url = `https://www.youtube.com/watch?v=${videoKey}`;
                await movie.save();
                this.logger.debug(`Update ${index} ${movie._id} -> ${movie.trailer_video_url}`);
            }
        }))), operators_1.tap({ complete: () => this.logger.debug(`Done update video url`) }));
    }
};
MovieDbService = __decorate([
    common_1.Injectable(),
    __param(2, mongoose_2.InjectModel(movie_schema_1.Movie.name)),
    __param(3, mongoose_2.InjectModel(category_schema_1.Category.name)),
    __param(4, mongoose_2.InjectModel(movie_category_schema_1.MovieCategory.name)),
    __param(5, mongoose_2.InjectModel(person_schema_1.Person.name)),
    __metadata("design:paramtypes", [common_1.HttpService,
        config_service_1.ConfigService,
        mongoose_1.Model,
        mongoose_1.Model,
        mongoose_1.Model,
        mongoose_1.Model])
], MovieDbService);
exports.MovieDbService = MovieDbService;
//# sourceMappingURL=movie-db.service.js.map