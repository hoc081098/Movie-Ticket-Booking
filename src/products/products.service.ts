import { Injectable } from '@nestjs/common';
import { DocumentDefinition, Model } from 'mongoose';
import { Product } from './product.schema';
import { InjectModel } from '@nestjs/mongoose';
import { seeds } from './seed';

@Injectable()
export class ProductsService {
  constructor(
      @InjectModel(Product.name) private readonly productModel: Model<Product>,
  ) {}

  async seed(): Promise<Product[]> {
    if (await this.productModel.estimatedDocumentCount() > 0) {
      return [];
    }

    const products: Omit<DocumentDefinition<Product>, '_id'>[] = seeds.map(s => {
      return {
        description: s.desc,
        image: s.img,
        is_active: true,
        name: s.name,
        price: s.price
      }
    });
    return await this.productModel.create(products);
  }

  getAll(): Promise<Product[]> {
    return this.productModel
        .find({})
        .sort({ price: 1 })
        .exec();
  }
}
