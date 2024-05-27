import 'dart:convert';

import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:smart_pos/enums/status_enums.dart';
import 'package:smart_pos/models/index.dart';
import 'package:smart_pos/services/index.dart';
import 'package:smart_pos/services/order_services.dart';
import 'package:smart_pos/utils/share_pref.dart';
import 'package:smart_pos/view_models/index.dart';

import '../enums/order_enum.dart';
import '../models/customer.dart';
import '../models/product_scan_model.dart';
import '../models/promotion_model.dart';
import '../utils/routes_constraints.dart';
import '../widgets/dialog.dart';

class CartViewModel extends Model {
  CartModel cart = CartModel();
  AccountServices accountData = AccountServices();
  OrderServices orderServices = OrderServices();
  List<PromotionPointify>? promotions = [];
  dynamic message;
  RedisService redisService = RedisService();
  PromotionServices promotionServices = PromotionServices();
  bool checkingStatus = false;
  CustomerInfoModel? customer;
  late ViewStatus status;
  List<PaymentProvider> listPayment = [
    PaymentProvider(
        name: "Thẻ thành viên",
        type: PaymentTypeEnums.POINTIFY,
        picUrl:
            "https://firebasestorage.googleapis.com/v0/b/pos-system-47f93.appspot.com/o/files%2Fpointify.jpg?alt=media&token=c1953b7c-23d4-4fb6-b866-ac13ae639a00")
  ];
  CartViewModel() {
    cart.productList = [];
    cart.promotionList = [];
    cart.paymentType = PaymentTypeEnums.POINTIFY;
    cart.totalAmount = 0;
    cart.finalAmount = 0;
    cart.bonusPoint = 0;
    cart.shippingFee = 0;
    cart.customerId = null;
    cart.promotionCode = null;
    cart.voucherCode = null;
    cart.orderType = DeliType().takeAway.type;
    cart.customerNumber = 1;
    status = ViewStatus.Completed;
  }

  Future scanCustomer(String phone) async {
    try {
      setState(ViewStatus.Loading);
      customer = await accountData.scanCustomer(phone);
      cart.customerId = customer?.id;
      await redisService.setDataToRedis("status", "SCAN");
      checkingStatus = true;
      hideDialog();
      notifyListeners();
      setState(ViewStatus.Completed);
    } catch (e) {
      setState(ViewStatus.Error, e.toString());
    }
  }

  Future scanProductFromRedis() async {
    try {
      if (checkingStatus == false) {
        return;
      } else {
        var res = await redisService.getDataFromRedis("products");
        message = await redisService.getDataFromRedis("message");
        List<ProductScanModel> list = ProductScanModel.fromList(
            List<Map<String, dynamic>>.from(
                jsonDecode(res.replaceAll("'", '"'))));
        if (list.isEmpty) {
          return;
        } else {
          cart.productList = [];

          for (ProductScanModel item in list) {
            print(item.code);
            addToCart(item);
          }
        }

        countCartAmount();
        countCartQuantity();
        setState(ViewStatus.Completed);
      }
    } catch (e) {
      setState(ViewStatus.Error, e.toString());
    }
  }

  void setState(ViewStatus newState, [String? msg]) {
    status = newState;
    msg = msg;
    notifyListeners();
  }

  Future<void> addToCart(ProductScanModel product) async {
    Product? productInfo = Get.find<MenuViewModel>()
        .normalProducts
        ?.firstWhereOrNull((element) => element.code == product.code);
    if (productInfo == null) {
      return;
    }
    ProductList productToAdd = ProductList(
        productInMenuId: productInfo.menuProductId,
        parentProductId: productInfo.parentProductId,
        name: productInfo.name,
        type: productInfo.type,
        quantity: product.quantity,
        code: product.code,
        categoryCode: Get.find<MenuViewModel>()
            .currentMenu!
            .categories!
            .firstWhereOrNull((element) => element.id == productInfo.categoryId)
            ?.code,
        sellingPrice: productInfo.sellingPrice,
        totalAmount: productInfo.sellingPrice! * (product.quantity ?? 1),
        finalAmount: productInfo.sellingPrice! * (product.quantity ?? 1),
        discount: 0,
        extras: [],
        attributes: []);
    cart.productList!.add(productToAdd);
    notifyListeners();
  }

