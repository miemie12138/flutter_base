abstract class BaseReqModel {
  String? service;
  String? requestNo;
  String? version;
  String? partnerId;
  String? userId;

  BaseReqModel();

  Map<String, dynamic> toJson() => {
        if (service != null) "service": service,
        if (requestNo != null) "requestNo": requestNo,
        if (version != null) "version": version,
        if (partnerId != null) "partnerId": partnerId,
        if (userId != null) "userId": userId,
      };
}

abstract class BasePageReqModel extends BaseReqModel {
  int? start; // 分页页号	N	可选	否	默认为：1，表示获取那页数据，页号默认为1，调用端可以根据第一次返回信息中的pageSize字段计算下次访问的页号。	1
  int? limit; // 分页大小	N	可选	否	默认为：20，表示返回的一页数据条数	20

  BasePageReqModel();

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        if (start != null) "start": start,
        if (limit != null) "limit": limit,
      };
}
