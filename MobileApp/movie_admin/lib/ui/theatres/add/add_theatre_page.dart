import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:google_maps_webservice/places.dart' hide Location;
import 'package:image_picker/image_picker.dart';

import '../../../domain/model/location.dart';
import '../../../domain/repository/theatres_repository.dart';
import '../../../env_manager.dart';
import '../../../ui/theatres/add/seats_page.dart';
import '../../../ui/theatres/seat.dart';
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
  Location location;
  final addressTextController = TextEditingController();

  var isLoading = false;

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
                  builder: (context) {
                    if (isLoading) {
                      return SizedBox(
                        child: Center(
                          child: const CircularProgressIndicator(),
                        ),
                        height: 50,
                      );
                    }

                    return RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () => submit(context),
                      textTheme: ButtonTextTheme.primary,
                      child: Text('Submit'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAddressFormField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: addressTextController,
            autocorrect: true,
            keyboardType: TextInputType.text,
            maxLines: 1,
            textInputAction: TextInputAction.done,
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
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.location_on,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: searchLocation,
        ),
      ],
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
        return;
      }

      final details = (await GoogleMapsPlaces(apiKey: apiKey)
              .getDetailsByPlaceId(prediction.placeId))
          .result;

      address = details.formattedAddress;
      location = Location(
        latitude: details.geometry.location.lat,
        longitude: details.geometry.location.lng,
      );

      addressTextController.text = address;
    } catch (e, s) {
      print('searchLocation $e $s');
    }
  }

  void submit(BuildContext context) async {
    final state = Form.of(context);

    state.save();

    print('>>>>> FORM_VALUE name= ${name}');
    print('>>>>> FORM_VALUE phone= ${phone}');
    print('>>>>> FORM_VALUE email= ${email}');
    print('>>>>> FORM_VALUE description= ${description}');
    print('>>>>> FORM_VALUE address= ${address}');
    print('>>>>> FORM_VALUE cover= ${cover}');
    print('>>>>> FORM_VALUE thumbnail= ${thumbnail}');
    print('>>>>> FORM_VALUE location= ${location}');

    if (!state.validate()) {
      return context.showSnackBar('Invalid information');
    }
    if (cover == null) {
      return context.showSnackBar('Missing cover image');
    }
    if (thumbnail == null) {
      return context.showSnackBar('Missing thumbnail image');
    }
    if (seats == null) {
      return context.showSnackBar('Missing seats map');
    }
    if (location == null) {
      return context.showSnackBar('Missing location');
    }

    try {
      final navigatorState = AppScaffold.of(context);
      setState(() => isLoading = true);

      final added = await Provider.of<TheatresRepository>(context).addTheatre(
        name: name,
        address: address,
        phone_number: phone,
        email: email,
        description: description,
        location: location,
        cover: cover,
        thumbnail: thumbnail,
        seats: seats,
      );

      await delay(500);
      if (mounted) {
        context.showSnackBar('Add successfully');
      }

      navigatorState.pop(added);
    } catch (e) {
      if (mounted) {
        context.showSnackBar('Error: ${getErrorMessage(e)}');
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }
}
