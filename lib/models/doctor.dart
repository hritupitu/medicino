import 'package:json_annotation/json_annotation.dart';

part 'doctor.g.dart';

@JsonSerializable(explicitToJson: true)
class Doctor {
  @JsonKey(defaultValue: '')
  final String name;

  @JsonKey(defaultValue: '')
  final String specialization;

  @JsonKey(defaultValue: 0)
  final int contact;

  @JsonKey(defaultValue: '')
  final String clinic;

  @JsonKey(defaultValue: 0)
  final double latitude;

  @JsonKey(defaultValue: 0)
  final double longitude;

  Doctor({
    this.name,
    this.specialization,
    this.contact,
    this.clinic,
    this.latitude,
    this.longitude,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorToJson(this);
}
