import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(fromJson: _idFromJson)
  final int id;
  final String name;
  final String? email;
  final String? username;

  const UserModel({
    required this.id,
    required this.name,
    this.email,
    this.username,
  });

  // Helper function to handle id as both String and int
  static int _idFromJson(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is String) {
      return int.tryParse(value) ?? 0;
    } else if (value is num) {
      return value.toInt();
    }
    return 0;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

