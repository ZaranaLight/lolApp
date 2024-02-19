import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropDown extends StatelessWidget {
  CustomDropDown({
    Key? key,
    this.alignment,
    this.width,
    this.focusNode,
    this.icon,
    this.autofocus = true,
    this.textStyle,
    this.items,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = true,
    this.validator,
    this.onChanged,
  }) : super(
    key: key,
  );

  final Alignment? alignment;

  final double? width;

  final FocusNode? focusNode;

  final Widget? icon;

  final bool? autofocus;

  final TextStyle? textStyle;

  final List<String>? items;

  final String? hintText;

  final TextStyle? hintStyle;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;

  final FormFieldValidator<String>? validator;

  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
      alignment: alignment ?? Alignment.center,
      child: dropDownWidget,
    )
        : dropDownWidget;
  }

  Widget get dropDownWidget => SizedBox(
    width: width ?? double.maxFinite,
    child: DropdownButtonFormField(
      focusNode: focusNode ?? FocusNode(),
      icon: icon,
      autofocus: autofocus!,
      style: textStyle ,
      items: items?.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: hintStyle  ,
          ),
        );
      }).toList(),
      decoration: decoration,
      validator: validator,
      onChanged: (value) {
        onChanged!(value.toString());
      },
    ),
  );
  InputDecoration get decoration => InputDecoration(
    hintText: hintText ?? "",
    hintStyle: hintStyle  ,
    prefixIcon: prefix,
    prefixIconConstraints: prefixConstraints,
    suffixIcon: suffix,
    suffixIconConstraints: suffixConstraints,
    isDense: true,
    contentPadding: contentPadding ??
        EdgeInsets.only(
          left: 12 ,
          top: 0 ,
          bottom: 12 ,
        ),
    fillColor: Colors.white ,
    filled: filled,
    border: borderDecoration ??
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(8 ),
          borderSide: BorderSide(
            color: Theme.of(navigator!.context).disabledColor.withOpacity(0.3),
            width: 1,
          ),
        ),
    enabledBorder: borderDecoration ??
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(8 ),
          borderSide: BorderSide(
            color:Theme.of(navigator!.context).disabledColor.withOpacity(0.3),
            width: 1,
          ),
        ),
    focusedBorder: borderDecoration ??
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(8 ),
          borderSide: BorderSide(
            color: Theme.of(navigator!.context).disabledColor.withOpacity(0.3),
            width: 1,
          ),
        ),
  );
}

/// Extension on [CustomDropDown] to facilitate inclusion of all types of border style etc
extension DropDownStyleHelper on CustomDropDown {
  static OutlineInputBorder get outlineGrayTL10 => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8 ),
    borderSide: BorderSide(
      color: Theme.of(navigator!.context).disabledColor.withOpacity(0.3),
      width: 1,
    ),
  );
}
