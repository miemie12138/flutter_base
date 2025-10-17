import 'package:flutter/material.dart';

class ListItemModel {
  /// 可选id
  dynamic id;

  /// 图标：本地图片
  String? icon;

  /// 标题
  String? title;

  /// 副标题
  String? subTitle;

  /// 右边文字
  String? trailing;

  /// 是否显示箭头
  bool? isShowArrow;

  ListItemModel({
    this.id,
    this.title,
    this.icon,
    this.subTitle,
    this.trailing,
    this.isShowArrow = true,
  });
}

///
/// 列表菜单组件
///
/// usage:
///
/// ListItemContainerWidget(
///   color: Colors.white,
///   items: [
///     ListItemModel(title: '1122', subTitle: '我是描述', trailing: '3344'),
///     ListItemModel(title: '1122', subTitle: '我是描述'),
///     ListItemModel(title: '1122', isShowArrow: false),
///   ],
/// ),
/// const SizedBox(height: 20),
/// ListItemContainerWidget(
///   color: Colors.white,
///   items: [
///     ListItemModel(icon: 'images/shop/order1.png', title: '2211', trailing: '4433'),
///     ListItemModel(icon: 'images/shop/order2.png', title: '2211', trailing: '4433'),
///   ],
/// ),
/// const SizedBox(height: 20),
/// ListItemContainerWidget(
///   color: Colors.white,
///   children: [
///     ListItemWidget(title: '1122', trailing: '3344'),
///     ListItemWidget(titleWidget: Text('Bold', style: TextStyle(fontWeight: FontWeight.bold))),
///   ],
/// )
class ListItemContainerWidget extends StatelessWidget {
  /// 间距
  final EdgeInsetsGeometry? padding;

  /// 背景色
  final Color? color;

  /// 背景
  final Decoration? decoration;

  /// 子组件
  ///
  /// 和 items 二选一
  final List<Widget>? children;

  /// 数据
  ///
  /// 和 children 二选一
  ///
  /// 如果设置的是 children 而非 items 则自行在 children中进行样式设置
  final List<ListItemModel>? items;

  /// 左边图标大小
  final double? iconSize;

  /// 标题样式
  final TextStyle? titleTextStyle;

  /// 副标题样式
  final TextStyle? subTitleTextStyle;

  /// 尾部样式
  final TextStyle? trailingTextStyle;

  /// 箭头
  final Widget? arrowIcon;

  /// 分割线高度
  final double? itemSperatorExtent;

  /// 分割线颜色
  final Color? itemSperatorColor;

  /// 点击事件
  final Function(int index)? onItemTap;

  const ListItemContainerWidget({
    super.key,
    this.children,
    this.items,
    this.padding,
    this.color,
    this.decoration,
    this.iconSize = 20,
    this.titleTextStyle = const TextStyle(
      fontSize: 14,
      color: Color(0xFF333333),
    ),
    this.subTitleTextStyle = const TextStyle(
      fontSize: 10,
      color: Color(0xFF999999),
    ),
    this.trailingTextStyle = const TextStyle(
      fontSize: 12,
      color: Color(0xFF666666),
    ),
    this.arrowIcon = const Icon(
      Icons.arrow_forward_ios,
      size: 12,
      color: Color(0xFFCCCCCC),
    ),
    this.itemSperatorExtent = 0.5,
    this.itemSperatorColor = const Color(0xFFCCCCCC),
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      decoration: decoration,
      padding: padding,
      child: Column(
        children: [
          if (children != null) ...[
            Container(
              height: itemSperatorExtent,
              color: itemSperatorColor,
            ),
            for (var i = 0; i < children!.length; i++) ...[
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  onItemTap?.call(i);
                },
                child: children![i],
              ),
              if (i < children!.length - 1)
                Container(
                  height: itemSperatorExtent,
                  color: itemSperatorColor,
                ),
            ],
            Container(
              height: itemSperatorExtent,
              color: itemSperatorColor,
            ),
          ],
          if (items != null) ...[
            Container(
              height: itemSperatorExtent,
              color: itemSperatorColor,
            ),
            for (var i = 0; i < items!.length; i++) ...[
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  onItemTap?.call(i);
                },
                child: ListItemWidget(
                  icon: items![i].icon != null
                      ? ImageIcon(
                          AssetImage(items![i].icon!),
                          size: iconSize,
                        )
                      : null,
                  titleWidget: items![i].title != null ? Text(items![i].title ?? '', style: titleTextStyle) : null,
                  subTitleWidget:
                      items![i].subTitle != null ? Text(items![i].subTitle ?? '', style: subTitleTextStyle) : null,
                  trailingWidget:
                      items![i].trailing != null ? Text(items![i].trailing ?? '', style: trailingTextStyle) : null,
                  arrowWidget: items![i].isShowArrow == true ? arrowIcon : null,
                ),
              ),
              if (i < items!.length - 1)
                Container(
                  margin: const EdgeInsets.only(left: 16),
                  height: itemSperatorExtent,
                  color: itemSperatorColor,
                ),
            ],
            Container(
              height: itemSperatorExtent,
              color: itemSperatorColor,
            ),
          ],
        ],
      ),
    );
  }
}

class ListItemWidget extends StatelessWidget {
  /// 整体上下左右间距
  final EdgeInsetsGeometry? padding;

  /// 背景色
  final Color? color;

  /// 背景图
  final Decoration? decoration;

  /// item上下左右间距：horizontal 控制组件之间的水平间距，vertical 控制组件之间的垂直间距
  final EdgeInsetsGeometry? itemPadding;

  /// 图标
  final Widget? iconWidget;

  /// 图标
  final Widget? icon;

  /// 标题
  final Widget? titleWidget;

  /// 标题
  final String? title;

  /// 副标题
  final Widget? subTitleWidget;

  /// 副标题
  final String? subTitle;

  /// 尾部
  final Widget? trailingWidget;
  final String? trailing;

  /// 箭头
  final Widget? arrowWidget;

  const ListItemWidget({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    this.color,
    this.decoration,
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 2.5, vertical: 1),
    this.iconWidget,
    this.icon,
    this.titleWidget,
    this.title,
    this.subTitleWidget,
    this.subTitle,
    this.trailingWidget,
    this.trailing,
    this.arrowWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      decoration: decoration,
      padding: padding,
      child: Row(
        children: [
          if (iconWidget != null || icon != null) ...[
            Container(
              child: iconWidget ?? icon,
            ),
            SizedBox(width: itemPadding?.horizontal ?? 0),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (titleWidget != null || title != null) ...[
                  Container(
                    child: titleWidget ?? Text(title ?? ''),
                  ),
                ],
                if (subTitleWidget != null || subTitle != null) ...[
                  SizedBox(height: itemPadding?.vertical ?? 0),
                  Container(
                    child: subTitleWidget ?? Text(subTitle ?? ''),
                  ),
                ],
              ],
            ),
          ),
          if (trailingWidget != null || trailing != null) ...[
            SizedBox(width: itemPadding?.horizontal ?? 0),
            Container(
              child: trailingWidget ?? Text(trailing ?? ''),
            ),
          ],
          if (arrowWidget != null) ...[
            SizedBox(width: itemPadding?.horizontal ?? 0),
            arrowWidget!,
          ],
        ],
      ),
    );
  }
}
