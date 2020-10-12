import { Person } from './person.schema';
import { Model } from 'mongoose';
export declare class PeopleService {
    readonly personModel: Model<Person>;
    constructor(personModel: Model<Person>);
}
