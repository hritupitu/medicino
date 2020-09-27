// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pharmacies.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pharmacies _$PharmaciesFromJson(Map<String, dynamic> json) {
  return Pharmacies(
    name: json['name'] as String ?? '',
    medicines: (json['medicines'] as List)
            ?.map((e) =>
                e == null ? null : Medicine.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    latitude: json['latitude'] as int ?? 0,
    longitude: json['longitude'] as int ?? 0,
  );
}

Map<String, dynamic> _$PharmaciesToJson(Pharmacies instance) =>
    <String, dynamic>{
      'name': instance.name,
      'medicines': instance.medicines?.map((e) => e?.toJson())?.toList(),
      'longitude': instance.longitude,
      'latitude': instance.latitude,
    };
