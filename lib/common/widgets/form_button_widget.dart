import 'package:ecodataatlas/constants/sizes.dart';
import 'package:flutter/material.dart';

class FormButtonWidget extends StatelessWidget {
  final bool isValid;
  final String text;
  const FormButtonWidget({
    super.key,
    required this.isValid,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: MediaQuery.of(context).size.width * 0.7,
      height: Sizes.size52,
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(vertical: Sizes.size12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isValid ? Theme.of(context).primaryColor : Color(0xFFF7CBF4),
        borderRadius: BorderRadius.circular(Sizes.size32),
        border: Border.all(width: Sizes.size2),
        boxShadow: [BoxShadow(color: Colors.black, offset: Offset(3, 3))],
      ),
      child: AnimatedDefaultTextStyle(
        duration: Duration(milliseconds: 300),
        style: TextStyle(
          color: isValid ? Colors.black : Colors.grey.shade500,
          fontSize: Sizes.size18,
          fontWeight: FontWeight.w600,
        ),
        child: Text(text),
      ),
    );
  }
}
