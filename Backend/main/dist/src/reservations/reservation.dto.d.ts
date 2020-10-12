export declare class CreateReservationProductDto {
    readonly product_id: string;
    readonly quantity: number;
}
export declare class CreateReservationDto {
    readonly show_time_id: string;
    readonly phone_number: string;
    readonly email: string;
    readonly products: CreateReservationProductDto[];
    original_price: number;
    pay_card_id: string;
    ticket_ids: string[];
}
