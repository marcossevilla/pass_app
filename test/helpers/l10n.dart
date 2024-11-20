import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_app/l10n/l10n.dart';

extension L10n on WidgetTester {
  AppLocalizations get l10n {
    final app = widget<CupertinoApp>(find.byType(CupertinoApp).first);
    final locale = app.locale ?? app.supportedLocales.first;
    return lookupAppLocalizations(locale);
  }
}
