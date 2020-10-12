import { CategoriesService } from './categories.service';
import { Observable } from 'rxjs';
import { Category } from './category.schema';
export declare class CategoriesController {
    private readonly categoriesService;
    constructor(categoriesService: CategoriesService);
    seed(): Observable<Category[]>;
}
