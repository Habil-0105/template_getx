import 'package:dio/dio.dart';
import 'package:get/get.dart' as controller;
import 'package:template_getx/features/auth/presentation/pages/login_page.dart';
import 'package:template_getx/shared/services/local/local_storage.dart';
import 'package:template_getx/shared/utils/constants/api_constant.dart';

///Interceptor for debugging
class HandlingInterceptor extends QueuedInterceptor {
  final _storage = LocalStorage.instance;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler)async{
    // TODO: implement onRequest
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler)async{
    if(err.response?.statusCode == null){
      print("Sorry, unable to connect to server. Please check your internet connection.");
    }else{
      if(err.response?.statusCode == 401){
        final token = await _storage.token;

        if(token.isEmpty){
          print(err.response?.data[ApiConstant.error] ?? "An error occurred. Please try again later.Code : ${err.response?.statusCode}.");
        }else{
          print("The session is over. Please log in again");
          controller.Get.to(() => const LoginPage());
        }
      }else{
        if((err.response?.data ?? '').toString().contains('<!DOCTYPE html>')){
          print("An error occurred. Please try again later.Code : ${err.response?.statusCode}.");
        }else{
          print(err.response?.data[ApiConstant.error] ?? "An error occurred. Please try again later.Code : ${err.response?.statusCode}.");
        }
      }
    }

    super.onError(err, handler);
  }
}
