import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_admin/domain/model/location.dart';
import 'package:movie_admin/domain/repository/theatres_repository.dart';
import 'package:movie_admin/ui/theatres/add/seats_page.dart';
import 'package:movie_admin/ui/theatres/seat.dart';

import '../../../utils/utils.dart';
import '../../app_scaffold.dart';

class AddTheatrePage extends StatefulWidget {
  static const routeName = '/home/theatres/add';

  @override
  _AddTheatrePageState createState() => _AddTheatrePageState();
}

class _AddTheatrePageState extends State<AddTheatrePage> {
  static final phoneNumberRegex = RegExp(
    r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$',
    caseSensitive: false,
  );
  final imagePicker = ImagePicker();

  String name;
  String phone;
  String email;
  String description;
  String address;
  File cover;
  File thumbnail;
  BuiltList<Seat> seats;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add theatre'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                buildNameFormField(),
                const SizedBox(height: 12),
                buildPhoneFormField(),
                const SizedBox(height: 12),
                buildEmailFormField(),
                const SizedBox(height: 12),
                buildDescriptionFormField(),
                const SizedBox(height: 12),
                buildAddressFormField(),
                const SizedBox(height: 12),
                buildThumbnail(),
                const SizedBox(height: 12),
                buildCover(),
                const SizedBox(height: 12),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    final newSeats = await AppScaffold.of(context).pushNamed(
                      SeatsPage.routeName,
                      arguments: seats,
                    );

                    print('newSeats: ${newSeats}');

                    if (newSeats is BuiltList<Seat>) {
                      seats = newSeats;
                    }
                  },
                  textTheme: ButtonTextTheme.primary,
                  child: Text('Change seats map'),
                ),
                const SizedBox(height: 16),
                Builder(
                  builder: (context) => RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () => submit(context),
                    textTheme: ButtonTextTheme.primary,
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAddressFormField() {
    return TextFormField(
      autocorrect: true,
      keyboardType: TextInputType.text,
      maxLines: 1,
      textInputAction: TextInputAction.next,
      onSaved: (v) => address = v,
      validator: (v) => v.isEmpty ? 'Empty address' : null,
      autovalidateMode: AutovalidateMode.always,
      decoration: InputDecoration(
        prefixIcon: const Padding(
          padding: EdgeInsetsDirectional.only(end: 8.0),
          child: Icon(Icons.map),
        ),
        labelText: 'Address',
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget buildDescriptionFormField() {
    return TextFormField(
      autocorrect: true,
      keyboardType: TextInputType.multiline,
      maxLines: 8,
      minLines: 4,
      textInputAction: TextInputAction.newline,
      onSaved: (v) => description = v,
      autovalidateMode: AutovalidateMode.always,
      validator: (v) => v.isEmpty ? 'Empty description' : null,
      decoration: InputDecoration(
        prefixIcon: const Padding(
          padding: EdgeInsetsDirectional.only(end: 8.0),
          child: Icon(Icons.info),
        ),
        labelText: 'Description',
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget buildEmailFormField() {
    return TextFormField(
      autocorrect: true,
      keyboardType: TextInputType.emailAddress,
      maxLines: 1,
      autovalidateMode: AutovalidateMode.always,
      textInputAction: TextInputAction.next,
      onSaved: (v) => email = v,
      validator: (v) => Validator.isValidEmail(v) ? null : 'Invalid email',
      decoration: InputDecoration(
        prefixIcon: const Padding(
          padding: EdgeInsetsDirectional.only(end: 8.0),
          child: Icon(Icons.email),
        ),
        labelText: 'Email',
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget buildPhoneFormField() {
    return TextFormField(
      autocorrect: true,
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.phone,
      maxLines: 1,
      textInputAction: TextInputAction.next,
      onSaved: (v) => phone = v,
      validator: (v) =>
          !phoneNumberRegex.hasMatch(v) ? 'Invalid phone number' : null,
      decoration: InputDecoration(
        prefixIcon: const Padding(
          padding: EdgeInsetsDirectional.only(end: 8.0),
          child: Icon(Icons.phone),
        ),
        labelText: 'Phone number',
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget buildNameFormField() {
    return TextFormField(
      autocorrect: true,
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.text,
      maxLines: 1,
      textInputAction: TextInputAction.next,
      onSaved: (v) => name = v,
      validator: (v) => v.isEmpty ? 'Empty name' : null,
      decoration: InputDecoration(
        prefixIcon: const Padding(
          padding: EdgeInsetsDirectional.only(end: 8.0),
          child: Icon(Icons.label),
        ),
        labelText: 'Name',
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget buildThumbnail() {
    final onTap = () async {
      final image = await imagePicker.getImage(
        source: ImageSource.gallery,
        maxWidth: 128,
        maxHeight: 128,
      );
      if (image != null) {
        setState(() => thumbnail = File(image.path));
      }
    };

    if (thumbnail == null) {
      return Center(
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),
                Text(
                  'Add thumbnail',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Center(
      child: InkWell(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            thumbnail,
            width: 128,
            height: 128,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget buildCover() {
    final onTap = () async {
      final image = await imagePicker.getImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() => cover = File(image.path));
      }
    };

    if (cover == null) {
      return Center(
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: 256,
            height: 256,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),
                Text(
                  'Add cover',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Center(
      child: InkWell(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            cover,
            width: 256,
            height: 256,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void submit(BuildContext context) async {
    final state = Form.of(context);

    state.save();
    if (!state.validate() ||
        cover == null ||
        thumbnail == null ||
        seats == null) {
      return context.showSnackBar('Invalid information');
    }

    print('>>>>> FORM_VALUE = ${name}');
    print('>>>>> FORM_VALUE = ${phone}');
    print('>>>>> FORM_VALUE = ${email}');
    print('>>>>> FORM_VALUE = ${description}');
    print('>>>>> FORM_VALUE = ${address}');
    print('>>>>> FORM_VALUE = ${cover}');
    print('>>>>> FORM_VALUE = ${thumbnail}');

    try {
      final added = await Provider.of<TheatresRepository>(context).addTheatre(
        name: name,
        address: address,
        phone_number: phone,
        email: email,
        description: description,
        location: Location(latitude: 0, longitude: 0),
        cover: cover,
        thumbnail: thumbnail,
        seats: seats,
      );

      if (mounted) {
        context.showSnackBar('Add successfully');
      }

      AppScaffold.of(context).pop(added);
    } catch (e) {
      if (mounted) {
        context.showSnackBar('Error: ${getErrorMessage(e)}');
      }
    }
  }
}
