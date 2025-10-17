import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

extension MyDateTime on DateTime {
  ///格式化时间戳
  String formart({String format = "yyyy-MM-dd"}) {
    return DateFormat(format).format(this);
  }
}

extension MyString on String {
  /// AES 密码加密
  String passwordEncrypt(String str) {
    final key = encrypt.Key.fromUtf8(str.substring(0, 16));
    // final iv = encrypt.IV.fromLength(16);

    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ecb));
    return encrypter.encrypt(this).base64;
  }

  /// AES 密码解密
  String passwordDecrypt(String str) {
    final key = encrypt.Key.fromUtf8(str.substring(0, 16));
    final iv = encrypt.IV.fromLength(16);

    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ecb, padding: null));
    return encrypter.decrypt(encrypt.Encrypted.fromBase64(this), iv: iv);
  }

  /// stringt转datetime
  DateTime toDateTime() {
    return DateTime.tryParse(this) ?? DateTime.now();
  }

  /// 可以解决换行问题
  String joinZeroWidthSpace() {
    return characters.join('\u{200B}');
  }

  /// 转换成base64
  String toBase64() {
    return utf8.fuse(base64).encode(this);
  }

  /// 从base64转换回来
  static String fromBase64(String base64String) {
    return utf8.fuse(base64).decode(base64String);
  }
}

extension MyInt on int {
  // int转时间
  DateTime get toDateTime => DateTime.fromMillisecondsSinceEpoch(this);
}
