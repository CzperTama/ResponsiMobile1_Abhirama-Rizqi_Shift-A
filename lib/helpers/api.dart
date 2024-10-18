import 'dart:io';
import 'dart:convert';
import 'app_exception.dart';
import 'package:http/http.dart' as http;

class Api {
  final String _baseUrl;

  Api(this._baseUrl);

  Future<dynamic> post(String endpoint, dynamic data) async {
    return _sendRequest(() => http.post(
      Uri.parse(_baseUrl + endpoint),
      body: json.encode(data),
      headers: {HttpHeaders.contentTypeHeader: "application/json"},
    ));
  }

  Future<dynamic> get(String endpoint) async {
    return _sendRequest(() => http.get(
      Uri.parse(_baseUrl + endpoint),
      headers: {HttpHeaders.contentTypeHeader: "application/json"},
    ));
  }

  Future<dynamic> delete(String endpoint) async {
    return _sendRequest(() => http.delete(
      Uri.parse(_baseUrl + endpoint),
      headers: {HttpHeaders.contentTypeHeader: "application/json"},
    ));
  }

  Future<dynamic> put(String endpoint, dynamic data) async {
    return _sendRequest(() => http.put(
      Uri.parse(_baseUrl + endpoint),
      body: json.encode(data),
      headers: {HttpHeaders.contentTypeHeader: "application/json"},
    ));
  }

  Future<dynamic> _sendRequest(Future<http.Response> Function() requestMethod) async {
    try {
      final response = await requestMethod();
      return _handleResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      throw FetchDataException('An error occurred: ${e.toString()}');
    }
  }

  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      case 400:
        throw BadRequestException(response.body);
      case 401:
        throw UnauthorisedException(response.body);
      case 422:
        throw UnprocessableEntityException(response.body);
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while communicating with server. Status code: ${response.statusCode}');
    }
  }
}
