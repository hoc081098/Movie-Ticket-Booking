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
exports.CommentsAndRatingSummary = exports.CreateCommentDto = void 0;
const openapi = require("@nestjs/swagger");
const class_validator_1 = require("class-validator");
class CreateCommentDto {
    static _OPENAPI_METADATA_FACTORY() {
        return { content: { required: true, type: () => String, minLength: 20, maxLength: 500 }, rate_star: { required: true, type: () => Number, minimum: 1, maximum: 5 }, movie_id: { required: true, type: () => String } };
    }
}
__decorate([
    class_validator_1.IsString(),
    class_validator_1.MinLength(20),
    class_validator_1.MaxLength(500),
    __metadata("design:type", String)
], CreateCommentDto.prototype, "content", void 0);
__decorate([
    class_validator_1.IsNumber(),
    class_validator_1.IsInt(),
    class_validator_1.Min(1),
    class_validator_1.Max(5),
    __metadata("design:type", Number)
], CreateCommentDto.prototype, "rate_star", void 0);
__decorate([
    class_validator_1.IsString(),
    class_validator_1.IsNotEmpty(),
    __metadata("design:type", String)
], CreateCommentDto.prototype, "movie_id", void 0);
exports.CreateCommentDto = CreateCommentDto;
class CommentsAndRatingSummary {
    constructor(comments, average, total) {
        this.comments = comments;
        this.average = average;
        this.total = total;
    }
    static _OPENAPI_METADATA_FACTORY() {
        return { comments: { required: true, type: () => [require("./comment.schema").Comment] }, average: { required: true, type: () => Number }, total: { required: true, type: () => Number } };
    }
}
exports.CommentsAndRatingSummary = CommentsAndRatingSummary;
//# sourceMappingURL=comment.dto.js.map