import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings_dto.g.dart';

typedef JsonMap = Map<String, dynamic>;

@immutable
@JsonSerializable()
class SettingsDto extends Equatable {
  @JsonKey(name: 'wifi_ssid')
  final String wifiSSID;

  @JsonKey(name: 'wifi_pass')
  final String wifiPass;

  @JsonKey(name: 'user_email')
  final String userEmail;

  @JsonKey(name: 'user_pass')
  final String userPass;

  @JsonKey(name: 'api_url')
  final String apiUrl;

  const SettingsDto({
    required this.wifiSSID,
    required this.wifiPass,
    required this.userEmail,
    required this.userPass,
    required this.apiUrl,
  });

  factory SettingsDto.fromJson(JsonMap json) => _$SettingsDtoFromJson(json);
  JsonMap toJson() => _$SettingsDtoToJson(this);

  @override
  List<Object?> get props => [wifiSSID, wifiPass, userEmail, userPass, apiUrl];
}
