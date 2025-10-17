import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// 网络图片加载
class MyNetworkImage extends StatelessWidget {
  final String url;

  final double? height;
  final double? width;
  final BoxFit? fit;
  final int? memCacheHeight;
  final int? memCacheWidth;

  const MyNetworkImage(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.memCacheHeight,
    this.memCacheWidth,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: fit,
      memCacheHeight: memCacheHeight,
      memCacheWidth: memCacheWidth,
      fadeInDuration: const Duration(milliseconds: 300),
      placeholder: (context, _) {
        return Container(color: Colors.grey[100]);
      },
      errorWidget: (context, url, error) {
        return Container(
          color: Colors.red[100],
          alignment: Alignment.center,
          child: Text("图片无法访问", style: Theme.of(context).textTheme.bodySmall),
        );
      },
    );
  }
}
