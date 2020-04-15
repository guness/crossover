import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crossover/constants.dart' as Constants;
import 'package:crossover/data/network/response.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class WebService {
  static final WebService _instance = WebService._internal();

  factory WebService() {
    return _instance;
  }

  WebService._internal();

  Future<TokenResponse> authorize(String username, String password) async {
    var token = base64Encode(utf8.encode('$username:$password'));

    return authorizeBasicToken(token);
  }

  Future<TokenResponse> authorizeBasicToken(String token) async {

    final response = await http.post(
      api("v3/token"),
      headers: {HttpHeaders.authorizationHeader: "Basic $token"},
    );

    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }

    return compute(parseTokenResponse, response.body);
  }

  String api(String path) {
    return Constants.BASE_URL + path;
  }
}

TokenResponse parseTokenResponse(String responseBody) {
  return TokenResponse.fromJson(json.decode(responseBody));
}
