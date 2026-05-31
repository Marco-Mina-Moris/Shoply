import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shoply/core/data/local_data/profile_local_data.dart';
import 'package:shoply/core/data/remote_data/profile_api.dart';
import 'package:shoply/core/model/request/update_user_request.dart';
import 'package:shoply/core/model/response/user_response.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  UserResponse user = UserResponse();
  String? accessToken; 
  String? localAvatarPath;

  Future<void> getDataProfile(String accessToken) async {
    emit(GetProfileLoading());
    try {
      if (accessToken.isEmpty || accessToken == 'null') {
        throw Exception('Unauthorized: No valid token found. Please log out and log in again.');
      }
      this.accessToken = accessToken;
      user = await ProfileApi.getProfileData(accessToken);
      final profileLocalData = await ProfileLocalData.instance;
      localAvatarPath = profileLocalData.getAvatarPath();
      emit(GetProfileSuccess());
    } catch (e) {
      emit(GetProfileError(e.toString()));
    }
  }

  Future<void> updateLocalAvatar(String path) async {
    try {
      final profileLocalData = await ProfileLocalData.instance;
      await profileLocalData.saveAvatarPath(path);
      localAvatarPath = path;
      emit(GetProfileSuccess());
    } catch (e) {
      emit(UpdateProfileError(e.toString()));
    }
  }

  Future<void> updateProfile(UpdateUserRequest request) async {
    emit(UpdateProfileLoading());
    try {
      if (user.id == null) {
        emit(UpdateProfileError('User ID is missing'));
        return;
      }
      UserResponse updatedUser =
          await ProfileApi.updateProfile(request, user.id.toString());
      user = updatedUser;
      emit(UpdateProfileSuccess());
      emit(GetProfileSuccess());
    } catch (e) {
      emit(UpdateProfileError(e.toString()));
    }
  }
}
