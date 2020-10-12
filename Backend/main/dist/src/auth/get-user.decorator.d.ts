import { User } from '../users/user.schema';
export declare type RawUserPayload = {
    uid: string;
    email?: string;
    user_entity?: User | undefined | null;
};
export declare class UserPayload {
    readonly uid: string;
    readonly email: string;
    readonly user_entity?: User | undefined | null;
    constructor(payload: RawUserPayload);
}
export declare const GetUser: (...dataOrPipes: unknown[]) => ParameterDecorator;
