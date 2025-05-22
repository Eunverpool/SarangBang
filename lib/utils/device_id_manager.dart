import 'package:shared_preferences/shared_preferences.dart'; // shared_preferences 패키지 추가
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class DeviceIdManager {
  static const String _deviceIdKey = 'device_id';

  // 저장된 device ID 불러오기
  static Future<String?> getDeviceId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_deviceIdKey);
  }

  // 새로운 UUID 생성 후 저장
  static Future<String> generateAndSaveDeviceId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const uuid = Uuid();
    //final String deviceId = uuid.v4();
    // 이거 테스트하는동안 uuid-1234로 고정
    const String deviceId = 'uuid-1234';
    await prefs.setString(_deviceIdKey, deviceId);
    return deviceId;
  }

  // 기존 device ID가 없으면 새로 생성해서 반환
  static Future<String> getOrCreateDeviceId() async {
    final String? storedDeviceId = await getDeviceId();
    if (storedDeviceId != null) {
      return storedDeviceId;
    } else {
      return await generateAndSaveDeviceId();
    }
  }

  // 디버그 용도로 device ID 출력
  static Future<void> printDeviceId() async {
    //final String deviceId = await getOrCreateDeviceId();
    const String deviceId = 'uuid-1234';
    print('Device ID: $deviceId');
  }

  // 앱 시작 시 서버로 UUID 전송
  static Future<void> sendDeviceIdToServer() async {
    //final String deviceId = await getOrCreateDeviceId();
    const String deviceId = 'uuid-1234';

    // 서버에 전송할 데이터
    final Map<String, dynamic> data = {
      'user_uuid': deviceId,
      'user_family_email': 'family@example.com', // 예시 이메일
      'user_date':
          DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now().toLocal()),
    };

    // 서버 URL
    const String url = 'http://localhost:3000/users'; // 실제 사용 시 IP로 변경 필요
    // 호식 URL
    //const String url = 'http://192.168.0.13:3000/users';

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
