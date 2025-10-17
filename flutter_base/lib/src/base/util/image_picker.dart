import 'package:image_picker/image_picker.dart';

// 图片选择
class MyImagePicker {
  MyImagePicker._();

  /// 图片选择-相机
  static Future<String> camera({double maxSize = 1200}) async {
    final res = await ImagePicker().pickImage(source: ImageSource.camera, maxWidth: maxSize, imageQuality: 80);
    if (res == null) return "";
    return res.path;
  }

  /// 图片选择-相册
  static Future<String> gallery({double maxSize = 1200}) async {
    final res = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: maxSize, imageQuality: 80);
    if (res == null) return "";
    return res.path;
  }
}
