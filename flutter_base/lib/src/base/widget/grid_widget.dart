import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GridItemModel {
  dynamic id;

  /// 图标
  String? icon;

  /// 标题
  String? label;

  /// 描述
  String? description;

  /// 提醒数字
  String? badget;

  GridItemModel(
      {this.id, this.icon, this.label, this.description, this.badget});
}

///
/// Grid 组件
///
// Usage:
// GridWidget(
//   crossAxisCount: 3,
//   border: Border.all(color: const Color(0xFFDDDDDD)),
//   children: [
//     GridItemWidget(
//       icon: 'images/shop/order2.png',
//       iconSize: 48,
//       label: '设置1',
//       badget: '100',
//     )
//   ],
// )
// or
// GridWidget(
//   crossAxisCount: 3,
//   border: Border.all(color: const Color(0xFFDDDDDD)),
//   children: [
//     GridItemWidget(
//       icon: 'images/shop/order2.png',
//       iconSize: 48,
//       label: '设置1',
//       badget: '100',
//     )
//   ],
// )
///
class GridWidget extends StatelessWidget {
  /// 边框
  final Decoration? decoration;

  /// 每个item的高度
  final double? itemHeight;

  /// 每个item的图标大小
  final double? itemIconSize;

  /// 每个item边框
  final Border? border;

  /// 每行的列数
  final int crossAxisCount;

  /// 数据
  ///
  /// 和 children 二选一，同时传入的时候使用 children
  final List<GridItemModel>? items;

  /// 子控件
  ///
  /// 和 items 二选一，同时传入的时候使用 children
  final List<Widget>? children;

  /// 点击事件
  final Function(int index)? onItemTap;

  const GridWidget({
    super.key,
    required this.crossAxisCount,
    this.items,
    this.children,
    this.decoration,
    this.itemIconSize = 48,
    this.itemHeight = 100,
    this.border,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    assert(crossAxisCount > 0);
    assert(children != null || items != null);
    return Container(
      decoration: decoration,
      child: StaggeredGrid.count(
        crossAxisCount: crossAxisCount,
        children: [
          ..._createList(),
        ],
      ),
    );
  }

  List<Widget> _createList() {
    List<Widget> list = [];
    for (int i = 0; i < (children?.length ?? items?.length ?? 0); i++) {
      list.add(_createItem(i));
    }
    return list;
  }

  Widget _createItem(int index) {
    final int itemCount = children?.length ?? items?.length ?? 0;
    final int colCount = crossAxisCount;
    final int col = index % colCount;
    final int rowCount = itemCount ~/ colCount + 1;
    final int row = index ~/ colCount;
    debugPrint(
        'rowCount: $rowCount, row: $row, colCount: $colCount, col: $col');
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onItemTap?.call(index),
      child: Container(
        height: itemHeight,
        decoration: BoxDecoration(
          border: Border(
            left: col != colCount
                ? border?.left ?? BorderSide.none
                : BorderSide.none,
            top: row < rowCount
                ? border?.top ?? BorderSide.none
                : BorderSide.none,
            right: col == colCount - 1 || col == itemCount - 1
                ? border?.right ?? BorderSide.none
                : BorderSide.none,
            bottom: row >= rowCount - 1
                ? border?.bottom ?? BorderSide.none
                : BorderSide.none,
          ),
        ),
        child: children != null ? _createItem1(index) : _createItem2(index),
      ),
    );
  }

  Widget _createItem1(int index) {
    return children![index];
  }

  Widget _createItem2(int index) {
    return GridItemWidget(
      icon: items![index].icon,
      iconSize: itemIconSize,
      label: items![index].label,
      description: items![index].description,
      badget: items![index].badget,
    );
  }
}

class GridItemWidget extends StatelessWidget {
  /// 背景色
  final Color? color;

  /// 边框
  final BoxBorder? border;

  /// 高度
  final double? height;

  /// 图标
  final String? icon;

  /// 图标大小
  final double? iconSize;

  /// 图标Widget
  final Widget? iconWidget;

  /// 图标和标题之间的间距
  final double? iconSpaceHeight;

  /// 标题
  final String? label;

  /// 标题样式
  final TextStyle? labelStyle;

  /// 标题Widget
  final Widget? labelWidget;

  /// 描述和标题之间的间距
  final double? descriptionSpaceHeight;

  /// 描述
  final String? description;

  /// 描述样式
  final TextStyle? descriptionStyle;

  /// 描述Widget
  final Widget? descriptionWidget;

  /// 提醒数字的偏移量
  final Offset? badgetOffset;

  /// 提醒数字
  final String? badget;

  /// 提醒数字样式
  final TextStyle? badgetStyle;

  /// 提醒数字Widget
  final Widget? badgetWidget;

  const GridItemWidget({
    super.key,
    this.color,
    this.border,
    this.height,
    this.icon,
    this.iconSize = 24,
    this.iconWidget,
    this.iconSpaceHeight = 0,
    this.label,
    this.labelStyle,
    this.labelWidget,
    this.descriptionSpaceHeight = 0,
    this.description,
    this.descriptionStyle,
    this.descriptionWidget,
    this.badgetOffset = const Offset(-20, 20),
    this.badget,
    this.badgetStyle,
    this.badgetWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        border: border,
      ),
      height: height,
      child: Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                iconWidget != null
                    ? iconWidget!
                    : icon?.isNotEmpty == true
                        ? Image.asset(
                            icon!,
                            width: iconSize,
                            height: iconSize,
                          )
                        : Container(),
                if (iconWidget != null || icon?.isNotEmpty == true)
                  SizedBox(height: iconSpaceHeight),
                labelWidget != null
                    ? labelWidget!
                    : label?.isNotEmpty == true
                        ? Text(
                            label!,
                            style: labelStyle ??
                                Theme.of(context).textTheme.labelLarge,
                          )
                        : Container(),
                if (descriptionWidget != null ||
                    description?.isNotEmpty == true)
                  SizedBox(height: descriptionSpaceHeight),
                descriptionWidget != null
                    ? descriptionWidget!
                    : description?.isNotEmpty == true
                        ? Text(
                            description!,
                            style: descriptionStyle ??
                                Theme.of(context).textTheme.labelSmall,
                          )
                        : Container(),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Transform.translate(
              offset: badgetOffset ?? Offset.zero,
              child: Center(
                child: badgetWidget != null
                    ? badgetWidget!
                    : badget?.isNotEmpty == true
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            child: Text(
                              badget!,
                              style: badgetStyle ??
                                  Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(color: Colors.white),
                            ),
                          )
                        : Container(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
