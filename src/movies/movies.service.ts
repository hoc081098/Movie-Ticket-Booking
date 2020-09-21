import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Movie } from './movie.schema';
import { Model } from 'mongoose';

@Injectable()
export class MoviesService {
  constructor(
      @InjectModel(Movie.name) private readonly movieModel: Model<Movie>,
  ) {}

  all() {
    return this.movieModel
        .find({})
        .populate('actors')
        .populate('directors')
        .exec();
  }
}
