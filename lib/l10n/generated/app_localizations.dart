import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Name of the event
  ///
  /// In en, this message translates to:
  /// **'FlutterConf Latam 2024'**
  String get eventName;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong!'**
  String get genericFailureText;

  /// Title for the sign in failure dialog
  ///
  /// In en, this message translates to:
  /// **'Sign in failure'**
  String get signInPageFailureDialogTitle;

  /// Content for the sign in failure dialog
  ///
  /// In en, this message translates to:
  /// **'Please make sure your credentials are correct.'**
  String get signInPageFailureDialogContent;

  /// Label for the action button on the sign in failure dialog
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get signInPageFailureDialogActionLabel;

  /// Title for the navigation bar on the sign in page
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInPageNavigationBarTitle;

  /// Placeholder for the username text field on the sign in page
  ///
  /// In en, this message translates to:
  /// **'Your username'**
  String get signInPageUsernameTextFieldPlaceholder;

  /// Placeholder for the password text field on the sign in page
  ///
  /// In en, this message translates to:
  /// **'Your password'**
  String get signInPagePasswordTextFieldPlaceholder;

  /// Label for the submit button on the sign in page
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInPageSubmitButtonLabel;

  /// Label for the create account button on the sign in page
  ///
  /// In en, this message translates to:
  /// **'I don\'t have an account'**
  String get signInPageCreateAccountButtonLabel;

  /// Title for the sign up failure dialog
  ///
  /// In en, this message translates to:
  /// **'Sign up failure'**
  String get signUpPageFailureDialogTitle;

  /// Content for the sign up failure dialog
  ///
  /// In en, this message translates to:
  /// **'Please try again later.'**
  String get signUpPageFailureDialogContent;

  /// Label for the action button on the sign up failure dialog
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get signUpPageFailureDialogActionLabel;

  /// Title for the navigation bar on the sign up page
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUpPageNavigationBarTitle;

  /// Placeholder for the username text field on the sign up page
  ///
  /// In en, this message translates to:
  /// **'Your username'**
  String get signUpPageUsernameTextFieldPlaceholder;

  /// Placeholder for the password text field on the sign up page
  ///
  /// In en, this message translates to:
  /// **'Your password'**
  String get signUpPagePasswordTextFieldPlaceholder;

  /// Label for the submit button on the sign up page
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get signUpPageSubmitButtonLabel;

  /// Label for the submit button on the create pass sheet
  ///
  /// In en, this message translates to:
  /// **'Get my ticket!'**
  String get createPassSheetSubmitButtonLabel;

  /// Title for the navigation bar on the home page
  ///
  /// In en, this message translates to:
  /// **'My passes'**
  String get homePageNavigationBarTitle;

  /// Text to display when the pass list is empty
  ///
  /// In en, this message translates to:
  /// **'You do not have passes yet...'**
  String get homePageEmptyPassListText;

  /// Title for the navigation bar on the pass detail page
  ///
  /// In en, this message translates to:
  /// **'Pass details'**
  String get passDetailPageNavigationBarTitle;

  /// Label for the add to wallet button on the pass detail page
  ///
  /// In en, this message translates to:
  /// **'Add to Wallet'**
  String get passDetailPageAddToWalletButtonLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
