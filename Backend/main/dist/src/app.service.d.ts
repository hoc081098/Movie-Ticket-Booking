import { HttpService } from '@nestjs/common';
import { FirebaseAuthenticationService } from '@aginix/nestjs-firebase-admin/dist';
import { ConfigService } from './config/config.service';
export declare class AppService {
    private readonly httpService;
    private readonly firebaseAuth;
    private readonly configService;
    constructor(httpService: HttpService, firebaseAuth: FirebaseAuthenticationService, configService: ConfigService);
    generateToken(): import("rxjs").Observable<any>;
}
