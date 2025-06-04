import 'package:flutter/material.dart';
import '../../../core/components/network_image.dart';
import '../../../core/constants/constants.dart';
import 'profile_header_options.dart';
import 'package:shared_preferences/shared_preferences.dart'; // shared_preferences 패키지 추가
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../../utils/device_id_manager.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  String? deviceId;

  @override
  void initState() {
    super.initState();
    _loadDeviceId();
  }

  // deviceId를 비동기적으로 로드하는 메서드
  Future<void> _loadDeviceId() async {
    final String id = await DeviceIdManager.getOrCreateDeviceId();
    setState(() {
      deviceId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background
        // Image.asset('assets/images/profile_page_background.png'),

        // Content
        Column(
          children: [
            AppBar(
              title: const Text('내 정보'),
              elevation: 0,
              backgroundColor: Colors.transparent,
              titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            _UserData(deviceId: deviceId),
          ],
        ),
      ],
    );
  }
}

class _UserData extends StatelessWidget {
  final String? deviceId;

  const _UserData({super.key, this.deviceId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Row(
        children: [
          const SizedBox(width: AppDefaults.padding),
          const SizedBox(
            width: 100,
            height: 100,
            child: ClipOval(
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child:
                    NetworkImageWithLoader('https://i.imgur.com/DK2IBDi.png'),
              ),
            ),
          ),
          const SizedBox(width: AppDefaults.padding),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    (deviceId != null && deviceId!.length >= 4
                        ? deviceId!.substring(deviceId!.length - 4)
                        : '익명'), // 마지막 4글자
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                  ),
                  Text(
                    '님',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '오늘 하루는 어떠셨나요? ',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
