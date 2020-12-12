import 'package:flutter/material.dart';

import '../generated/l10n.dart';

extension SBC on BuildContext {
  S get s => S.of(this);
}

extension SS on State {
  S get s => context.s;
}
