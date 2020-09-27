import 'package:json_annotation/json_annotation.dart';

part 'medicine.g.dart';

@JsonSerializable(explicitToJson: true)
class Medicine {
  @JsonKey(defaultValue: '', name: "Name")
  final String name;

  @JsonKey(defaultValue: 0, name: "Avail")
  final int avail;

  @JsonKey(defaultValue: 0, name: "Price")
  final int price;

  Medicine({this.name, this.avail, this.price});

  factory Medicine.fromJson(Map<String, dynamic> json) =>
      _$MedicineFromJson(json);

  Map<String, dynamic> toJson() => _$MedicineToJson(this);
}
