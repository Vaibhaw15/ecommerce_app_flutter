import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/api.dart';
import 'package:ecommerce_app/data/models/user/user_model.dart';

class UserRepository {
  final _api = Api();

  Future<UserModel> createAccount(
      {required String email, required String password}) async {
    try {
      Response response = await _api.sendrequest.post("/user/createAccount",
          data: jsonEncode({"email": email, "password": password}));

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }

      //convert raw data to model
      return UserModel.fromJson(apiResponse.data);
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<UserModel> signIn(
      {required String email, required String password}) async {
    try {
      Response response = await _api.sendrequest.post("/user/signIn",
          data: jsonEncode({"email": email, "password": password}));

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }

      //convert raw data to model
      return UserModel.fromJson(apiResponse.data);
    } catch (ex) {
      rethrow;
    }
  }

  Future<UserModel> updateUser(UserModel userModel) async {
    try {
      Response response = await _api.sendrequest
          .put("/user/${userModel.sId}", data: jsonEncode(userModel.toJson()));

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }

      //convert raw data to model
      return UserModel.fromJson(apiResponse.data);
    } catch (ex) {
      rethrow;
    }
  }
  Future<UserModel> updateProfileImageUser(UserModel userModel,String image) async {
    try {
      Response response = await _api.sendrequest
          .post("/user/updateProfilePic",
          data: jsonEncode({
            "userId":userModel.sId!,
            "profilePicture":image}));

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }
      return UserModel.fromJson(apiResponse.data);
    } catch (ex) {
      rethrow;
    }
  }
}
