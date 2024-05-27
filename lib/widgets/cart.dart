import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/cart_model.dart';
import '../utils/format.dart';

Widget cartItem(ProductList item, int index) {
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
              formatPrice(item.sellingPrice!),
              style: Get.textTheme.bodyMedium,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "${item.quantity}",
              style: Get.textTheme.bodyMedium,
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: AlignmentDirectional.topEnd,
              child: Column(
                children: [
                  Text(
                    formatPrice(item.finalAmount ?? 0),
                    style: Get.textTheme.bodyMedium,
                  ),
                  item.discount != null && item.discount != 0
                      ? Text(
                          "-${formatPrice(item.discount ?? 0)}",
                        )
                      : const SizedBox.shrink(),
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
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: Text(
                  " +${item.extras![i].name!}",
                  style: Get.textTheme.bodySmall,
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${item.extras![i].quantity}",
                      style: Get.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(
                    "+${formatPrice(item.extras![i].totalAmount!)}",
                    style: Get.textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Row(
            children: [
              if (item.attributes != null)
                for (int i = 0; i < item.attributes!.length; i++)
                  Text(
                      (item.attributes![i].value != null &&
                              item.attributes![i].value!.isNotEmpty)
                          ? "${item.attributes![i].name}:${item.attributes![i].value}, "
                          : "",
                      style: Get.textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
              Text(item.note ?? '',
                  style: Get.textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    ],
  );
}
