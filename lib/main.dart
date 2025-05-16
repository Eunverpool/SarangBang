import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // shared_preferences 패키지 추가
import 'package:uuid/uuid.dart';

import 'core/routes/app_routes.dart';
import 'core/routes/on_generate_route.dart';
import 'core/themes/app_themes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// 국제화 기능
import 'package:intl/date_symbol_data_local.dart';

// 기기 ID 관리 함수
class DeviceIdManager {
  static const String _deviceIdKey = 'device_id';

  static Future<String?> getDeviceId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_deviceIdKey);
  }

  static Future<String> generateAndSaveDeviceId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const uuid = Uuid();
    //final String deviceId = uuid.v4(); 이거 테스트하는동안 uuid-1234로 고정
    const String deviceId = 'uuid-1234';
    await prefs.setString(_deviceIdKey, deviceId);
    return deviceId;
  }

  static Future<String> getOrCreateDeviceId() async {
    final String? storedDeviceId = await getDeviceId();
    if (storedDeviceId != null) {
      return storedDeviceId;
    } else {
      return await generateAndSaveDeviceId();
    }
  }

  static Future<void> printDeviceId() async {
    //final String deviceId = await getOrCreateDeviceId();
    const String deviceId = 'uuid-1234';
    print('Device ID: $deviceId');
  }

  static Future<void> sendDeviceIdToServer() async {
    final String deviceId = await getOrCreateDeviceId();

    // 서버에 전송할 데이터
    final Map<String, dynamic> data = {
      'user_uuid': deviceId,
      'user_family_email': 'family@example.com', // 예시 이메일
      'user_date': DateTime.now().toIso8601String(),
    };

    // 서버 URL
    final String url = 'http://localhost:3000/users';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Successfully sent data to server');
      } else {
        print('Failed to send data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

void main() {
  initializeDateFormatting().then((_) => runApp(const MyApp()));
  DeviceIdManager.sendDeviceIdToServer();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SarangBang',
      theme: AppTheme.defaultTheme,
      onGenerateRoute: RouteGenerator.onGenerate,
      initialRoute: AppRoutes.entryPoint,
    );
  }
}
