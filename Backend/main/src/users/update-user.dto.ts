import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsDateString,
  IsIn,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsPhoneNumber,
  IsString,
  Matches
} from 'class-validator';

export class UpdateUserDto {
  @IsOptional()
  @IsString()
  @IsPhoneNumber('VN')
  phone_number?: string;

  @IsNotEmpty()
  @IsString()
  @Matches(/^[\p{L} .'-]+$/u)
  full_name: string;

  @IsString()
  @IsIn(['MALE', 'FEMALE'])
  gender: 'MALE' | 'FEMALE';

  @IsOptional()
  @IsString()
  @IsNotEmpty()
  avatar?: string;

  @IsOptional()
  @IsString()
  @IsNotEmpty()
  address?: string;

  @IsOptional()
  @IsDateString()
  birthday?: Date;

  @IsOptional()
  @IsArray()
  @IsNumber({}, { each: true })
  @ArrayMinSize(2)
  @ArrayMaxSize(2)
  location?: number[];
}