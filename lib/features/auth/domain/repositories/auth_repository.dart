import 'package:template_getx/shared/services/network/api_response.dart';

abstract class AuthRepository{
  Future<ApiResponse<String>> login({required String email, required String password});
}