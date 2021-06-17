import 'dart:convert';
import 'dart:io';
import 'api_response.dart';

import 'package:http/http.dart';

class ApiHelper {
  Future<ApiResponse> postReq(
      {String endpoint, Map data, String query = ""}) async {
    final String url = endpoint + query;

    try {
      Response postReq = await post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonEncode(data),
      );
      return postReq.statusCode >= 200 && postReq.statusCode <= 205
          ? ApiResponse(data: postReq.body)
          : ApiResponse(
              error: true,
              errorMessage:
                  postReq.statusCode.toString() + '\n' + postReq.body);
    } on SocketException {
      return ApiResponse(error: true, errorMessage: "NO INTERNET");
    } on HttpException {
      return ApiResponse(error: true, errorMessage: "HTTP Error");
    } catch (e) {
      return ApiResponse(error: true, errorMessage: e.toString());
    }
  }

  Future<ApiResponse> getReq({String endpoint, String query = ""}) async {
    final String url = endpoint + query;

    try {
      Response getReq = await get(
        url,
      );

      return ApiResponse(data: getReq.body);
    } catch (e) {
      return ApiResponse(error: true, errorMessage: e.toString());
    }
  }
}
