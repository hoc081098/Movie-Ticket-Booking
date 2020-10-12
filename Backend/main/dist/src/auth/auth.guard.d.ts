import { CanActivate, ExecutionContext } from '@nestjs/common';
import { FirebaseAuthenticationService } from '@aginix/nestjs-firebase-admin/dist';
import { UsersService } from '../users/users.service';
import { ConfigService } from '../config/config.service';
export declare class AuthGuard implements CanActivate {
    private readonly firebaseAuth;
    private readonly usersService;
    private readonly configService;
    private readonly logger;
    constructor(firebaseAuth: FirebaseAuthenticationService, usersService: UsersService, configService: ConfigService);
    canActivate(context: ExecutionContext): Promise<boolean>;
    private decodeToken;
    private debugToken;
}
