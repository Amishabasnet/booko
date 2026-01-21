import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const bool isPhysicalDevice = false;

  static const String comIpAddress = "192.168.1.1";

  static String get baseUrl {
    if (isPhysicalDevice) {
      return 'http://$comIpAddress:3000/api/v1';
    }
    if (kIsWeb) {
      return 'http://localhost:3000/api/v1';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000/api/v1';
    } else if (Platform.isIOS) {
      return 'http://localhost:3000/api/v1';
    } else {
      return 'http://localhost:3000/api/v1';
    }
  }

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String userRegister = '/users';
  static const String userLogin = '/users/login';
}
