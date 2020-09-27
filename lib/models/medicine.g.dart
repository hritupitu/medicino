// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Medicine _$MedicineFromJson(Map<String, dynamic> json) {
  return Medicine(
    name: json['Name'] as String ?? '',
    avail: json['Avail'] as int ?? 0,
    price: json['Price'] as int ?? 0,
  );
}

Map<String, dynamic> _$MedicineToJson(Medicine instance) => <String, dynamic>{
      'Name': instance.name,
      'Avail': instance.avail,
      'Price': instance.price,
    };
