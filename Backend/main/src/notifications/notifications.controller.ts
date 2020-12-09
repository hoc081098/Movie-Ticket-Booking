import {
  Controller,
  Delete,
  Get,
  Logger,
  Param,
  Post,
  Query,
  UnprocessableEntityException,
  UseGuards
} from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from '../auth/auth.guard';
import { MailerService } from '@nestjs-modules/mailer';
import { Model } from 'mongoose';
import { Reservation } from '../reservations/reservation.schema';
import { InjectModel } from '@nestjs/mongoose';
import { Ticket } from '../seats/ticket.schema';
import { generateQRCode } from '../common/qrcode';
import { PaginationDto } from "../common/pagination.dto";
import { NotificationsService } from "./notifications.service";
import { GetUser, UserPayload } from "../auth/get-user.decorator";
import { Notification } from "./notification.schema";

@UseGuards(AuthGuard)
@ApiTags('notifications')
@Controller('notifications')
export class NotificationsController {
  private readonly logger = new Logger(NotificationsController.name);

  constructor(
      private readonly mailerService: MailerService,
      @InjectModel(Reservation.name) private readonly reservationModel: Model<Reservation>,
      @InjectModel(Ticket.name) private readonly ticketModel: Model<Ticket>,
      private readonly notificationsService: NotificationsService
  ) {}

  @ApiOperation({ summary: 'PRIVATE' })
  @Post('test_send_mail')
  async testSendMail(): Promise<'SUCCESS'> {
    try {
      const count = await this.reservationModel.estimatedDocumentCount();
      const skip = Math.floor(Math.random() * count);
      const reservation = await this.reservationModel
          .findOne()
          .skip(skip)
          .populate('user')
          .populate({
            path: 'show_time',
            populate: { path: 'movie' },
          })
          .populate({
            path: 'show_time',
            populate: { path: 'theatre' },
          })
          .lean();

      const tickets = await this.ticketModel
          .find({ reservation: reservation._id })
          .populate('seat')
          .lean();

      const qrcode = await generateQRCode({
        reservation_id: reservation._id.toHexString(),
        show_time_id: reservation.show_time._id.toHexString(),
        ticket_ids: tickets.map(t => t._id.toHexString()),
        user_id: reservation.user._id.toHexString(),
      });

      await this.mailerService.sendMail(
          {
            to: 'hoc081098@gmail.com',
            subject: `Tickets for movie: ${reservation.show_time.movie.title}`,
            template: 'mail',
            context: { reservation, tickets },
            attachments: [
              {
                filename: 'qrcode.png',
                content: qrcode.split('base64,')[1],
                encoding: 'base64'
              } as any,
            ]
          }
      );

      return 'SUCCESS';
    } catch (e) {
      throw new UnprocessableEntityException(e.message ?? `Cannot send mail: ${e}`);
    }
  }

  @ApiOperation({ summary: 'PRIVATE' })
  @Post('seed')
  seed() {
    return this.notificationsService.seed();
  }

  @Get()
  getNotifications(
      @GetUser() userPayload: UserPayload,
      @Query() dto: PaginationDto,
  ): Promise<Notification[]> {
    return this.notificationsService.getNotifications(userPayload, dto);
  }

  @Get(':id')
  getNotificationById(
      @Param('id') id: string
  ) {
    return this.notificationsService.getNotificationById(id);
  }

  @Delete(':id')
  deleteById(
      @Param('id') id: string,
  ): Promise<Notification> {
    return this.notificationsService.deleteById(id);
  }
}
