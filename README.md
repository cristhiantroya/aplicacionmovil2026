
### Backend
- Node.js + TypeScript
- Express.js
- Prisma ORM
- MariaDB/MySQL
- bcrypt (password hashing)
- jsonwebtoken (JWT authentication)

### Frontend (Mobile App)
- Flutter
- Dart
- Dio (HTTP client)
- flutter_secure_storage (secure token storage)
- Provider (state management)
- Geolocator


## API Endpoints

- `/api/auth/register` - Register a new user
- `/api/auth/login` - User login
- `/api/products` - Product CRUD
- `/api/transactions` - Transaction management
- `/api/ratings` - Rating system
- `/api/verifications` - Identity verification
- `/api/points` - Safe points
- `/api/notifications` - Notifications


## Configuración del Entorno de Desarrollo (App Móvil)

### 1. Framework multiplataforma seleccionado

**Flutter** (Dart), sobre el canal `stable`.

**Justificación técnica:**
- Compila a código nativo ARM tanto para Android como para iOS a partir de una única base de código, evitando mantener dos proyectos separados.
- Dart ofrece tipado estático, lo que reduce errores en tiempo de ejecución y mejora la mantenibilidad del proyecto.
- El modelo de programación reactiva basado en widgets permite una experiencia de usuario consistente entre plataformas.
- Cuenta con un ecosistema maduro de paquetes utilizados en este proyecto: `dio` (cliente HTTP), `flutter_secure_storage` (almacenamiento seguro de tokens), `image_picker` (selección de fotos), `flutter_map` (mapas sin dependencia de API keys de pago), `provider` (gestión de estado).
- El hot reload agiliza significativamente el ciclo de desarrollo frente a alternativas nativas (Android/Kotlin y iOS/Swift por separado).

### 2. Entorno instalado

| Componente                      | Versión / Detalle |
| Flutter SDK                     | 3.44.4 (canal stable) |
| Dart SDK                        | 3.12.2 |
| Editor                          | Visual Studio Code, con extensiones Flutter y Dart |
| IDE para Android                | Android Studio (incluye Android SDK, emulador, y SDK Manager) |
| Android SDK                     | Versión 36.1.0 |
| Sistema operativo de desarrollo | Windows 11 (24H2) |

### 3. Diagnóstico del framework (`flutter doctor`)

Se ejecutó `flutter doctor -v` y se resolvieron los siguientes hallazgos:

- **`cmdline-tools component is missing`**: resuelto instalando "Android SDK Command-line Tools (latest)" desde Android Studio → Tools → SDK Manager → pestaña SDK Tools.
- **`Android license status unknown`**: resuelto ejecutando `flutter doctor --android-licenses` y aceptando todas las licencias del SDK.
- **`Visual Studio not installed; this is necessary to develop Windows apps`**: no se resolvió, de forma intencional. Este proyecto está orientado exclusivamente a dispositivos móviles Android, no a aplicaciones de escritorio nativas de Windows, por lo que instalar Visual Studio con la carga de trabajo de C++ no aporta valor al alcance del proyecto.

Tras estas correcciones, `flutter doctor -v` no reporta hallazgos pendientes relevantes para el desarrollo móvil Android.

### 4. Destino de ejecución

**Dispositivo virtual (emulador Android)**: `sdk gphone64 x86 64`, Android 13 (API 33).

**Justificación:** se optó por un emulador en lugar de un dispositivo físico por tres razones: (1) no requiere adquirir hardware adicional, (2) ofrece un entorno reproducible y consistente entre sesiones de desarrollo, y (3) las especificaciones del emulador (Android 13 / API 33) son representativas de un rango amplio de dispositivos reales en el mercado ecuatoriano, suficiente para validar la funcionalidad de la aplicación en esta etapa del proyecto.

### 5. Creación del proyecto base y verificación

El proyecto se estructura como una aplicación Flutter estándar (`lib/`, `android/`, `pubspec.yaml`). Se verificó la ejecución exitosa mediante `flutter run -d emulator-5554`, y el correcto funcionamiento del hot reload (`r`) y hot restart (`R`) durante todo el ciclo de desarrollo, permitiendo iterar sobre la interfaz y la lógica sin reiniciar la aplicación completa en cada cambio.

### 6. Variable de entorno para la URL base del API

La URL base del backend se definió mediante `String.fromEnvironment`, inyectada en tiempo de compilación con `--dart-define`, en lugar de estar codificada de forma fija en el código fuente:

```dart
// lib/constants/app_constants.dart
static const String baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:3000/api',
);
```

Ejecución:
```bash
flutter run -d emulator-5554 --dart-define=API_BASE_URL=http://10.0.2.2:3000/api
```

**Autorización acotada de tráfico HTTP:** dado que el backend de desarrollo no utiliza HTTPS, y Android bloquea por defecto el tráfico sin cifrar, se configuró `network_security_config.xml` para autorizar tráfico HTTP **únicamente** hacia `10.0.2.2` (la dirección que el emulador usa para representar el `localhost` de la máquina anfitriona), dejando bloqueado por defecto el tráfico sin cifrar hacia cualquier otro dominio:

```xml
<!-- android/app/src/main/res/xml/network_security_config.xml -->
<network-security-config>
    <domain-config cleartextTrafficPermitted="true">
        <domain includeSubdomains="false">10.0.2.2</domain>
    </domain-config>
</network-security-config>
```

Referenciado en `android/app/src/main/AndroidManifest.xml`:
```xml
<application
    android:networkSecurityConfig="@xml/network_security_config"
    ...>
```

### 7. Verificación de comunicación con el backend propio

Se realizó una solicitud real desde la aplicación hacia el backend local (`POST /api/auth/login`), confirmando la recepción exitosa de la respuesta (código `200 OK`, con `accessToken`, `refreshToken` y los datos del usuario autenticado). Este flujo se probó de forma repetida durante el desarrollo, incluyendo operaciones de lectura (`GET /api/products`) y escritura (`POST /api/products`), confirmando la correcta comunicación cliente-servidor sobre la URL base configurada mediante variable de entorno.

### 8. Resumen de comandos utilizados

```bash
# Diagnóstico
flutter doctor -v
flutter doctor --android-licenses

# Dispositivos disponibles
flutter devices

# Ejecución con variable de entorno
flutter run -d emulator-5554 --dart-define=API_BASE_URL=http://10.0.2.2:3000/api

# Ciclo de desarrollo (dentro de la sesión de flutter run)
r   # hot reload
R   # hot restart