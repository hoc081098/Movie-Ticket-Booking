import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/model/exception.dart';
import '../../domain/repository/user_repository.dart';
import '../../generated/l10n.dart';
import '../../utils/utils.dart';
import '../app_scaffold.dart';
import '../home/change_language_button.dart';
import '../login_update_profile/login_update_profile_page.dart';
import '../main_page.dart';
import '../register/register_page.dart';
import '../reset_password/reset_password_page.dart';
import '../widgets/password_text_field.dart';
import 'facebook_login_bloc.dart';
import 'google_sign_in_bloc.dart';
import 'login_bloc.dart';
import 'login_state.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin<LoginPage> {
  DisposeBag? disposeBag;

  late AnimationController loginButtonController;
  late Animation<double> buttonSqueezeAnimation;

  late FocusNode passwordFocusNode;
  late TextEditingController emailController;

  late GoogleSignInBloc googleSignInBloc;
  late FacebookLoginBloc facebookLoginBloc;

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
      final userRepository = Provider.of<UserRepository>(context);

      final loginBloc = BlocProvider.of<LoginBloc>(context);
      googleSignInBloc = GoogleSignInBloc(userRepository);
      facebookLoginBloc = FacebookLoginBloc(userRepository);

      return DisposeBag([
        Rx.merge([
          loginBloc.message$,
          googleSignInBloc.message$,
          facebookLoginBloc.message$,
        ]).listen(handleMessage),
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

    disposeBag!.dispose();
    googleSignInBloc.dispose();
    facebookLoginBloc.dispose();

    print('$this disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    return Scaffold(
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
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset('assets/images/enjoy.png'),
                    const SizedBox(height: 24),
                    Text(
                      S.of(context).loginToYourAccount,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: emailTextField(loginBloc),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: passwordTextField(loginBloc),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: loginButton(loginBloc),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFde5246),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(8),
                                elevation: 4,
                              ),
                              onPressed: googleSignInBloc.submitLogin,
                              child: RxStreamBuilder<bool>(
                                stream: googleSignInBloc.isLoading$,
                                builder: (context, isLoading) {
                                  if (isLoading) {
                                    return CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(
                                        Colors.white,
                                      ),
                                    );
                                  }

                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.google,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Google',
                                        style: Theme.of(context)
                                            .textTheme
                                            .button!
                                            .copyWith(color: Colors.white),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF1178f2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(8),
                                elevation: 4,
                              ),
                              onPressed: facebookLoginBloc.submitLogin,
                              child: RxStreamBuilder<bool>(
                                stream: facebookLoginBloc.isLoading$,
                                builder: (context, isLoading) {
                                  if (isLoading) {
                                    return CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(
                                        Colors.white,
                                      ),
                                    );
                                  }

                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.facebookSquare,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Facebook',
                                        style: Theme.of(context)
                                            .textTheme
                                            .button!
                                            .copyWith(color: Colors.white),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    needAnAccount(loginBloc),
                    forgotPassword(loginBloc),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handleMessage(LoginMessage message) async {
    final navigator = Navigator.of(context);
    print('>>>>>>>>>>>>> SignIn $message >> $navigator');

    if (message is LoginSuccessMessage) {
      context.showSnackBar(S.of(context).loginSuccessfully);
      await delay(400);

      navigator.popUntil((route) => false);
      unawaited(navigator.pushNamedX(MainPage.routeName));
      print('>>>>>>>>>>>>> SignIn to home >>');

      return;
    }

    if (message is LoginErrorMessage) {
      context.showSnackBar(message.message);

      if (message.error is NotCompletedLoginException) {
        await delay(400);

        navigator.popUntil((route) => false);
        unawaited(navigator.pushNamedX(UpdateProfilePage.routeName));
        print('>>>>>>>>>>>>> SignIn to update >>');
      }

      return;
    }

    if (message is InvalidInformationMessage) {
      context.showSnackBar(S.of(context).invalidInformation);
    }
  }

  Widget emailTextField(LoginBloc loginBloc) {
    return StreamBuilder<String?>(
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
    return StreamBuilder<String?>(
      stream: loginBloc.passwordError$,
      builder: (context, snapshot) {
        return PasswordTextField(
          errorText: snapshot.data,
          onChanged: loginBloc.passwordChanged,
          labelText: S.of(context).password,
          textInputAction: TextInputAction.done,
          onSubmitted: () {
            FocusScope.of(context).unfocus();
          },
          focusNode: passwordFocusNode,
        );
      },
    );
  }

  Widget loginButton(LoginBloc loginBloc) {
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
          loginBloc.submitLogin();
        },
        color: Theme.of(context).backgroundColor,
        splashColor: Theme.of(context).accentColor,
        child: Text(
          S.of(context).LOGIN,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget needAnAccount(LoginBloc loginBloc) {
    return TextButton(
      onPressed: () async {
        final email = await Navigator.of(context).pushNamedX(
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
        S.of(context).dontHaveAnAccountSignUp,
        style: TextStyle(
          color: Colors.white70,
          fontStyle: FontStyle.italic,
          fontSize: 14.0,
        ),
      ),
    );
  }

  Widget forgotPassword(LoginBloc loginBloc) {
    return Stack(
      children: [
        Center(
          child: TextButton(
            onPressed: () async {
              final email = await Navigator.of(context)
                  .pushNamedX(ResetPasswordPage.routeName);
              print('[DEBUG] email = $email');
              if (email != null && email is String) {
                emailController.text = email;
                loginBloc.emailChanged(email);
                FocusScope.of(context).requestFocus(passwordFocusNode);
              }
            },
            child: Text(
              S.of(context).forgotPassword,
              style: TextStyle(
                color: Colors.white70,
                fontStyle: FontStyle.italic,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
        const Align(
          alignment: AlignmentDirectional.centerEnd,
          child: ChangeLanguageButton(
            iconColor: Colors.white,
          ),
        )
      ],
    );
  }
}
