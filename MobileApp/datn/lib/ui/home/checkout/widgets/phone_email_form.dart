import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';

import '../../../../domain/model/user.dart';
import '../../../../generated/l10n.dart';
import '../checkout_page.dart';

class PhoneEmailForm extends StatelessWidget {
  final User user;

  const PhoneEmailForm({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final phoneNode = FocusNode();
    final bloc = BlocProvider.of<CheckoutBloc>(context);

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(4, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          RxStreamBuilder<String?>(
            stream: bloc.emailError$,
            builder: (context, data) {
              return TextFormField(
                key: ValueKey('email'),
                initialValue: user.email,
                autocorrect: true,
                keyboardType: TextInputType.emailAddress,
                maxLines: 1,
                onChanged: bloc.emailChanged,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(phoneNode),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8.0),
                    child: Icon(Icons.email),
                  ),
                  labelText: S.of(context).emailToReceiveTickets,
                  labelStyle: TextStyle(fontSize: 13),
                  errorText: data,
                  border: OutlineInputBorder(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          RxStreamBuilder<String?>(
            stream: bloc.phoneError$,
            builder: (context, data) {
              return TextFormField(
                key: ValueKey('phoneNumber'),
                initialValue: user.phoneNumber,
                focusNode: phoneNode,
                autocorrect: true,
                keyboardType: TextInputType.phone,
                maxLines: 1,
                onChanged: bloc.phoneChanged,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8.0),
                    child: Icon(Icons.phone),
                  ),
                  labelText: S.of(context).phoneNumberToReceiveTickets,
                  labelStyle: TextStyle(fontSize: 13),
                  errorText: data,
                  border: OutlineInputBorder(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
