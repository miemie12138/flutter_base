import 'my_refresh_list_widget.dart';

class MyRefreshListViewModel<T> extends BaseRefreshListViewModel<T> {
  @override
  int get pageSize => 20;

  @override
  Map<String, dynamic> get pageParams => {"start": page, "limit": pageSize};
}
