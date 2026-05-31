import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shoply/core/model/request/update_user_request.dart';
import 'package:shoply/core/model/response/user_response.dart';

abstract class ProfileApi {
  static Future<UserResponse> getProfileData(String accessToken) async {
    // https://api.escuelajs.co/api/v1/auth/profile
    Uri url = Uri.https('api.escuelajs.co', '/api/v1/auth/profile');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $accessToken'});
    var responseBody = response.body;
    var json = jsonDecode(responseBody);
    if (response.statusCode == 200) {
      return UserResponse.fromJson(json);
    } else {
      throw Exception(json['message'] ?? 'Failed to get profile data');
    }
  }

  static Future<UserResponse> updateProfile(
      UpdateUserRequest request, String id) async {
    // https://api.escuelajs.co/api/v1/users/5
    Uri url = Uri.https('api.escuelajs.co', '/api/v1/users/$id');
    var response = await http.put(url,
        headers: {'Content-Type': 'application/json'}, body: request.toJson());
    var responseBody = response.body;
    var json = jsonDecode(responseBody);
    if (response.statusCode == 200) {
      return UserResponse.fromJson(json);
    } else {
      throw Exception(json['message'] ?? 'Failed to update profile');
    }
  }
}
