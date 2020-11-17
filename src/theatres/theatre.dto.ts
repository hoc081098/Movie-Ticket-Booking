import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsEmail,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsPhoneNumber,
  IsString,
  Min,
  ValidateNested,
} from "class-validator";
import { LocationDto } from "../common/location.dto";

export class AddTheatreDto extends LocationDto {
  @IsString()
  @IsNotEmpty()
  name: string;

  @IsString()
  @IsNotEmpty()
  address: string;

  @IsString()
  @IsPhoneNumber('VN')
  phone_number: string;

  @IsOptional()
  @IsString()
  @IsNotEmpty()
  @IsEmail()
  email?: string | null;

  @IsString()
  @IsNotEmpty()
  description: string;

  @IsOptional()
  @IsString()
  @IsNotEmpty()
  thumbnail?: string | null;

  @IsOptional()
  @IsString()
  @IsNotEmpty()
  cover?: string | null;

  @IsArray()
  @ArrayMinSize(1)
  @ValidateNested({ each: true })
  seats: SeatDto[];
}

export class SeatDto {
  @IsString()
  @IsNotEmpty()
  row: string;

  @IsNumber()
  @Min(1)
  count: number;

  @IsArray()
  @IsNumber({}, { each: true })
  @ArrayMinSize(2)
  @ArrayMaxSize(2)
  coordinates: [number, number];
}