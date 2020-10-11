import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:flutter_disposebag/flutter_disposebag.dart';

import '../../utils/utils.dart';
import 'reset_password_bloc.dart';
import 'reset_password_state.dart';

class ResetPasswordPage extends StatefulWidget {
  static const routeName = '/reset_password';

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DisposeBag disposeBag;

  AnimationController buttonController;
  Animation<double> buttonSqueezeAnimation;

  FocusNode passwordFocusNode;
  TextEditingController emailController;

  @override
  void initState() {
    super.initState();

    buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    buttonSqueezeAnimation = Tween(
      begin: 200.0,
      end: 70.0,
    ).animate(
      CurvedAnimation(
        parent: buttonController,
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
      final loginBloc = BlocProvider.of<ResetPasswordBloc>(context);
      return DisposeBag([
        loginBloc.message$.listen(handleMessage),
        loginBloc.isLoading$.listen((isLoading) {
          if (isLoading) {
            buttonController
              ..reset()
              ..forward();
          } else {
            buttonController.reverse();
          }
        })
      ]);
    }();
  }

  @override
  void dispose() {
    buttonController.dispose();
    disposeBag.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<ResetPasswordBloc>(context);

    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/register_bg.png'),
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
                    const Color(0xff545AE9).withOpacity(0.6),
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
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset('assets/images/enjoy.png'),
                    const SizedBox(height: 24),
                    Text(
                      'Enter your Email to reset Password',
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: emailTextField(loginBloc),
                    ),
                    const SizedBox(height: 32.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildButton(loginBloc),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handleMessage(message) async {
    if (message is SuccessMessage) {
      scaffoldKey.showSnackBar(
          'Reset successfully. Please check your email to reset password!');
      await delay(1000);
      await Navigator.of(context).pop(message.email);
    }
    if (message is ErrorMessage) {
      scaffoldKey.showSnackBar(message.message);
    }
    if (message is InvalidInformationMessage) {
      scaffoldKey.showSnackBar('Invalid information');
    }
  }

  Widget emailTextField(ResetPasswordBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.emailError$,
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
          onChanged: bloc.emailChanged,
          textInputAction: TextInputAction.next,
          autofocus: true,
          onSubmitted: (_) {
            FocusScope.of(context).requestFocus(passwordFocusNode);
          },
        );
      },
    );
  }

  Widget buildButton(ResetPasswordBloc bloc) {
    return AnimatedBuilder(
      animation: buttonSqueezeAnimation,
      child: MaterialButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          bloc.submit();
        },
        color: Theme.of(context).backgroundColor,
        child: Text(
          'RESET PASSWORD',
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
}
