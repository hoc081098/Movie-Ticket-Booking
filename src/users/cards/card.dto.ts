import { IsNotEmpty, IsNumber, IsString, Length, Matches, Max, Min } from 'class-validator';

export class Card {
  readonly id: string;
  readonly brand: string;
  readonly country: string;
  readonly exp_month: number;
  readonly exp_year: number;
  readonly funding: string;
  readonly last4: string;
  readonly card_holder_name: string;

  constructor(raw: {
    id: string,
    brand: string,
    country: string,
    exp_month: number,
    exp_year: number,
    funding: string,
    last4: string,
    card_holder_name: string
  }) {
    Object.assign(this, raw);
  }
}

export class AddCardDto {

  @IsString()
  @IsNotEmpty()
  readonly card_holder_name: string;

  @IsString()
  @Length(16, 16)
  @Matches(/^[0-9]{16}$/)
  readonly number: string;

  @IsNumber()
  @Min(20)
  @Max(99)
  readonly exp_year: number;

  @IsNumber()
  @Min(1)
  @Max(12)
  readonly exp_month: number;

  @IsString()
  @Length(3, 3)
  @Matches(/^[0-9]{3}$/)
  readonly cvc: string;
}