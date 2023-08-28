import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/api.dart';
import 'package:ecommerce_app/data/models/category/category_model.dart';

class CategoryRepository {
  final _api = Api();

  Future<List<CategoryModel>> fetchAllCategory() async {
    try {
      Response response = await _api.sendrequest.get("/category");

      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }

      //convert raw data to model
      return (apiResponse.data as List<dynamic>).map((json) => CategoryModel.fromJson(json)).toList();

    } catch (ex) {
      rethrow;
    }
  }
}
