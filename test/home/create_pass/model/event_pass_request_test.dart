// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pass_app/home/create_pass/create_pass.dart';

void main() {
  group('EventPassRequest', () {
    test('supports value equality', () {
      expect(
        EventPassRequest(
          name: 'John Doe',
          title: 'Speaker',
          company: 'FlutterConf Latam',
        ),
        equals(
          EventPassRequest(
            name: 'John Doe',
            title: 'Speaker',
            company: 'FlutterConf Latam',
          ),
        ),
      );

      expect(
        EventPassRequest(
          name: 'John Doe',
          title: 'Speaker',
          company: 'FlutterConf Latam',
        ),
        isNot(
          equals(
            EventPassRequest(
              name: 'Jane Doe',
              title: 'Speaker',
              company: 'FlutterConf Latam',
            ),
          ),
        ),
      );
    });
  });
}
