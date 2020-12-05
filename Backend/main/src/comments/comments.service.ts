import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { DocumentDefinition, Model, Types } from 'mongoose';
import { Comment } from './comment.schema';
import { InjectModel } from '@nestjs/mongoose';
import { Movie } from '../movies/movie.schema';
import { User } from '../users/user.schema';
import * as faker from 'faker';
import { checkCompletedLogin, getSkipLimit } from '../common/utils';
import { PaginationDto } from '../common/pagination.dto';
import { CommentsAndRatingSummary, CreateCommentDto } from './comment.dto';
import { UserPayload } from '../auth/get-user.decorator';
import { MoviesService } from '../movies/movies.service';

const rateStars = [1, 2, 3, 4, 5];

function randomStar() {
  return rateStars[Math.floor(Math.random() * rateStars.length)];
}

//
//
//

const emojis =
    '😀,😃,😄,😁,😆,😅,😂,🤣,😊,🙂,🙃,😉,😌,😍,😘,😗,😙,😚,😋,😛,😝,😜,🤪,🤨,🧐,🤓,😎,🤩,😏,😒,😞,😔,😟,😕,🙁,😣,😖,😫,😩,😢,😭,😤,😠,😡,🤬,🤯,😳,😱,😨,😰,😥,😓,🤗,🤔,🤭,🤫,🤥,😶,😐,😑,😬,🙄,😯,😦,😧,😮,😲,😴,🤤,😪,😵,🤐,🤢,🤮,🤧,😷,🤒,🤕,🤑,🤠,😈,👿,👹,👺,🤡,💩,👻,💀,👽,👾,🤖,🎃,😺,😸,😹,😻,😼,😽,🙀,😿,😾,🤲,👐,🙌,👏,🤝,👍,👎,👊,✊,🤛,🤞,🤟,🤘,👌,👉,👈,👆,👇,✋,🤚,🖐,🖖,👋,🤙,💪,🖕,🙏';

const emojisArray = emojis.split(',');

function emojiRandom() {
  return emojisArray[Math.floor(Math.random() * emojisArray.length)];
}

@Injectable()
export class CommentsService {
  private readonly logger = new Logger('CommentsService');

  constructor(
      @InjectModel(Comment.name) private readonly commentModel: Model<Comment>,
      @InjectModel(Movie.name) private readonly movieModel: Model<Movie>,
      @InjectModel(User.name) private readonly userModel: Model<User>,
      private readonly moviesService: MoviesService,
  ) {}

  async seed() {
    // const list = await this.movieModel.find({});
    // for (const m of list) {
    //   const com = await this.commentModel.find({ movie: m._id });
    //   if (com.length === 0) {
    //     await this.movieModel.findByIdAndUpdate(m._id, { total_favorite: 0, total_rate: 0, rate_star: 0 }).exec();
    //   } else {
    //     const rate_star = com.reduce((acc, e) => acc + e.rate_star, 0) / com.length;
    //     await this.movieModel.findByIdAndUpdate(m._id, { total_favorite: 0, total_rate: com.length, rate_star }).exec();
    //   }
    // }
    // this.logger.debug(`Seed comments done`);
    // return;
    await this.seedNowPlayingMovies();
    await this.seedComingSoonMovies();
  }

  private async seedComingSoonMovies() {
    this.logger.debug(`Seed comments start`, '2');
    const count = await this.userModel.estimatedDocumentCount();

    const movies = await Promise.all([
      await this.moviesService.getComingSoonMovies((() => {
            const paginationDto = new PaginationDto();
            paginationDto.page = 1;
            paginationDto.per_page = 10;
            return paginationDto;
          })()
      ),
      await this.moviesService.getComingSoonMovies((() => {
            const paginationDto = new PaginationDto();
            paginationDto.page = 3;
            paginationDto.per_page = 10;
            return paginationDto;
          })()
      ),
    ]).then(([a, b]) => [...a, ...b]);
    this.logger.debug(movies.length, 'MOVIES.LENGTH');

    let createdCount = 0;
    for (const movie of movies) {
      const skip = Math.floor(Math.random() * count);
      const users = await this.userModel.find({})
          .skip(skip)
          .limit(20);

      for (let i = 0; i < 5; i++) {
        for (const user of users) {
          const doc: Omit<DocumentDefinition<Comment>, '_id'> = {
            content: `${faker.hacker.phrase()} ${emojiRandom()}`,
            rate_star: randomStar(),
            movie: movie._id,
            user: user._id,
            is_active: true,
          };
          await this.commentModel.create(doc);
          createdCount++;
        }
      }
    }


    this.logger.debug(createdCount, '2');
    this.logger.debug(`Seed comments done`, '2');
  }