  Future<void> updateCart(ProductList cartModel, int cartIndex) async {
    cart.productList![cartIndex] = cartModel;
    countCartAmount();
    countCartQuantity();
    // await prepareOrder();
    notifyListeners();
  }

  void countCartAmount() {
    cart.totalAmount = 0;
    cart.discountAmount = 0;
    for (ProductList item in cart.productList!) {
      cart.totalAmount = cart.totalAmount! + item.totalAmount!;
    }
    cart.finalAmount = cart.totalAmount! - cart.discountAmount!;
  }

  countCartQuantity() {
    num quantity = 0;
    for (ProductList item in cart.productList!) {
      quantity = quantity + item.quantity!;
    }
    return quantity;
  }

  bool isPromotionApplied(String code) {
    return cart.promotionCode == code;
  }

  Future<void> clearCartData() async {
    customer = null;
    checkingStatus = false;
    cart.paymentType = PaymentTypeEnums.POINTIFY;
    cart.orderType = DeliType().eatIn.type;
    cart.customerNumber = 1;
    cart.productList = [];
    cart.finalAmount = 0;
    cart.totalAmount = 0;
    cart.discountAmount = 0;
    cart.promotionList = [];
    cart.voucherCode = null;
    cart.promotionCode = null;
    cart.bonusPoint = 0;
    cart.shippingFee = 0;
    cart.customerId = null;
    cart.customerName = null;
    await redisService.setDataToRedis("status", "STOP");
    notifyListeners();
  }

  Future getListPromotion() async {
    try {
      promotions = await promotionServices.getListPromotionOfStore();
    } catch (e) {
      setState(ViewStatus.Error, e.toString());
    }
  }

  bool isPromotionExist(String code) {
    return cart.promotionCode == code;
  }

  Future<void> removePromotion() async {
    cart.promotionCode = null;
    cart.voucherCode = null;
    // await prepareOrder();
    notifyListeners();
  }

  Future<void> selectPromotion(String code) async {
    cart.promotionCode = code;
    cart.voucherCode = null;
    // await prepareOrder();
    notifyListeners();
  }

  Future<void> removeVoucher() async {
    cart.voucherCode = null;
    cart.promotionCode = null;
    // await prepareOrder();
    notifyListeners();
  }

  void setCartNote(String note) {
    cart.notes = note;
    notifyListeners();
  }

  Future<void> prepareOrder() async {
    cart.paymentType = PaymentTypeEnums.POINTIFY;
    cart.discountAmount = 0;
    cart.bonusPoint = 0;
    cart.customerId = customer?.id;
    cart.customerName = customer?.fullName;
    cart.finalAmount = cart.totalAmount;
    for (var element in cart.productList!) {
      element.discount = 0;
      element.finalAmount = element.totalAmount;
      element.promotionCodeApplied = null;
    }
    cart.promotionList!.clear();
    if (cart.promotionCode == null &&
        cart.voucherCode == null &&
        cart.customerId == null) {
      return;
    }
    var storeId = await getStoreId();
    await orderServices.prepareOrder(cart, storeId ?? '').then((value) => {
          cart = value,
        });
  }

  Future<void> createOrder() async {
    await prepareOrder();
    for (var item in cart.productList!) {
      if (item.attributes != null) {
        for (var attribute in item.attributes!) {
          item.note = (attribute.value != null && attribute.value!.isNotEmpty)
              ? "${attribute.name} ${attribute.value}, ${item.note}"
              : item.note;
        }
      }
    }
    var storeId = await getStoreId();
    orderServices.createOrder(cart, storeId!).then((value) async => {
          if (value != null)
            {
              await clearCartData(),
              Get.toNamed(
                "${RouteHandler.PAYMENT}?id=$value",
              )
            }
        });
  }
}
