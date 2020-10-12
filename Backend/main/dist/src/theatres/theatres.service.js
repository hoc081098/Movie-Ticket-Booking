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
exports.TheatresService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const theatre_schema_1 = require("./theatre.schema");
const mongoose_2 = require("mongoose");
const seedTheatres = [
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
        ]
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
        ]
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
        ]
    }
];
let TheatresService = class TheatresService {
    constructor(theatreModel) {
        this.theatreModel = theatreModel;
    }
    async seed() {
        if (await this.theatreModel.estimatedDocumentCount().exec() > 0) {
            return 'Nice';
        }
        return await this.theatreModel.create(seedTheatres);
    }
};
TheatresService = __decorate([
    common_1.Injectable(),
    __param(0, mongoose_1.InjectModel(theatre_schema_1.Theatre.name)),
    __metadata("design:paramtypes", [mongoose_2.Model])
], TheatresService);
exports.TheatresService = TheatresService;
//# sourceMappingURL=theatres.service.js.map