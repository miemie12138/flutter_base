import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../model/base_req_model.dart';
import 'my_http.dart';
import 'my_http_error.dart';
import 'my_http_response.dart';

class HttpServices {
  HttpServices._();

  static String _accessKey = "";
  static String _secretKey = "";
  static String _partnerId = "";

  static init({required String accessKey, required String secretKey, required String partnerId}) {
    _accessKey = accessKey;
    _secretKey = secretKey;
    _partnerId = partnerId;
  }

  static ValueGetter<String>? getToken;
  static ValueGetter<String>? getPartnerId;
  static ValueGetter<String>? getAccessKey;
  static ValueGetter<String>? getSecretKey;

  ///  post 操作
  static Future<MyHttpResponse<T>> post<T>({
    String? service,
    dynamic data,
    dynamic extra,
    CancelToken? cancelToken,
    bool hideToast = false,
    bool hideErrorToast = false,
  }) async {
    if (data is BaseReqModel || data is! Map) {
      data = data?.toJson() ?? {};
    } else {
      data = data;
    }

    final commonData = {
      "service": service,
      "requestNo": DateTime.now().microsecondsSinceEpoch.toString(),
      "version": "1.0",
      "partnerId": getPartnerId?.call() ?? _partnerId,
    };
    // 加token
    final token = (getToken?.call() ?? "");
    if (token.isNotEmpty) {
      commonData["token"] = token;
    }

    final reqData = {...commonData, ...data};
    final sign = _getSign(reqData, getSecretKey?.call() ?? _secretKey);

    final headers = {
      "x-api-sign": sign,
      "x-api-accessKey": getAccessKey?.call() ?? _accessKey,
      "x-api-signType": "MD5",
    };

    final response = await MyHttp.request<T>(
      "",
      MyHttpType.post,
      data: reqData,
      headers: headers,
      hideToast: hideToast,
      hideErrorToast: hideErrorToast,
      extra: extra,
      cancelToken: cancelToken,
    );

    if (response.success) return response;

    /// 取detail 展示给用户
    final error = MyHttpError(code: response.code, message: response.detail);
    MyHttp.onError?.call(error);
    throw error;
  }

  // 签名
  static _getSign(dynamic data, String secretKey) {
    final waitForSignString = jsonEncode(data);
    final signString = waitForSignString + secretKey;
    return md5.convert(utf8.encode(signString)).toString();
  }
}
