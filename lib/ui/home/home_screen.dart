import 'package:base_flutter_provider_project/common_widgets/loading_widgets/loader.dart';
import 'package:base_flutter_provider_project/constants/dimensions.dart';
import 'package:base_flutter_provider_project/constants/strings.dart';
import 'package:base_flutter_provider_project/utils/common_functions.dart';
import 'package:base_flutter_provider_project/utils/logger.dart';
import 'package:base_flutter_provider_project/viewModel/base_view_model/base_view_model.dart';
import 'package:base_flutter_provider_project/viewModel/chatbotlist_viewmodel.dart';
import 'package:base_flutter_provider_project/viewModel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewModel/base_view_model/productbycat_viewmodel.dart';
import '../../viewModel/test_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //late HomeViewModel _homeViewModel;
  late TestViewModel _testViewModel;
  late ProdtoCatViewModel _prodbycatViewModel;

//  late ChatBotlistViewModel _chatBotlistViewModel;

  @override
  void initState() {
    super.initState();
  //  _homeViewModel = Provider.of<HomeViewModel>(context, listen: false);

   // _testViewModel = Provider.of<TestViewModel>(context, listen: false);

    _prodbycatViewModel = Provider.of<ProdtoCatViewModel>(context, listen: false);

  //  _chatBotlistViewModel = Provider.of<ChatBotlistViewModel>(context,listen: false);
    //UI render callback
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      //Calling api after UI gets rendered successfully
     // _homeViewModel.fetchHome(onFailureRes: onFailureRes);

    //  _testViewModel.fetchTestUser(onFailureRes: onFailureRes);

      _prodbycatViewModel.fetchProdByCat(onFailureRes: onFailureRes);

    //  _chatBotlistViewModel.fetchChatbotList(onFailureRes: onFailureRes);

    });
  }

  onFailureRes(String error) {
    Logger.appLogs('onFailureRes:: $error');
    errorAlert(context, error);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<ProdtoCatViewModel>(
          builder: (context, viewModel, child) {
            return viewModel.state == ViewState.busy
                ? const Loader()
                : _renderBody();
          },
        ),
      ),
    );
  }

  Widget _renderBody() {
    return Column(
      children: [
        Consumer<ProdtoCatViewModel>(
          builder: (context, viewModel, child) {
            return viewModel.state == ViewState.success
                ?
            Container(
                    padding: const EdgeInsets.all(Dimensions.dm_15),
                    child: Card(
                      child: Column(
                        children: [
                          Text(
                            viewModel.prodtocResponsemodel?.data?[0].productName ?? Strings.homePage,

                            style: const TextStyle(
                              fontSize: Dimensions.dm_14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 50,),
                          GestureDetector(
                            onTap: (){
                              for(var i=0; i<=3 ; i++){
                                print('print out side $i ');
                                for(var j=1; j<=i ; j++){
                                  print('print inside $i ');
                                }
                                print('');
                            }
                            },
                            child: Text(
                              viewModel.prodtocResponsemodel?.data?[0].imageUrl ?? Strings.homePage,

                              style: const TextStyle(
                                fontSize: Dimensions.dm_14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                        ],
                      )


                    ),
                  )
                : const SizedBox.shrink();
          },
        ),




        /*Consumer<ChatBotlistViewModel>(
          builder: (context, viewModel, child){
            return viewModel.state == ViewState.success
                ? Builder(
                  builder: (context) {
                    return Container(
              padding: const EdgeInsets.all(Dimensions.dm_15),
              child: Column(
                children: [
                  Text(
                      //  "User Name : ${viewModel.testResponsemodel!.data?.firstName ?? Strings.homePage}",
                    "Bot Name ::${viewModel.chatBotResponsemodel!.selectedBot!.botName}",
                        style: const TextStyle(
                          fontSize: Dimensions.dm_14,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 20,),

                  Text(
                    //  "User Name : ${viewModel.testResponsemodel!.data?.firstName ?? Strings.homePage}",
                    "Bot Id ::${viewModel.chatBotResponsemodel!.selectedBot!.botId}",
                    style: const TextStyle(
                      fontSize: Dimensions.dm_14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
                  }
                ) : SizedBox.shrink();
          },
        ),*/












        // Consumer<HomeViewModel>(
        //   builder: (context, viewModel, child) {
        //     return viewModel.state == ViewState.success
        //         ? Container(
        //             padding: const EdgeInsets.all(Dimensions.dm_15),
        //             child: Text(
        //               '${viewModel.homeResponseModel!.userDetails!.age}',
        //               style: const TextStyle(
        //                 fontSize: Dimensions.dm_14,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //           )
        //         : const SizedBox.shrink();
        //   },
        // ),
        // Consumer<HomeViewModel>(
        //   builder: (context, viewModel, child) {
        //     return viewModel.state == ViewState.success
        //         ? Container(
        //             padding: const EdgeInsets.all(Dimensions.dm_15),
        //             child: Text(
        //               '${viewModel.homeResponseModel!.userDetails!.email}',
        //               style: const TextStyle(
        //                 fontSize: Dimensions.dm_14,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //           )
        //         : const SizedBox.shrink();
        //   },
        // )
      ],
    );
  }
}
