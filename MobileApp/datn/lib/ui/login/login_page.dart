import 'package:datn/domain/model/exception.dart';
import 'package:datn/ui/login_update_profile/login_update_profile_page.dart';
import 'package:datn/ui/register/register_page.dart';
import 'package:datn/ui/reset_password/reset_password_page.dart';
import 'package:datn/ui/widgets/password_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';

import '../../utils/delay.dart';
import '../../utils/snackbar.dart';
import '../main_page.dart';
import 'login_bloc.dart';
import 'login_state.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin<LoginPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DisposeBag disposeBag;

  AnimationController loginButtonController;
  Animation<double> buttonSqueezeAnimation;

  FocusNode passwordFocusNode;
  TextEditingController emailController;

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

    passwordFocusNode = FocusNode();
    emailController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    disposeBag ??= () {
      final loginBloc = BlocProvider.of<LoginBloc>(context);
      return DisposeBag([
        loginBloc.message$.listen(handleMessage),
        loginBloc.isLoading$.listen((isLoading) {
          if (isLoading) {
            loginButtonController
              ..reset()
              ..forward();
          } else {
            loginButtonController.reverse();
          }
        })
      ]);
    }();
  }

  @override
  void dispose() {
    loginButtonController.dispose();
    disposeBag.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);

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
                    const Color(0xffB881F9).withOpacity(0.58),
                    const Color(0xff545AE9).withOpacity(0.58),
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
                            child: emailTextField(loginBloc),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: passwordTextField(loginBloc),
                          ),
                          const SizedBox(height: 32.0),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: loginButton(loginBloc),
                          ),
                          const SizedBox(height: 32.0),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: needAnAccount(loginBloc),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: forgotPassword(loginBloc),
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

  void handleMessage(message) async {
    if (message is LoginSuccessMessage) {
      scaffoldKey.showSnackBar('Login successfully');
      await delay(1000);
      await Navigator.of(context).pushReplacementNamed(MainPage.routeName);
    }
    if (message is LoginErrorMessage) {
      scaffoldKey.showSnackBar(message.message);

      if (message.error is NotCompletedLoginException) {
        await Navigator.pushReplacementNamed(
          context,
          LoginUpdateProfilePage.routeName,
        );
      }
    }
    if (message is InvalidInformationMessage) {
      scaffoldKey.showSnackBar('Invalid information');
    }
  }

  Widget emailTextField(LoginBloc loginBloc) {
    return StreamBuilder<String>(
      stream: loginBloc.emailError$,
      builder: (context, snapshot) {
        return TextField(
          controller: emailController,
          autocorrect: true,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(end: 8.0),
              child: Icon(
                Icons.email,
                color: Colors.white,
              ),
            ),
            labelText: 'Email',
            errorText: snapshot.data,
            labelStyle: TextStyle(color: Colors.white),
            fillColor: Colors.white,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          maxLines: 1,
          style: TextStyle(fontSize: 16.0, color: Colors.white),
          onChanged: loginBloc.emailChanged,
          textInputAction: TextInputAction.next,
          autofocus: true,
          onSubmitted: (_) {
            FocusScope.of(context).requestFocus(passwordFocusNode);
          },
        );
      },
    );
  }

  Widget passwordTextField(LoginBloc loginBloc) {
    return StreamBuilder<String>(
      stream: loginBloc.passwordError$,
      builder: (context, snapshot) {
        return PasswordTextField(
          errorText: snapshot.data,
          onChanged: loginBloc.passwordChanged,
          labelText: 'Password',
          textInputAction: TextInputAction.done,
          onSubmitted: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          focusNode: passwordFocusNode,
        );
      },
    );
  }

  Widget loginButton(LoginBloc loginBloc) {
    return AnimatedBuilder(
      animation: buttonSqueezeAnimation,
      child: MaterialButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          loginBloc.submitLogin();
        },
        color: Theme.of(context).backgroundColor,
        child: Text(
          'LOGIN',
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

  Widget needAnAccount(LoginBloc loginBloc) {
    return FlatButton(
      onPressed: () async {
        final email = await Navigator.pushNamed(
          context,
          RegisterPage.routeName,
        );
        print('[DEBUG] email = $email');
        if (email != null && email is String) {
          emailController.text = email;
          loginBloc.emailChanged(email);
          FocusScope.of(context).requestFocus(passwordFocusNode);
        }
      },
      child: Text(
        "Don't have an account? Sign up",
        style: TextStyle(
          color: Colors.white70,
          fontStyle: FontStyle.italic,
          fontSize: 14.0,
        ),
      ),
    );
  }

  Widget forgotPassword(LoginBloc loginBloc) {
    return FlatButton(
      onPressed: () async {
        final email = await Navigator.pushNamed(
          context,
          ResetPasswordPage.routeName,
        );
        print('[DEBUG] email = $email');
        if (email != null && email is String) {
          emailController.text = email;
          loginBloc.emailChanged(email);
          FocusScope.of(context).requestFocus(passwordFocusNode);
        }
      },
      child: Text(
        'Forgot password?',
        style: TextStyle(
          color: Colors.white70,
          fontStyle: FontStyle.italic,
          fontSize: 14.0,
        ),
      ),
    );
  }
}
