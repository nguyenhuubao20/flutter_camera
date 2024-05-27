import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:smart_pos/view_models/index.dart';

import '../theme/theme.dart';
import '../widgets/bill_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String id;
  const PaymentScreen({
    super.key,
    required this.id,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  OrderViewModel orderViewModel = OrderViewModel();
  bool isQrCodeOpen = false;
  @override
  void initState() {
    orderViewModel.getOrderDetails(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.surfaceColor,
      body: ScopedModel(
          model: orderViewModel,
          child: ScopedModelDescendant<OrderViewModel>(
              builder: (context, build, model) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Expanded(child: BillScreen()),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 80,
                            padding: const EdgeInsets.all(8.0),
                            child: FilledButton(
                                onPressed: () {
                                  model.completeOrder(widget.id);
                                },
                                child: const Text("Thanh toán")),
                          ),
                        ),
                        Container(
                          height: 80,
                          width: 160,
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                              onPressed: () {
                                model.cancelOrder();
                              },
                              child: Text(
                                "Hủy đơn",
                                style: POSTextTheme.bodyL
                                    .copyWith(color: ThemeColor.errorColor),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          })),
    );
  }
}
