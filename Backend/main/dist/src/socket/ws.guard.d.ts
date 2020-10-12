import { CanActivate, ExecutionContext } from '@nestjs/common';
import { FirebaseAuthenticationService } from '@aginix/nestjs-firebase-admin/dist';
export declare class WsGuard implements CanActivate {
    private readonly firebaseAuth;
    private readonly logger;
    constructor(firebaseAuth: FirebaseAuthenticationService);
    canActivate(context: ExecutionContext): Promise<boolean>;
    private decodeToken;
}
