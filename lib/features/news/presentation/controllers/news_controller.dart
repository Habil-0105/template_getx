import 'package:get/get.dart';
import 'package:template_getx/features/auth/domain/repositories/auth_repository.dart';
import 'package:template_getx/features/news/domain/repositories/news_repository.dart';

class NewsController extends GetxController{
  NewsController({required this.newsRepository});
  final NewsRepository newsRepository;

  static NewsController get to => Get.find<NewsController>();
}