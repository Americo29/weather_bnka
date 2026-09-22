# Weather Bnka

Aplicación Flutter que consulta el pronóstico del tiempo en tiempo real para una lista de ciudades,
construida sobre **Clean Architecture**, **BLoC** como gestor de estado y un **paquete de dominio
desacoplado** publicado localmente.

El objetivo del proyecto es demostrar decisiones de arquitectura en una app pequeña: separación
estricta de capas, inversión de dependencias, modularización en paquetes y una capa de presentación
reactiva basada en eventos y estados.

---

## Tabla de contenidos

- [Funcionalidades](#funcionalidades)
- [Arquitectura](#arquitectura)
- [Estructura del proyecto](#estructura-del-proyecto)
- [Flujo de datos](#flujo-de-datos)
- [Gestión de estado (BLoC)](#gestión-de-estado-bloc)
- [Inyección de dependencias](#inyección-de-dependencias)
- [API externa](#api-externa)
- [Persistencia local](#persistencia-local)
- [Dependencias](#dependencias)
- [Puesta en marcha](#puesta-en-marcha)
- [Compilación por plataforma](#compilación-por-plataforma)
- [Calidad de código y pruebas](#calidad-de-código-y-pruebas)
- [Alcance y decisiones de diseño](#alcance-y-decisiones-de-diseño)
- [Roadmap](#roadmap)

---

## Funcionalidades

| # | Funcionalidad | Detalle |
|---|---|---|
| 1 | **Registro local** | Alta de usuario con validación de formulario; se persiste en el dispositivo. |
| 2 | **Login** | Valida credenciales contra el usuario registrado; si no existe, invita a registrarse. |
| 3 | **Catálogo de ciudades** | 20 ciudades seleccionables desde una grilla con marcado de favoritos. |
| 4 | **Consulta de clima** | Al marcar una ciudad se resuelve su geolocalización y se consulta su temperatura actual. |
| 5 | **Panel principal** | Tarjetas por ciudad seguida, con detalle de la ciudad seleccionada y bandera del país. |
| 6 | **Agregados en vivo** | Ciudad más cálida, ciudad más fría y conteo total, recalculados en cada cambio. |
| 7 | **Eliminar ciudad** | Quita una ciudad del panel y sincroniza el estado del catálogo. |
| 8 | **Logout** | Limpia la sesión persistida y devuelve al login sin dejar rutas en el stack. |

Navegación: `Splash` (3,5 s con animación) → `Login` ⇄ `Signup` → `Home` (tabs *Home* / *Cities*).

---

## Arquitectura

El proyecto aplica **Clean Architecture** con organización **feature-first**, y lleva la separación
un paso más allá: el dominio del clima vive en un **paquete Dart independiente**
(`packages/weather_repository`), consumido por la app como una dependencia local.

```
┌──────────────────────────────────────────────────────────────┐
│  PRESENTATION                                                │
│  Pages · Widgets · BLoC (Events → States)                    │
│  Depende de: Domain                                          │
└───────────────────────────┬──────────────────────────────────┘
                            │  (usa abstracciones)
┌───────────────────────────▼──────────────────────────────────┐
│  DOMAIN                                                      │
│  Entities · Repository (abstract) · Use Cases                │
│  Depende de: nada. Puro Dart.                                │
└───────────────────────────▲──────────────────────────────────┘
                            │  (implementa abstracciones)
┌───────────────────────────┴──────────────────────────────────┐
│  DATA                                                        │
│  Models (DTO) · Repository Impl · Data Sources (Dio / Prefs) │
│  Depende de: Domain                                          │
└──────────────────────────────────────────────────────────────┘
```

**Regla de dependencia.** Las flechas apuntan siempre hacia el dominio. `WeatherBloc` no conoce a
`Dio` ni a Open-Meteo: solo conoce `GetWeatherUseCase`, que a su vez depende de la *abstracción*
`WeatherRepository`. La implementación concreta se inyecta en tiempo de arranque. Sustituir la fuente
de datos (otra API, una caché local, un mock de pruebas) no exige tocar ni una línea de la capa de
presentación.

**Por qué un paquete aparte.** `weather_repository` es un módulo cerrado con su propio `pubspec.yaml`,
su propio ciclo de vida y una **API pública explícita** definida en `lib/weather_repository.dart`.
Todo lo que vive bajo `lib/src/` es privado para los consumidores. Esto aporta:

- una frontera real, verificada por el compilador, en lugar de una convención de carpetas;
- reutilización directa desde otra app del mismo ecosistema;
- tiempos de análisis y prueba acotados al módulo.

**Modelos vs. entidades.** `LocationModel extends Location` y `WeatherModel extends Weather`: el DTO
hereda de la entidad de dominio y aporta `fromJson` / `toJson`. El contrato JSON queda confinado a la
capa de datos y el dominio nunca ve la forma de la respuesta HTTP.

---

## Estructura del proyecto

```
weather_bnka/
├── lib/
│   ├── main.dart                        # Bootstrap: DI + BlocProvider raíz + MaterialApp
│   ├── injection_container.dart         # Registro de dependencias (GetIt)
│   ├── config/
│   │   ├── routes/app_routes.dart       # Rutas nombradas vía onGenerateRoute
│   │   └── theme/                       # Paletas de color por condición climática
│   ├── core/
│   │   └── util/utils.dart              # Extension String.toFlag (ISO-3166 → emoji)
│   └── features/
│       ├── auth/
│       │   ├── data/
│       │   │   ├── data_sources/shared_pref_helper.dart
│       │   │   └── repository/user_repository_impl.dart
│       │   ├── domain/
│       │   │   ├── entities/user.dart
│       │   │   ├── repository/user_repository.dart
│       │   │   └── usecases/login_usecase.dart
│       │   └── presentation/
│       │       ├── bloc/auth_bloc/      # auth_bloc · auth_event · auth_state
│       │       ├── pages/               # splash_screen · login_page · signup_page
│       │       └── widgets/             # login_form · signup_form · action_button
│       └── home/
│           └── presentation/
│               ├── bloc/                # weather_bloc · weather_event · weather_state
│               ├── pages/home_page.dart
│               └── widgets/             # weather_details · weather_cards · cities_list_cards
│
└── packages/
    └── weather_repository/              # Paquete de dominio independiente
        ├── lib/
        │   ├── weather_repository.dart  # Barrel: API pública del paquete
        │   └── src/
        │       ├── domain/
        │       │   ├── entities/        # Weather · Location · City · WeatherCity
        │       │   ├── repositories/    # WeatherRepository · CityRepository (abstract)
        │       │   └── usecases/        # GetWeather · GetLocation · GetCities
        │       └── data/
        │           ├── models/          # WeatherModel · LocationModel
        │           ├── data_sources/    # WeatherRemoteDataSource (Dio)
        │           └── repositories/    # WeatherRepositoryImpl · CityRepositoryImpl
        └── pubspec.yaml
```

La feature `home` solo tiene capa de presentación **a propósito**: su dominio y sus datos viven en
`weather_repository`. La feature `auth` sí conserva las tres capas porque su persistencia es
específica de la aplicación.

---

## Flujo de datos

Ejemplo completo: el usuario marca **Madrid** como favorita.

```
Usuario toca la tarjeta
        │
        ▼
CitiesListCards ──add(MarkCityAsFavorite("Madrid"))──► WeatherBloc
        │                                                   │
        │                                    emit(CitiesLoading)
        │                                                   │
        │                              add(GetWeatherForCity("Madrid"))
        │                                                   │
        │                                    emit(WeatherCityLoading)
        │                                                   ▼
        │                                         GetLocationUseCase
        │                                                   ▼
        │                                  WeatherRepository (abstract)
        │                                                   ▼
        │                                     WeatherRepositoryImpl
        │                                                   ▼
        │                                    WeatherRemoteDataSource
        │                                                   ▼
        │                          GET geocoding-api.open-meteo.com/v1/search
        │                                                   ▼
        │                                  LocationModel.fromJson → Location
        │                                                   ▼
        │                          GetWeatherUseCase(lat, lon) → GET /v1/forecast
        │                                                   ▼
        │                                   WeatherModel.fromJson → Weather
        │                                                   │
        ▼                                    emit(WeatherCityLoaded)
Navega al tab Home ◄──────────────────────────────────────┘
        │
        ▼
WeatherDetails pinta la ciudad, su temperatura y su bandera
```

La resolución de una ciudad requiere **dos llamadas encadenadas**: primero geocodificación
(nombre → lat/lon) y luego pronóstico (lat/lon → temperatura). La orquestación de esa secuencia
vive en el BLoC, no en el widget ni en el repositorio.

---

## Gestión de estado (BLoC)

Se usa el patrón **BLoC** (`flutter_bloc`) con eventos y estados **inmutables** y comparados por
valor mediante `equatable`. Tanto eventos como estados se declaran `sealed`, lo que permite al
compilador verificar la exhaustividad del manejo.

### AuthBloc

Alcance **global**: se provee en la raíz del árbol (`main.dart`), porque el logout debe poder
dispararse desde cualquier pantalla autenticada.

| Eventos | Estados |
|---|---|
| `LoginEvent(username, password)` | `AuthInitial` |
| `SignupEvent(username, password)` | `AuthLoading` |
| `LogoutEvent()` | `AuthSuccess(user)` · `AuthFailure(error)` · `AuthLogout` |

### WeatherBloc

Alcance **local**: se provee dentro de `HomePage`, de modo que su ciclo de vida queda atado a la
sesión y se descarta al salir.

| Eventos | Estados |
|---|---|
| `LoadCities()` | `WeatherInitial` · `WeatherLoading` |
| `MarkCityAsFavorite(cityName)` | `CitiesLoading` · `CitiesLoaded(cities)` · `CitiesFavoriteUpdated(cities)` |
| `GetWeatherForCity(city)` | `WeatherCityLoading(city)` · `WeatherCityLoaded(location, weather)` |
| `GetWeatherFavCities()` | `WeatherFavCitiesLoaded(list)` |
| `RemoveWeatherFavCity(city)` | `WeatherError(message)` |

**Encadenamiento de eventos.** `MarkCityAsFavorite` dispara internamente `GetWeatherForCity`: el
marcado de favorito y la carga de su clima son dos unidades de trabajo distintas, con sus propios
estados de carga y error, y así cada tarjeta puede mostrar su propio spinner sin bloquear la grilla.

`BlocListener` se usa para efectos de lado (navegación, `SnackBar`, diálogos) y `BlocProvider` para
la inyección del BLoC en el subárbol.

---

## Inyección de dependencias

`get_it` como *service locator*, con todo el grafo declarado en un único punto
(`lib/injection_container.dart`) e inicializado antes de `runApp`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(const MyApp());
}
```

Criterio de registro:

| Tipo | Registro | Motivo |
|---|---|---|
| `Dio`, `SharedPreferences`, data sources, repositorios, casos de uso | `registerLazySingleton` | Sin estado propio; una instancia basta y se crea bajo demanda. |
| `AuthBloc`, `WeatherBloc` | `registerFactory` | Cada `BlocProvider` recibe una instancia nueva, con su propio ciclo de vida y su `close()`. |

Los repositorios se registran **contra su abstracción** (`getIt.registerLazySingleton<WeatherRepository>`),
no contra la implementación: es el punto exacto donde se cumple la inversión de dependencias.

---

## API externa

[**Open-Meteo**](https://open-meteo.com/) — API pública de meteorología, **sin API key** ni registro,
gratuita para uso no comercial.

| Propósito | Endpoint |
|---|---|
| Geocodificación (nombre → lat/lon + código de país) | `GET https://geocoding-api.open-meteo.com/v1/search?name={city}&count=1` |
| Clima actual | `GET https://api.open-meteo.com/v1/forecast?latitude={lat}&longitude={lon}&current_weather=true` |

El cliente HTTP es **Dio**, aislado en `WeatherRemoteDataSource`. Los errores de red se capturan en
esa frontera y se propagan como excepciones de dominio, que el BLoC traduce a `WeatherError`.

El código de país que devuelve la geocodificación se convierte a bandera con una `extension` sobre
`String` que desplaza cada letra ASCII al rango de *Regional Indicator Symbols* Unicode:

```dart
extension ConvertFlag on String {
  String get toFlag => toUpperCase().replaceAllMapped(
        RegExp(r'[A-Z]'),
        (m) => String.fromCharCode(m.group(0)!.codeUnitAt(0) + 127397),
      );
}
```

---

## Persistencia local

**`shared_preferences`**, encapsulado en `SharedPrefHelper` (capa de datos de `auth`). La entidad de
usuario se serializa a JSON bajo una única clave:

| Operación | Método |
|---|---|
| Registrar / guardar sesión | `setUser(UserEntity)` |
| Leer sesión | `getUser() → UserEntity?` |
| Cerrar sesión | `clearUser()` |

Ningún widget ni BLoC habla con `SharedPreferences` directamente: la dependencia entra por
`UserRepositoryImpl` y sale hacia la presentación como `LoginUseCase`.

---

## Dependencias

| Paquete | Versión | Rol en el proyecto |
|---|---|---|
| [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) | 8.1.6 | Gestión de estado por eventos/estados y widgets de integración (`BlocProvider`, `BlocListener`). |
| [`bloc`](https://pub.dev/packages/bloc) | 8.1.4 | Núcleo del patrón, sobre el que se apoya `flutter_bloc`. |
| [`equatable`](https://pub.dev/packages/equatable) | 2.0.5 | Igualdad por valor en entidades, eventos y estados; evita reconstrucciones innecesarias. |
| [`get_it`](https://pub.dev/packages/get_it) | 7.7.0 | Service locator para la inyección de dependencias. |
| [`dio`](https://pub.dev/packages/dio) | 5.6.0 | Cliente HTTP (interceptores, timeouts y manejo de errores tipado). |
| [`shared_preferences`](https://pub.dev/packages/shared_preferences) | 2.3.2 | Almacenamiento clave-valor de la sesión. |
| [`cupertino_icons`](https://pub.dev/packages/cupertino_icons) | 1.0.8 | Set de iconos iOS. |
| [`flutter_lints`](https://pub.dev/packages/flutter_lints) | 4.0.0 | Reglas de análisis estático recomendadas *(dev)*. |
| [`bloc_test`](https://pub.dev/packages/bloc_test) | 9.1.7 | Aserciones sobre secuencias de estados emitidas por un BLoC *(dev)*. |
| [`mocktail`](https://pub.dev/packages/mocktail) | 1.0.5 | Dobles de prueba sin generación de código *(dev)*. |

**Tipografía:** familia [Manrope](https://fonts.google.com/specimen/Manrope) (Light 300 / Regular 400 /
Bold 700) embebida en `assets/fonts/`.

---

## Puesta en marcha

### Requisitos

| Herramienta | Versión |
|---|---|
| Flutter SDK | 3.24.1 o superior (verificado con 3.35.4) |
| Dart SDK | ^3.5.1 (verificado con 3.9.2) |
| Xcode | 15+ · CocoaPods 1.16+ (solo iOS/macOS) |
| Android SDK | API 34 · **JDK 17** (Temurin 17 recomendado) |

### Instalación

```bash
git clone <url-del-repositorio>
cd weather_bnka

# Resuelve las dependencias de la app y del paquete local
flutter pub get

# iOS: instala los pods
cd ios && pod install && cd ..

flutter run
```

No hace falta ninguna variable de entorno ni API key: Open-Meteo es de acceso abierto.

### Primer uso

1. La app abre en el splash y navega a **Login**.
2. Como todavía no hay usuario registrado, pulsa **Sign Up** y crea uno
   (usuario sin caracteres especiales · contraseña de 4 caracteres o más).
3. El registro deja la sesión iniciada y lleva directo a **Home**.
4. En el tab **Cities**, toca una ciudad para seguirla: la app vuelve a **Home** y carga su clima.
5. Toca una tarjeta para ver su detalle; el icono de papelera deja de seguir la ciudad.

---

## Compilación por plataforma

### iOS ✅

```bash
flutter build ios --debug --no-codesign     # verificado
flutter build ipa                            # release (requiere firma)
```

- **Deployment target:** iOS 13.0
- **Orientaciones:** portrait y landscape (iPhone y iPad)
- **Pods:** `shared_preferences_foundation` (única dependencia nativa)
- Probado en el simulador de **iPhone 15**.

### Android ✅

```bash
flutter build apk --debug          # verificado
flutter build appbundle --release  # verificado
```

- **Permiso declarado:** `android.permission.INTERNET` (obligatorio para consumir la API)
- **`compileSdk` / `targetSdk`:** los que provee el Flutter Gradle Plugin (API 34)
- **Toolchain:** Gradle 8.12 · Android Gradle Plugin 8.7.3 · Kotlin 2.1.0 · Java 17

> **Nota sobre el JDK.** La build requiere **JDK 17**. Si tu `java` por defecto es otro, apunta
> Flutter al correcto con
> `flutter config --jdk-dir /Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home`.
> Android Studio **no lee esa opción**: su JDK se configura aparte, en
> *Settings → Build, Execution, Deployment → Build Tools → Gradle → Gradle JDK*.

### Otras plataformas

El proyecto conserva los *runners* generados para **web**, **macOS**, **Linux** y **Windows**. La app
no usa APIs exclusivas de móvil, pero esas plataformas no forman parte del alcance probado.

---

## Calidad de código y pruebas

```bash
flutter analyze                                   # → No issues found!
flutter test                                      # → 15 tests, app
cd packages/weather_repository && flutter test    # → 15 tests, paquete de dominio
```

**30 pruebas, ambas suites en verde y el analizador sin hallazgos.** Cada módulo mantiene su propia
suite, igual que su propio `pubspec.yaml`.

| Suite | Archivo | Qué cubre |
|---|---|---|
| App | `test/features/auth/auth_bloc_test.dart` | Las cuatro ramas del login (éxito, sin usuario registrado, contraseña incorrecta, usuario distinto), el alta con persistencia verificada y el logout. |
| App | `test/features/home/weather_bloc_test.dart` | Carga del catálogo y su error, la secuencia geocodificación → pronóstico con las coordenadas correctas, el fallo al geocodificar y el **encadenamiento** `MarkCityAsFavorite` → `GetWeatherForCity`. |
| Paquete | `test/data/models_test.dart` | `fromJson`/`toJson` de `WeatherModel` y `LocationModel` contra la forma real de la respuesta de Open-Meteo. |
| Paquete | `test/domain/city_test.dart` | Inmutabilidad de `City.toggleFavorite()` e igualdad por valor. |
| Paquete | `test/domain/usecases_test.dart` | Que cada caso de uso delegue en su repositorio, propague los fallos y respete el orden de los argumentos. |
| Paquete | `test/data/city_repository_impl_test.dart` | Integridad del catálogo estático. |

Los dobles se construyen con `mocktail` (sin generación de código) y las secuencias de estados se
verifican con `bloc_test`, que es lo que permite afirmar no solo *qué* estado quedó, sino **en qué
orden se emitió cada uno** — el detalle que hace falta para probar el encadenamiento de eventos.

---

## Alcance y decisiones de diseño

Este es un proyecto de demostración, y algunas decisiones están deliberadamente acotadas. Se
documentan aquí para que la frontera entre *decisión* y *deuda* quede explícita.

- **La autenticación es local, no un backend.** No hay servidor, ni token, ni sesión remota:
  `shared_preferences` guarda un único usuario en el dispositivo. La credencial se persiste en
  claro, lo cual es aceptable para una demo sin datos reales, pero en producción exigiría
  `flutter_secure_storage` (Keychain / Keystore) y, sobre todo, que la validación ocurriera en el
  servidor y nunca en el cliente.
- **Un solo usuario registrado a la vez.** El helper escribe siempre sobre la misma clave, de modo
  que un nuevo registro reemplaza al anterior. Es suficiente para el flujo de la demo.
- **El catálogo de ciudades es estático.** `CityRepositoryImpl` devuelve 20 ciudades desde memoria.
  Al estar detrás de la abstracción `CityRepository`, sustituirlo por un endpoint remoto o una base
  de datos local es cambiar un registro en el contenedor de DI.
- **Las ciudades seguidas no se persisten** entre ejecuciones: viven en el `WeatherBloc` y se
  descartan con la sesión.
- **Sin caché de respuestas.** Cada vez que se marca una ciudad se consulta la API; no hay TTL ni
  almacenamiento intermedio.
- **Se consume `current_weather`**, es decir la temperatura actual y el código de condición. La API
  ofrece además pronóstico horario y a 7 días, no incorporados aquí.

---

## Roadmap

Mejoras identificadas, en orden de valor:

1. **Pruebas de widget e integración** — la lógica ya está cubierta (30 pruebas sobre BLoCs, casos de
   uso y modelos); falta ejercitar los formularios, la grilla de ciudades y el recorrido completo
   login → seleccionar ciudad → ver temperatura.
2. **Manejo de errores tipado** — reemplazar las excepciones genéricas por un `Either<Failure, T>`
   (`dartz` / `fpdart`) o un `sealed Result`, y distinguir sin red, timeout, ciudad no encontrada y
   error del servidor con mensajes propios.
3. **Persistir las ciudades seguidas** en `shared_preferences` o SQLite, para que el panel sobreviva
   al reinicio.
4. **Migrar el estado derivado al `WeatherState`** — hoy el BLoC conserva algunas listas como campos
   mutables; llevarlas al estado y consumirlas con `BlocBuilder` haría el flujo unidireccional de
   punta a punta y eliminaría el `setState` espejo en los widgets.
5. **Tematización por condición climática** — las paletas ya están definidas en
   `config/theme/color_palettes.dart`; falta enlazarlas al `weatherCode` que ya devuelve la API.
6. **Configurar `Dio`** con `baseUrl`, timeouts e interceptor de logging.
7. **CI** — `flutter analyze` + `flutter test` en cada push (GitHub Actions).
8. **Accesibilidad e i18n** — la interfaz mezcla español e inglés; unificar vía `flutter_localizations`.

---

## Autor

**Américo Arroyo** — desarrollo móvil con Flutter.

