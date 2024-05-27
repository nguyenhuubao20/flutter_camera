import 'package:flutter/foundation.dart';
import 'package:smart_pos/models/order_detail_model.dart';

import '../models/index.dart';
import '../models/payment_response_model.dart';
import '../utils/request.dart';
import '../widgets/dialog.dart';

class OrderServices {
  Future placeOrder(OrderModel order, String storeId) async {
    var dataJson = order.toJson();
    final res = await request.post('stores/$storeId/orders', data: dataJson);
    var jsonList = res.data;
    return jsonList;
  }

  Future prepareOrder(CartModel cart, String storeId) async {
    cart.storeId = storeId;
    var dataJson = cart.toJson();
    final res = await request.post('/orders/prepare', data: dataJson);
    var jsonList = res.data;
    if (kDebugMode) {
      print(jsonList);
    }
    return CartModel.fromJson(jsonList);
  }

  Future createOrder(CartModel cart, String storeId) async {
    cart.storeId = storeId;
    var dataJson = cart.toJson();
    final res = await request.post('/orders/create', data: dataJson);
    var jsonList = res.data;
    print(jsonList);
    return jsonList;
  }

  Future<OrderDetailsModel?> getOrderDetails(String orderId) async {
    try {
      final res = await request.get('/orders/$orderId');
      var jsonList = res.data;
      OrderDetailsModel orderResponse = OrderDetailsModel.fromJson(jsonList);
      return orderResponse;
    } catch (e) {
      showAlertDialog(
          title: "Lỗi đơn hàng", content: "Không tìm thấy đơn hàng");
      return null;
    }
  }

  Future updateOrder(
    String storeId,
    String orderId,
    String? status,
    String? paymentType,
  ) async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['paymentType'] = paymentType;
    final res = await request.post('orders/$orderId/checkout',
        queryParameters: {'storeId': storeId}, data: data);
    var json = res.data;
    return json;
  }

  Future<MakePaymentResponse>? makePayment(
    String orderId,
    String? paymentType,
  ) async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['paymentType'] = paymentType;
    final res = await request.post('orders/$orderId/payment', data: data);
    var json = res.data;
    MakePaymentResponse? paymentResponse = MakePaymentResponse.fromJson(json);
    return paymentResponse;
  }
}
