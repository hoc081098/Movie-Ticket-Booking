"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SeatsService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("mongoose");
const seat_schema_1 = require("./seat.schema");
const mongoose_2 = require("@nestjs/mongoose");
const theatre_schema_1 = require("../theatres/theatre.schema");
const show_time_schema_1 = require("../show-times/show-time.schema");
const ticket_schema_1 = require("./ticket.schema");
let SeatsService = class SeatsService {
    constructor(seatModel, theatreModel, showTimeModel, ticketModel) {
        this.seatModel = seatModel;
        this.theatreModel = theatreModel;
        this.showTimeModel = showTimeModel;
        this.ticketModel = ticketModel;
        this.logger = new common_1.Logger('SeatsService');
        this.seedChange = false;
    }
    async findShowTimeById(id) {
        const showTime = await this.showTimeModel.findById(id);
        if (showTime == null) {
            throw new common_1.NotFoundException(`Show time with id: ${id} not found`);
        }
        return showTime;
    }
    async getSeatsByShowTimeId(id) {
        const showTime = await this.findShowTimeById(id);
        return this.seatModel.find({
            theatre: showTime.theatre,
            room: showTime.room
        });
    }
    async seedTicketsForSingleShowTime(showTime) {
        const seats = await this.getSeatsByShowTimeId(showTime._id);
        const price = [60000, 70000, 80000, 100000].random();
        const docs = seats.map(seat => {
            return {
                is_active: true,
                price: price,
                reservation: null,
                seat: seat._id,
                show_time: showTime._id,
            };
        });
        const tickets = await this.ticketModel.create(docs);
        this.logger.debug(`Seeded ${tickets.length} tickets for show time: ${showTime._id}`);
        return tickets;
    }
    async seed(theatreId) {
        const theatre = await this.theatreModel.findById(theatreId);
        if (theatre == null) {
            throw new common_1.NotFoundException();
        }
        await this.seatModel.deleteMany({ theatre: theatre._id });
        const start = 'A'.charCodeAt(0);
        const end = 'H'.charCodeAt(0);
        const seats = [];
        for (const room of theatre.rooms) {
            if (await this.seatModel.countDocuments({ theatre: theatre._id, room }) > 0) {
                continue;
            }
            if (this.seedChange) {
                for (let row = 0; row <= end - start; row++) {
                    let currentCol = 1;
                    if (row < end - start - 1) {
                        for (let col = 2; col <= 11; col++) {
                            const doc = {
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
                    else {
                        for (let col = 0; col <= 5; col += 2) {
                            const doc = {
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
                            const doc = {
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
            else {
                for (let row = 0; row <= end - start; row++) {
                    let currentCol = 1;
                    if (row < end - start - 1) {
                        for (let col = 2; col <= 11; col++) {
                            const doc = {
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
                    else {
                        for (let col = 0; col <= 14; col++) {
                            const doc = {
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
        const showTimes = await this
            .showTimeModel
            .find({ start_time: { $gte: new Date() } });
        let last = [];
        for (const st of showTimes) {
            last = await this.seedTicketsForSingleShowTime(st);
        }
        return last;
    }
    async getTicketsByShowTimeId(id) {
        const showTime = await this.findShowTimeById(id);
        return await this.ticketModel
            .find({ show_time: showTime._id })
            .populate('seat')
            .exec();
    }
};
SeatsService = __decorate([
    common_1.Injectable(),
    __param(0, mongoose_2.InjectModel(seat_schema_1.Seat.name)),
    __param(1, mongoose_2.InjectModel(theatre_schema_1.Theatre.name)),
    __param(2, mongoose_2.InjectModel(show_time_schema_1.ShowTime.name)),
    __param(3, mongoose_2.InjectModel(ticket_schema_1.Ticket.name)),
    __metadata("design:paramtypes", [mongoose_1.Model,
        mongoose_1.Model,
        mongoose_1.Model,
        mongoose_1.Model])
], SeatsService);
exports.SeatsService = SeatsService;
Array.prototype.random = function () {
    const i = Math.floor(Math.random() * this.length);
    return this[i];
};
//# sourceMappingURL=seats.service.js.map