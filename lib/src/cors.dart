import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_cors/src/cors_defaults.dart';

/// Injects CORS headers into every [Response].
///
/// Also adds an immediate response to `OPTIONS` requests for preflight checks.
Middleware cors({
  String allowOrigin = CorsDefaults.allowOrigin,
  String allowMethods = CorsDefaults.allowMethods,
  String allowHeaders = CorsDefaults.allowHeaders,
  Map<String, String>? additional,
}) {
  final headers = {
    HttpHeaders.accessControlAllowOriginHeader: allowOrigin,
    HttpHeaders.accessControlAllowMethodsHeader: allowMethods,
    HttpHeaders.accessControlAllowHeadersHeader: allowHeaders,
    if (additional != null) ...additional,
  };

  return (handler) {
    return (context) async {
      if (context.request.method == HttpMethod.options) {
        return Response(statusCode: HttpStatus.ok, headers: headers);
      }

      final response = await handler(context);
      return response.copyWith(
        headers: {
          ...response.headers,
          ...headers,
        },
      );
    };
  };
}
