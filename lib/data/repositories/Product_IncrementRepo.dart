
import 'package:base_flutter_provider_project/data/models/home_model/ProductByCategoryResponsemodel.dart';

import '../../constants/end_points_constants.dart';
import '../../services/dio_client.dart';
import '../../utils/logger.dart';
import '../models/home_model/ProductIncrementResModel.dart';


class ProductIncrementRepository{
  final ApiClient _client = ApiClient();

  Future<AddItemResponse?> addproduct(body) async {

    final response = await _client.post(EndPointConstants.productincrement,body: body);

    Logger.appLogs('callBackResponse:: $response');
    if (response != null) {
      //Success returning data back
      Logger.appLogs('responseRepo:: $response');
      return AddItemResponse.fromJson(response as Map<String, dynamic>);
    } else {
      //Failed returning null
      Logger.appLogs('errorNull:: $response');
      return null;
    }
  }


}

class HomeScreenException implements Exception {
  HomeScreenException(this.message);

  final String message;
}
