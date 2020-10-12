import { HttpService } from '@nestjs/common';
import { Category } from './category.schema';
import { Model } from 'mongoose';
import { Observable } from 'rxjs';
import { ConfigService } from '../config/config.service';
export declare class CategoriesService {
    private readonly categoryMode;
    private readonly httpService;
    private readonly configService;
    private readonly logger;
    constructor(categoryMode: Model<Category>, httpService: HttpService, configService: ConfigService);
    seed(): Observable<Category[]>;
}
