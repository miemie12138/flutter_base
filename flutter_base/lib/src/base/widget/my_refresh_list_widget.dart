import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import 'my_status_widget.dart';
import 'my_viewmodel_status_widget.dart';

typedef IndexedValueWidgetBuilder<E> = Widget Function(BuildContext context, int index, E value);

///
/// 分页加载 ViewModel 基类，封装了一些便捷操作和分页数据
///
/// usage:
///
/// class YourViewModel<dynamic> extends BaseRefreshListViewModel<dynamic> {
///   @override
///   loadData([bool refresh = true]) {
///     super.loadData(refresh); // 记得调用父类的方法重置分页页码
///     // ... your code
///   }
/// }
///
class BaseRefreshListViewModel<T> extends BaseViewModel {
  /// 设置多少条以内就不显示 "没有更多数据了"
  int? completeDataCount;

  /// 分页开始页码
  static int pageStartAt = 1;

  RefreshController refreshController = RefreshController();

  /// 分页页码
  int _page = pageStartAt;
  int get page => _page;

  /// 分页大小
  int pageSize = 20;

  /// 列表数据集
  List<T> data = [];

  /// 标记data列表需要更新
  bool dataShouldRebuild = false;

  /// 获取分页参数
  ///
  /// [return] {"page": page, "size": pageSize}
  Map<String, dynamic> get pageParams {
    return {"page": page, "size": pageSize};
  }

  BaseRefreshListViewModel({this.completeDataCount});

  /// 加载数据
  ///
  /// [refresh] 是否刷新：true-会重置分页页码
  ///
  /// *覆盖此方法时，注意调用`super.loadData()`*
  ///
  loadData([bool refresh = true]) {
    if (refresh) _page = pageStartAt;
  }

  /// 通知界面更新
  notifyDataListener() {
    dataShouldRebuild = true;
    notifyListeners();
  }

  /// 更新数据集
  ///
  /// [refresh] 是否刷新：true-会清空数据，false-会累加数据
  /// [value] 数据集
  /// [error] 是否出错：true-如果是没有数据的情况下，会显示 networkError
  ///
  /// 会自动设置分页页码，无需手动控制
  setupData({bool refresh = true, List<T>? value, bool error = false}) {
    if (page == pageStartAt && completeDataCount != null && value != null && value.length < completeDataCount!) {
      refresh = true;
    }

    if (refresh) {
      // 是刷新
      _page = pageStartAt;
      data = [];
      refreshController.resetNoData();
      if (value != null && value.isNotEmpty) {
        data = value;
      }
      if (!error) {
        refreshController.refreshCompleted();
        status = data.isEmpty ? MyStatusEnum.emptyData : MyStatusEnum.normal;
      } else {
        refreshController.refreshFailed();
        if (data.isEmpty) {
          status = MyStatusEnum.networkError;
        }
      }
      notifyListeners();
    } else {
      // 加载更多
      if (value != null && value.isNotEmpty) {
        data = data + value;
        notifyListeners();
      }
      if (!error) {
        refreshController.loadComplete();
      } else {
        refreshController.loadFailed();
      }
    }

    // 不管是否刷新都要做的操作
    // 5. 处理是否可以加载更多
    if (value != null && value.length < pageSize) {
      if (completeDataCount != null && data.length < completeDataCount!) {
        refreshController.loadComplete();
      } else {
        refreshController.loadNoData();
      }
    }
    if (!error) {
      if (completeDataCount != null && data.length < completeDataCount!) {
      } else {
        _page++;
      }
    }
  }
}

///
/// 分页加载列表基类
///
///
class BaseRefreshListWidget<T extends BaseRefreshListViewModel, E> extends StatelessWidget {
  static Widget? defaultHeader;
  static Widget? defaultFooter;

  const BaseRefreshListWidget({
    Key? key,
    required this.itemBuilder,
    this.separatorBuilder,
    this.loading,
    this.emptyData,
    this.networkError,
    this.other,
    this.onTap,
    this.enablePullDown = true,
    this.enablePullUp = false,
    this.itemExtent,
    this.padding,
    this.refreshHeader,
    this.refreshFooter,
    this.scrollController,
  }) : super(key: key);

  /// 通过itemBuilder构建列表项
  final IndexedValueWidgetBuilder<E> itemBuilder;

  /// 通过separatorBuilder构建列表分割项
  ///
  /// 会出现在item之间
  final IndexedWidgetBuilder? separatorBuilder;

  /// 是否允许下拉刷新
  final bool enablePullDown;

  /// 是否允许上拉加载更多
  final bool enablePullUp;

  /// 加载中 view
  final MyWidgetBuilder? loading;

  /// 空数据 view
  final MyWidgetBuilder? emptyData;

  /// 网络错误 view
  final MyWidgetBuilder? networkError;

  /// 其他状态 view
  final MyWidgetBuilder? other;

  /// 点击事件：用于处理网络错误、空数据、其他状态的点击事件
  final ValueChanged<MyStatusEnum>? onTap;

  /// item 高度
  final double? itemExtent;

  /// 列表内边距
  final EdgeInsetsGeometry? padding;

  /// 刷新表头
  final Widget? refreshHeader;

  /// 刷新表尾
  final Widget? refreshFooter;

  /// 监听滑动的高度
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<T>(context, listen: false);

    return BaseViewModelStatusWidget<T>(
        loading: loading,
        emptyData: emptyData,
        networkError: networkError,
        other: other,
        onTap: onTap,
        builder: (context) {
          return Selector<T, List>(
            shouldRebuild: (o1, o2) {
              if (viewModel.dataShouldRebuild) {
                viewModel.dataShouldRebuild = false;
                return true;
              }
              return o1 != o2;
            },
            selector: (_, vm) => vm.data,
            builder: (context, data, _) {
              return SmartRefresher(
                onRefresh: () => viewModel.loadData(true),
                onLoading: () => viewModel.loadData(false),
                controller: viewModel.refreshController,
                enablePullUp: enablePullUp,
                header: refreshHeader ?? defaultHeader,
                footer: refreshFooter ?? defaultFooter,
                child: (separatorBuilder == null)
                    ? ListView.builder(
                        controller: scrollController,
                        itemExtent: itemExtent,
                        padding: padding,
                        itemCount: data.length,
                        itemBuilder: (context, index) => itemBuilder(context, index, data[index]),
                      )
                    : ListView.separated(
                        controller: scrollController,
                        padding: padding,
                        itemCount: data.length,
                        itemBuilder: (context, index) => itemBuilder(context, index, data[index]),
                        separatorBuilder: separatorBuilder!,
                      ),
              );
            },
          );
        });
  }
}
