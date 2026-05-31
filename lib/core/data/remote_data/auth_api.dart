import 'dart:convert';

import 'package:shoply/core/model/request/login_request.dart';
import 'package:shoply/core/model/request/register_requested.dart';
import 'package:shoply/core/model/response/login_response.dart';
import 'package:shoply/core/model/response/register_response.dart';
import 'package:http/http.dart' as http;

abstract class AuthApi {
  static Future<RegisterResponse> register(RegisterRequest request) async {
    // https://api.escuelajs.co/api/v1/users/
    Uri url = Uri.https('api.escuelajs.co', '/api/v1/users/');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    var responseBody = response.body;
    var json = jsonDecode(responseBody);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return RegisterResponse.fromJson(json);
    } else {
      dynamic errMsg = json['message'];
      if (errMsg is List) {
        errMsg = errMsg.join(', ');
      }
      throw Exception(errMsg ?? 'Failed to register');
    }
  }

  static Future<LoginResponse> login(LoginRequest request) async {
    // https://api.escuelajs.co/api/v1/auth/login
    Uri url = Uri.https('api.escuelajs.co', '/api/v1/auth/login');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    var responseBody = response.body;
    var json = jsonDecode(responseBody);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return LoginResponse.fromJson(json);
    } else {
      dynamic errMsg = json['message'];
      if (errMsg is List) {
        errMsg = errMsg.join(', ');
      }
      throw Exception(errMsg ?? 'Failed to login');
    }
  }

  static Future<LoginResponse> refreshToken(String refreshToken) async {
  Uri url = Uri.https('api.escuelajs.co', '/api/v1/auth/refresh-token');
  var response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'refreshToken': refreshToken}),
  );
  var json = jsonDecode(response.body);
  return LoginResponse.fromJson(json);
}
}
