import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // shared_preferences 패키지 추가
import 'package:uuid/uuid.dart';

import 'core/routes/app_routes.dart';
import 'core/routes/on_generate_route.dart';
import 'core/themes/app_themes.dart';

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
    final String deviceId = uuid.v4();
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
    final String deviceId = await getOrCreateDeviceId();
    print('Device ID: $deviceId');
  }
}

void main() {
  initializeDateFormatting().then((_) => runApp(const MyApp()));
  DeviceIdManager.printDeviceId();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SarangBang',
      theme: AppTheme.defaultTheme,
      onGenerateRoute: RouteGenerator.onGenerate,
      initialRoute: AppRoutes.login,
    );
  }
}
