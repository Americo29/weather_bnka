import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
  static const List<Locale> supportedLocales = <Locale>[Locale('es')];

  /// No description provided for @loginTitle.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get loginTitle;

  /// No description provided for @signupTitle.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get signupTitle;

  /// No description provided for @usernameHint.
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get usernameHint;

  /// No description provided for @passwordHint.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get passwordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In es, this message translates to:
  /// **'¿Has olvidado tu contraseña?'**
  String get forgotPassword;

  /// No description provided for @loginAction.
  ///
  /// In es, this message translates to:
  /// **'Entrar'**
  String get loginAction;

  /// No description provided for @signupAction.
  ///
  /// In es, this message translates to:
  /// **'Registrarse'**
  String get signupAction;

  /// No description provided for @usernameRequired.
  ///
  /// In es, this message translates to:
  /// **'Por favor ingrese su nombre de usuario'**
  String get usernameRequired;

  /// No description provided for @usernameInvalidChars.
  ///
  /// In es, this message translates to:
  /// **'El nombre no puede contener caracteres especiales'**
  String get usernameInvalidChars;

  /// No description provided for @passwordRequired.
  ///
  /// In es, this message translates to:
  /// **'Por favor ingrese su contraseña'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe tener al menos {min} caracteres'**
  String passwordTooShort(int min);

  /// No description provided for @authUserNotFound.
  ///
  /// In es, this message translates to:
  /// **'Usuario no encontrado, regístrese primero'**
  String get authUserNotFound;

  /// No description provided for @authWrongCredentials.
  ///
  /// In es, this message translates to:
  /// **'Credenciales incorrectas'**
  String get authWrongCredentials;

  /// No description provided for @authUnknownUser.
  ///
  /// In es, this message translates to:
  /// **'Usuario no reconocido, regístrese primero'**
  String get authUnknownUser;

  /// No description provided for @navHome.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get navHome;

  /// No description provided for @navCities.
  ///
  /// In es, this message translates to:
  /// **'Ciudades'**
  String get navCities;

  /// No description provided for @logoutTooltip.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get logoutTooltip;

  /// No description provided for @pickACity.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una ciudad'**
  String get pickACity;

  /// No description provided for @noCitySelected.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una ciudad para ver su clima'**
  String get noCitySelected;

  /// No description provided for @temperature.
  ///
  /// In es, this message translates to:
  /// **'Temperatura: {value} °C'**
  String temperature(String value);

  /// No description provided for @dataUnavailable.
  ///
  /// In es, this message translates to:
  /// **'Datos no disponibles'**
  String get dataUnavailable;

  /// No description provided for @loadingCity.
  ///
  /// In es, this message translates to:
  /// **'Cargando {city}'**
  String loadingCity(String city);

  /// No description provided for @weatherLoadError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo obtener la información del clima'**
  String get weatherLoadError;

  /// No description provided for @cityCount.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 ciudad} other{{count} ciudades}}'**
  String cityCount(int count);

  /// No description provided for @hottestCity.
  ///
  /// In es, this message translates to:
  /// **'Más cálida: {city} {value} °C'**
  String hottestCity(String city, String value);

  /// No description provided for @coldestCity.
  ///
  /// In es, this message translates to:
  /// **'Más fría: {city} {value} °C'**
  String coldestCity(String city, String value);
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
      <String>['es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
