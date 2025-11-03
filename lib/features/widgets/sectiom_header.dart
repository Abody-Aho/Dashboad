import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    this.texColor,
     this.rightSideWidget,
    required this.title,
  });

  final Color? texColor;
  final Widget? rightSideWidget;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
        style: Theme.of(context).textTheme!.headlineSmall!.apply(color: texColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        ),
        if(rightSideWidget != null) rightSideWidget!

      ],
    );
  }
}
