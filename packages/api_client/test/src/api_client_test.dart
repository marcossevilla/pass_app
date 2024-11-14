// ignore_for_file: prefer_const_constructors
import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  group('ApiClient', () {
    // ignore: unused_local_variable
    late Dio dio;

    setUp(() {
      dio = _MockDio();
    });

    test(
      'can be instantiated',
      () => expect(ApiClient(host: 'localhost:8080'), isNotNull),
    );
  });
}
