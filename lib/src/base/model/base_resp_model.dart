abstract class BaseRespModel {}

class PageRespModel<T> {
  late int totalRows; // 总行数	N	必须	否	总行数	200
  late int totalPages; // 总页数	N	必须	否	总行数/页大小	10
  List<T>? rows; // 页数据	A	可选	否	当totalRows大于0时，rows不为空

  PageRespModel({
    required this.totalRows,
    required this.totalPages,
    this.rows,
  });

  PageRespModel.fromJson(Map json, T Function(Map) fromJson) {
    totalRows = json['totalRows'];
    totalPages = json['totalPages'];
    if (json['rows'] != null) {
      rows = [];
      for (var item in json['rows']) {
        rows!.add(fromJson(item));
      }
    }
  }
}
