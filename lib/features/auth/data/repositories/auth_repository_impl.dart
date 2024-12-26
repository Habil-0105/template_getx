import 'package:dio/dio.dart';
import 'package:template_getx/features/auth/domain/repositories/auth_repository.dart';
import 'package:template_getx/shared/services/network/api_response.dart';
import 'package:template_getx/shared/services/network/network_client.dart';
import 'package:template_getx/shared/services/network/url.dart';
import 'package:template_getx/shared/utils/constants/api_constant.dart';

class AuthRepositoryImpl extends AuthRepository{
  final NetworkClient _client = NetworkClient();

  @override
  Future<ApiResponse<String>> login({required String email, required String password})async{
    try{
      FormData data = FormData.fromMap({
        ApiConstant.email : email,
        ApiConstant.password : password,
      });

      final response = await _client.post(endpoint: Url.auth(AuthEndpoint.login), data: data);

      // Sebagai contoh jika response nya seperti ini dan hanya membutuhkan token nya, hanya perlu lakukan seperti yang ada pada nilai token dibawah
      // {
      //   "data" : {
      //     "token" : "ASDASDASDASDasdasdASDZXCS"
      //   }
      // }

      final token = response.data[ApiConstant.data][ApiConstant.token];

      ApiResponse<String> result = ApiResponse(
          data: token,
          code: response.statusCode!,
          message: response.data[ApiConstant.message],
          error: false
      );

      return result;
    } on DioException catch(e){
      return _client.errorParser(e: e);
    } catch(e){
      ApiResponse<String> response = ApiResponse(
          code: 500,
          message: e.toString(),
          error: true
      );

      return response;
    }
  }
}