import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shoply/core/data/remote_data/auth_api.dart';
import 'package:shoply/core/model/request/register_requested.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(RegisterLoading());
    try {
      await AuthApi.register(
        RegisterRequest(
          name: name.trim(),
          email: email.trim(),
          password: password.trim(),
        ),
      );
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }
}
