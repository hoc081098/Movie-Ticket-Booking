import { Injectable, Logger } from '@nestjs/common';
import { auth, driver, Driver, Transaction } from 'neo4j-driver';
import { ConfigKey, ConfigService } from '../config/config.service';
import { Model } from 'mongoose';
import { User } from '../users/user.schema';
import { InjectModel } from '@nestjs/mongoose';

@Injectable()
export class Neo4jService {
  private readonly logger = new Logger(Neo4jService.name);
  private readonly driver: Driver;

  constructor(
      configService: ConfigService,
      @InjectModel(User.name) private readonly userModel: Model<User>,
  ) {
    try {
      this.driver = driver(
          configService.get(ConfigKey.NEO4J_URL),
          auth.basic(
              configService.get(ConfigKey.NEO4J_USER),
              configService.get(ConfigKey.NEO4J_PASSWORD),
          )
      );
      this.logger.debug(`Done ${this.driver}`);
    } catch (e) {
      this.logger.debug(`Error ${e}`);
    }
  }

  async transferData(): Promise<void> {
    await this.runTransaction(txc =>
            txc.run(`
          MATCH (n)
          DETACH DELETE n`
            ),
        '[DELETE]',
    );

    await this.addUsers();
  }

  private async addUsers() {
    const users = await this.userModel.find({}).lean();
    await this.runTransaction(
        async txc => {
          for (const user of users) {

          }
        },
        '[USERS]',
    );
  }

  private async runTransaction(operation: (txc: Transaction) => Promise<any>, tag?: string): Promise<void> {
    const session = this.driver.session();
    const transaction = session.beginTransaction();

    try {
      await operation(transaction);
      await transaction.commit();
      this.logger.debug(`${tag} success`);
    } catch (e) {
      await transaction.rollback();
      this.logger.debug(`${tag} error ${e}`);
    } finally {
      await session.close();
    }
  }
}
