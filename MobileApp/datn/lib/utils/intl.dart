import 'package:flutter/material.dart';

import '../domain/model/city.dart';
import '../domain/repository/city_repository.dart';
import '../generated/l10n.dart';

extension SBC on BuildContext {
  S get s => S.of(this);
}

extension SS on State {
  S get s => context.s;
}

extension LocalizedNameCity on City {
  String localizedName(BuildContext context) =>
      // ignore: deprecated_member_use_from_same_package
      name == CityRepository.nationwide ? context.s.nationwide : name;
}
