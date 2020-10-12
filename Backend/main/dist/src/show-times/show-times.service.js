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
exports.ShowTimesService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const show_time_schema_1 = require("./show-time.schema");
const mongoose = require("mongoose");
const mongoose_2 = require("mongoose");
const movie_schema_1 = require("../movies/movie.schema");
const theatre_schema_1 = require("../theatres/theatre.schema");
const dayjs = require("dayjs");
const rxjs_1 = require("rxjs");
const operators_1 = require("rxjs/operators");
const utils_1 = require("../common/utils");
const isBetween = require('dayjs/plugin/isBetween');
dayjs.extend(isBetween);
let ShowTimesService = class ShowTimesService {
    constructor(showTimeModel, movieModel, theatreModel) {
        this.showTimeModel = showTimeModel;
        this.movieModel = movieModel;
        this.theatreModel = theatreModel;
        this.logger = new common_1.Logger('ShowTimesService');
        this.movieCount = null;
    }
    async seed() {
        const current = dayjs(new Date());
        const theatres = await this.theatreModel.find({});
        for (const theatre of theatres) {
            const [startHString, endHString] = theatre.opening_hours.split(' - ');
            let startH = +startHString.split(':')[0];
            const startM = +startHString.split(':')[1];
            if (startM > 0) {
                ++startH;
            }
            const [endH, endM] = endHString.split(':').map(x => +x);
            const hours = Array.from({ length: endH - startH + 1 }, (_, i) => i + startH);
            this.logger.debug(`Hours for ${theatre.name} are ${JSON.stringify(hours)} -- ${startH}:${startM} -> ${endH}:${endM}`);
            for (const room of theatre.rooms) {
                for (let dDate = -1; dDate <= 20; dDate++) {
                    const day = current.startOf('day').add(dDate, 'day');
                    const thStartTime = day.set('hour', startH).set('minute', startM);
                    const thEndTime = day.set('hour', endH).set('minute', endM);
                    const movie = await this.randomMovie();
                    for (const hour of hours) {
                        await this.checkAndSave(day, hour, movie, theatre, room, thStartTime, thEndTime);
                    }
                }
            }
        }
    }
    async checkAndSave(day, hour, movie, theatre, room, thStartTime, thEndTime) {
        const startTime = day
            .set('hour', hour)
            .set('minute', 0)
            .set('second', 0)
            .set('millisecond', 0);
        const endTime = startTime.add(movie.duration, 'minute');
        this.logger.debug(`Start saving show time: ${theatre.name} -- ${room} <> ${thStartTime.toDate()}-${thEndTime.toDate()} <> ${startTime}-${endTime}`);
        const showTimes = await this.showTimeModel
            .find({
            theatre: theatre._id,
            room,
            is_active: true,
            start_time: { $gte: thStartTime.toDate() },
            end_time: { $lte: thEndTime.toDate() },
        })
            .sort({ start_time: 'asc' });
        if (showTimes.length == 1) {
            if (startTime.isBefore(showTimes[0].end_time) && endTime.isAfter(showTimes[0].start_time)
                || startTime.isBefore(thStartTime) || endTime.isAfter(thEndTime)) {
                return;
            }
        }
        if (showTimes.length >= 2) {
            const array = await rxjs_1.from(showTimes)
                .pipe(operators_1.pairwise(), operators_1.filter(([prev, next]) => startTime.isBetween(prev.end_time, next.start_time)
                && endTime.isBetween(prev.end_time, next.start_time)
                && startTime.isBetween(thStartTime, thEndTime)
                && endTime.isBetween(thStartTime, thEndTime)), operators_1.take(1))
                .toPromise();
            if (array === undefined) {
                return;
            }
            this.logger.debug(`>>> Array ${array}`);
        }
        const doc = {
            movie: movie._id,
            theatre: theatre._id,
            room,
            is_active: true,
            end_time: endTime.toDate(),
            start_time: startTime.toDate(),
        };
        const showTime = await this.showTimeModel.create(doc);
        this.logger.debug(`Saved show time: ${JSON.stringify(showTime)}`);
    }
    async randomMovie() {
        var _a;
        const count = this.movieCount = (_a = this.movieCount) !== null && _a !== void 0 ? _a : await this.movieModel.count({});
        const skip = Math.floor(count * Math.random());
        return await this.movieModel.findOne().skip(skip).exec();
    }
    getShowTimesByMovieId(movieId, center) {
        const currentDay = new Date();
        const start = dayjs(currentDay).startOf('day').toDate();
        const end = dayjs(currentDay).endOf('day').add(4, 'day').toDate();
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
                $addFields: {
                    theatre: '$$ROOT',
                },
            },
            {
                $project: {
                    theatre: 1,
                }
            },
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
                        { 'show_time.movie': new mongoose.Types.ObjectId(movieId) },
                        { 'show_time.start_time': { $gte: start } },
                        { 'show_time.end_time': { $lte: end } },
                        { 'show_time.is_active': true },
                    ]
                },
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
            { $project: { movie: 0 } },
        ]).exec();
    }
};
ShowTimesService = __decorate([
    common_1.Injectable(),
    __param(0, mongoose_1.InjectModel(show_time_schema_1.ShowTime.name)),
    __param(1, mongoose_1.InjectModel(movie_schema_1.Movie.name)),
    __param(2, mongoose_1.InjectModel(theatre_schema_1.Theatre.name)),
    __metadata("design:paramtypes", [mongoose_2.Model,
        mongoose_2.Model,
        mongoose_2.Model])
], ShowTimesService);
exports.ShowTimesService = ShowTimesService;
//# sourceMappingURL=show-times.service.js.map