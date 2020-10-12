import { Model } from 'mongoose';
import { Product } from './product.schema';
export declare class ProductsService {
    private readonly productModel;
    constructor(productModel: Model<Product>);
    seed(): Promise<Product[]>;
    getAll(): Promise<Product[]>;
}
