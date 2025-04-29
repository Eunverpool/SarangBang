import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_defaults.dart';

import '../../../core/components/app_back_button.dart';

class AddNewCardPage extends StatefulWidget {
  const AddNewCardPage({super.key});

  @override
  State<AddNewCardPage> createState() => _AddNewCardPageState();
}

class _AddNewCardPageState extends State<AddNewCardPage> {
  late TextEditingController cardNumber;
  late TextEditingController expireDate;
  late TextEditingController cvv;
  late TextEditingController holderName;

  bool rememberMyCard = false;

  onTextChanged(v) {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    cardNumber = TextEditingController();
    expireDate = TextEditingController();
    holderName = TextEditingController();
    cvv = TextEditingController();
  }

  @override
  void dispose() {
    cardNumber.dispose();
    expireDate.dispose();
    holderName.dispose();
    cvv.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('카드 추가'),
      ),
      backgroundColor: AppColors.cardColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: AppDefaults.padding / 2),
            CreditCardWidget(
              cardNumber: cardNumber.text,
              expiryDate: expireDate.text,
              cardHolderName: holderName.text,
              isHolderNameVisible: true,
              backgroundNetworkImage: 'https://i.imgur.com/AMA5llS.png',
              cvvCode: cvv.text,
              showBackView: false,
              cardType: CardType.visa,
              onCreditCardWidgetChange: (v) {},
              isChipVisible: false,
            ),
            CreditCardForm(
              cardNumber: cardNumber,
              expireDate: expireDate,
              cvv: cvv,
              holderName: holderName,
              rememberMyCard: rememberMyCard,
              onTextChanged: onTextChanged,
              onRememberMyCardChanged: (v) {
                rememberMyCard = !rememberMyCard;
                if (mounted) setState(() {});
              },
            )
          ],
        ),
      ),
    );
  }
}

class CreditCardForm extends StatelessWidget {
  const CreditCardForm({
    super.key,
    required this.cardNumber,
    required this.expireDate,
    required this.cvv,
    required this.holderName,
    required this.rememberMyCard,
    required this.onTextChanged,
    required this.onRememberMyCardChanged,
  });

  final TextEditingController cardNumber;
  final TextEditingController expireDate;
  final TextEditingController cvv;
  final TextEditingController holderName;
  final bool rememberMyCard;
  final void Function(String?) onTextChanged;
  final void Function(bool v) onRememberMyCardChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDefaults.padding),
      margin: const EdgeInsets.all(AppDefaults.padding),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: AppDefaults.borderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("카드 소유자 이름", style: TextStyle(color: Colors.black)),
          const SizedBox(height: 8),
          TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            controller: holderName,
            onChanged: onTextChanged,
            decoration: const InputDecoration(
              hintText: '카드에 표시된 이름과 동일하게 입력하세요',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: AppDefaults.padding),
          const Text("카드 번호", style: TextStyle(color: Colors.black)),
          const SizedBox(height: 8),
          TextFormField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            controller: cardNumber,
            onChanged: onTextChanged,
          ),
          const SizedBox(height: AppDefaults.padding),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("만료일", style: TextStyle(color: Colors.black)),
                    const SizedBox(height: 8),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      controller: expireDate,
                      onChanged: onTextChanged,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDefaults.padding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("보안 코드(CVV)",
                        style: TextStyle(color: Colors.black)),
                    const SizedBox(height: 8),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      controller: cvv,
                      onChanged: onTextChanged,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDefaults.padding),
          Row(
            children: [
              Text(
                '내 카드 정보 기억하기',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black,
                    ),
              ),
              const Spacer(),
              Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  value: rememberMyCard,
                  onChanged: onRememberMyCardChanged,
                ),
              )
            ],
          ),
          const SizedBox(height: AppDefaults.padding),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('등록하기'),
            ),
          ),
          const SizedBox(height: AppDefaults.padding),
        ],
      ),
    );
  }
}
