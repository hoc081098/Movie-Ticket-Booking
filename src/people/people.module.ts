import { Module } from '@nestjs/common';
import { PeopleController } from './people.controller';
import { PeopleService } from './people.service';
import { MongooseModule } from '@nestjs/mongoose';
import { Person, PersonSchema } from './person.schema';
import { AuthModule } from '../auth/auth.module';
import { UsersModule } from '../users/users.module';
import { ConfigModule } from '../config/config.module';

@Module({
  imports: [
    MongooseModule.forFeature([
      {
        name: Person.name,
        schema: PersonSchema,
      }
    ]),
    AuthModule,
    UsersModule,
    ConfigModule,
  ],
  controllers: [PeopleController],
  providers: [PeopleService]
})
export class PeopleModule {}
