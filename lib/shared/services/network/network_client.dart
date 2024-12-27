import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:template_getx/main.dart';
import 'package:template_getx/shared/services/network/api_response.dart';
import 'package:template_getx/shared/services/network/interceptors/handling_interceptor.dart';
import 'package:template_getx/shared/services/network/interceptors/token_interceptor.dart';
import 'package:template_getx/shared/services/network/pagination_responce.dart';
import 'package:template_getx/shared/services/network/url.dart';
import 'package:template_getx/shared/utils/constants/api_constant.dart';

class NetworkClient {
  //Dio instance
  final Dio _dio;

  //Cancel token
  final CancelToken _cancelToken;

  //Network client constructor
  NetworkClient()
      : _dio = Dio(BaseOptions(baseUrl: Url.baseURL)),
        _cancelToken = CancelToken() {
    // if (interceptors != null) _dio.interceptors.addAll(interceptors);
    _dio.interceptors.addAll([
      alice.getDioInterceptor(),
      PrettyDioLogger(requestBody: true, requestHeader: true),
      TokenInterceptor(),
      HandlingInterceptor()
    ]);
  }

  void cancelRequests({CancelToken? cancelToken}) {
    if (cancelToken == null) {
      _cancelToken.cancel('Cancelled');
    } else {
      cancelToken.cancel();
    }
  }

  /// HTTP Methods `GET`
  ///
  /// This methods return `Response` from [Dio]
  ///
  /// Keep [Dio] instance isolated from other layers
  Future<Response> get({
    required String endpoint,
    Map<String,dynamic>? queryParams,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get(endpoint,
        queryParameters: queryParams,
        options: options,
        cancelToken: cancelToken);
    return response;
  }

  /// HTTP Methods `POST`
  ///
  /// Add new [data] to database
  ///
  /// This methods will send [data] to backend
  ///
  /// Keep [Dio] instance isolated from other layers
  Future<Response> post({
    required String endpoint,
    Map<String,dynamic>? queryParams,
    Object? data,
    Options? options,
    void Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.post(endpoint,
        queryParameters: queryParams,
        data: data,
        options: options,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken);
    return response;
  }

  /// HTTP Methods `PUT`
  ///
  /// This methods will send [data] to backend
  ///
  /// Keep [Dio] instance isolated from other layers
  Future<Response> put({
    required String endpoint,
    Map<String,dynamic>? queryParams,
    Object? data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.put(endpoint,
        queryParameters: queryParams,
        data: data,
        options: options,
        cancelToken: cancelToken);
    return response;
  }

  /// HTTP Methods `DELETE`
  ///
  /// This methods will delete [data]
  ///
  /// Keep [Dio] instance isolated from other layers
  Future<Response> delete({
    required String endpoint,
    Object? data,
    Map<String,dynamic>? queryParams,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.delete(endpoint,
        data: data,
        queryParameters: queryParams,
        options: options,
        cancelToken: cancelToken);
    return response;
  }

  /// ApiResponse errorParser. This method
  /// will parse error based on DioExceptionType
  ///
  /// Will return [ApiResponse]
  Future<ApiResponse<T>> errorParser<T>({DioException? e}) {
    ApiResponse<T> result = ApiResponse<T>(
      code: 400,
      message: '',
      error: true,
    );

    if(e == null){
      return Future(() => result);
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        result = result.copyWith(message: 'Connection Timeout', code: e.response?.statusCode ?? 408,);
        break;
      case DioExceptionType.sendTimeout:
        result = result.copyWith(message: 'Send Connection Timeout', code: e.response?.statusCode ?? 408);
        break;
      case DioExceptionType.receiveTimeout:
        result = result.copyWith(message: 'Receive Connection Timeout', code: e.response?.statusCode ?? 408);
        break;
      case DioExceptionType.badCertificate:
        result = result.copyWith(message: 'Bad certificate', code: e.response?.statusCode ?? 403);
        break;
      case DioExceptionType.badResponse:
        result = result.copyWith(message: e.response!.data.toString().contains('<!DOCTYPE html>') ? 'Bad Response' : e.response?.data[ApiConstant.message] ?? 'Bad Response', code: e.response?.statusCode ?? 400);
        break;
      case DioExceptionType.cancel:
        result = result.copyWith(message: 'Request cancelled', code: e.response?.statusCode ?? 500);
        break;
      case DioExceptionType.connectionError:
        result = result.copyWith(message: 'No Internet connection', code: e.response?.statusCode ?? 408);
        break;
      case DioExceptionType.unknown:
        result = result.copyWith(message: e.response?.data[ApiConstant.message] ?? 'Can not connect to server', code: e.response?.statusCode ?? 500);
        break;
    }

    return Future(() => result);
  }

  /// PaginationResponse errorParser. This method
  /// will parse error based on DioExceptionType
  ///
  /// Will return [PaginationResponse]
  Future<PaginationResponse<T>> errorParserPagination<T>(DioException e) {
    PaginationResponse<T> result = PaginationResponse<T>(
      lastPage: 1,
      code: 400,
      message: '',
      error: true,
    );

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        result = result.copyWith(message: 'Connection Timeout', code: e.response?.statusCode ?? 408,);
        break;
      case DioExceptionType.sendTimeout:
        result = result.copyWith(message: 'Send Connection Timeout', code: e.response?.statusCode ?? 408);
        break;
      case DioExceptionType.receiveTimeout:
        result = result.copyWith(message: 'Receive Connection Timeout', code: e.response?.statusCode ?? 408);
        break;
      case DioExceptionType.badCertificate:
        result = result.copyWith(message: 'Bad certificate', code: e.response?.statusCode ?? 403);
        break;
      case DioExceptionType.badResponse:
        result = result.copyWith(message: e.response!.data.toString().contains('<!DOCTYPE html>') ? 'Bad Response' : e.response?.data[ApiConstant.message] ?? 'Bad Response', code: e.response?.statusCode ?? 400);
        break;
      case DioExceptionType.cancel:
        result = result.copyWith(message: 'Request cancelled', code: e.response?.statusCode ?? 500);
        break;
      case DioExceptionType.connectionError:
        result = result.copyWith(message: 'No Internet connection', code: e.response?.statusCode ?? 408);
        break;
      case DioExceptionType.unknown:
        result = result.copyWith(message: e.response?.data[ApiConstant.message] ?? 'Can not connect to server', code: e.response?.statusCode ?? 500);
        break;
    }

    return Future(() => result);
  }
}