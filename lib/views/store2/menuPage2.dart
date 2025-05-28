import 'package:flutter/material.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_info.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_widget_options.dart';
import 'package:tosspayments_widget_sdk_flutter/payment_widget.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/agreement.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/payment_method.dart';

import '../../../core/components/bundle_tile_square.dart';
import '../../../core/constants/constants.dart';
import '../../../core/constants/dummy_data.dart';

class menuPage2 extends StatelessWidget {
  const menuPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상점 페이지'),
      ),
      backgroundColor: const Color(0xFFFFFBF7),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40.0),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
            child: Text(
              '구매하고 싶은 캐릭터를 선택하세요',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 16.0),
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: AppDefaults.padding),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                Dummy.bundles.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: AppDefaults.padding),
                  child: BundleTileSquare(
                    data: Dummy.bundles[index],
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: SizedBox(
                            width: 400,
                            height: 600,
                            child: PaymentWidgetDialog(
                              orderId:
                                  'order_${DateTime.now().millisecondsSinceEpoch}',
                              orderName: Dummy.bundles[index].name,
                              amount: (Dummy.bundles[index].price ?? 0).toInt(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32.0),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
            child: Text(
              '원하는 캐릭터를 선택해 다양한 목소리와 함께 대화를 시작해보세요!',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentWidgetDialog extends StatefulWidget {
  final String orderId;
  final String orderName;
  final int amount;

  const PaymentWidgetDialog({
    super.key,
    required this.orderId,
    required this.orderName,
    required this.amount,
  });

  @override
  State<PaymentWidgetDialog> createState() => _PaymentWidgetDialogState();
}

class _PaymentWidgetDialogState extends State<PaymentWidgetDialog> {
  late PaymentWidget _paymentWidget;
  PaymentMethodWidgetControl? _paymentMethodWidgetControl;
  AgreementWidgetControl? _agreementWidgetControl;

  @override
  void initState() {
    super.initState();

    _paymentWidget = PaymentWidget(
      clientKey: "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm",
      customerKey: "a1b2c3d4e5f67890",
    );

    _paymentWidget
        .renderPaymentMethods(
            selector: 'methods',
            amount: Amount(
                value: widget.amount, currency: Currency.KRW, country: "KR"))
        .then((control) {
      _paymentMethodWidgetControl = control;
    });

    _paymentWidget.renderAgreement(selector: 'agreement').then((control) {
      _agreementWidgetControl = control;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                PaymentMethodWidget(
                  paymentWidget: _paymentWidget,
                  selector: 'methods',
                ),
                AgreementWidget(
                  paymentWidget: _paymentWidget,
                  selector: 'agreement',
                ),
                ElevatedButton(
                  onPressed: () async {
                    final paymentResult = await _paymentWidget.requestPayment(
                        paymentInfo: PaymentInfo(
                      orderId: widget.orderId,
                      orderName: widget.orderName,
                    ));
                    if (paymentResult.success != null) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('결제 성공!')),
                      );
                    } else if (paymentResult.fail != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                '결제 실패: ${paymentResult.fail?.toString() ?? ''}')),
                      );
                    }
                  },
                  child: const Text('결제하기'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
