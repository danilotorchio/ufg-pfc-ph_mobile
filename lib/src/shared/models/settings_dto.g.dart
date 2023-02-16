// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsDto _$SettingsDtoFromJson(Map<String, dynamic> json) => SettingsDto(
      wifiSSID: json['wifi_ssid'] as String,
      wifiPass: json['wifi_pass'] as String,
      userEmail: json['user_email'] as String,
      userPass: json['user_pass'] as String,
      apiUrl: json['api_url'] as String,
    );

Map<String, dynamic> _$SettingsDtoToJson(SettingsDto instance) =>
    <String, dynamic>{
      'wifi_ssid': instance.wifiSSID,
      'wifi_pass': instance.wifiPass,
      'user_email': instance.userEmail,
      'user_pass': instance.userPass,
      'api_url': instance.apiUrl,
    };
