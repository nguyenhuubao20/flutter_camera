import 'dart:core';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:smart_pos/enums/status_enums.dart';
import 'package:smart_pos/models/index.dart';
import 'package:smart_pos/models/order_detail_model.dart';
import 'package:smart_pos/services/order_services.dart';
import 'package:smart_pos/utils/routes_constraints.dart';
import 'package:smart_pos/utils/share_pref.dart';
import 'package:smart_pos/view_models/cart_view_model.dart';

import '../enums/order_enum.dart';
import '../models/payment_response_model.dart';
import '../widgets/dialog.dart';

class OrderViewModel extends Model {
  late OrderServices api;
  String? currentOrderId;
  num customerMoney = 0;
  num returnMoney = 0;
  String? paymentCode;
  ViewStatus status = ViewStatus.Completed;
  OrderDetailsModel? currentOrder;
  PaymentProvider payment = PaymentProvider(
      name: "Thẻ thành viên",
      type: PaymentTypeEnums.POINTIFY,
      picUrl:
          "https://firebasestorage.googleapis.com/v0/b/pos-system-47f93.appspot.com/o/files%2Fpointify.jpg?alt=media&token=c1953b7c-23d4-4fb6-b866-ac13ae639a00");
  OrderViewModel() {
    api = OrderServices();
  }

  void setState(ViewStatus newState, [String? msg]) {
    status = newState;
    msg = msg;
    notifyListeners();
  }

  void setPaymentCode(String code) {
    paymentCode = code;
    print(paymentCode);
  }

  String getPaymentName(String paymentType) {
    List<PaymentProvider> listPayment = Get.find<CartViewModel>().listPayment;
    for (var item in listPayment) {
      if (item.type == paymentType) {
        return item.name!;
      }
    }
    return "Tiền mặt";
  }

  // void scanMembership(String phone) async {
  //   try {
  //     setState(ViewStatus.Loading);
  //     memberShipInfo = await accountData.scanCustomer(phone);
  //     setState(ViewStatus.Completed);
  //     notifyListeners();
  //   } catch (e) {
  //     setState(ViewStatus.Error, e.toString());
  //     setState(ViewStatus.Completed);
  //   }
  // }

  void makePayment(PaymentProvider payment) async {
    // if (listPayment.isEmpty) {

    await completeOrder(currentOrder!.orderId ?? '');
    // } else {
    //   qrCodeData = null;
    //   if (currentOrder == null) {
    //     showAlertDialog(
    //         title: "Lỗi đơn hàng", content: "Không tìm thấy đơn hàng");

    //     return;
    //   }
    //   MakePaymentResponse makePaymentResponse =
    //       await api.makePayment(currentOrder!, payment.id ?? '');
    //   if (makePaymentResponse.displayType == "Url") {
    //     currentPaymentStatusMessage =
    //         makePaymentResponse.message ?? "Đợi thanh toán";
    //     // qrCodeData = payment.type != "VNPAY" ? makePaymentResponse.url : null;
    //     await launchInBrowser(makePaymentResponse.url ?? '');
    //   } else if (makePaymentResponse.displayType == "Qr") {
    //     currentPaymentStatusMessage =
    //         makePaymentResponse.message ?? "Đợi thanh toán";
    //     qrCodeData = makePaymentResponse.url;
    //     await launchQrCode(makePaymentResponse.url ?? '');
    //   } else {
    //     currentPaymentStatusMessage =
    //         makePaymentResponse.message ?? "Đợi thanh toán";
    //   }
    //   checkPaymentStatus(currentOrder!.orderId ?? '');
    //   notifyListeners();
    // }
  }

  Future<void> getOrderDetails(String orderId) async {
    setState(ViewStatus.Loading);
    currentOrder = await api.getOrderDetails(orderId);
    setState(ViewStatus.Completed);
  }

  Future<void> completeOrder(
    String orderId,
  ) async {
    String? storeId = await getStoreId();
    MakePaymentResponse? makePaymentResponse =
        await api.makePayment(orderId, PaymentTypeEnums.POINTIFY);
    if (makePaymentResponse?.status == "FAIL") {
      await showAlertDialog(
          title: "Lỗi thanh toán", content: makePaymentResponse?.message ?? '');
    } else if (makePaymentResponse?.status == "SUCCESS") {
      await api.updateOrder(storeId ?? '', orderId, OrderStatusEnum.PAID,
          makePaymentResponse?.paymentType);
      clearOrder();
      await showAlertDialog(
          title: "Thanh toán thành công",
          content: "Đơn hàng thanh toán thành công");
      Get.offNamed(RouteHandler.HOME);
    }
  }

  Future<void> cancelOrder() async {
    bool res = await showConfirmDialog(
        title: "Hủy đơn",
        content: "Bạn có chắc muốn hủy đơn hàng",
        confirmText: "Xác nhận hủy",
        cancelText: "Đóng");

    if (res) {
      await clearOrder();
      Get.offNamed(RouteHandler.HOME);
    } else {
      return;
    }
  }

  clearOrder() {
    currentOrderId = null;
    currentOrder = null;
    hideDialog();
  }
}
