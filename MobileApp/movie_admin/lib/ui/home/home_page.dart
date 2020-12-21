import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:movie_admin/domain/model/exception.dart';
import 'package:movie_admin/domain/model/user.dart';
import 'package:movie_admin/domain/repository/user_repository.dart';
import 'package:movie_admin/ui/qr/qrcode_page.dart';
import 'package:movie_admin/ui/report/report_page.dart';
import 'package:movie_admin/ui/show_times/show_times_page.dart';
import 'package:movie_admin/ui/theatres/theatre_info_page.dart';

import '../../ui/movies/movies_page.dart';
import '../../ui/movies/upload_movie/movie_upload_page.dart';
import '../../ui/theatres/theatre_page.dart';
import '../../utils/type_defs.dart';
import '../app_scaffold.dart';
import '../users/manager_users_page.dart';

// ignore_for_file: prefer_single_quotes

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final userOptional = Provider.of<UserRepository>(context).user$.value;
    assert(userOptional != null);
    final user =
        userOptional.fold(() => throw const NotLoggedInException(), (v) => v);

    final role = user.role;
    print('?????? role=$role');

    if (role == Role.ADMIN) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: GridView.count(
          primary: false,
          childAspectRatio: 1.5,
          crossAxisCount: 2,
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            card(
              Icons.supervised_user_circle_rounded,
              'Manager users',
              '${Random().nextInt(10) + 1} notifications',
              Colors.red,
              () => Navigator.of(context).pushNamed(ManagerUsersPage.routeName),
            ),
            card(
              Icons.movie_filter_outlined,
              "Manager movie",
              "${Random().nextInt(10) + 1} notifications",
              Colors.red,
              () => Navigator.of(context).pushNamed(MoviePage.routeName),
            ),
            card(
              Icons.add_box_rounded,
              "Upload movie",
              "${Random().nextInt(10) + 1} notifications",
              Colors.red,
              () => Navigator.of(context).pushNamed(UploadMoviePage.routeName),
            ),
            card(
              Icons.theaters,
              "Manager theatre",
              "${Random().nextInt(10) + 1} notifications",
              Colors.red,
              () => Navigator.of(context).pushNamed(
                TheatresPage.routeName,
                arguments: TheatresMode.theatreInfo,
              ),
            ),
            card(
              Icons.movie_creation,
              "Manager show time",
              "${Random().nextInt(10) + 1} notifications",
              Colors.red,
              () => Navigator.of(context).pushNamed(
                TheatresPage.routeName,
                arguments: TheatresMode.showTimes,
              ),
            ),
            card(
              Icons.movie_creation,
              "Report",
              "${Random().nextInt(10) + 1} notifications",
              Colors.red,
              () => Navigator.of(context).pushNamed(
                TheatresPage.routeName,
                arguments: TheatresMode.report,
              ),
            ),
            card(
              Icons.movie_creation,
              "Scan QR code",
              "${Random().nextInt(10) + 1} notifications",
              Colors.red,
              () => Navigator.of(context).pushNamed(
                QRCodePage.routeName,
              ),
            )
          ],
        ),
      );
    } else {
      assert(user.theatre != null);
      print(user.theatre);

      return TheatreInfoPage(
        theatre: user.theatre,
        automaticallyImplyLeading: true,
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            card(
              Icons.movie_creation,
              "Manager show time",
              "${Random().nextInt(10) + 1} notifications",
              Colors.red,
              () => AppScaffold.of(context).pushNamed(
                ShowTimesPage.routeName,
                arguments: user.theatre,
              ),
            ),
            card(
              Icons.movie_creation,
              "Report",
              "${Random().nextInt(10) + 1} notifications",
              Colors.red,
              () => Navigator.of(context).pushNamed(
                ReportPage.routeName,
                arguments: user.theatre,
              ),
            ),
            card(
              Icons.movie_creation,
              "Scan QR code",
              "${Random().nextInt(10) + 1} notifications",
              Colors.red,
              () => Navigator.of(context).pushNamed(
                QRCodePage.routeName,
              ),
            )
          ],
        ),
      );
    }
  }

  Widget card(
      IconData icon, String title, String note, Color color, Function0 onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: Colors.white,
          elevation: 14.0,
          borderRadius: BorderRadius.circular(10.0),
          shadowColor: Color(0x802196F3),
          child: Column(
            children: [
              Container(
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            icon,
                            color: Colors.blueAccent,
                            size: 25,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            child: Text(
                              title,
                              maxLines: 1,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.notifications_none,
                                size: 10,
                                color: Colors.redAccent,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                note,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Poppins',
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
