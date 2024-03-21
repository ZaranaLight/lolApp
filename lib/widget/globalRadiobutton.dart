import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Color.dart';

class RadioOptionsWidget extends StatelessWidget {
  final String title;
  final List<String> options;
  final RxString selectedOption;
  final void Function(String?) onChanged;

  RadioOptionsWidget({
    required this.title,
    required this.options,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        Container(
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius:
                BorderRadius.circular(5), // Set the border radius here
            border: Border.all(
              color: blackColor.withOpacity(0.4), // Set border color if needed
            ),
          ),
          child: Obx(
            () => Row(children: [
              ...options
                  .map(
                    (option) => Expanded(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text(option),
                        leading: Radio(
                          activeColor: primaryColor,
                          value: option,
                          groupValue: selectedOption.value,
                          onChanged: onChanged,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ]),
          ),
        ),
      ],
    );
  }
}
