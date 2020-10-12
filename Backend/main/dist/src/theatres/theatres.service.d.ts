import { Theatre } from './theatre.schema';
import { Model } from 'mongoose';
export declare class TheatresService {
    private readonly theatreModel;
    constructor(theatreModel: Model<Theatre>);
    seed(): Promise<string | Theatre[]>;
}
