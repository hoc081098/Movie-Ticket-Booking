import { PaginationDto } from './pagination.dto';
import { UserPayload } from '../auth/get-user.decorator';
import { User } from '../users/user.schema';
export declare const constants: {
    maxDistanceInMeters: number;
    defaultPage: number;
    defaultPerPage: number;
};
export interface LatLng {
    lat?: string | number | undefined | null;
    lng?: string | number | undefined | null;
}
export declare function getCoordinates(latLng: LatLng): [number, number] | null;
export interface SkipAndLimit {
    skip: number;
    limit: number;
}
export declare function getSkipLimit(paginationDto: PaginationDto): SkipAndLimit;
export declare function checkCompletedLogin(userPayload: UserPayload): User;
