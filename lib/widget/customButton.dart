import 'package:flutter/material.dart';

import '../Color.dart';
import '../dimentions.dart';

class ButtonWight extends StatelessWidget {
  final String? buttonText;
  final String? tag;
  final Color? buttonTextColor;
  final bool? borderButton;
  final bool? isReviewButton;
  final double? width;
  final double? height;
  final Function? onClick;
  final bool? loading;
  final bool? isReactangle;
  const ButtonWight(
      {key,
      this.buttonText,
      this.onClick,
      this.height,
      this.width,
      this.borderButton,
      this.isReviewButton,
      this.buttonTextColor,
      this.loading = false,
      this.tag,
      this.isReactangle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {onClick!()},
      child: Hero(
        tag: tag ?? '',
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              /*color: borderButton!
                  ? ColorssA.whiteColor
                  : ColorssA.primaryColor,*/
              gradient: AppLinears,
              border: Border.all(
                color: Theme.of(context).primaryColor,

                width: 0, //                   <--- border width here
              ),
              borderRadius: isReactangle == true
                  ? BorderRadius.circular(10)
                  : BorderRadius.circular(10)),
          child: Center(
            child: !loading!
                ? DefaultTextStyle(
                    style: TextStyle(),
                    child: Text(
                      buttonText!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                      style: TextStyle(
                          fontFamily: 'Metropolis',
                          decoration: TextDecoration.none,
                          fontSize: Dimensions
                              .fontSizeLarge15 /*isReviewButton == true
                              ? Dimensions.fontSizeLarge15
                              : 17*/
                          ,
                          color: /* borderButton!
                              ? Theme.of(context).hintColor
                              : */
                              whiteColor,
                          fontWeight: FontWeight.w700),
                    ),
                  )
                : CircularProgressIndicator(
                    value: null,
                    strokeWidth: 3.0,
                    color: borderButton!
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).secondaryHeaderColor,
                  ),
          ),
        ),
      ),
    );
  }
}
