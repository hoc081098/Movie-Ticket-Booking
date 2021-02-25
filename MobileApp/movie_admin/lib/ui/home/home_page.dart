import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_provider/flutter_provider.dart';

import '../../domain/model/user.dart';
import '../../domain/repository/user_repository.dart';
import '../../ui/movies/movies_page.dart';
import '../../ui/movies/upload_movie/movie_upload_page.dart';
import '../../ui/theatres/theatre_page.dart';
import '../../utils/type_defs.dart';
import '../../utils/utils.dart';
import '../app_scaffold.dart';
import '../qr/qrcode_page.dart';
import '../report/report_page.dart';
import '../show_times/show_times_page.dart';
import '../theatres/theatre_info_page.dart';
import '../users/manager_users_page.dart';

// ignore_for_file: prefer_single_quotes

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return RxStreamBuilder<Optional<User>>(
      stream: Provider.of<UserRepository>(context).user$,
      builder: (context, userOptional) {
        if (userOptional == null) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          );
        }

        final user = userOptional.fold(() => null, (v) => v);

        if (user == null) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          );
        }

        final role = user.role;
        print('>>>>> role=$role');

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
                  () => Navigator.of(context)
                      .pushNamed(ManagerUsersPage.routeName),
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
                  () => Navigator.of(context)
                      .pushNamed(UploadMoviePage.routeName),
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
        } else if (role == Role.STAFF) {
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
        } else {
          return Container();
        }
      },
    );
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
