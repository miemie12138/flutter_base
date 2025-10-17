import 'dart:math';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

const bool isProduct = bool.fromEnvironment("dart.vm.product");
// 开发环境
const bool isDebug = !isProduct;

// debug模式下才打印
printDebug(Object? object) {
  if (isDebug) {
    // ignore: avoid_print
    print(object);
  }
}

// 随机颜色
Color randomColor() {
  final r = Random();
  return Color.fromARGB(255, r.nextInt(36) + 220, r.nextInt(36) + 220, r.nextInt(36) + 220);
}

// 随机深颜色
Color randomAccentColor() {
  final r = Random();
  return Color.fromARGB(255, r.nextInt(36) + 180, r.nextInt(36) + 180, r.nextInt(36) + 180);
}

// 随机固定颜色
Color randomSeedColor(int seed) {
  return Color.fromARGB(
    255,
    Random(seed).nextInt(36) + 220,
    Random(seed + 10).nextInt(36) + 220,
    Random(seed - 10).nextInt(36) + 220,
  );
}

unfocus() {
  WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
}

bool _prevent = false;
// 防抖
bool debounce([int milliseconds = 1000]) {
  if (_prevent) return true;
  _prevent = true;
  Future.delayed(Duration(milliseconds: milliseconds), () {
    _prevent = false;
  });
  return false;
}

///是否第一次
Future<bool> isFirstTime({String key = "default", bool saveStatus = true}) async {
  final prefs = await SharedPreferences.getInstance();
  final keyStr = "isFirest_$key";
  final isFirest = !(prefs.getBool(keyStr) ?? false);
  if (saveStatus) prefs.setBool(keyStr, true);
  return isFirest;
}
