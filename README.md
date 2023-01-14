<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

Adds CORS middleware for `dart_frog` server applications.

## Features

Responds to `OPTIONS` requests and injects your CORS headers into your `Response`s.

## Usage

1. Install the package:

```dart
dart pub add dart_frog_cors
```

2. Add the middleware:

```dart
import 'package:dart_frog_cors/dart_frog_cors.dart';

Handler middleware(Handler handler) {
  return handler.use(cors());
}
```

## Defaults

The package includes the following defaults:

* `Access-Control-Allow-Origin`: `*`
* `Access-Control-Allow-Methods`: `GET,PUT,POST,PATCH,DELETE,OPTIONS`
* `Access-Control-Allow-Headers`: `Origin,X-Requested-With,Content-Type,Accept,Authorization`

### Overriding defaults

You can easily override the defaults with your own values.

```dart
Handler middleware(Handler handler) {
  return handler.use(cors(
    allowOrigin: 'https://your-domain.com',
    allowMethods: 'GET,POST,PUT',
  ));
}
```

### Additional headers

You can also add your own `Map<String, String>` of headers to be injected using the `additional` property.

```dart
Handler middleware(Handler handler) {
  return handler.use(cors(
    additional: {
      'Some-Key': 'SomeValue',
    },
  ));
}
```

## Additional information

This is not an official `dart_frog` package.

This package was based on this fabulous CORS example for the `shelf` server: [shelf_helpers](https://github.com/Kleak/shelf_helpers/blob/main/lib/src/middlewares/cors.dart)
