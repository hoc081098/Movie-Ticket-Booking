import {
  ArrayNotEmpty,
  IsArray,
  IsEmail,
  IsNotEmpty,
  IsNumber,
  IsPhoneNumber,
  IsString,
  Max,
  Min,
  ValidateNested
} from 'class-validator';
import { Type } from 'class-transformer';

export class CreateReservationProductDto {
  @IsString()
  @IsNotEmpty()
  readonly product_id: string;

  @IsNumber()
  @Min(1)
  @Max(20)
  readonly quantity: number;
}

export class CreateReservationDto {
  @IsString()
  @IsNotEmpty()
  readonly show_time_id: string;

  @IsString()
  @IsPhoneNumber('VN')
  readonly phone_number: string;

  @IsString()
  @IsNotEmpty()
  @IsEmail()
  readonly email: string;

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CreateReservationProductDto)
  readonly products: CreateReservationProductDto[];

  @IsNumber()
  original_price: number;

  @IsString()
  @IsNotEmpty()
  pay_card_id: string;

  @IsArray()
  @ArrayNotEmpty()
  @IsString({ each: true })
  @IsNotEmpty({ each: true })
  ticket_ids: string[];
}
