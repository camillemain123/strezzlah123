import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class AppKeys {
  static const String geminiApiKey = 'AIzaSyBdMBCu6tYDcS0Zhq9tKjdZdwZcGBtZX-0';
}


class AppConfig {
  static String get apiBaseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000'; // Web uses actual localhost
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000'; // Android emulator maps localhost to 10.0.2.2
    } else {
      return 'http://localhost:5000'; // iOS simulator or others
    }
  }
}
