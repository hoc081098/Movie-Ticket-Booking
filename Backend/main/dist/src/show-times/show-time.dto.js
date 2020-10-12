"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.MovieAndTheatre = void 0;
const openapi = require("@nestjs/swagger");
class MovieAndTheatre {
    constructor(doc) {
        this.theatre = doc.theatre;
        this.show_time = doc.show_time;
    }
    static _OPENAPI_METADATA_FACTORY() {
        return { theatre: { required: true, type: () => require("../theatres/theatre.schema").Theatre }, show_time: { required: true, type: () => require("./show-time.schema").ShowTime } };
    }
}
exports.MovieAndTheatre = MovieAndTheatre;
//# sourceMappingURL=show-time.dto.js.map