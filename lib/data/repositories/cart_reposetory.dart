import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/api.dart';
import 'package:ecommerce_app/data/models/cart/cart_item_model.dart';
import 'package:ecommerce_app/data/models/category/category_model.dart';

class CartRepository {
  final _api = Api();

  Future<List<CartItemModel>> fetchCartForUser(String userId) async {
    try {
      Response response = await _api.sendrequest.get("/cart/$userId");

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }

      //convert raw data to model
      return (apiResponse.data as List<dynamic>)
          .map((json) => CartItemModel.fromJson(json))
          .toList();
    } catch (ex) {
      rethrow;
    }
  }

  Future<List<CartItemModel>> addToCartForUser(
      CartItemModel cartItem, String userId) async {
    try {
      Map<String, dynamic> data = cartItem.toJson();
      data["user"] = userId;
      Response response = await _api.sendrequest.post(
        "/cart",
        data: jsonEncode(data),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }

      //convert raw data to model
      return (apiResponse.data as List<dynamic>)
          .map((json) => CartItemModel.fromJson(json))
          .toList();
    } catch (ex) {
      rethrow;
    }
  }

  Future<List<CartItemModel>> removeFromCartForUser(
      String productId, String userId) async {
    try {
      Map<String,dynamic> data = {
        "product": productId,
        "user": userId
      };
      Response response = await _api.sendrequest.delete(
        "/cart",
        data: jsonEncode(data),
      );

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }

      //convert raw data to model
      return (apiResponse.data as List<dynamic>)
          .map((json) => CartItemModel.fromJson(json))
          .toList();
    } catch (ex) {
      rethrow;
    }
  }
}
