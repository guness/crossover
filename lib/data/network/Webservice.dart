import 'dart:convert';
import 'package:crossover/data/network/response.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'package:crossover/constants.dart' as Constants;

class WebService {
  Future<TokenResponse> authorize(String username, String password) async {
    var token = base64Encode(utf8.encode('$username:$password'));
    return authorizeBasicToken(token);
  }

  Future<TokenResponse> authorizeBasicToken(String token) async {
    var auth = 'Basic ' + base64Encode(utf8.encode(token));

    final response = await http.post(
      Constants.BASE_URL + "v3/token",
      headers: {HttpHeaders.authorizationHeader: "Basic $auth"},
    );
    final responseJson = json.decode(response.body);

    return TokenResponse.fromJson(responseJson);
  }
}
