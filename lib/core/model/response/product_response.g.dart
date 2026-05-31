// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductResponseAdapter extends TypeAdapter<ProductResponse> {
  @override
  final int typeId = 0;

  @override
  ProductResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductResponse(
      id: fields[0] as int?,
      title: fields[1] as String?,
      slug: fields[6] as String?,
      price: fields[2] as int?,
      description: fields[5] as String?,
      images: (fields[4] as List?)?.cast<String>(),
      creationAt: fields[7] as String?,
      updatedAt: fields[8] as String?,
      quantity: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ProductResponse obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(6)
      ..write(obj.slug)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.images)
      ..writeByte(7)
      ..write(obj.creationAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(3)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
