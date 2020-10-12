import { ProductsService } from './products.service';
import { Product } from './product.schema';
export declare class ProductsController {
    private readonly productsService;
    constructor(productsService: ProductsService);
    seed(): Promise<Product[]>;
    getAll(): Promise<Product[]>;
}
