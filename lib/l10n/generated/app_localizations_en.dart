// dart format off
// coverage:ignore-file

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get eventName => 'FlutterConf Latam 2024';

  @override
  String get genericFailureText => 'Something went wrong!';

  @override
  String get signInPageFailureDialogTitle => 'Sign in failure';

  @override
  String get signInPageFailureDialogContent => 'Please make sure your credentials are correct.';

  @override
  String get signInPageFailureDialogActionLabel => 'OK';

  @override
  String get signInPageNavigationBarTitle => 'Sign in';

  @override
  String get signInPageUsernameTextFieldPlaceholder => 'Your username';

  @override
  String get signInPagePasswordTextFieldPlaceholder => 'Your password';

  @override
  String get signInPageSubmitButtonLabel => 'Sign in';

  @override
  String get signInPageCreateAccountButtonLabel => 'I don\'t have an account';

  @override
  String get signUpPageFailureDialogTitle => 'Sign up failure';

  @override
  String get signUpPageFailureDialogContent => 'Please try again later.';

  @override
  String get signUpPageFailureDialogActionLabel => 'OK';

  @override
  String get signUpPageNavigationBarTitle => 'Sign up';

  @override
  String get signUpPageUsernameTextFieldPlaceholder => 'Your username';

  @override
  String get signUpPagePasswordTextFieldPlaceholder => 'Your password';

  @override
  String get signUpPageSubmitButtonLabel => 'Create account';

  @override
  String get createPassSheetSubmitButtonLabel => 'Get my ticket!';

  @override
  String get homePageNavigationBarTitle => 'My passes';

  @override
  String get homePageEmptyPassListText => 'You do not have passes yet...';

  @override
  String get passDetailPageNavigationBarTitle => 'Pass details';

  @override
  String get passDetailPageAddToWalletButtonLabel => 'Add to Wallet';
}
