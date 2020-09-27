import 'package:hackathon_app/models/medicine.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pharmacies.g.dart';

@JsonSerializable(explicitToJson: true)
class Pharmacies {
  @JsonKey(defaultValue: '')
  final String name;

  @JsonKey(defaultValue: [])
  final List<Medicine> medicines;

  @JsonKey(defaultValue: 0)
  final int longitude;

  @JsonKey(defaultValue: 0)
  final int latitude;

  Pharmacies({this.name, this.medicines, this.latitude, this.longitude});

  factory Pharmacies.fromJson(Map<String, dynamic> json) =>
      _$PharmaciesFromJson(json);

  Map<String, dynamic> toJson() => _$PharmaciesToJson(this);
}
