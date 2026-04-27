import 'package:flutter/material.dart';
import 'package:mona/ui/constants/dimensions.dart';

class MainPageWrapper extends StatelessWidget {
  final bool isLoading;
  final bool isEmpty;
  final String emptyMessage;
  final Widget child;

  const MainPageWrapper({
    required this.isLoading,
    required this.isEmpty,
    required this.emptyMessage,
    required this.child,
  }) : super();

  @override
  Widget build(BuildContext context) {
    if (isLoading) return Center(child: CircularProgressIndicator());
    if (isEmpty) {
      return Padding(
        padding: pagePadding,
        child: Center(
          child: Text(emptyMessage, textAlign: TextAlign.center),
        ),
      );
    }
    return child;
  }
}
