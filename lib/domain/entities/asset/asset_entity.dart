import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_entity.freezed.dart';

@freezed
class AssetEntity with _$AssetEntity {
  factory AssetEntity({
    required int id,
    required String path,
    required String mimetype,
  }) = _AssetEntity;
}