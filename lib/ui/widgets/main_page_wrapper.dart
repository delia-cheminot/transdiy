import 'package:flutter/material.dart';

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
    if (isEmpty) return Center(child: Text(emptyMessage));
    return child;
  }
}
