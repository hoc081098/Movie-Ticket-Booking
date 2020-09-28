import { Injectable, NotFoundException } from '@nestjs/common';
import { DocumentDefinition, Model } from 'mongoose';
import { Seat } from './seat.schema';
import { InjectModel } from '@nestjs/mongoose';
import { Theatre } from '../theatres/theatre.schema';
import { ShowTime } from '../show-times/show-time.schema';

@Injectable()
export class SeatsService {
  constructor(
      @InjectModel(Seat.name) private readonly seatModel: Model<Seat>,
      @InjectModel(Theatre.name) private readonly theatreModel: Model<Theatre>,
      @InjectModel(ShowTime.name) private readonly showTimeModel: Model<ShowTime>,
  ) {}

  async seed(id: string): Promise<Seat[]> {
    const theatre = await this.theatreModel.findById(id);
    if (theatre == null) {
      throw new NotFoundException();
    }

    await this.seatModel.deleteMany({ theatre: theatre._id });

    const start = 'A'.charCodeAt(0);
    const end = 'H'.charCodeAt(0);
    const seats: Seat[] = [];

    for (const room of theatre.rooms) {
      for (let row = 0; row <= end - start; row++) {
        let currentCol = 1;

        if (row < end - start - 1) {
          for (let col = 2; col <= 11; col++) {
            const doc: Omit<DocumentDefinition<Seat>, '_id'> = {
              room: room,
              theatre: theatre._id,
              column: currentCol++,
              row: String.fromCharCode(start + row),
              coordinates: [col, row],
              count: 1,
              is_active: true,
            };

            seats.push(await this.seatModel.create(doc));
          }
        } else {
          for (let col = 0; col <= 5; col += 2) {
            const doc: Omit<DocumentDefinition<Seat>, '_id'> = {
              room: room,
              theatre: theatre._id,
              column: currentCol++,
              row: String.fromCharCode(start + row),
              coordinates: [col, row],
              count: 2,
              is_active: true,
            };

            seats.push(await this.seatModel.create(doc));
          }

          for (let col = 6; col <= 14; col++) {
            const doc: Omit<DocumentDefinition<Seat>, '_id'> = {
              room: room,
              theatre: theatre._id,
              column: currentCol++,
              row: String.fromCharCode(start + row),
              coordinates: [col, row],
              count: 1,
              is_active: true,
            };

            seats.push(await this.seatModel.create(doc));
          }

        }

      }
    }

    return seats;
  }

  async getSeatsByShowTimeId(id: string): Promise<Seat[]> {
    const showTime = await this.showTimeModel.findById(id);
    if (showTime == null) {
      throw new NotFoundException(`Show time with id: ${id} not found`);
    }
    return this.seatModel.find({
      theatre: showTime.theatre,
      room: showTime.room
    });
  }
}
