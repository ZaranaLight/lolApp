import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

import '../Color.dart';

class SimpleDropdown extends StatelessWidget {
  const SimpleDropdown({
    Key? key,
    required this.controller,
    required this.items,
    required this.hint,
    this.size,
  }) : super(key: key);

  final TextEditingController controller;
  final List<String> items;
  final String hint;
  final double? size; // Change the type to double

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: dialpgColor)),
        child: Center(
          child: CustomDropdown.search(
            hintText: hint,
            items: items,
            controller: controller,
            excludeSelected: false,
          ),
        ),
      ),
    );
  }
}
