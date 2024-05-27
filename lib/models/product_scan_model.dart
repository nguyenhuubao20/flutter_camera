class ProductScanModel {
  String? code;
  int? quantity;

  ProductScanModel({this.code, this.quantity});

  ProductScanModel.fromJson(Map<String, dynamic> json) {
    code = json['code'].toString();
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['quantity'] = quantity;
    return data;
  }

  static List<ProductScanModel> fromList(dynamic jsonList) {
    var list = jsonList as List;
    return list.map((map) => ProductScanModel.fromJson(map)).toList();
  }
}
