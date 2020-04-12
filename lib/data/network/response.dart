import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable(nullable: false)
class TokenResponse {
  final String token;

  TokenResponse({this.token});

  factory TokenResponse.fromJson(Map<String, dynamic> json) => _$TokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TokenResponseToJson(this);
}
