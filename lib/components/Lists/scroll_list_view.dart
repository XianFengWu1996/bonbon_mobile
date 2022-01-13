import 'package:flutter/material.dart';

class ScrollListView extends StatelessWidget {
  final int length;
  final ScrollPhysics? physics;
  final Widget Function(BuildContext, int) itemBuilder;

  const ScrollListView({
    Key? key,
    required this.length,
    required this.itemBuilder,
    this.physics
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
        shrinkWrap: true,
        physics: physics ?? const AlwaysScrollableScrollPhysics(),
        itemCount: length,
        itemBuilder: itemBuilder
    );
  }
}
