import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_cors/src/cors_defaults.dart';

/// Immediately respond to `OPTIONS` requests with your CORS headers
/// and injects CORS headers into every other [Response].
Middleware cors({
  String allowOrigin = CorsDefaults.allowOrigin,
  String allowMethods = CorsDefaults.allowMethods,
  String allowHeaders = CorsDefaults.allowHeaders,
  Map<String, String>? additional,
}) {
  final headers = {
    'Access-Control-Allow-Origin': allowOrigin,
    'Access-Control-Allow-Methods': allowMethods,
    'Access-Control-Allow-Headers': allowHeaders,
    if (additional != null) ...additional
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
