import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart' hide Location;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_ext/rxdart_ext.dart';
import 'package:tuple/tuple.dart';

import '../../domain/model/location.dart';
import '../../domain/model/user.dart';
import '../../domain/repository/user_repository.dart';
import '../../env_manager.dart';
import '../../generated/l10n.dart';
import '../../utils/error.dart';
import '../../utils/utils.dart';
import '../app_scaffold.dart';
import '../main_page.dart';

class UpdateProfilePage extends StatefulWidget {
  static const routeName = '/profile_update';

  final User? user;

  const UpdateProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage>
    with SingleTickerProviderStateMixin, DisposeBagMixin {
  final formKey = GlobalKey<FormState>();
  final birthDayDateFormat = intl.DateFormat.yMMMd();

  late AnimationController loginButtonController;
  late Animation<double> buttonSqueezeAnimation;

  TextStyle get textFieldStyle => Theme.of(context)
      .textTheme
      .subtitle1!
      .copyWith(fontSize: 15.0, color: Colors.white);

  final phoneNumberFocusNode = FocusNode();
  final addressFocusNode = FocusNode();

  String? fullName;
  String? phoneNumber;
  String? address;
  DateTime? birthday;
  final gender$ = ValueSubject(Gender.MALE);
  Location? location;
  final avatarFile$ = BehaviorSubject<File?>.seeded(null);
  final avatar$ = BehaviorSubject<String?>.seeded(null);
  var isLoading = false;

  final fullNameRegex = RegExp(r"^[\p{L} .'-]+$", unicode: true);
  final phoneNumberRegex = RegExp(
    r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$',
    caseSensitive: false,
  );

  final fullNameTextController = TextEditingController();
  final phoneNumberTextController = TextEditingController();
  final addressTextController = TextEditingController();
  final birthdayTextController = TextEditingController();

  Object? checkAuthToken;
  late ValueStream<Tuple2<File?, String?>> avatarTuple$;
  final isFetching$ = ValueSubject(false);

  @override
  void initState() {
    super.initState();

    loginButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    buttonSqueezeAnimation = Tween(
      begin: 200.0,
      end: 70.0,
    ).animate(
      CurvedAnimation(
        parent: loginButtonController,
        curve: Interval(
          0.0,
          0.250,
        ),
      ),
    );

    final user = widget.user;
    if (user != null) {
      isFetching$.add(true);
      populateUser(user);
    }

    avatarTuple$ = Rx.combineLatest2(
      avatarFile$,
      avatar$,
      (File? a, String? b) => Tuple2(a, b),
    ).shareValueSeeded(Tuple2<File?, String?>(avatarFile$.value, avatar$.value))
      ..listen(null).disposedBy(bag);

    bag.addAll(<StreamController>[
      isFetching$,
      avatarFile$,
      avatar$,
      gender$,
    ]);
  }

  void populateUser(User user) {
    print('>>> populateUser $user');

    fullName = user.fullName;
    fullNameTextController.text = fullName!;

    phoneNumber = user.phoneNumber;
    phoneNumberTextController.text = phoneNumber ?? '';

    address = user.address;
    addressTextController.text = address ?? '';

    birthday = user.birthday;
    birthdayTextController.text = DateTimeField.tryFormat(
      birthday,
      birthDayDateFormat,
    );

    gender$.add(user.gender);

    location = user.location;

    avatar$.add(user.avatar);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.user != null) {
      checkAuthToken ??= () async* {
        final repository = Provider.of<UserRepository>(context);

        await repository.checkAuth();
        await Future.delayed(const Duration(milliseconds: 500));

        yield (await repository.user$.first)?.fold(() => null, (r) => r);
      }()
          .whereNotNull()
          .doOnData((_) => isFetching$.add(false))
          .doOnError((_, __) => isFetching$.add(false))
          .listen(
            populateUser,
            onError: (e, s) => print('Fetch user error $e $s'),
          )
          .disposedBy(bag);
    }
  }

