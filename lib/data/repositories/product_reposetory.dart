import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/api.dart';
import 'package:ecommerce_app/data/models/category/category_model.dart';
import 'package:ecommerce_app/data/models/product/product_model.dart';

class ProductRepository {
  final _api = Api();

  Future<List<ProductModel>> fetchAllProduct() async {
    try {
      Response response = await _api.sendrequest.get("/product");

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }

      //convert raw data to model
      return (apiResponse.data as List<dynamic>)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (ex) {
      rethrow;
    }
  }
  Future<List<ProductModel>> fetchProductByCategory(String categoryId) async {
    try {
      Response response = await _api.sendrequest.get("/product/category/$categoryId");

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }

      //convert raw data to model
      return (apiResponse.data as List<dynamic>)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (ex) {
      rethrow;
    }
  }
}
