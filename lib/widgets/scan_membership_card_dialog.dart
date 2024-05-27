import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_pos/view_models/cart_view_model.dart';

import '../theme/theme.dart';

Future<String?> scanPointifyWallet() async {
  TextEditingController value = TextEditingController();
  String? result;
  await Get.dialog(Dialog.fullscreen(
    child: Container(
      width: Get.width * 0.5,
      height: 160,
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: value,
                decoration: InputDecoration(
                    hintText: "Quét mã Thành viên để tiếp tục",
                    hintStyle: POSTextTheme.bodyM,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    isDense: true,
                    labelStyle: POSTextTheme.labelL,
                    fillColor: ThemeColor.backgroundColor,
                    prefixIcon: const Icon(
                      Icons.portrait_rounded,
                      color: ThemeColor.onBackgroundColor,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        value.text = "";
                      },
                      icon: const Icon(Icons.clear),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                            color: ThemeColor.primaryColor, width: 2.0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                            color: ThemeColor.primaryColor, width: 2.0)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                            color: ThemeColor.primaryColor, width: 2.0)),
                    contentPadding: const EdgeInsets.all(16),
                    isCollapsed: true,
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                            color: ThemeColor.errorColor, width: 2.0))),
                onChanged: (value) {
                  result = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton.tonal(
                  onPressed: () {
                    Get.find<CartViewModel>().scanCustomer(value.text);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Tiếp tục', style: Get.textTheme.titleMedium),
                  )),
            ),
          ],
        ),
      ),
    ),
  ));
  return result;
}
