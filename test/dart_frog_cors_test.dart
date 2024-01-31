import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_cors/dart_frog_cors.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockRequestContext extends Mock implements RequestContext {}

class MockResponse extends Mock implements Response {}

class MockRequest extends Mock implements Request {}

void main() {
  const allowOriginHeader = HttpHeaders.accessControlAllowOriginHeader;
  const allowMethodsHeader = HttpHeaders.accessControlAllowMethodsHeader;
  const allowHeadersHeader = HttpHeaders.accessControlAllowHeadersHeader;

  late Request request;
  late RequestContext context;
  late Response response;
  late Handler handler;

  Map<String, String> getCapturedHeaders() {
    return Map.from(verify(
      () => response.copyWith(
        headers: captureAny(named: 'headers'),
      ),
    ).captured.first);
  }

  group('cors', () {
    late bool handlerCalled;
    late Response result;

    setUp(() {
      handlerCalled = false;

      response = MockResponse();
      request = MockRequest();
      context = MockRequestContext();

      handler = (context) {
        handlerCalled = true;
        return response;
      };
    });

    group('defaults', () {
      group('when the request is OPTIONS', () {
        setUp(() async {
          when(() => request.method).thenReturn(HttpMethod.options);
          when(() => context.request).thenReturn(request);

          result = await cors()(handler)(context);
        });

        test('the headers contain the default keys', () {
          final headers = result.headers;
          expect(headers.containsKey(allowOriginHeader), isTrue);
          expect(headers.containsKey(allowMethodsHeader), isTrue);
          expect(headers.containsKey(allowHeadersHeader), isTrue);
        });

        test('the headers contain the default values', () {
          final headers = result.headers;
          final allowOrigin = headers[allowOriginHeader]!;
          final allowMethods = headers[allowMethodsHeader]!;
          final allowHeaders = headers[allowHeadersHeader]!;

          expect(allowOrigin, equals(CorsDefaults.allowOrigin));
          expect(allowMethods, equals(CorsDefaults.allowMethods));
          expect(allowHeaders, equals(CorsDefaults.allowHeaders));
        });

        test('it immediately returns without processing the pipeline', () {
          expect(handlerCalled, isFalse);
        });
      });

      group('when the request is not OPTIONS', () {
        setUp(() async {
          when(() => response.copyWith(headers: captureAny(named: 'headers')))
              .thenReturn(response);
          when(() => response.headers).thenReturn(const {});
          when(() => request.method).thenReturn(HttpMethod.get);
          when(() => context.request).thenReturn(request);

          result = await cors()(handler)(context);
        });

        test('it runs the handler pipeline', () {
          expect(handlerCalled, isTrue);
        });

        test('it injects the default header keys', () {
          final headers = getCapturedHeaders();

          expect(headers.containsKey(allowOriginHeader), isTrue);
          expect(headers.containsKey(allowMethodsHeader), isTrue);
          expect(headers.containsKey(allowHeadersHeader), isTrue);
        });

        test('it injects the default header values', () {
          final headers = getCapturedHeaders();
          final allowOrigin = headers[allowOriginHeader]!;
          final allowMethods = headers[allowMethodsHeader]!;
          final allowHeaders = headers[allowHeadersHeader]!;

          expect(allowOrigin, equals(CorsDefaults.allowOrigin));
          expect(allowMethods, equals(CorsDefaults.allowMethods));
          expect(allowHeaders, equals(CorsDefaults.allowHeaders));
        });
      });
    });
  });
}
