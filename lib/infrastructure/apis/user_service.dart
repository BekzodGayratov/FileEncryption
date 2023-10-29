import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:test/domain/user_model.dart';

class UserApis {
  Future<Either<String, List<UserModel>>> getUsers() async {
    try {
      Response response =
          await Dio().get("https://jsonplaceholder.typicode.com/users");
      if (response.statusCode == 200) {
        return right((response.data as List)
            .map((e) => UserModel.fromRawJson(jsonEncode(e)))
            .toList());
      } else {
        return left(response.statusMessage.toString());
      }
    } on DioException catch (e) {
      if (e.error.toString().contains('SocketException')) {
        return left("No internet connection");
      }
      return left(e.message.toString());
    }
  }
}