  private async seedNowPlayingMovies() {
    this.logger.debug(`Seed comments start`, '1');
    const count = await this.userModel.estimatedDocumentCount();

    const movies = await Promise.all([
      await this.moviesService.getNowShowingMovies(null, (() => {
            const paginationDto = new PaginationDto();
            paginationDto.page = 1;
            paginationDto.per_page = 10;
            return paginationDto;
          })()
      ),
      await this.moviesService.getNowShowingMovies(null, (() => {
            const paginationDto = new PaginationDto();
            paginationDto.page = 3;
            paginationDto.per_page = 10;
            return paginationDto;
          })()
      ),
    ]).then(([a, b]) => [...a, ...b]);
    this.logger.debug(movies.length, 'MOVIES.LENGTH');

    let createdCount = 0;
    for (const movie of movies) {
      const skip = Math.floor(Math.random() * count);
      const users = await this.userModel.find({})
          .skip(skip)
          .limit(20);

      for (let i = 0; i < 5; i++) {
        for (const user of users) {
          const doc: Omit<DocumentDefinition<Comment>, '_id'> = {
            content: `${faker.hacker.phrase()} ${emojiRandom()}`,
            rate_star: randomStar(),
            movie: movie._id,
            user: user._id,
            is_active: true,
          };
          await this.commentModel.create(doc);
          createdCount++;
        }
      }
    }

    this.logger.debug(createdCount, '1');
    this.logger.debug(`Seed comments done`, '1');
  }

  async getCommentsByMovieId(
      movieId: string,
      paginationDto: PaginationDto,
  ): Promise<CommentsAndRatingSummary> {
    const skipLimit = getSkipLimit(paginationDto);

    const results: {
      comments: Comment[];
      rate_avg: number;
      total: number
    }[] = await this.commentModel.aggregate()
        .match({ movie: new Types.ObjectId(movieId) })
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

    const result = results?.[0];

    return new CommentsAndRatingSummary(
        result?.comments ?? [],
        result?.rate_avg ?? 0,
        result?.total ?? 0,
    );
  }

  async createComment(user: UserPayload, dto: CreateCommentDto): Promise<Comment> {
    const userId = checkCompletedLogin(user)._id;

    const movie: Movie | null = await this.movieModel.findById(dto.movie_id);

    if (!movie) {
      throw new NotFoundException(`Movie with id ${dto.movie_id} not found!`);
    }

    const doc: Omit<DocumentDefinition<Comment>, '_id'> = {
      content: dto.content,
      rate_star: dto.rate_star,
      movie: movie._id,
      user: userId,
      is_active: true,
    };

    const saved = await this.commentModel.create(doc);

    const total_rate = movie.total_rate + 1;
    const rate_star = (movie.rate_star * movie.total_rate + doc.rate_star) / total_rate;
    await this.movieModel.updateOne(
        { _id: doc.movie },
        { total_rate, rate_star }
    );
    this.logger.debug(`[DONE] updated ${movie._id} ${total_rate}, ${rate_star}`);

    return await saved.populate('user').execPopulate();
  }

  async deleteComment(id: string): Promise<Comment> {
    const result = await this.commentModel.findByIdAndDelete(id);
    if (result == null) {
      throw new NotFoundException(`Comment with id ${id} not found`);
    }

    const movie = await this.movieModel.findById(result.movie);
    const totalRate = Math.max(movie.total_rate - 1, 0);
    movie.rate_star = totalRate == 0 ? 0 : (movie.rate_star * movie.total_rate - result.rate_star) / totalRate;
    movie.total_rate = totalRate;
    await movie.save();

    return result;
  }
}
