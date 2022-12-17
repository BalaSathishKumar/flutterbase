

import 'package:base_flutter_provider_project/data/models/home_model/ProductByCategoryResponsemodel.dart';
import 'package:base_flutter_provider_project/data/models/home_model/test_model.dart';
import 'package:base_flutter_provider_project/viewModel/base_view_model/base_view_model.dart';

import '../../config/locator.dart';
import '../../constants/strings.dart';
import '../../data/repositories/ProductbyCatRepo.dart';
import '../../utils/common_functions.dart';
import '../../utils/generic_exception.dart';
import '../../utils/logger.dart';


class ProdtoCatViewModel extends BaseViewModel{



  final ProductbyCatRepository _prodtocRepository = locator<ProductbyCatRepository>();

  ModelProductList?   _prodtocreponsemodel;


  ModelProductList? get  prodtocResponsemodel => _prodtocreponsemodel;

  Future<ModelProductList?> fetchProdByCat({required Function(String) onFailureRes}) async {
    //Loader State
    setState(ViewState.busy);

    try {
      var data = await _prodtocRepository.fetchprodbycat();
      if (data != null) {
        _prodtocreponsemodel = data;
        //Success State
        setState(ViewState.success);
      }else{
        //Failed
        onFailureRes(Strings.somethingWentWrong);
        //Failure State
        setState(ViewState.idle);
      }
    } on AppException catch (appException) {
      Logger.appLogs('errorType:: ${appException.type}');
      Logger.appLogs('onFailure:: $appException');
      //Common Error Handler
      errorMsg = errorHandler(appException);
      //Failed
      onFailureRes(errorMsg);
      //Idle / Failure State
      setState(ViewState.idle);
    }
    return null;
  }

}