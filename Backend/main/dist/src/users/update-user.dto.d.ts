export declare class UpdateUserDto {
    phone_number?: string;
    full_name: string;
    gender: 'MALE' | 'FEMALE';
    avatar?: string;
    address?: string;
    birthday?: Date;
    location?: number[];
}
