"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ConfigService = void 0;
const common_1 = require("@nestjs/common");
const dotenv = require("dotenv");
const fs = require("fs");
class ConfigService {
    constructor(filePath) {
        this.logger = new common_1.Logger('ConfigService');
        this.envConfig = dotenv.parse(fs.readFileSync(filePath));
        const stringify = JSON.stringify(this.envConfig);
        this.logger.log(`Load config: ${stringify}`);
    }
    get(key) {
        const value = this.envConfig[key];
        if (value === undefined) {
            throw Error(`Missing key ${key} in .env file`);
        }
        return value;
    }
}
exports.ConfigService = ConfigService;
//# sourceMappingURL=config.service.js.map