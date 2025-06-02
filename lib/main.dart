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
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  runApp(const MyApp());

  // runApp 이후 백그라운드로 비동기 작업
  DeviceIdManager.sendDeviceIdToServer();
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

      // 메인페이지 경로
      // initialRoute: AppRoutes.entryPoint,

      // 테스트용 작업중
      initialRoute: AppRoutes.colab_test2,
    );
  }
}
