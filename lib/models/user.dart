import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class CustomUser {
  @JsonKey(defaultValue: '')
  final String email;

  @JsonKey(defaultValue: '')
  final String name;

  @JsonKey(defaultValue: '')
  final String gender;

  CustomUser({this.gender, this.email, this.name});

  factory CustomUser.fromJson(Map<String, dynamic> json) =>
      _$CustomUserFromJson(json);

  Map<String, dynamic> toJson() => _$CustomUserToJson(this);
}
