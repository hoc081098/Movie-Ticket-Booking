import 'package:flutter/material.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/remote/auth_client.dart';
import '../../data/remote/base_url.dart';
import '../../utils/error.dart';
import '../../utils/snackbar.dart';
import '../app_scaffold.dart';

class QRCodePage extends StatefulWidget {
  static const routeName = '/home/qrcode';

  @override
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> with DisposeBagMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            // To ensure the Scanner view is properly sizes after rotation
            // we need to listen for Flutter SizeChanged notification and update controller
            child: NotificationListener<SizeChangedLayoutNotification>(
              onNotification: (notification) {
                Future.microtask(() => controller?.updateDimensions(qrKey));
                return false;
              },
              child: SizeChangedLayoutNotifier(
                key: const Key('qr-size-notifier'),
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream
        .where((event) => event != null && event.isNotEmpty)
        // .startWith('5fdf4b930976ba0004b08358')
        .switchMap(
          (id) => Rx.fromCallable(
            () => Provider.of<AuthClient>(context)
                .getBody(buildUrl('admin-reservations/$id')),
          ),
        )
        .cast<Map<String, dynamic>>()
        .listen(
      (event) {
        print(event);
        context.showSnackBar('Successfully');
        AppScaffold.of(context).push(
          MaterialPageRoute(
            builder: (context) => _DetailPage(map: event),
          ),
        );
      },
      onError: (e, s) {
        print(e);
        print(s);
        context.showSnackBar('Error: ${getErrorMessage(e)}');
      },
    ).disposedBy(bag);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class _DetailPage extends StatelessWidget {
  final Map<String, dynamic> map;

  const _DetailPage({Key key, this.map}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
