import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';

import 'login_update_profile_bloc.dart';

class LoginUpdateProfilePage extends StatefulWidget {
  static const routeName = '/login_profile_update';

  @override
  _LoginUpdateProfilePageState createState() => _LoginUpdateProfilePageState();
}

class _LoginUpdateProfilePageState extends State<LoginUpdateProfilePage>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DisposeBag disposeBag;

  AnimationController loginButtonController;
  Animation<double> buttonSqueezeAnimation;

  FocusNode phoneNumberFocusNode;
  FocusNode addressFocusNode;

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

    phoneNumberFocusNode = FocusNode();
    addressFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<LoginUpdateProfilePageBloc>(context);

    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/login_bg.png'),
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
                    const Color(0xffB881F9).withOpacity(0.5),
                    const Color(0xff545AE9).withOpacity(0.5),
                  ],
                  begin: AlignmentDirectional.topEnd,
                  end: AlignmentDirectional.bottomStart,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                  ),
                  color: Colors.transparent,
                  width: double.infinity,
                  height: kToolbarHeight,
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: fullNameTextField(bloc),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: phoneNumber(bloc),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: addressTextField(bloc),
                          ),
                          const SizedBox(height: 32.0),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: submitButton(bloc),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget fullNameTextField(LoginUpdateProfilePageBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.fullNameError$,
      builder: (context, snapshot) {
        return TextField(
          autocorrect: true,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(end: 8.0),
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            labelText: 'Full name',
            errorText: snapshot.data,
            labelStyle: TextStyle(color: Colors.white),
            fillColor: Colors.white,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          keyboardType: TextInputType.name,
          maxLines: 1,
          style: TextStyle(fontSize: 16.0, color: Colors.white),
          onChanged: bloc.fullNameChanged,
          textInputAction: TextInputAction.next,
          autofocus: true,
          onSubmitted: (_) =>
              FocusScope.of(context).requestFocus(phoneNumberFocusNode),
        );
      },
    );
  }

  Widget phoneNumber(LoginUpdateProfilePageBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.phoneNumberError$,
      builder: (context, snapshot) {
        return TextField(
          autocorrect: true,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(end: 8.0),
              child: Icon(
                Icons.phone,
                color: Colors.white,
              ),
            ),
            labelText: 'Phone number',
            errorText: snapshot.data,
            labelStyle: TextStyle(color: Colors.white),
            fillColor: Colors.white,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          keyboardType: TextInputType.phone,
          maxLines: 1,
          style: TextStyle(fontSize: 16.0, color: Colors.white),
          onChanged: bloc.phoneNumberChanged,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) =>
              FocusScope.of(context).requestFocus(addressFocusNode),
          focusNode: phoneNumberFocusNode,
        );
      },
    );
  }

  Widget submitButton(LoginUpdateProfilePageBloc bloc) {
    return AnimatedBuilder(
      animation: buttonSqueezeAnimation,
      child: MaterialButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          bloc.submit();
        },
        color: Theme.of(context).backgroundColor,
        child: Text(
          'UPDATE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        splashColor: Theme.of(context).accentColor,
      ),
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
    );
  }

  Widget addressTextField(LoginUpdateProfilePageBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.addressError$,
      builder: (context, snapshot) {
        return TextField(
          autocorrect: true,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(end: 8.0),
              child: Icon(
                Icons.label,
                color: Colors.white,
              ),
            ),
            labelText: 'Address',
            errorText: snapshot.data,
            labelStyle: TextStyle(color: Colors.white),
            fillColor: Colors.white,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          keyboardType: TextInputType.phone,
          maxLines: 1,
          style: TextStyle(fontSize: 16.0, color: Colors.white),
          onChanged: bloc.addressChanged,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) => FocusScope.of(context).requestFocus(),
          focusNode: addressFocusNode,
        );
      },
    );
  }
}
