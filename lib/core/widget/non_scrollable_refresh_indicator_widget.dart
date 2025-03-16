import 'package:flutter/material.dart';

class NonScrollableRefreshIndicatorWidget extends StatelessWidget {
  final Widget? child;
  final Future<void> Function() onRefresh;
  const NonScrollableRefreshIndicatorWidget({super.key, this.child, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          onRefresh();
        },
        child: CustomScrollView(
          slivers: <Widget>[
            SliverFillRemaining(
              child: child,
            ),
          ],
        )
    );
  }
}
