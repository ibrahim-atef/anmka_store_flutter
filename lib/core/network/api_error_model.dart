import 'package:json_annotation/json_annotation.dart';

part 'api_error_model.g.dart';

@JsonSerializable()
class ApiErrorModel {
  final String? message;
  final String? code;
  final Map<String, dynamic>? data;
  final int? statusCode;

  const ApiErrorModel({
    this.message,
    this.code,
    this.data,
    this.statusCode,
  });

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorModelToJson(this);

  String get errorMessage {
    if (message != null && message!.isNotEmpty) {
      return message!;
    }
    if (code != null && code!.isNotEmpty) {
      return code!;
    }
    return 'حدث خطأ غير متوقع';
  }
}

