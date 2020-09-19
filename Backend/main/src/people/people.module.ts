import { Module } from '@nestjs/common';
import { PeopleController } from './people.controller';
import { PeopleService } from './people.service';
import { MongooseModule } from '@nestjs/mongoose';
import { Person, PersonSchema } from './person.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      {
        name: Person.name,
        schema: PersonSchema,
      }
    ]),
  ],
  controllers: [PeopleController],
  providers: [PeopleService]
})
export class PeopleModule {}
