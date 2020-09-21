import { Module } from '@nestjs/common';
import { TheatresController } from './theatres.controller';
import { TheatresService } from './theatres.service';
import { MongooseModule } from '@nestjs/mongoose';
import { Theatre, TheatreSchema } from './theatre.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      {
        name: Theatre.name,
        schema: TheatreSchema,
      },
    ]),
  ],
  controllers: [TheatresController],
  providers: [TheatresService]
})
export class TheatresModule {}