  @override
  void dispose() {
    loginButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).updateProfile),
        actions: [
          if (widget.user == null) // not completed login
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () async {
                FocusScope.of(context).unfocus();

                final shouldLogout = await showDialog<bool>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(S.of(context).logoutOut),
                      content: Text(S.of(context).areYouSureYouWantToLogout),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(S.of(context).cancel),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );

                if (identical(shouldLogout, true)) {
                  // final localeBloc = BlocProvider.of<LocaleBloc>(context);
                  final userRepository = Provider.of<UserRepository>(context);

                  try {
                    await userRepository.logout();
                    // await localeBloc.resetLocale(S.delegate.supportedLocales[0]);
                    print('>>> logged out');
                  } catch (e, s) {
                    print('>>>> logout $e $s');
                    try {
                      context.showSnackBar(S
                          .of(context)
                          .logoutFailed(context.getErrorMessage(e)));
                    } catch (_) {}
                  }
                }
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/login_update_profile.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6),
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    const Color(0xffB881F9).withOpacity(0.58),
                    const Color(0xff545AE9).withOpacity(0.75),
                    Colors.black.withOpacity(0.5),
                  ],
                  stops: [0, 0.68, 1],
                  begin: AlignmentDirectional.topEnd,
                  end: AlignmentDirectional.bottomStart,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.1),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: RxStreamBuilder<bool>(
                stream: isFetching$,
                builder: (context, data) {
                  if (data) {
                    return SizedBox(
                      width: 64,
                      height: 64,
                      child: LoadingIndicator(
                        color: Colors.white,
                        indicatorType: Indicator.ballScaleMultiple,
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: buildAvatar(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: buildFullNameTextField(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: buildPhoneNumber(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: buildAddressTextField(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: buildBirthDayTextField(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: buildGender(),
                          ),
                          const SizedBox(height: 12.0),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: buildSubmitButton(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAvatar() {
    const imageSize = 80.0;

    return InkWell(
      onTap: pickImage,
      child: Container(
        width: imageSize,
        height: imageSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).backgroundColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              offset: Offset(2, 2),
              color: Colors.grey.shade600,
              spreadRadius: 2,
            )
          ],
        ),
        child: ClipOval(
          child: RxStreamBuilder<Tuple2<File?, String?>>(
            stream: avatarTuple$,
            builder: (context, data) {
              final avatarFile = data.item1;
              final avatar = data.item2;

              if (avatarFile != null) {
                return Image.file(
                  avatarFile,
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                );
              }

              if (avatar != null) {
                return CachedNetworkImage(
                  imageUrl: avatar,
                  fit: BoxFit.cover,
                  width: imageSize,
                  height: imageSize,
                  progressIndicatorBuilder: (
                    BuildContext context,
                    String url,
                    progress,
                  ) {
                    return Center(
                      child: CircularProgressIndicator(
                        value: progress.progress,
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    );
                  },
                  errorWidget: (
                    BuildContext context,
                    String url,
                    dynamic error,
                  ) {
                    return Center(
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: imageSize * 0.7,
                      ),
                    );
                  },
                );
              }

              return Center(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: imageSize * 0.7,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildFullNameTextField() {
    return TextFormField(
      autocorrect: true,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsetsDirectional.only(end: 8.0),
          child: Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
        labelText: S.of(context).fullName,
        labelStyle: TextStyle(color: Colors.white),
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      keyboardType: TextInputType.name,
      maxLines: 1,
      style: textFieldStyle,
      onChanged: (v) => fullName = v,
      textInputAction: TextInputAction.next,
      autofocus: true,
      onFieldSubmitted: (_) =>
          FocusScope.of(context).requestFocus(phoneNumberFocusNode),
      validator: (v) => v != null && fullNameRegex.hasMatch(v)
          ? null
          : S.of(context).invalidFullName,
      controller: fullNameTextController,
    );
  }

  Widget buildPhoneNumber() {
    return TextFormField(
      autocorrect: true,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsetsDirectional.only(end: 8.0),
          child: Icon(
            Icons.phone,
            color: Colors.white,
          ),
        ),
        labelText: S.of(context).phoneNumber,
        labelStyle: TextStyle(color: Colors.white),
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      keyboardType: TextInputType.phone,
      maxLines: 1,
      style: textFieldStyle,
      onChanged: (v) => phoneNumber = v,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) =>
          FocusScope.of(context).requestFocus(addressFocusNode),
      focusNode: phoneNumberFocusNode,
      validator: (v) => v != null && phoneNumberRegex.hasMatch(v)
          ? null
          : S.of(context).invalidPhoneNumber,
      controller: phoneNumberTextController,
    );
  }

  Widget buildAddressTextField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: addressTextController,
            autocorrect: true,
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsetsDirectional.only(end: 8.0),
                child: Icon(
                  Icons.label,
                  color: Colors.white,
                ),
              ),
              labelText: S.of(context).address,
              labelStyle: TextStyle(color: Colors.white),
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            keyboardType: TextInputType.streetAddress,
            maxLines: 1,
            style: textFieldStyle,
            onChanged: (v) => address = v,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
            focusNode: addressFocusNode,
            validator: (v) =>
                v == null || v.isEmpty ? S.of(context).emptyAddress : null,
          ),
        ),
        const SizedBox(width: 8),
        Material(
          color: Colors.transparent,
          elevation: 2,
          type: MaterialType.transparency,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.white,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: IconButton(
              icon: Icon(Icons.location_on, color: Colors.white),
              onPressed: searchLocation,
            ),
          ),
        )
      ],
    );
  }

  Widget buildSubmitButton() {
    return AnimatedBuilder(
      animation: buttonSqueezeAnimation,
      builder: (context, child) {
        final value = buttonSqueezeAnimation.value;

        return Container(
          width: value,
          height: 60.0,
          child: Material(
            elevation: 5.0,
            clipBehavior: Clip.antiAlias,
            shadowColor: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(30.0),
            child: value > 75.0
                ? child
                : Center(
                    child: CircularProgressIndicator(strokeWidth: 2.0),
                  ),
          ),
        );
      },
      child: MaterialButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          onSubmit();
        },
        color: Theme.of(context).backgroundColor,
        splashColor: Theme.of(context).accentColor,
        elevation: 12,
        child: Text(
          S.of(context).UPDATE,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget buildBirthDayTextField() {
    return DateTimeField(
      format: birthDayDateFormat,
      readOnly: true,
      controller: birthdayTextController,
      onShowPicker: (context, currentValue) {
        return showDatePicker(
          context: context,
          firstDate: DateTime(1900),
          initialDate: currentValue ?? DateTime.now(),
          lastDate: DateTime(2100),
          selectableDayPredicate: (date) => date.isBefore(DateTime.now()),
        );
      },
      validator: (date) {
        if (date == null) {
          return null;
        }
        return date.isAfter(DateTime.now())
            ? S.of(context).invalidBirthday
            : null;
      },
      onChanged: (v) => birthday = v,
      resetIcon: Icon(Icons.delete, color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsetsDirectional.only(end: 8.0),
          child: Icon(
            Icons.date_range,
            color: Colors.white,
          ),
        ),
        labelText: S.of(context).birthday,
        labelStyle: TextStyle(color: Colors.white),
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      style: textFieldStyle,
    );
  }

  void onSubmit() async {
    if (isLoading) {
      return;
    }

    print('>>> Submit');
    print('fullName=$fullName');
    print('phoneNumber=$phoneNumber');
    print('address=$address');
    print('birthday=$birthday');
    print('gender=${gender$.value}');
    print('location=$location');
    print('avatar=${avatarFile$.value}');
    print('<<< Submit');

    final isValid = formKey.currentState?.validate() == true;

    if (!isValid) {
      context.showSnackBar(S.of(context).invalidInformation);
      return;
    }

    try {
      isLoading = true;
      loginButtonController
        ..reset()
        ..forward();

      await Provider.of<UserRepository>(context).loginUpdateProfile(
        fullName: fullName!,
        phoneNumber: phoneNumber!,
        address: address!,
        gender: gender$.value,
        location: location,
        birthday: birthday,
        avatarFile: avatarFile$.value,
      );
      context.showSnackBar(S.of(context).updateProfileSuccessfully);
      if (widget.user == null) {
        await Navigator.of(context).pushNamedAndRemoveUntilX(
          MainPage.routeName,
          (route) => false,
        );
      } else {
        Navigator.pop(context);
      }
    } catch (e, s) {
      print('loginUpdateProfile $e $s');
      context.showSnackBar(
          S.of(context).updateProfileFailedMsg(getErrorMessage(e)));
    } finally {
      isLoading = false;
      unawaited(loginButtonController.reverse());
    }
  }

  void searchLocation() async {
    try {
      final apiKey = EnvManager.shared.get(EnvKey.PLACES_API_KEY);

      final prediction = await PlacesAutocomplete.show(
        context: context,
        apiKey: apiKey,
        mode: Mode.overlay,
        language: 'vi',
        components: [
          Component(
            Component.country,
            'VN',
          ),
        ],
      );

      if (prediction == null) {
        print('prediction == null');
        return;
      }

      final details = (await GoogleMapsPlaces(
        apiKey: apiKey,
        apiHeaders: await GoogleApiHeaders().getHeaders(),
      ).getDetailsByPlaceId(prediction.placeId!))
          .result;

      final formattedAddress = details.formattedAddress;
      final geometry = details.geometry;
      if (formattedAddress == null || geometry == null) {
        print('details.formattedAddress == null || details.geometry == null');
        return;
      }

      address = formattedAddress;
      location = Location((b) => b
        ..latitude = geometry.location.lat
        ..longitude = geometry.location.lng);

      addressTextController.text = address ?? '';
    } catch (e, s) {
      print('searchLocation $e $s');
    }
  }

  Widget buildGender() {
    final addToGender$ = (Gender? v) => v != null ? gender$.add(v) : null;

    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: Colors.white.withOpacity(0.4),
      ),
      child: RxStreamBuilder<Gender>(
        stream: gender$,
        builder: (context, gender) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () => gender$.add(Gender.MALE),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Radio<Gender>(
                        value: Gender.MALE,
                        groupValue: gender,
                        onChanged: addToGender$,
                      ),
                      Text(S.of(context).male, style: textFieldStyle),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => gender$.add(Gender.FEMALE),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio<Gender>(
                        value: Gender.FEMALE,
                        groupValue: gender,
                        onChanged: addToGender$,
                      ),
                      Text(S.of(context).female, style: textFieldStyle),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          );
        },
      ),
    );
  }

  void pickImage() async {
    final path = (await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 720,
      maxHeight: 720,
    ))
        ?.path;
    if (path != null) {
      avatarFile$.add(File(path));
    }
  }
}
