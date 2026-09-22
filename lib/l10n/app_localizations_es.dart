// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get loginTitle => 'Iniciar sesión';

  @override
  String get signupTitle => 'Crear cuenta';

  @override
  String get usernameHint => 'Usuario';

  @override
  String get passwordHint => 'Contraseña';

  @override
  String get forgotPassword => '¿Has olvidado tu contraseña?';

  @override
  String get loginAction => 'Entrar';

  @override
  String get signupAction => 'Registrarse';

  @override
  String get usernameRequired => 'Por favor ingrese su nombre de usuario';

  @override
  String get usernameInvalidChars =>
      'El nombre no puede contener caracteres especiales';

  @override
  String get passwordRequired => 'Por favor ingrese su contraseña';

  @override
  String passwordTooShort(int min) {
    return 'La contraseña debe tener al menos $min caracteres';
  }

  @override
  String get authUserNotFound => 'Usuario no encontrado, regístrese primero';

  @override
  String get authWrongCredentials => 'Credenciales incorrectas';

  @override
  String get authUnknownUser => 'Usuario no reconocido, regístrese primero';

  @override
  String get navHome => 'Inicio';

  @override
  String get navCities => 'Ciudades';

  @override
  String get logoutTooltip => 'Cerrar sesión';

  @override
  String get pickACity => 'Selecciona una ciudad';

  @override
  String get noCitySelected => 'Selecciona una ciudad para ver su clima';

  @override
  String temperature(String value) {
    return 'Temperatura: $value °C';
  }

  @override
  String get dataUnavailable => 'Datos no disponibles';

  @override
  String loadingCity(String city) {
    return 'Cargando $city';
  }

  @override
  String get weatherLoadError => 'No se pudo obtener la información del clima';

  @override
  String cityCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ciudades',
      one: '1 ciudad',
    );
    return '$_temp0';
  }

  @override
  String hottestCity(String city, String value) {
    return 'Más cálida: $city $value °C';
  }

  @override
  String coldestCity(String city, String value) {
    return 'Más fría: $city $value °C';
  }
}
