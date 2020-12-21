import { toDataURL } from 'qrcode';

export function generateQRCode(
    info: {
      reservation_id: string,
      user_id: string,
      show_time_id: string,
      ticket_ids: string[]
    }
): Promise<string> {
  return new Promise<string>((resolve, reject) => {
    toDataURL(
        info.reservation_id,
        (error, url) => error ? reject(error) : resolve(url),
    );
  });
}