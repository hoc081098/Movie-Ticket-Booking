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
          const result = [];

          for (const user of users) {
            const r = await txc.run(
                `
                    MERGE(user: USER { _id: $_id })
                    ON CREATE SET
                        user.uid = $uid,
                        user.email = $email,
                        user.full_name = $full_name,
                        user.gender = $gender,
                        user.address = $address,
                        user.location = point({ latitude: toFloat($latitude), longitude: toFloat($longitude) })
                    ON MATCH SET
                        user.uid = $uid,
                        user.email = $email,
                        user.full_name = $full_name,
                        user.gender = $gender,
                        user.address = $address,
                        user.location = point({ latitude: toFloat($latitude), longitude: toFloat($longitude) })
                    RETURN user.email as email
                `,
                {
                  _id: user._id.toString(),
                  uid: user.uid,
                  email: user.email ?? '',
                  full_name: user.full_name ?? '',
                  gender: user.gender ?? 'MALE',
                  address: user.address ?? '',
                  longitude: user.location?.coordinates?.[0] ?? -1,
                  latitude: user.location?.coordinates?.[1] ?? -1,
                }
            );
            result.push(r);
          }

          return result;
        },
        '[USERS]',
    );
  }

  private async runTransaction(operation: (txc: Transaction) => Promise<any>, tag?: string): Promise<void> {
    const session = this.driver.session();
    const transaction = session.beginTransaction();

    try {
      const result = await operation(transaction);
      await transaction.commit();
      this.logger.debug(`${tag} success ${JSON.stringify(result)}`);
    } catch (e) {
      await transaction.rollback();
      this.logger.debug(`${tag} error ${e}`);
    } finally {
      await session.close();
    }
  }
}
