import 'package:flutter/material.dart';

class ResponsiveGrid extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  final double spacing;
  final ScrollPhysics physics;
  final bool shrinkWrap;

  const ResponsiveGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.spacing = 12,
    this.physics = const NeverScrollableScrollPhysics(),
    this.shrinkWrap = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        double aspectRatio;

        if (constraints.maxWidth < 600) {
          crossAxisCount = 1;
          aspectRatio = 2.8;
        } else if (constraints.maxWidth < 1000) {
          crossAxisCount = 2;
          aspectRatio = 2.2;
        } else {
          crossAxisCount = 4;
          aspectRatio = 1.8;
        }

        return GridView.builder(
          shrinkWrap: shrinkWrap,
          physics: physics,
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: aspectRatio,
          ),
          itemBuilder: itemBuilder,
        );
      },
    );
  }
}