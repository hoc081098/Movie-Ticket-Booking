"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.PersonSchema = exports.Person = void 0;
const openapi = require("@nestjs/swagger");
const mongoose_1 = require("mongoose");
const mongoose_2 = require("@nestjs/mongoose");
let Person = class Person extends mongoose_1.Document {
    static _OPENAPI_METADATA_FACTORY() {
        return { avatar: { required: false, type: () => String }, full_name: { required: true, type: () => String }, is_active: { required: true, type: () => Boolean } };
    }
};
__decorate([
    mongoose_2.Prop(),
    __metadata("design:type", String)
], Person.prototype, "avatar", void 0);
__decorate([
    mongoose_2.Prop({ required: true }),
    __metadata("design:type", String)
], Person.prototype, "full_name", void 0);
__decorate([
    mongoose_2.Prop({ default: true }),
    __metadata("design:type", Boolean)
], Person.prototype, "is_active", void 0);
Person = __decorate([
    mongoose_2.Schema({
        collection: 'people',
        timestamps: true,
    })
], Person);
exports.Person = Person;
exports.PersonSchema = mongoose_2.SchemaFactory.createForClass(Person);
//# sourceMappingURL=person.schema.js.map