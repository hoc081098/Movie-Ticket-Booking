import { UsersService } from './users.service';
import { UserPayload } from '../auth/get-user.decorator';
import { User } from './user.schema';
import { UpdateUserDto } from './update-user.dto';
import { PaginationDto } from '../common/pagination.dto';
export declare class UsersController {
    private readonly usersService;
    private readonly logger;
    constructor(usersService: UsersService);
    me(uid: string): Promise<User>;
    findById(uid: string): Promise<User>;
    update(user: UserPayload, updateUserDto: UpdateUserDto): Promise<User>;
    delete(uid: string): Promise<User>;
    getAllUsers(dto: PaginationDto): Promise<User[]>;
}
