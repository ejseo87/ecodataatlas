import 'package:ecodataatlas/constants/gaps.dart';
import 'package:ecodataatlas/constants/sizes.dart';
import 'package:flutter/material.dart';


class ProfileDetailCard extends StatelessWidget {
  final String numberString;
  final String numberLabel;
  const ProfileDetailCard({
    super.key,
    required this.numberString,
    required this.numberLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          numberString,
          style: const TextStyle(
            fontSize: Sizes.size18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Gaps.v3,
        Text(
          numberLabel,
          style: TextStyle(color: Colors.grey.shade500, fontSize: Sizes.size14),
        ),
      ],
    );
  }
}
