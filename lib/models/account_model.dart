class AccountModel {
  String? storeId;
  String? storeCode;
  String? brandId;
  String? brandCode;
  String? accessToken;
  String? id;
  String? username;
  String? name;
  String? role;
  String? status;
  String? brandPicUrl;

  AccountModel(
      {this.storeId,
      this.storeCode,
      this.brandId,
      this.brandCode,
      this.accessToken,
      this.id,
      this.username,
      this.name,
      this.role,
      this.status,
      this.brandPicUrl});

  AccountModel.fromJson(Map<String, dynamic> json) {
    storeId = json['storeId'];
    storeCode = json['storeCode'];
    brandId = json['brandId'];
    brandCode = json['brandCode'];
    accessToken = json['accessToken'];
    id = json['id'];
    username = json['username'];
    name = json['name'];
    role = json['role'];
    status = json['status'];
    brandPicUrl = json['brandPicUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['storeId'] = storeId;
    data['storeCode'] = storeCode;
    data['brandId'] = brandId;
    data['brandCode'] = brandCode;
    data['accessToken'] = accessToken;
    data['id'] = id;
    data['username'] = username;
    data['name'] = name;
    data['role'] = role;
    data['status'] = status;
    data['brandPicUrl'] = brandPicUrl;
    return data;
  }
}
