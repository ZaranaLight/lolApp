import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Unils/sizes.dart';
import '../dimentions.dart';
import '../styles.dart';
import 'customButton.dart';

void showCustomSnackBar(String message, BuildContext context,
    {bool isError = true}) {
  if (message != null && message.isNotEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.horizontal,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

showPopUpDialog(String message, BuildContext context,
    {bool isApplyForm = false,
    bool isSkillPopup = false,
    isChangePassword = false,
    VoidCallback? onClickYes,
    Widget? widgetIcon,
    VoidCallback? onClickNo}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.all(30),
          backgroundColor: Theme.of(context).colorScheme.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              width: 1,
              color: Theme.of(context).colorScheme.background,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Sizes.normalHeight,
                widgetIcon ??
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.lightBlueAccent,
                    ),
                Sizes.normalHeight,
                Container(
                  alignment: Alignment.topRight,
                  child: (isApplyForm == true || isSkillPopup == true)
                      ? IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Theme.of(context).hintColor,
                          ))
                      : Container(),
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: poppinsMedium.copyWith(
                            color: isApplyForm == true
                                ? Theme.of(context).hintColor.withOpacity(0.7)
                                : Theme.of(context).hintColor,
                            fontSize: isApplyForm == true
                                ? Dimensions.fontSizeDefault
                                : Dimensions.fontSizeOverLarge22,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Get.height * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: ButtonWight(
                        height: 45,
                        width: Get.width * 0.3,
                        buttonText: 'Cancel',
                        borderButton: false,
                        // isLightButton: false,
                        // size: 15,
                        onClick: onClickNo,
                      ),
                    ),
                    if (isChangePassword == true)
                      SizedBox(
                        width: Get.width * 0.04,
                      ),
                    if (isChangePassword == true)
                      Center(
                        child: ButtonWight(
                          height: 45,
                          width: Get.width * 0.3,
                          buttonText: 'Yes',
                          borderButton: false,
                          // isLightButton: false,
                          // size: 15,
                          onClick: onClickYes,
                        ),
                      ),
                  ],
                ),
                // if (isChangePassword == true)
                //   SizedBox(
                //     height: Get.height * 0.04,
                //   ),
                // if (isChangePassword == true)
                //   Center(
                //     child: ButtonWight(
                //       height: 45,
                //       width: Get.width * 0.3,
                //       buttonText: 'Yes',
                //       borderButton: false,
                //       isLightButton: false,
                //       size: 15,
                //       onClick: onClickYes,
                //     ),
                //   ),
                SizedBox(
                  height: Get.height * 0.04,
                ),
              ],
            ),
          ),
        );
      });
}

showPopUpSellDialog(
  String message,
  BuildContext context, {
  VoidCallback? onClickYes,
  VoidCallback? onClickNo,
  TextEditingController? textEditingController,
}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.all(30),
          backgroundColor: Theme.of(context).colorScheme.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              width: 1,
              color: Theme.of(context).colorScheme.background,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Sizes.normalHeight,
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: poppinsMedium.copyWith(
                        color: Theme.of(context).hintColor,
                        fontSize: Dimensions.fontSizeOverLarge22,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: Get.height * 0.04,
                  ),
                  TextField(
                    controller: textEditingController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color:
                                Theme.of(context).primaryColor), //<-- SEE HERE
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color:
                                Theme.of(context).primaryColor), //<-- SEE HERE
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.04,
                  ),
                  SizedBox(
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ButtonWight(
                          height: 45,
                          width: Get.width * 0.3,
                          buttonText: 'Sell it!',
                          borderButton: false,
                          // isLightButton: false,
                          // size: 15,
                          onClick: onClickYes,
                        ),
                        ButtonWight(
                          height: 45,
                          width: Get.width * 0.3,
                          buttonText: 'Cancel',
                          borderButton: true,
                          // buttonBgColor:
                          // Theme.of(context).primaryColor.withOpacity(0.2),
                          // isLightButton: true,
                          buttonTextColor: Theme.of(context).primaryColor,
                          // size: 15,
                          onClick: onClickNo,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.04,
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
