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