import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';

import '../checkout_page.dart';

class PhoneEmailForm extends StatelessWidget {
  const PhoneEmailForm({Key key}) : super(key: key);

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
          StreamBuilder<String>(
            stream: bloc.emailError$,
            builder: (context, snapshot) {
              return TextField(
                autocorrect: true,
                keyboardType: TextInputType.emailAddress,
                maxLines: 1,
                onChanged: bloc.emailChanged,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(phoneNode),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8.0),
                    child: Icon(Icons.email),
                  ),
                  labelText: 'Email to receive tickets',
                  labelStyle: TextStyle(fontSize: 13),
                  errorText: snapshot.data,
                  border: OutlineInputBorder(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          StreamBuilder<String>(
            stream: bloc.phoneError$,
            builder: (context, snapshot) {
              return TextField(
                focusNode: phoneNode,
                autocorrect: true,
                keyboardType: TextInputType.phone,
                maxLines: 1,
                onChanged: bloc.phoneChanged,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => FocusScope.of(context).requestFocus(),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8.0),
                    child: Icon(Icons.phone),
                  ),
                  labelText: 'Phone number to receive tickets',
                  labelStyle: TextStyle(fontSize: 13),
                  errorText: snapshot.data,
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
