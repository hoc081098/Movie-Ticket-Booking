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
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CommentsController = void 0;
const openapi = require("@nestjs/swagger");
const common_1 = require("@nestjs/common");
const comments_service_1 = require("./comments.service");
const swagger_1 = require("@nestjs/swagger");
const auth_guard_1 = require("../auth/auth.guard");
const pagination_dto_1 = require("../common/pagination.dto");
const comment_dto_1 = require("./comment.dto");
const get_user_decorator_1 = require("../auth/get-user.decorator");
let CommentsController = class CommentsController {
    constructor(commentsService) {
        this.commentsService = commentsService;
    }
    seed() {
        return this.commentsService.seed();
    }
    getCommentsByMovieId(movieId, paginationDto) {
        return this.commentsService.getCommentsByMovieId(movieId, paginationDto);
    }
    createComment(user, createCommentDto) {
        return this.commentsService.createComment(user, createCommentDto);
    }
    deleteComment(id) {
        return this.commentsService.deleteComment(id);
    }
};
__decorate([
    swagger_1.ApiOperation({ summary: 'PRIVATE' }),
    common_1.Post('seed'),
    openapi.ApiResponse({ status: 201, type: [require("./comment.schema").Comment] }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], CommentsController.prototype, "seed", null);
__decorate([
    common_1.Get('/movies/:movie_id'),
    openapi.ApiResponse({ status: 200, type: require("./comment.dto").CommentsAndRatingSummary }),
    __param(0, common_1.Param('movie_id')),
    __param(1, common_1.Query()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, pagination_dto_1.PaginationDto]),
    __metadata("design:returntype", Promise)
], CommentsController.prototype, "getCommentsByMovieId", null);
__decorate([
    common_1.Post(),
    openapi.ApiResponse({ status: 201, type: require("./comment.schema").Comment }),
    __param(0, get_user_decorator_1.GetUser()),
    __param(1, common_1.Body()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [get_user_decorator_1.UserPayload,
        comment_dto_1.CreateCommentDto]),
    __metadata("design:returntype", Promise)
], CommentsController.prototype, "createComment", null);
__decorate([
    common_1.Delete(':id'),
    openapi.ApiResponse({ status: 200, type: require("./comment.schema").Comment }),
    __param(0, common_1.Param('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], CommentsController.prototype, "deleteComment", null);
CommentsController = __decorate([
    swagger_1.ApiTags('comments'),
    common_1.UseGuards(auth_guard_1.AuthGuard),
    common_1.Controller('comments'),
    __metadata("design:paramtypes", [comments_service_1.CommentsService])
], CommentsController);
exports.CommentsController = CommentsController;
//# sourceMappingURL=comments.controller.js.map