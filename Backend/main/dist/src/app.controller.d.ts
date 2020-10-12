import { AppService } from './app.service';
export declare class AppController {
    private readonly appService;
    constructor(appService: AppService);
    token(): import("rxjs").Observable<any>;
    get(): string;
    getAdmin(): string;
}
