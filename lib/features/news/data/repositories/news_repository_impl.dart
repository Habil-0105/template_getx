import 'package:dio/dio.dart';
import 'package:template_getx/features/auth/domain/repositories/auth_repository.dart';
import 'package:template_getx/features/news/data/models/news_model.dart';
import 'package:template_getx/features/news/domain/repositories/news_repository.dart';
import 'package:template_getx/shared/services/network/api_response.dart';
import 'package:template_getx/shared/services/network/network_client.dart';
import 'package:template_getx/shared/services/network/pagination_responce.dart';
import 'package:template_getx/shared/services/network/url.dart';
import 'package:template_getx/shared/utils/constants/api_constant.dart';

class NewsRepositoryImpl extends NewsRepository{
  final NetworkClient _client = NetworkClient();

  @override
  Future<ApiResponse<NewsModel>> getDetailNews({required int id})async{
    try{
      final response = await _client.post(endpoint: Url.news(NewsEndpoint.getDetailNews, id: id));

      /// Jika contoh response seperti dibawah, gunakan seperti berikut
      // final example = '''
      //   {
      //       "id": 94,
      //       "title": "Agung",
      //       "subtitle": "Agung",
      //       "author": "Agung",
      //       "created_at": "2024-10-02T09:00:45.000000Z",
      //       "updated_at": "2024-10-02T09:00:45.000000Z"
      //   }
      // ''';
      // final token = response.data;

      /// Jika contoh response seperti dibawah, gunakan seperti berikut
      final example = '''
        {
          data : {
            "id": 94,
            "title": "Agung",
            "subtitle": "Agung",
            "author": "Agung",
            "created_at": "2024-10-02T09:00:45.000000Z",
            "updated_at": "2024-10-02T09:00:45.000000Z"
          }
        }
      ''';
      final news = response.data[ApiConstant.data];

      ApiResponse<NewsModel> result = ApiResponse(
          data: news,
          code: response.statusCode!,
          message: response.data[ApiConstant.message],
          error: false
      );

      return result;
    } on DioException catch(e){
      return _client.errorParser(e: e);
    } catch(e){
      ApiResponse<NewsModel> response = ApiResponse(
          code: 500,
          message: e.toString(),
          error: true
      );

      return response;
    }
  }

