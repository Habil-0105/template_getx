import 'package:template_getx/features/news/data/models/news_model.dart';
import 'package:template_getx/shared/services/network/api_response.dart';
import 'package:template_getx/shared/services/network/pagination_responce.dart';

abstract class NewsRepository{
  Future<ApiResponse<NewsModel>> getDetailNews({required int id});
  Future<PaginationResponse<List<NewsModel>>> getAllNews({required int page});
}