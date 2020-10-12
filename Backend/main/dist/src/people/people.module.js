"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.PeopleModule = void 0;
const common_1 = require("@nestjs/common");
const people_controller_1 = require("./people.controller");
const people_service_1 = require("./people.service");
const mongoose_1 = require("@nestjs/mongoose");
const person_schema_1 = require("./person.schema");
const auth_module_1 = require("../auth/auth.module");
const users_module_1 = require("../users/users.module");
const config_module_1 = require("../config/config.module");
let PeopleModule = class PeopleModule {
};
PeopleModule = __decorate([
    common_1.Module({
        imports: [
            mongoose_1.MongooseModule.forFeature([
                {
                    name: person_schema_1.Person.name,
                    schema: person_schema_1.PersonSchema,
                }
            ]),
            auth_module_1.AuthModule,
            users_module_1.UsersModule,
            config_module_1.ConfigModule,
        ],
        controllers: [people_controller_1.PeopleController],
        providers: [people_service_1.PeopleService]
    })
], PeopleModule);
exports.PeopleModule = PeopleModule;
//# sourceMappingURL=people.module.js.map