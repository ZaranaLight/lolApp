import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/homecontroller.dart';

class DropdownTextFiled extends StatefulWidget {
  final String? hint;
  final String? colorData;
  final ValueChanged<String>? onChanged;
  final bool? depth;
  final bool? isSelected;
  final bool? isFlagList;
  final bool? isEditProfile;
  final bool? isFilterScreen;
  final bool? loading;
  final bool? isStatusColor;

  DropdownTextFiled({
    @required this.hint,
    this.onChanged,
    this.depth = false,
    this.isSelected,
    this.isFlagList,
    this.isEditProfile,
    this.isFilterScreen,
    this.loading = false,
    this.isStatusColor,
    this.colorData,
  });

  @override
  __TextFieldState createState() => __TextFieldState();
}

class __TextFieldState extends State<DropdownTextFiled> {
  final Homecontroller homecontroller = Get.put(Homecontroller());
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.hint);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Homecontroller>(builder: (authController) {
      return Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: Get.width * 0.9,
            padding: const EdgeInsets.only(top: 10),
            child: !widget.loading!
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade200, width: 1),
                        borderRadius: BorderRadius.circular(6)),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (widget.isStatusColor == true)
                            if (widget.colorData != null &&
                                widget.colorData != 'null')
                              Container(
                                width: 15,
                                height: 15,
                                margin: EdgeInsets.only(right: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.transparent),
                              ),
                          Container(
                            height: 45,
                            width: widget.isStatusColor == true
                                ? Get.width * 0.5
                                : Get.width * 0.7,
                            child: Text(
                              widget.hint!,
                              maxLines: 2,
                              style: TextStyle(
                                  height: 2.5,
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: "Metropolis",
                                  fontSize:
                                      widget.isFlagList == false ? 14.0 : 18,
                                  color: widget.isSelected == false
                                      ? Theme.of(context)
                                          .hintColor
                                          .withOpacity(0.3)
                                      : Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.keyboard_arrow_down_outlined,
                            size: 25,
                            color: Theme.of(context).unselectedWidgetColor,
                          ),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.blue),
                    ),
                  ),
          ),
        ],
      );
    });
  }
}
