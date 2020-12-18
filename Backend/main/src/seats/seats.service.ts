import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { DocumentDefinition, Model } from 'mongoose';
import { Seat } from './seat.schema';
import { InjectModel } from '@nestjs/mongoose';
import { Theatre } from '../theatres/theatre.schema';
import { ShowTime } from '../show-times/show-time.schema';
import { Ticket } from './ticket.schema';
import { checkStaffPermission } from "../common/utils";
import { UserPayload } from "../auth/get-user.decorator";

@Injectable()
export class SeatsService {
  private readonly logger = new Logger('SeatsService');
  private seedChange = false;

  constructor(
      @InjectModel(Seat.name) private readonly seatModel: Model<Seat>,
      @InjectModel(Theatre.name) private readonly theatreModel: Model<Theatre>,
      @InjectModel(ShowTime.name) private readonly showTimeModel: Model<ShowTime>,
      @InjectModel(Ticket.name) private readonly ticketModel: Model<Ticket>,
  ) {}

  /**
   * Helper: Find ShowTime by id
   * @param id
   */
  private async findShowTimeById(id: string): Promise<ShowTime> {
    const showTime = await this.showTimeModel.findById(id);
    if (showTime == null) {
      throw new NotFoundException(`Show time with id: ${id} not found`);
    }
    return showTime
  }

  private async getSeatsByShowTimeId(id: string): Promise<Seat[]> {
    const showTime = await this.findShowTimeById(id);
    return this.seatModel.find({
      theatre: showTime.theatre,
      room: showTime.room
    });
  }

  async seedTicketsForSingleShowTime(showTime: ShowTime): Promise<Ticket[]> {
    const seats: Seat[] = await this.getSeatsByShowTimeId(showTime._id);
    const price = [60_000, 70_000, 80_000, 100_000].random();

    const docs: Omit<DocumentDefinition<Ticket>, '_id'>[] = seats.map(seat => {
      return {
        is_active: true,
        price: price * seat.count,
        reservation: null,
        seat: seat._id,
        show_time: showTime._id,
      };
    });

    const tickets = await this.ticketModel.create(docs);
    this.logger.debug(`Seeded ${tickets.length} tickets for show time: ${showTime._id}`);
    return tickets;
  }

  async seed(theatreId: string): Promise<Seat[]> {
    const theatre = await this.theatreModel.findById(theatreId);
    if (theatre == null) {
      throw new NotFoundException();
    }

    await this.seatModel.deleteMany({ theatre: theatre._id });

    const start = 'A'.charCodeAt(0);
    const end = 'H'.charCodeAt(0);
    const seats: Seat[] = [];

    for (const room of theatre.rooms) {
      if (await this.seatModel.countDocuments({ theatre: theatre._id, room }) > 0) {
        continue;
      }

      if (this.seedChange) {
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
      } else {
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
            for (let col = 0; col <= 14; col++) {
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
    }

    this.seedChange = !this.seedChange;

    this.logger.debug(`Seed ${seats.length} seats`);
    return seats;
  }

  async seedTickets() {
    const showTimes: ShowTime[] = await this
        .showTimeModel
        .find({ start_time: { $gte: new Date() } });

    let count = 0;
    for (const st of showTimes) {
      await this.seedTicketsForSingleShowTime(st);
      this.logger.debug(`Done ${++count}/${showTimes.length}`);
    }
  }

  async getTicketsByShowTimeId(id: string, userPayload: UserPayload): Promise<Ticket[]> {
    const showTime = await this.findShowTimeById(id);
    if (!showTime) {
      throw new NotFoundException();
    }
    checkStaffPermission(userPayload, showTime.theatre._id.toString());

    return await this.ticketModel
        .find({ show_time: showTime._id })
        .populate('seat')
        .exec();

  }

  getSeatsByTheatreId(theatre_id: string): Promise<Seat[]> {
    return this.seatModel.find({
      theatre: theatre_id,
      room: '2D 1',
      is_active: true,
    }).exec();
  }
}

declare global {
  interface Array<T> {
    random(): T | undefined;
  }
}

Array.prototype.random = function <T>(this: T[]): T | undefined {
  const i = Math.floor(Math.random() * this.length);
  return this[i];
};