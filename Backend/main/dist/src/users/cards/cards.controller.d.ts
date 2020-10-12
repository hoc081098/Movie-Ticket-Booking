import { UserPayload } from '../../auth/get-user.decorator';
import { AddCardDto, Card } from './card.dto';
import { UsersService } from '../users.service';
export declare class CardsController {
    private readonly usersService;
    constructor(usersService: UsersService);
    getCards(user: UserPayload): Promise<Card[]>;
    addCard(userPayload: UserPayload, cardDto: AddCardDto): Promise<Card>;
    removeCard(userPayload: UserPayload, cardId: string): Promise<'SUCCESS'>;
}