  @override
  Future<PaginationResponse<List<NewsModel>>> getAllNews({required int page})async{
    try{
      final response = await _client.get(
          endpoint: Url.news(NewsEndpoint.getAllNews),
          queryParams: {
            ApiConstant.page : page,
          }
      );

    //   work jika mempunyai response yang mirip seperti ini
    //   '''
    //   {
    //     "data": {
    //         "current_page": 1,
    //         "data": [
    //             {
    //                 "id": "5021e788-714d-42bb-b001-ac1bdb837472",
    //                 "type": "App\\Notifications\\GeneralNotification",
    //                 "notifiable_type": "App\\Models\\User",
    //                 "notifiable_id": 345269,
    //                 "data": {
    //                     "title": "PulsaIn : Pesanan - Aktif",
    //                     "body": "Pesanan konversi pulsa Indosat sejumlah Rp. 30,000 telah diaktifkan kembali.",
    //                     "screen": "transaction-489883",
    //                     "category": "order",
    //                     "notifier_name": "Transaction",
    //                     "notifier_id": 489883
    //                 },
    //                 "read_at": "2024-05-31T02:30:12.000000Z",
    //                 "created_at": "2024-03-28T02:31:56.000000Z",
    //                 "updated_at": "2024-05-31T02:30:12.000000Z"
    //             },
    //             {
    //                 "id": "qwe",
    //                 "type": "App\\Notifications\\GeneralNotification",
    //                 "notifiable_type": "App\\Models\\User",
    //                 "notifiable_id": 345269,
    //                 "data": {
    //                     "title": "PulsaIn : Pesanan - Aktif",
    //                     "body": "Pesanan konversi pulsa Indosat sejumlah Rp. 30,000 telah diaktifkan kembali.",
    //                     "screen": "transaction-489883",
    //                     "category": "order",
    //                     "notifier_name": "Transaction",
    //                     "notifier_id": 489883
    //                 },
    //                 "read_at": "2024-05-30T02:43:37.000000Z",
    //                 "created_at": "2024-03-28T02:31:56.000000Z",
    //                 "updated_at": "2024-05-30T02:43:37.000000Z"
    //             },
    //             {
    //                 "id": "qwe-qwe-qwe",
    //                 "type": "App\\Notifications\\GeneralNotification",
    //                 "notifiable_type": "App\\Models\\User",
    //                 "notifiable_id": 345269,
    //                 "data": {
    //                     "title": "PulsaIn : Pesanan - Aktif",
    //                     "body": "Pesanan konversi pulsa Indosat sejumlah Rp. 30,000 telah diaktifkan kembali.",
    //                     "screen": "transaction-489883",
    //                     "category": "order",
    //                     "notifier_name": "Transaction",
    //                     "notifier_id": 489883
    //                 },
    //                 "read_at": "2024-05-30T02:43:37.000000Z",
    //                 "created_at": "2024-03-28T02:31:56.000000Z",
    //                 "updated_at": "2024-05-30T02:43:37.000000Z"
    //             },
    //             {
    //                 "id": "vbn",
    //                 "type": "App\\Notifications\\GeneralNotification",
    //                 "notifiable_type": "App\\Models\\User",
    //                 "notifiable_id": 345269,
    //                 "data": {
    //                     "title": "PulsaIn : Pesanan - Aktif",
    //                     "body": "Pesanan konversi pulsa Indosat sejumlah Rp. 30,000 telah diaktifkan kembali.",
    //                     "screen": "transaction-489883",
    //                     "category": "order",
    //                     "notifier_name": "Transaction",
    //                     "notifier_id": 489883
    //                 },
    //                 "read_at": "2024-05-30T02:43:37.000000Z",
    //                 "created_at": "2024-03-28T02:31:56.000000Z",
    //                 "updated_at": "2024-05-30T02:43:37.000000Z"
    //             }
    //         ],
    //         "first_page_url": "https://tetrapulsa.test/api/v1/users/notifications?page=1",
    //         "from": 1,
    //         "last_page": 1,
    //         "last_page_url": "https://tetrapulsa.test/api/v1/users/notifications?page=1",
    //         "links": [
    //             {
    //                 "url": null,
    //                 "label": "&laquo; Previous",
    //                 "active": false
    //             },
    //             {
    //                 "url": "https://tetrapulsa.test/api/v1/users/notifications?page=1",
    //                 "label": "1",
    //                 "active": true
    //             },
    //             {
    //                 "url": null,
    //                 "label": "Next &raquo;",
    //                 "active": false
    //             }
    //         ],
    //         "next_page_url": null,
    //         "path": "https://tetrapulsa.test/api/v1/users/notifications",
    //         "per_page": 15,
    //         "prev_page_url": null,
    //         "to": 4,
    //         "total": 4
    //     }
    // }
    //   '''

      PaginationResponse<List<NewsModel>> apiResponse = PaginationResponse(
          data: (response.data[ApiConstant.data][ApiConstant.data] as Iterable).map((e) => NewsModel.fromJson(e)).toList(),
          lastPage: response.data[ApiConstant.data][ApiConstant.lastPage],
          code: response.statusCode!,
          message: "",
          error: false
      );

      return apiResponse;
    } on DioException catch(e){
      return _client.errorParserPagination(e);
    } catch(e){
      PaginationResponse<List<NewsModel>> response = PaginationResponse(
          lastPage: 1,
          code: 500,
          message: e.toString(),
          error: true
      );

      return response;
    }
  }
}