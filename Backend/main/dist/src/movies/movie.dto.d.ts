import { PaginationDto } from '../common/pagination.dto';
import { LatLng } from '../common/utils';
export declare class GetNowShowingMoviesDto extends PaginationDto implements LatLng {
    lat?: number | null | undefined;
    lng?: number | null | undefined;
}
