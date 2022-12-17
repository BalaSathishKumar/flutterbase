
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../common_widgets/loading_widgets/loader.dart';
import '../../data/models/home_model/ProductByCategoryResponsemodel.dart';
import '../../utils/common_functions.dart';
import '../../utils/logger.dart';
import '../../viewModel/base_view_model/base_view_model.dart';
import '../../viewModel/base_view_model/productbycat_viewmodel.dart';
import '../../viewModel/productincrementviewmodel.dart';


enum ApiType {
  remove,
  add,
}

class ProductPageByCategories extends StatefulWidget {




  @override
  State<ProductPageByCategories> createState() =>
      _ProductPageByCategoriesState();
}

class _ProductPageByCategoriesState extends State<ProductPageByCategories> {
  List<ProductData> allProductList = [];
  num counter = 0;
  num? itemQuantity;
  String? getCategoryName;

  String? userToken;
  String? productName_temp;
  late ProdtoCatViewModel _prodbycatViewModel;
  late ProductincrementViewModel _prodincViewModel;
/*  final carouselController = CarouselController();*/

  getToken() async {
    final prefs = await SharedPreferences.getInstance();
    var Token = prefs.getString('auth_token');
    setState(() {
      userToken = Token.toString();
    });
  }

  @override
  void initState() {
    getToken();
    _prodbycatViewModel = Provider.of<ProdtoCatViewModel>(context, listen: false);
    _prodincViewModel = Provider.of<ProductincrementViewModel>(context, listen: false);

    WidgetsBinding.instance?.addPostFrameCallback((_) {

      _prodbycatViewModel.fetchProdByCat(onFailureRes: onFailureRes);




     });

  }
  onFailureRes(String error) {
    Logger.appLogs('onFailureRes:: $error');
    errorAlert(context, error);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
   /*   bottomNavigationBar: bottomSortFilterButton(),*/
      body: Consumer<ProdtoCatViewModel>(
        builder: (context, viewModel, child) {
          return viewModel.state == ViewState.busy
              ? const Loader()
              :  _renderBody();
        },
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
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: GridView.builder(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              shrinkWrap: true,
              physics: ScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 4,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5),
              itemCount: viewModel.prodtocResponsemodel?.data?.length,
              itemBuilder: (BuildContext context, index) {
                print("productId${viewModel.prodtocResponsemodel?.data?[index].id}");
                itemQuantity = viewModel.prodtocResponsemodel?.data?[index].quantity;

                return InkWell(
                  onTap: () {
                    setState(() {
                      productName_temp =
                          viewModel.prodtocResponsemodel?.data?[index].productName.toString();
                    });

                /*    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetaisPage(
                                  productName: productName_temp),
                        ));*/
                  },
                  child: Card(
                    elevation: 2,

                    child: Padding(
                      padding: EdgeInsets.all(7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: double.maxFinite,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            height: MediaQuery
                                .of(context)
                                .size
                                .height / 10,
                            child: Image.network(
                                "${viewModel.prodtocResponsemodel?.data?[index].imageUrl.toString()}"),
                          ),
                          Text(
                          "${viewModel.prodtocResponsemodel?.data?[index].productName.toString()}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.sp,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: "₹ ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: "${viewModel.prodtocResponsemodel?.data?[index].price.toString()}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold),
                                )
                              ])),
                          viewModel.prodtocResponsemodel?.data?[index].cartQuantity == 0
                              ? SizedBox(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: ElevatedButton(

                                onPressed: () {
                                  viewModel.prodtocResponsemodel?.data?[index].cartQuantity = 1;
                                  num? totalprice = viewModel.prodtocResponsemodel?.data?[index].price;
                                  var itemData = {
                                    "productId":  viewModel.prodtocResponsemodel?.data?[index].id.toString(),
                                    "productName":  viewModel.prodtocResponsemodel?.data?[index].productName,
                                    "quantity": 1,
                                    "price":  viewModel.prodtocResponsemodel?.data?[index].price,
                                    "manufacture":  viewModel.prodtocResponsemodel?.data?[index].manufacture,
                                    "imageUrl":  viewModel.prodtocResponsemodel?.data?[index].imageUrl,
                                    "total": 1 * totalprice!,
                                  };
                                  print('Post APi param ${itemData}');
                                  var body = json.encode(itemData);
                                  _prodincViewModel.productinc(onFailureRes: onFailureRes,body: body);

                               /*   qtyApi(
                                    param0: viewModel.prodtocResponsemodel?.data,
                                      index: index,
                                      qty:  1,
                                      apiType: ApiType.add);*/
                                },
                                child: Text(
                                  "ADD TO CART",
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                  ),
                                )),
                          )
                              :
                          Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width/2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    child: const Text("-"),
                                    onPressed: () {
                                      //TODO CartQuantity should not in 0
                                      if (viewModel.prodtocResponsemodel?.data![index].cartQuantity != 0) {
                                        qtyApi(
                                          param0: viewModel.prodtocResponsemodel?.data,
                                          index: index,
                                          qty:  1,
                                          apiType: ApiType.remove,
                                        );
                                      }
                                    }),
                                Text(
                                 "${viewModel.prodtocResponsemodel?.data?[index].cartQuantity
                                     .toString()}",
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                  ),
                                ),
                                TextButton(
                                  child: const Text("+"),
                                  onPressed: () {
                                    num? additem = viewModel.prodtocResponsemodel?.data?[index].cartQuantity;
                                    num? totalprice = viewModel.prodtocResponsemodel?.data?[index].price;
                                    //TODO Stock Validation check needed
                                    var itemData = {
                                      "productId":  viewModel.prodtocResponsemodel?.data?[index].id.toString(),
                                      "productName":  viewModel.prodtocResponsemodel?.data?[index].productName,
                                      "quantity": additem! + 1,
                                      "price":  viewModel.prodtocResponsemodel?.data?[index].price,
                                      "manufacture":  viewModel.prodtocResponsemodel?.data?[index].manufacture,
                                      "imageUrl":  viewModel.prodtocResponsemodel?.data?[index].imageUrl,
                                      "total": 1 * totalprice!,
                                    };
                                    print('Post APi param ${itemData}');
                                    var body = json.encode(itemData);
                                    _prodincViewModel.productinc(onFailureRes: onFailureRes,body: body);

                              /*      if (viewModel.prodtocResponsemodel?.data?[index].quantity >= viewModel.prodtocResponsemodel?.data?[index].cartQuantity) {
                                      qtyApi(
                                        snapShot: snapShot,
                                        index: index,
                                        qty: snapShot.data![index]
                                            .cartQuantity! +
                                            1,
                                        apiType: ApiType.add,
                                      );
                                    } else {
                                      print('Quantity exceeded...!');
                                    }*/
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      )
          : const SizedBox.shrink();
    }
    )
      ],
    );

  }




  bottomSortFilterButton() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: 40,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              height: 40,
              width: MediaQuery.of(context).size.width / 2.9,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 234, 235, 234)),
              height: 35,
              width: MediaQuery.of(context).size.width / 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    child: Row(
                      children: [
                        SizedBox(
                            height: 13,
                          //  child: Image.asset(assetSort_icon)
                        ),
                        const Text(" Sort")
                      ],
                    ),
                    onTap: () => showModalBottomSheet(
                      isScrollControlled: false,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: ((context) => bottomSheetSort()),
                    ),
                  ),
                  const VerticalDivider(
                    color: Colors.black,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
                  GestureDetector(
                    child: Row(
                      children: [
                        SizedBox(
                            height: 13,
                        //    child: Image.asset(assetFilter_icon)
                        ),
                        const Text(" Filter")
                      ],
                    ),
                    onTap: () => showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      context: context,
                      builder: ((context) => bottomSheetFilters()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List sortOption = [
    {
      "option": "Popular",
    },
    {
      "option": "Discount",
    },
    {
      "option": "Price Low to High",
    },
    {
      "option": "Price High to Low",
    },
    {
      "option": "Name A to Z",
    },
    {
      "option": "Name Z to A",
    }
  ];
  List filterOption = [
    {
      "option": "AVAILABILITY",
    },
    {
      "option": "SUB-CATEGORY",
    },
    {
      "option": "BRANDS",
    },
    {
      "option": "MANUFACTURER",
    },
    {
      "option": "PRICE",
    },
    {
      "option": "DISCOUNT",
    }
  ];

  Color selectedColorFont = Colors.red;
  Color unselectedColorFont = Colors.black;
  Color selectedColorBorder = Colors.green;
  Color unselectedColorBorder = Colors.grey;

  String? selectedOptionSort;
  String? selectedOptionfilter;

  bottomSheetSort() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter state) {
      return Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              // height: MediaQuery.of(context).size.height / 3.5,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 40.h),
              // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 0.0,
                      offset: Offset(0.0, 0.0),
                    ),
                  ]),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 20, right: 20, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("SORT BY"),
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      // height: MediaQuery.of(context).size.height / 10,
                      height: 60.h,
                      child: ListView.builder(
                        itemExtent: 80,
                        scrollDirection: Axis.horizontal,
                        itemCount: sortOption.length,
                        itemBuilder: (context, index) {
                          final option = sortOption[index]["option"];
                          return InkWell(
                            child: Container(
                              margin: EdgeInsets.only(right: 10.w),
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: selectedOptionSort == option
                                          ? selectedColorBorder
                                          : unselectedColorBorder),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                sortOption[index]["option"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    color: selectedOptionSort == option
                                        ? selectedColorFont
                                        : unselectedColorFont),
                              ),
                            ),
                            onTap: () {
                              state(() {
                                selectedOptionSort = option;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.3,
                          child: ElevatedButton(
                            onPressed: () {},

                            child: const Text(
                              "CLEAR ALL",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.3,
                          child: ElevatedButton(
                            onPressed: () {},

                            child: const Text("APPLY"),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              // right: 0,
              child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height / 20,
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
            //  child: Image.asset(cancelButtonImg),
            ),
          ))
        ],
      );
    });
  }

  Color unselectedColor = Colors.white;

  bottomSheetFilters() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter state) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 15.h,
                    )),
                Text(
                  "Filters",
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Text(
                "FILTER BY",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: filterOption.length,
                    itemBuilder: (context, index) {
                      final option = filterOption[index]['option'];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            child: Container(
                              width: double.maxFinite,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20),
                              height: 40.h,
                              decoration: BoxDecoration(
                                  color: selectedOptionfilter == option
                                      ? Colors.white
                                      : Colors.grey.shade300),
                              child: Text(
                                filterOption[index]['option'],
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onTap: () {
                              state(() {
                                selectedOptionfilter = option;
                              });
                            },
                          ),
                          Divider(
                            height: 0,
                            thickness: 1.5,
                            color: Colors.grey.shade400,
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.3,
                  child: ElevatedButton(
                    onPressed: () {},

                    child: const Text("CLEAR ALL",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.3,
                  child: ElevatedButton(
                    onPressed: () {},

                    child: const Text("APPLY"),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    });
  }

  void qtyApi(
      {
        required param0,
      required int index,
      required num qty,
      required ApiType apiType}) {
    var itemData = {
      "productId": param0.data![index].id.toString(),
      "productName": param0.data![index].productName,
      "quantity": qty,
      "price": param0.data![index].price,
      "manufacture": param0.data![index].manufacture,
      "imageUrl": param0.data![index].imageUrl,
      "total": 1 * param0.data![index].price!.toInt(),
    };

    print("+data:: $itemData");

    switch (apiType) {
      case ApiType.add:


        break;
      case ApiType.remove:

        break;
    }
  }

  onSuccess(String value) {
    if (value == 'callApi') {
      setState(() {
      });
    }
  }

  onFailure(String error) {
    debugPrint(error);
  }
}
