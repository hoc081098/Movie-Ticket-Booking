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
exports.CommentsService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("mongoose");
const comment_schema_1 = require("./comment.schema");
const mongoose_2 = require("@nestjs/mongoose");
const movie_schema_1 = require("../movies/movie.schema");
const user_schema_1 = require("../users/user.schema");
const faker = require("faker");
const utils_1 = require("../common/utils");
const comment_dto_1 = require("./comment.dto");
const rateStars = [1, 2, 3, 4, 5];
function randomStar() {
    return rateStars[Math.floor(Math.random() * rateStars.length)];
}
const emojis = '😀,😃,😄,😁,😆,😅,😂,🤣,😊,🙂,🙃,😉,😌,😍,😘,😗,😙,😚,😋,😛,😝,😜,🤪,🤨,🧐,🤓,😎,🤩,😏,😒,😞,😔,😟,😕,🙁,😣,😖,😫,😩,😢,😭,😤,😠,😡,🤬,🤯,😳,😱,😨,😰,😥,😓,🤗,🤔,🤭,🤫,🤥,😶,😐,😑,😬,🙄,😯,😦,😧,😮,😲,😴,🤤,😪,😵,🤐,🤢,🤮,🤧,😷,🤒,🤕,🤑,🤠,😈,👿,👹,👺,🤡,💩,👻,💀,👽,👾,🤖,🎃,😺,😸,😹,😻,😼,😽,🙀,😿,😾,🤲,👐,🙌,👏,🤝,👍,👎,👊,✊,🤛,🤞,🤟,🤘,👌,👉,👈,👆,👇,✋,🤚,🖐,🖖,👋,🤙,💪,🖕,🙏';
const emojisArray = emojis.split(',');
function emojiRandom() {
    return emojisArray[Math.floor(Math.random() * emojisArray.length)];
}
let CommentsService = class CommentsService {
    constructor(commentModel, movieModel, userModel) {
        this.commentModel = commentModel;
        this.movieModel = movieModel;
        this.userModel = userModel;
        this.logger = new common_1.Logger('CommentsService');
    }
    async seed() {
        this.logger.debug(`Seed comments start`);
        const users = await this.userModel.find({});
        const movies = await this.movieModel.find({});
        const comments = [];
        for (const movie of movies) {
            for (let i = 0; i < 20; i++) {
                for (const user of users) {
                    const doc = {
                        content: `${faker.hacker.phrase()} ${emojiRandom()}`,
                        rate_star: randomStar(),
                        movie: movie._id,
                        user: user._id,
                        is_active: true,
                    };
                    const created = await this.commentModel.create(doc);
                    comments.push(created);
                }
            }
        }
        this.logger.debug(`Seed comments done`);
        return comments;
    }
    async getCommentsByMovieId(movieId, paginationDto) {
        var _a, _b, _c;
        const skipLimit = utils_1.getSkipLimit(paginationDto);
        const results = await this.commentModel.aggregate()
            .match({ movie: new mongoose_1.Types.ObjectId(movieId) })
            .facet({
            comments: [
                {
                    $lookup: {
                        from: 'users',
                        localField: 'user',
                        foreignField: '_id',
                        as: 'user',
                    }
                },
                { $unwind: '$user' },
                { $sort: { createdAt: -1 } },
                { $skip: skipLimit.skip },
                { $limit: skipLimit.limit },
            ],
            rate_avg: [
                {
                    $group: {
                        _id: null,
                        rate_avg: { $avg: '$rate_star' },
                    }
                },
            ],
            total: [
                { $count: 'total' },
            ]
        })
            .project({
            rate_avg: {
                $let: {
                    vars: {
                        first: {
                            $arrayElemAt: ['$rate_avg', 0],
                        }
                    },
                    in: {
                        $ifNull: [
                            '$$first.rate_avg',
                            0
                        ]
                    }
                },
            },
            total: {
                $arrayElemAt: [
                    '$total.total',
                    0,
                ]
            },
            comments: 1,
        });
        const result = results === null || results === void 0 ? void 0 : results[0];
        return new comment_dto_1.CommentsAndRatingSummary((_a = result === null || result === void 0 ? void 0 : result.comments) !== null && _a !== void 0 ? _a : [], (_b = result === null || result === void 0 ? void 0 : result.rate_avg) !== null && _b !== void 0 ? _b : 0, (_c = result === null || result === void 0 ? void 0 : result.total) !== null && _c !== void 0 ? _c : 0);
    }
    async createComment(user, dto) {
        const userId = utils_1.checkCompletedLogin(user)._id;
        const movie = await this.movieModel.findById(dto.movie_id);
        if (!movie) {
            throw new common_1.NotFoundException(`Movie with id ${dto.movie_id} not found!`);
        }
        const doc = {
            content: dto.content,
            rate_star: dto.rate_star,
            movie: movie._id,
            user: userId,
            is_active: true,
        };
        const saved = await this.commentModel.create(doc);
        const total_rate = movie.total_rate + 1;
        const rate_star = (movie.rate_star * movie.total_rate + doc.rate_star) / total_rate;
        await this.movieModel.updateOne({ _id: doc.movie }, { total_rate, rate_star });
        this.logger.debug(`[DONE] updated ${movie._id} ${total_rate}, ${rate_star}`);
        return await saved.populate('user').execPopulate();
    }
    async deleteComment(id) {
        const result = await this.commentModel.findByIdAndDelete(id);
        if (result == null) {
            throw new common_1.NotFoundException(`Comment with id ${id} not found`);
        }
        const movie = await this.movieModel.findById(result.movie);
        const totalRate = Math.max(movie.total_rate - 1, 0);
        movie.rate_star = totalRate == 0 ? 0 : (movie.rate_star * movie.total_rate - result.rate_star) / totalRate;
        movie.total_rate = totalRate;
        await movie.save();
        return result;
    }
};
CommentsService = __decorate([
    common_1.Injectable(),
    __param(0, mongoose_2.InjectModel(comment_schema_1.Comment.name)),
    __param(1, mongoose_2.InjectModel(movie_schema_1.Movie.name)),
    __param(2, mongoose_2.InjectModel(user_schema_1.User.name)),
    __metadata("design:paramtypes", [mongoose_1.Model,
        mongoose_1.Model,
        mongoose_1.Model])
], CommentsService);
exports.CommentsService = CommentsService;
//# sourceMappingURL=comments.service.js.map