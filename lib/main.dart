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

// 기기 ID 관리
import '/utils/device_id_manager.dart';

void main() async {
  // initializeDateFormatting().then((_) => runApp(const MyApp()));
  // DeviceIdManager.sendDeviceIdToServer(); // 앱 시작 시 서버에 UUID 전송
  // DeviceIdManager.printDeviceId();
  WidgetsFlutterBinding.ensureInitialized(); // 🔑 필수 초기화
  await initializeDateFormatting();

  await DeviceIdManager.sendDeviceIdToServer(); // UUID 서버 전송
  await DeviceIdManager.printDeviceId(); // UUID 콘솔 출력

  runApp(const MyApp());
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
