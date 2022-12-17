class ModelProductList {
  String? status;
  List<ProductData>? data;


  ModelProductList({this.status, this.data});

  ModelProductList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <ProductData>[];
      json['data'].forEach((v) {
        data!.add(new ProductData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductData {
  String? id;
  String? productName;
  String? categoryName;
  String? model;
  num? price;
  num? quantity;
  num? cartQuantity;
  String? manufacture;
  String? imageUrl;

  ProductData(
      {
        this.id,
        this.productName,
        this.categoryName,
        this.model,
        this.price,
        this.quantity,
        this.cartQuantity,
        this.manufacture,
        this.imageUrl});

  ProductData.fromJson(Map<String, dynamic> json) {
    productName = json['productName'];
    id = json['id'];
    categoryName = json['categoryName'];
    model = json['model'];
    price = json['price'];
    quantity = json['quantity'];
    cartQuantity = json['cartQuantity'];
    manufacture = json['manufacture'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productName'] = this.productName;
    data['id'] = this.id;
    data['categoryName'] = this.categoryName;
    data['model'] = this.model;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['cartQuantity'] = this.cartQuantity;
    data['manufacture'] = this.manufacture;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}