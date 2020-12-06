import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Theatre } from './theatre.schema';
import { CreateDocumentDefinition, Model } from 'mongoose';
import { LocationDto } from "../common/location.dto";
import { constants, getCoordinates } from "../common/utils";
import { AddTheatreDto, SeatDto } from "./theatre.dto";
import { Seat } from "../seats/seat.schema";

const seedTheatres: Omit<CreateDocumentDefinition<Theatre>, '_id'>[] = [
  {
    name: 'Galaxy - Đà Nẵng',
    address: 'Tầng 3, TTTM Coop Mart, 478 Điện Biên Phủ, Quận Thanh Khê, Đà Nẵng',
    location: {
      type: 'Point',
      coordinates: [108.1861624, 16.0666692],
    },
    phone_number: '02363739888',
    is_active: true,
    description: 'Thành lập hơn mười năm, Galaxy Cinema đã trở thành một thương hiệu nổi tiếng, được cả nước biết đến. Ngày 23/9/2016, hệ thống rạp phim hàng đầu đã cập bến Đà Nẵng, hứa hẹn đem đến cho các bạn trẻ bên bờ sông Hàn một địa điểm vui chơi mới mẻ.',
    email: null,
    opening_hours: '9:00 - 23:00',
    room_summary: '7 2D, 1 3D',
    rooms: [
      '2D 1',
      '2D 2',
      '2D 3',
      '2D 4',
      '2D 5',
      '2D 6',
      '2D 7',
      '3D',
    ],
    cover: '',
    thumbnail: '',
  },
  {
    name: 'Starlight Đà Nẵng',
    address: 'T4-Tòa nhà Nguyễn Kim, 46 Điện Biên Phủ, ĐN',
    location: {
      type: 'Point',
      coordinates: [108.2052573, 16.0662866],
    },
    phone_number: '19001744',
    is_active: true,
    description: 'Quy mô 4 phòng chiếu phim hiện đại, sức chứa lên đến 688 ghế ngồi được thiết kế với phong cách hiện đại, đem lại cảm giác thoãi mái cho người xem.Ngoài ra phòng chiếu còn được trang bị hệ thống âm thanh Dolby 7.1 sống động, màn hình chiếu kĩ thuật 2D, 3D sắc nét đến từng phân đoạn.',
    email: null,
    opening_hours: '8:30 - 23:30',
    room_summary: '4 2D',
    rooms: [
      '2D 1',
      '2D 2',
      '2D 3',
      '2D 4',
    ],
    cover: 'https://s3img.vcdn.vn/123phim/2017/07/starlight-da-nang-14999290721876.jpg',
    thumbnail: 'https://s3img.vcdn.vn/123phim/2018/09/16b811ab4773065c15eb0e9be67527b3.png',
  },
  {
    name: 'Lotte Cinema Đà Nẵng',
    address: 'Lotte Mart Đà Nẵng, Hải Châu, ĐN',
    location: {
      type: 'Point',
      coordinates: [108.2291364, 16.0347492],
    },
    phone_number: '02363679667',
    is_active: true,
    description: 'Rạp chiếu phim Lotte Cinema Đà Nẵng nằm trên tầng 5 và 6 của khu trung tâm mua sắm Lotte Mart, nằm trên đường 2 Tháng 9 bên cạnh dòng sông Hàn thơ mộng và khu thể thao Tiên Sơn. Đây là một trong những rạp chiếu phim hiện đại đẳng cấp quốc tế thuộc hệ thống rạp chiếu Lotte Cinema của Hàn Quốc',
    email: null,
    opening_hours: '8:00 - 24:00',
    room_summary: '4 2D',
    rooms: [
      '2D 1',
      '2D 2',
      '2D 3',
      '2D 4',
    ],
    cover: 'https://s3img.vcdn.vn/123phim/2017/07/lotte-cinema-da-nang-14999146022923.jpg',
    thumbnail: 'https://s3img.vcdn.vn/123phim/2018/09/404b8c4b80d77732e7426cdb7e24be20.png',
  }
];

@Injectable()
export class TheatresService {
  constructor(
      @InjectModel(Theatre.name) private readonly theatreModel: Model<Theatre>,
      @InjectModel(Seat.name) private readonly seatModel: Model<Seat>,
  ) {}

  // eslint-disable-next-line @typescript-eslint/ban-ts-ignore
  // @ts-ignore
  async seed(): Promise<string | Theatre[]> {
    const theatres = await this.theatreModel.find({});
    for (const theatre of theatres) {
      const data = seedTheatres.find(e => e.name === theatre.name);
      await this.theatreModel.updateOne(
          { _id: theatre._id },
          { cover: data.cover, thumbnail: data.thumbnail }
      ).exec();
    }
    return;

    if (await this.theatreModel.estimatedDocumentCount().exec() > 0) {
      return 'Nice';
    }
    // eslint-disable-next-line @typescript-eslint/ban-ts-ignore
    // @ts-ignore
    return await this.theatreModel.create(seedTheatres);
  }

  async getNearbyTheatres(dto?: LocationDto): Promise<Theatre[]> {
    const center = getCoordinates(dto);
    if (!center) {
      return this.theatreModel.find({}).sort({ name: 1 });
    }

    return this.theatreModel.aggregate([
      {
        $geoNear: {
          near: {
            type: 'Point',
            coordinates: center,
          },
          distanceField: 'distance',
          includeLocs: 'location',
          maxDistance: constants.maxDistanceInMeters,
          spherical: true,
        },
      },
      { $match: { is_active: true } },
    ]).exec();
  }

  async addTheatre(dto: AddTheatreDto): Promise<Theatre> {
    const coordinates = getCoordinates(dto);
    if (!coordinates) {
      throw new BadRequestException(`Required lat and lng`);
    }

    const theatreDoc: Omit<CreateDocumentDefinition<Theatre>, '_id'> = {
      address: dto.address,
      cover: dto.cover,
      description: dto.description,
      email: dto.email,
      is_active: true,
      location: {
        type: 'Point',
        coordinates,
      },
      name: dto.name,
      opening_hours: '8:30 - 23:30',
      phone_number: dto.phone_number,
      room_summary: '1 2D',
      rooms: ['2D 1'],
      thumbnail: dto.thumbnail,
    };

    const theatre = await this.theatreModel.create(theatreDoc);

    const seatsMap = new Map<string, SeatDto[]>();
    dto.seats.forEach(s => {
      const row = seatsMap.get(s.row) ?? [];
      seatsMap.set(s.row, [...row, s]);
    });

    for (const [_, v] of seatsMap) {
      await this.seatModel
          .create(
              v.sort((l, r) => l.coordinates[0] - r.coordinates[0])
                  .map((seat, index) => {
                    const doc: Omit<CreateDocumentDefinition<Seat>, '_id'> = {
                      column: index + 1,
                      coordinates: seat.coordinates,
                      count: seat.count,
                      is_active: true,
                      room: '2D 1',
                      row: seat.row,
                      theatre: theatre._id,
                    };
                    return doc;
                  })
          );
    }


    return theatre;
  }
}
