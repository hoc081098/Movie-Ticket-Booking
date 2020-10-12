import { TheatresService } from './theatres.service';
export declare class TheatresController {
    private readonly theatresService;
    constructor(theatresService: TheatresService);
    seed(): Promise<string | import("./theatre.schema").Theatre[]>;
}
