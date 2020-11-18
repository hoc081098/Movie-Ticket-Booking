import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Person } from './person.schema';
import { Model } from 'mongoose';

@Injectable()
export class PeopleService {
  constructor(
      @InjectModel(Person.name) readonly personModel: Model<Person>,
  ) {}

  searchByName(name: string): Promise<Person[]> {
    return this.personModel
        .find({
          full_name: {
            $regex: name,
            $options: 'i',
          }
        })
        .exec();
  }
}
