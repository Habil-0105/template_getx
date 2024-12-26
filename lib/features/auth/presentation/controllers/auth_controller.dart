import 'package:get/get.dart';
import 'package:template_getx/features/auth/domain/repositories/auth_repository.dart';

enum AuthStatus {
  initial,
  loading,
  loginSuccess,
  error,
}

class AuthController extends GetxController{
  AuthController({required this.authRepository});
  final AuthRepository authRepository;

  static AuthController get to => Get.find<AuthController>();

  /// !!!
  /// Jangan pernah meletakkan urusan untuk view di controller.
  /// Contoh: TextEditingController
  /// Jadi, jika membutuhkan data tersebut di page lain, bisa dengan menambahkan variable tambahan, seperti variable dibawah

  String _token = "";

  String _username = "";
  String get username => _username;

  String _password = "";
  String get password => _password;

  /// Digunakan untuk mengatur bagaimana UI akan bereaksi setiap ada pemanggilan API
  var status = AuthStatus.initial.obs;

  @override
  void onInit() {
    ever(status, _handleAuthStatusChange);
    super.onInit();
  }

  Future<void> _handleAuthStatusChange(AuthStatus status)async{
    if(status == AuthStatus.loginSuccess){
      /// Do something when success
      return;
    }
  }

  Future<void> login({required String email, required String password})async{
    status.value = AuthStatus.loading;

    final response = await authRepository.login(email: email, password: password);

    if (response.error) {
      status.value = AuthStatus.error;
      return;
    }

    _username = username;
    _password = password;

    _token = response.data ?? "";
    status.value = AuthStatus.loginSuccess;
  }

  /// Jangan terlalu memberatkan kepada controller, jika bisa dilakukan di UI lakukan di UI, controller hanya sebagai jembatan antara UI dan logic business
}