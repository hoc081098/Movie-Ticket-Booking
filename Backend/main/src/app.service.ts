import { HttpService, Injectable } from '@nestjs/common';
import { FirebaseAuthenticationService } from '@aginix/nestjs-firebase-admin/dist';
import { ConfigService } from './config/config.service';
// import { defer } from 'rxjs';
// import { map, mergeMap } from 'rxjs/operators';

@Injectable()
export class AppService {
  constructor(
      private readonly httpService: HttpService,
      private readonly firebaseAuth: FirebaseAuthenticationService,
      private readonly configService: ConfigService,
  ) {}

  // generateToken() {
    // return defer(() => this.firebaseAuth.createCustomToken('l9StgzQlR1h3XpaWCf3juyYgG772'))
    //     .pipe(
    //         mergeMap(customToken =>
    //             this.httpService.post(
    //                 `https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyCustomToken?key=${this.configService.get(ConfigKey.FIREBASE_API_KEY)}`,
    //                 {
    //                   token: customToken,
    //                   returnSecureToken: true
    //                 }
    //             )
    //         ),
    //         map(response => response.data),
    //     );
  // }
}
