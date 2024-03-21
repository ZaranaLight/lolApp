import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../Color.dart';

class GlobalTypeAheadField<T> extends StatelessWidget {
  final TextEditingController controller;
  Future<List<T>> Function(String) fetchSuggestions;
  final Widget Function(BuildContext, T) itemBuilder;
  final Widget Function(BuildContext, T)? itemBuildertho;
  final void Function(T) onSuggestionSelected;
  final void Function(T)? onSuggestionRemoved;
  final void Function(T)? onTapOutside;
  final String label;
  final String hint;
  final bool isEnabled;
  dynamic floatingLabelBehavior;

  GlobalTypeAheadField(
      {required this.controller,
      required this.fetchSuggestions,
      required this.itemBuilder,
      this.itemBuildertho,
      required this.onSuggestionSelected,
      this.onSuggestionRemoved,
      this.onTapOutside,
      required this.label,
      required this.hint,
      required this.isEnabled,
      this.floatingLabelBehavior});

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<T>(
      textFieldConfiguration: TextFieldConfiguration(
        onTapOutside: (event) => onTapOutside,
        enabled: isEnabled,
        controller: controller,
        autofocus: false,
        decoration: InputDecoration(
          floatingLabelBehavior: floatingLabelBehavior,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.black,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: dialpgColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: 1,
                color: dialpgColor), // Change the border color when not focused
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: 1,
                color: dialpgColor), // Change the border color when focused
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: Icon(
            Icons.arrow_drop_down,
            size: 30,
          ),
        ),
      ),
      suggestionsCallback: (pattern) => fetchSuggestions(pattern),
      itemBuilder: (context, suggestion) => itemBuilder(context, suggestion),
      onSuggestionSelected: (suggestion) => onSuggestionSelected(suggestion),
    );
  }
}
