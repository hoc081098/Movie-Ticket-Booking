import { HttpService } from '@nestjs/common';
import { ConfigService } from '../../config/config.service';
import { Observable } from 'rxjs';
import { Movie } from '../movie.schema';
import { Model } from 'mongoose';
import { Category } from '../../categories/category.schema';
import { MovieCategory } from '../movie-category.schema';
import { Person } from '../../people/person.schema';
export declare class MovieDbService {
    private readonly httpService;
    private readonly configService;
    private readonly movieModel;
    private readonly categoryModel;
    private readonly movieCategoryModel;
    private readonly personModel;
    private readonly logger;
    private readonly catDocByName;
    private readonly personByFullName;
    private readonly days;
    private dayCount;
    constructor(httpService: HttpService, configService: ConfigService, movieModel: Model<Movie>, categoryModel: Model<Category>, movieCategoryModel: Model<MovieCategory>, personModel: Model<Person>);
    seed(query: string, page: number, year: number): Observable<never>;
    private get apiKey();
    private search;
    private detail;
    private credits;
    private getCategories;
    private getPeople;
    private saveMovieCategory;
    private saveMovieDetail;
    updateVideoUrl(): Observable<void>;
}
export interface SearchMovieResponseResult {
    page: number;
    total_results: number;
    total_pages: number;
    results: SearchMovie[];
}
export interface SearchMovie {
    popularity: number;
    vote_count: number;
    video: boolean;
    poster_path: null | string;
    id: number;
    adult: boolean;
    backdrop_path: null | string;
    original_language: string;
    original_title: string;
    genre_ids: number[];
    title: string;
    vote_average: number;
    overview: string;
    release_date: string;
}
export interface MovieDetailResponseResult {
    adult: boolean;
    backdrop_path: string;
    belongs_to_collection: null;
    budget: number;
    genres: Genre[];
    homepage: string;
    id: number;
    imdb_id: string;
    original_language: string;
    original_title: string;
    overview: string;
    popularity: number;
    poster_path: string;
    production_companies: ProductionCompany[];
    production_countries: ProductionCountry[];
    release_date: string;
    revenue: number;
    runtime: number;
    spoken_languages: SpokenLanguage[];
    status: string;
    tagline: string;
    title: string;
    video: boolean;
    vote_average: number;
    vote_count: number;
    videos: Videos;
}
export interface Videos {
    results: VideoResult[];
}
export interface VideoResult {
    id: string;
    iso_639_1: string;
    iso_3166_1: string;
    key: string;
    name: string;
    site: string;
    size: number;
    type: string;
}
export interface Genre {
    id: number;
    name: string;
}
export interface ProductionCompany {
    id: number;
    logo_path: null | string;
    name: string;
    origin_country: string;
}
export interface ProductionCountry {
    iso_3166_1: string;
    name: string;
}
export interface SpokenLanguage {
    iso_639_1: string;
    name: string;
}
export interface MovieCreditsResponseResult {
    id: number;
    cast: Cast[];
    crew: Crew[];
}
export interface Cast {
    cast_id: number;
    character: string;
    credit_id: string;
    gender: number;
    id: number;
    name: string;
    order: number;
    profile_path: null | string;
}
export interface Crew {
    credit_id: string;
    department: string;
    gender: number;
    id: number;
    job: string;
    name: string;
    profile_path: null | string;
}
