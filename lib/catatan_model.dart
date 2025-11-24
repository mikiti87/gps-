import 'package:latlong2/latlong.dart' as latlong;

enum CatatanType { Toko, Rumah, Kantor }

class CatatanModel {
  final latlong.LatLng position;
  final String note;
  final String address;
  final CatatanType type;

  CatatanModel({
    required this.position,
    required this.note,
    required this.address,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'lat': position.latitude,
        'lng': position.longitude,
        'note': note,
        'address': address,
        'type': type.index,
      };

  factory CatatanModel.fromJson(Map<String, dynamic> json) => CatatanModel(
        position: latlong.LatLng(
            (json['lat'] as num).toDouble(), (json['lng'] as num).toDouble()),
        note: json['note'] as String,
        address: json['address'] as String,
        type: CatatanType.values[(json['type'] as int)],
      );
}
