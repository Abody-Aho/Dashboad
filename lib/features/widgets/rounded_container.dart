import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

class RoundedContainer extends StatelessWidget {
  final Widget? child;
  final double radius;
  final double? width;
  final double? height;
  final bool showBorder;
  final bool showShadow;
  final Color borderColor;
  final EdgeInsets? margin;
  final EdgeInsets padding;
  final Color backgroundColor;
  final void Function()? onTap;

  const RoundedContainer({
    super.key,
    this.child,
     this.width,
     this.height,
    this.showBorder = false,
    this.showShadow = true,
    this.radius = 20,
    this.borderColor = Constants.primary,
    this.margin,
    this.padding = const EdgeInsets.all(10),
    this.backgroundColor = Colors.white,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(radius),
          border:  showBorder ? Border.all(color: borderColor) : null,
          boxShadow: [
            if (showShadow)
              BoxShadow(
                color: Constants.grey,
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3)
              )
          ]
        ),
        child: child,
      ),
    );
  }
}
