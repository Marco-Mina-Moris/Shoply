import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shoply/core/data/remote_data/auth_api.dart';
import 'package:shoply/core/model/request/login_request.dart';
import 'package:shoply/core/storage_helper/app_shared_preference_helper.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    try {
      var response =
          await AuthApi.login(LoginRequest(email: email.trim(), password: password.trim()));
      if (response.accessToken == null || response.refreshToken == null) {
        throw Exception('Failed to retrieve login tokens');
      }
      await SharedPreferencesHelper.saveData(
          key: 'accessToken', value: response.accessToken);
      await SharedPreferencesHelper.saveData(
          key: 'refreshToken', value: response.refreshToken);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}
