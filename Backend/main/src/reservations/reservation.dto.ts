import {
  ArrayNotEmpty,
  IsArray,
  IsEmail,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsPhoneNumber,
  IsString,
  Max,
  Min,
  ValidateNested
} from 'class-validator';
import { Type } from 'class-transformer';
import { Reservation } from './reservation.schema';
import { Ticket } from 'src/seats/ticket.schema';

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

  @IsString()
  @IsNotEmpty()
  pay_card_id: string;

  @IsArray()
  @ArrayNotEmpty()
  @IsString({ each: true })
  @IsNotEmpty({ each: true })
  ticket_ids: string[];

  @IsOptional()
  @IsString()
  @IsNotEmpty()
  promotion_id?: string | null;
}

export class ReservationAndTickets {
  readonly reservation: Reservation;
  readonly tickets: Ticket[];

  constructor(raw: {reservation: Reservation, tickets: Ticket[]}) {
    Object.assign(this, raw);
  }
}