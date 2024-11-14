import 'package:equatable/equatable.dart';
import 'package:passkit/passkit.dart';

class EventPassRequest extends Equatable {
  const EventPassRequest({
    required this.name,
    required this.title,
    required this.company,
  });

  final String name;
  final String title;
  final String company;

  @override
  List<Object> get props => [name, title, company];

  PassData toPassData() {
    final eventTicket = PassStructure(
      primaryFields: [
        FieldDict(
          key: 'eventName',
          value: 'FlutterConf Latam 2024',
          label: 'Event',
          changeMessage: '',
          textAlignment: PkTextAlignment.left,
        ),
      ],
      secondaryFields: [
        FieldDict(
          key: 'ticket',
          value: 'Speaker',
          label: 'Product',
          changeMessage: '',
          textAlignment: PkTextAlignment.left,
        ),
      ],
      backFields: [
        FieldDict(
          key: 'doorsAdmission',
          value: '2024-10-29 07:00',
          label: 'Admission time',
          changeMessage: '',
          textAlignment: PkTextAlignment.left,
        ),
        FieldDict(
          key: 'name',
          value: name,
          label: 'Attendee name',
          changeMessage: '',
          textAlignment: PkTextAlignment.left,
        ),
        FieldDict(
          key: 'email',
          value: name,
          label: 'Ordered by',
          changeMessage: '',
          textAlignment: PkTextAlignment.left,
        ),
        FieldDict(
          key: 'organizer',
          value: 'FlutterConf Latam',
          label: 'Organizer',
          changeMessage: '',
          textAlignment: PkTextAlignment.left,
        ),
        FieldDict(
          key: 'organizerContact',
          value: 'flutterconflatam@gmail.com',
          label: 'Organizer contact',
          changeMessage: '',
          textAlignment: PkTextAlignment.left,
        ),
        FieldDict(
          key: 'orderCode',
          value: 'BCTT3',
          label: 'Order code',
          changeMessage: '',
          textAlignment: PkTextAlignment.left,
        ),
        FieldDict(
          key: 'purchaseDate',
          value: '2024-10-30 14:00',
          label: 'Purchase date',
          changeMessage: '',
          textAlignment: PkTextAlignment.left,
        ),
        FieldDict(
          key: 'website',
          value: 'https://flutterconflatam.dev/',
          label: 'Website',
          changeMessage: '',
          textAlignment: PkTextAlignment.left,
        ),
      ],
      auxiliaryFields: [
        FieldDict(
          key: 'name',
          value: name,
          label: 'Attendee name',
          textAlignment: PkTextAlignment.left,
        ),
        FieldDict(
          key: 'title',
          value: title,
          label: 'Job title',
          textAlignment: PkTextAlignment.left,
        ),
        FieldDict(
          key: 'company',
          value: company,
          label: 'Company',
          textAlignment: PkTextAlignment.left,
        ),
      ],
    );

    return PassData(
      teamIdentifier: const String.fromEnvironment('TEAM_IDENTIFIER'),
      passTypeIdentifier: const String.fromEnvironment('PASS_TYPE_IDENTIFIER'),
      logoText: 'FlutterConf Latam 2024',
      description: 'FlutterConf Latam 2024 Event Ticket',
      serialNumber: 'flutterconf-latam24',
      organizationName: 'FlutterConf Latam',
      eventTicket: eventTicket,
      suppressStripShine: false,
      labelColor: parseColor('#ca4d4f'),
      backgroundColor: parseColor('#FFFFFF'),
      foregroundColor: parseColor('#000000'),
      locations: [Location(latitude: -16.39889, longitude: -71.535)],
      barcodes: [
        Barcode(
          format: PkPassBarcodeType.qr,
          message: 'https://flutterconflatam.dev/',
          messageEncoding: 'iso-8859-1',
        ),
      ],
    );
  }
}
