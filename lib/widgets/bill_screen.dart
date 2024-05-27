import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:smart_pos/models/order_detail_model.dart';
import 'package:smart_pos/theme/theme.dart';
import 'package:smart_pos/utils/format.dart';

import '../enums/order_enum.dart';
import '../enums/status_enums.dart';
import '../view_models/index.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({super.key});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<OrderViewModel>(
        builder: (context, build, model) {
      if (model.status == ViewStatus.Loading || model.currentOrder == null) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return Container(
        padding: const EdgeInsets.all(16),
        width: Get.width,
        height: Get.height,
        decoration: BoxDecoration(
          color: ThemeColor.backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child:
                          Text("Thanh toán", style: Get.textTheme.titleSmall),
                    ),
                    const Divider(
                      color: ThemeColor.surfaceColor,
                      thickness: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 7,
                            child: Text(
                              'Sản phẩm',
                              style: Get.textTheme.bodyMedium,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Đơn giá',
                              style: Get.textTheme.bodyMedium,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'SL',
                              style: Get.textTheme.bodyMedium,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Tổng',
                                style: Get.textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: ThemeColor.surfaceColor,
                      thickness: 2,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: model.currentOrder!.productList!.length,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, i) {
                        return productItem(model.currentOrder!.productList![i]);
                      },
                    ),
                    const Divider(
                      color: ThemeColor.surfaceColor,
                      thickness: 2,
                    ),
                    customerInfo(model.currentOrder?.customerInfo),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Mã đơn',
                          style: Get.textTheme.bodyMedium,
                        ),
                        Text(
                          model.currentOrder!.invoiceId!,
                          style: Get.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Trạng thái đơn hàng',
                          style: Get.textTheme.bodyMedium,
                        ),
                        Text(
                          showOrderStatus(
                              model.currentOrder!.orderStatus ?? ""),
                          style: Get.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Thời gian',
                          style: Get.textTheme.bodyMedium,
                        ),
                        Text(
                          formatTime(model.currentOrder?.checkInDate ?? ""),
                          style: Get.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Thanh toán',
                          style: Get.textTheme.bodyMedium,
                        ),
                        Text(
                          getPaymentName(model.currentOrder!.paymentType ?? ""),
                          style: Get.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const Divider(
                      color: ThemeColor.surfaceColor,
                      thickness: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Tạm tính',
                          style: Get.textTheme.bodyMedium,
                        ),
                        Text(
                          formatPrice(model.currentOrder!.totalAmount!),
                          style: Get.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    model.currentOrder!.promotionList != null
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                model.currentOrder!.promotionList!.length,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, i) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "- ${model.currentOrder!.promotionList![i].promotionName}",
                                    style: Get.textTheme.bodySmall,
                                  ),
                                  Text(
                                    model.currentOrder!.promotionList![i]
                                                .effectType ==
                                            "GET_POINT"
                                        ? ("+${model.currentOrder!.promotionList![i].discountAmount} Điểm")
                                        : ("- ${formatPrice(model.currentOrder!.promotionList![i].discountAmount ?? 0)}"),
                                    style: Get.textTheme.bodySmall,
                                  ),
                                ],
                              );
                            },
                          )
                        : const SizedBox(),
                    model.currentOrder!.discount != 0
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Tổng giảm",
                                  style: Get.textTheme.bodyMedium,
                                ),
                                Text(
                                  " - ${formatPrice(model.currentOrder!.discount ?? 0)}",
                                  style: Get.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    const Divider(
                      color: ThemeColor.surfaceColor,
                      thickness: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Tổng tiền',
                          style: Get.textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        Text(formatPrice(model.currentOrder!.finalAmount!),
                            style: Get.textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget customerInfo(CustomerInfo? info) {
    if (info == null) {
      return const SizedBox();
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Khách hàng',
              style: Get.textTheme.bodyMedium,
            ),
            Text(
              info.name ?? "Khách",
              style: Get.textTheme.bodyMedium,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Trạng thái thanh toán',
              style: Get.textTheme.bodyMedium,
            ),
            Text(
              showPaymentStatusEnum(
                  info.paymentStatus ?? PaymentStatusEnum.PENDING),
              style: Get.textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}

Widget productItem(ProductList item) {
  return Column(
    children: [
      Row(
        textDirection: TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 7,
            child: Text(
              item.name!,
              style: Get.textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.clip,
            ),
          ),
          Expanded(
              flex: 2,
              child: Text(
                formatPrice(item.sellingPrice ?? 0),
                style: Get.textTheme.bodyMedium,
              )),
          Expanded(
            flex: 1,
            child: Text(
              "${item.quantity}",
              style: Get.textTheme.bodyLarge,
            ),
          ),
          Expanded(
            flex: 3,
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Column(
                children: [
                  Text(
                    formatPrice(item.finalAmount!),
                    style: Get.textTheme.bodyLarge,
                  ),
                  item.discount != 0
                      ? Text(
                          "-${formatPrice(item.discount!)}",
                          style: Get.textTheme.bodyMedium,
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
      ListView.builder(
        shrinkWrap: true,
        itemCount: item.extras?.length,
        physics: const ScrollPhysics(),
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 0, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: Text(
                    "+${item.extras![i].name!}",
                    style: Get.textTheme.bodyMedium,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      formatPrice(item.extras![i].sellingPrice!),
                      style: Get.textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      if (item.note != null)
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(item.note ?? '',
                style: Get.textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
        ),
    ],
  );
}

void hideDialog() {
  if (Get.isDialogOpen ?? false) {
    Get.back();
  }
}

void hideSnackbar() {
  if (Get.isSnackbarOpen) {
    Get.back();
  }
}

void hideBottomSheet() {
  if (Get.isBottomSheetOpen ?? false) {
    Get.back();
  }
}

Future<String?> inputDialog(String title, String hint, String? value,
    {bool isNum = false}) async {
  hideDialog();
  String? result;
  await Get.dialog(AlertDialog(
    title: Text(title),
    content: TextField(
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      inputFormatters:
          isNum ? [FilteringTextInputFormatter.digitsOnly] : null, // Only numb
      controller: TextEditingController(text: value),
      decoration: InputDecoration(hintText: hint),
      onChanged: (value) {
        result = value;
      },
    ),
    actions: [
      TextButton(
          onPressed: () {
            Get.back(result: result);
          },
          child: const Text('Cập nhật')),
      TextButton(
          onPressed: () {
            Get.back(result: value);
          },
          child: const Text('Huỷ')),
    ],
  ));
  return result;
}
