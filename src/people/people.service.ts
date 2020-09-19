import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Person } from './person.schema';
import { Model } from 'mongoose';

@Injectable()
export class PeopleService {
  constructor(
      @InjectModel(Person.name) readonly personModel: Model<Person>,
  ) {}
}
