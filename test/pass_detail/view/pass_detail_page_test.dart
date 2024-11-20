// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:csslib/parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:pass_app/pass_detail/pass_detail.dart';
import 'package:passkit/passkit.dart';
import 'package:passkit_ui/passkit_ui.dart';

import '../../helpers/helpers.dart';

class _MockPassDetailBloc extends MockBloc<PassDetailEvent, PassDetailState>
    implements PassDetailBloc {}

class _FakePkPass extends Fake implements PkPass {
  PkImage get _image {
    const source =
        '''iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAFUlEQVR42mP8/5+hnoEIwDiqkL4KAcT9GO0U4BxoAAAAAElFTkSuQmCC''';
    final image = base64.decode(source);
    return PkImage(
      image1: image,
      image2: image,
      image3: image,
    );
  }

  @override
  PassData get pass => _FakePassData();

  @override
  PassType get type => PassType.eventTicket;

  @override
  PkImage? get strip => null;

  @override
  PkImage? get logo => _image;

  @override
  PkImage? get background => _image;

  @override
  PkImage? get thumbnail => _image;
}

class _FakePassData extends Fake implements PassData {
  @override
  Color? get backgroundColor => parseColor('#FF0000');

  @override
  Color? get foregroundColor => parseColor('#00FF00');

  @override
  Color? get labelColor => parseColor('#0000FF');

  @override
  PassStructure? get eventTicket => _FakePassStructure();

  @override
  String? get logoText => 'logoText';

  @override
  List<Barcode>? get barcodes => [];

  @override
  Barcode? get barcode => _FakeBarcode();
}

class _FakePassStructure extends Fake implements PassStructure {
  @override
  List<FieldDict>? get headerFields {
    return [FieldDict(key: 'header', label: 'Header', value: 'Value')];
  }

  @override
  List<FieldDict>? get auxiliaryFields {
    return [FieldDict(key: 'auxiliary', label: 'Auxiliary', value: 'Value')];
  }

  @override
  List<FieldDict>? get primaryFields {
    return [FieldDict(key: 'primary', label: 'Primary', value: 'Value')];
  }

  @override
  List<FieldDict>? get secondaryFields {
    return [FieldDict(key: 'secondary', label: 'Secondary', value: 'Value')];
  }
}

class _FakeBarcode extends Fake implements Barcode {
  @override
  PkPassBarcodeType get format => PkPassBarcodeType.qr;

  @override
  String get message => 'message';

  @override
  String get messageEncoding => 'messageEncoding';

  @override
  String? get altText => 'altText';
}

void main() {
  group('PassDetailPage', () {
    late PkPass pkPass;

    setUp(() {
      pkPass = _FakePkPass();
    });

    test(
      'is routable',
      () => expect(
        PassDetailPage.route(pass: pkPass),
        isRoute<void>(whereName: equals(PassDetailPage.routeName)),
      ),
    );

    testWidgets('renders PassDetailView', (tester) async {
      await tester.pumpApp(
        Navigator(
          onGenerateRoute: (_) => PassDetailPage.route(pass: pkPass),
        ),
      );
      expect(find.byType(PassDetailView), findsOneWidget);
    });
  });

  group('PassDetailView', () {
    late PassDetailBloc passDetailBloc;
    late PkPass pkPass;
    late Widget widgetToTest;

    setUp(() {
      passDetailBloc = _MockPassDetailBloc();
      pkPass = _FakePkPass();

      when(() => passDetailBloc.state).thenReturn(
        PassDetailState(pass: pkPass),
      );

      widgetToTest = BlocProvider.value(
        value: passDetailBloc,
        child: PassDetailView(),
      );
    });

    testWidgets('renders PkPassWidget', (tester) async {
      await tester.pumpApp(widgetToTest);
      expect(find.byType(PkPassWidget), findsOneWidget);
    });

    testWidgets('adds pass when button is tapped', (tester) async {
      await tester.pumpApp(widgetToTest);

      final finder = find.widgetWithText(
        CupertinoButton,
        tester.l10n.passDetailPageAddToWalletButtonLabel,
      );

      await tester.scrollUntilVisible(finder, 100);
      await tester.tap(finder);

      verify(() => passDetailBloc.add(PassDetailPassAdded(pkPass))).called(1);
    });
  });
}
