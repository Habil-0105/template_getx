import 'package:get/get.dart';
import 'package:template_getx/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:template_getx/features/auth/domain/repositories/auth_repository.dart';
import 'package:template_getx/features/auth/presentation/controllers/auth_controller.dart';
import 'package:template_getx/features/news/data/repositories/news_repository_impl.dart';
import 'package:template_getx/features/news/domain/repositories/news_repository.dart';
import 'package:template_getx/features/news/presentation/controllers/news_controller.dart';

void injectorSetup() {
  // Authentication
  Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl());
  Get.lazyPut<AuthController>(() => AuthController(authRepository: Get.find<AuthRepository>()));

  // News
  Get.lazyPut<NewsRepository>(() => NewsRepositoryImpl());
  Get.lazyPut<NewsController>(() => NewsController(newsRepository: Get.find<NewsRepository>()));
}