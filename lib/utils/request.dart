// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_pos/widgets/dialog.dart';

Map<String, dynamic> convertToQueryParams(
    [Map<String, dynamic> params = const {}]) {
  Map<String, dynamic> queryParams = Map.from(params);
  return queryParams.map<String, dynamic>(
    (key, value) => MapEntry(
        key,
        value == null
            ? null
            : (value is List)
                ? value.map<String>((e) => e.toString()).toList()
                : value.toString()),
  );
}

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorizedException extends AppException {
  UnauthorizedException([message]) : super(message, "Unauthorized: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}

class ExpiredException extends AppException {
  ExpiredException([String? message]) : super(message, "Token Expired: ");
}

class CustomInterceptors extends Interceptor {
  int maxCharactersPerLine = 200;
  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    debugPrint("--> ${options.method} ${options.path}");
    debugPrint("Headers: ${options.headers.toString()}");
    debugPrint("<-- END HTTP");

    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    debugPrint(
        "<-- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}");

    String responseAsString = response.data.toString();

    if (responseAsString.length > maxCharactersPerLine) {
      int iterations = (responseAsString.length / maxCharactersPerLine).floor();
      for (int i = 0; i <= iterations; i++) {
        int endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
        if (endingIndex > responseAsString.length) {
          endingIndex = responseAsString.length;
        }
      }
    }

    debugPrint("<-- END HTTP");

    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint(
        "ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}");
    return super.onError(err, handler);
  }
}

// or new Dio with a BaseOptions instance
class MyRequest {
  static BaseOptions options = BaseOptions(
      baseUrl: 'https://admin.reso.vn/api/v1/',
      // baseUrl: 'https://localhost:7131/api/v1/',
      headers: {
        Headers.contentTypeHeader: "application/json",
        Headers.acceptHeader: "text/plain"
      },
      sendTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30));
  late Dio _inner;
  MyRequest() {
    _inner = Dio(options);
    _inner.interceptors.add(CustomInterceptors());
    _inner.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        return handler.next(e); // continue
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 400) {
          await showAlertDialog(
              title: "Lỗi",
              content:
                  error.response?.data["Error"].toString() ?? 'Có lỗi xãy ra');
        } else if (error.response?.statusCode == 403) {
          showAlertDialog(
            title: "Lỗi đăng nhập",
            content:
                "Tài khoản của bạn không có quyền đăng nhập vào hệ thống này",
          ).then((value) => {
                // if (value) Get.find<LoginViewModel>().logout(),
              });
        } else if (error.response?.statusCode == 500) {
          showAlertDialog(
            title: "Lỗi hệ thống",
            content:
                "Lỗi xảy ra do hệ thống gặp vấn đề, vui lòng thử lại sau hoặc là tắt ứng dụng và mở lại",
          );
        }
        handler.next(error);
      },
    ));
  }

  Dio get request {
    return _inner;
  }

  set setToken(token) {
    options.headers["Authorization"] = "Bearer $token";
  }
}

final requestObj = MyRequest();
final request = requestObj.request;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
