import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:template_getx/shared/services/local/local_storage.dart';
import 'package:template_getx/shared/services/network/url.dart';
import 'package:template_getx/shared/utils/constants/api_constant.dart';

/// Interceptor untuk menambahkan token di header sebelum user melakukan request ke API
class TokenInterceptor extends QueuedInterceptor {
  final _storage = LocalStorage.instance;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler)async{
    RequestOptions customOptions = options;

    if (!Url.excludedPath.contains(options.path)) {
      customOptions.headers = {
        HttpHeaders.acceptHeader : ContentType.json,
        HttpHeaders.authorizationHeader : '${ApiConstant.bearer} ${await _storage.token}'
      };

      log(await _storage.token);
    }else{
      customOptions.headers = {
        HttpHeaders.acceptHeader : ContentType.json,
      };
    }

    log(
      customOptions.headers.toString(),
      name: "Headers from TokenInterceptor",
    );
    // handler.next(customOptions);

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // TODO: implement onResponse
    super.onError(err, handler);
  }
}