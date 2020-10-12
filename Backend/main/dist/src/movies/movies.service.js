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
exports.MoviesService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const movie_schema_1 = require("./movie.schema");
const mongoose_2 = require("mongoose");
const show_time_schema_1 = require("../show-times/show-time.schema");
const dayjs = require("dayjs");
const theatre_schema_1 = require("../theatres/theatre.schema");
const utils_1 = require("../common/utils");
let MoviesService = class MoviesService {
    constructor(movieModel, showTimeModel, theatreModel) {
        this.movieModel = movieModel;
        this.showTimeModel = showTimeModel;
        this.theatreModel = theatreModel;
        this.logger = new common_1.Logger('MoviesService');
    }
    all() {
        return this.movieModel
            .find({})
            .populate('actors')
            .populate('directors')
            .exec();
    }
    getNowShowingMovies(center, paginationDto) {
        const currentDay = new Date();
        const start = dayjs(currentDay).startOf('day').toDate();
        const end = dayjs(currentDay).endOf('day').add(4, 'day').toDate();
        const skipLimit = utils_1.getSkipLimit(paginationDto);
        this.logger.debug(`getNowShowingMovies: ${currentDay} -- ${start} -- ${end} -- ${center}`);
        return this.theatreModel.aggregate([
            ...(center != null
                ?
                    [
                        {
                            $geoNear: {
                                near: {
                                    type: 'Point',
                                    coordinates: center,
                                },
                                distanceField: 'distance',
                                includeLocs: 'location',
                                maxDistance: utils_1.constants.maxDistanceInMeters,
                                spherical: true,
                            },
                        },
                        { $match: { is_active: true } }
                    ]
                : []),
            {
                $lookup: {
                    from: 'show_times',
                    localField: '_id',
                    foreignField: 'theatre',
                    as: 'show_time',
                }
            },
            { $unwind: '$show_time' },
            {
                $match: {
                    $and: [
                        { 'show_time.start_time': { $gte: start } },
                        { 'show_time.end_time': { $lte: end } },
                        { 'show_time.is_active': true },
                    ]
                },
            },
            {
                $sort: {
                    'show_time.start_time': 1
                }
            },
            {
                $lookup: {
                    from: 'movies',
                    localField: 'show_time.movie',
                    foreignField: '_id',
                    as: 'movie',
                }
            },
            { $unwind: '$movie' },
            {
                $match: {
                    'movie.released_date': { $lte: start },
                },
            },
            {
                $group: {
                    _id: '$movie._id',
                    data: { $first: '$movie' },
                }
            },
            {
                $unwind: '$data'
            },
            {
                $skip: skipLimit.skip,
            },
            {
                $limit: skipLimit.limit
            },
            {
                $replaceRoot: {
                    newRoot: '$data'
                }
            }
        ]).exec();
    }
    getComingSoonMovies(paginationDto) {
        const currentDay = new Date();
        const startOfTomorrow = dayjs(currentDay).startOf('day').add(1, 'day').toDate();
        const skipLimit = utils_1.getSkipLimit(paginationDto);
        this.logger.debug(`getComingSoonMovies: ${currentDay} -- ${startOfTomorrow}`);
        return this.movieModel.aggregate([
            {
                $match: {
                    released_date: {
                        $gte: startOfTomorrow,
                    }
                },
            },
            {
                $lookup: {
                    from: 'show_times',
                    localField: '_id',
                    foreignField: 'movie',
                    as: 'show_times',
                },
            },
            {
                $match: {
                    'show_times.0': {
                        $exists: false
                    }
                }
            },
            {
                $sort: {
                    released_date: 1,
                }
            },
            {
                $skip: skipLimit.skip,
            },
            {
                $limit: skipLimit.limit
            },
        ]).exec();
    }
    async getDetail(id) {
        var _a;
        const movie = (_a = (await this.movieModel
            .findOne({ _id: id })
            .populate('actors')
            .populate('directors')
            .populate({
            path: 'categories',
            populate: { path: 'category_id' },
        })
            .exec())) === null || _a === void 0 ? void 0 : _a.toJSON();
        if (movie == null) {
            throw new common_1.NotFoundException(`Movie with id: ${id} not found`);
        }
        movie.categories = movie.categories.map(c => c.category_id);
        return movie;
    }
};
MoviesService = __decorate([
    common_1.Injectable(),
    __param(0, mongoose_1.InjectModel(movie_schema_1.Movie.name)),
    __param(1, mongoose_1.InjectModel(show_time_schema_1.ShowTime.name)),
    __param(2, mongoose_1.InjectModel(theatre_schema_1.Theatre.name)),
    __metadata("design:paramtypes", [mongoose_2.Model,
        mongoose_2.Model,
        mongoose_2.Model])
], MoviesService);
exports.MoviesService = MoviesService;
//# sourceMappingURL=movies.service.js.map