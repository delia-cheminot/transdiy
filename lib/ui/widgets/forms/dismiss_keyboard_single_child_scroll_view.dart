import 'package:flutter/material.dart';

class DismissKeyboardSingleChildScrollView extends StatefulWidget {
  final Widget child;
  const DismissKeyboardSingleChildScrollView({required this.child});

  @override
  State<DismissKeyboardSingleChildScrollView> createState() =>
      _ScrollDismissKeyboardState();
}

class _ScrollDismissKeyboardState
    extends State<DismissKeyboardSingleChildScrollView> {
  final ScrollController _controller = ScrollController();
  double _startOffset = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _controller.offset;
    final delta = offset - _startOffset;

    if (delta.abs() > 50) {
      FocusScope.of(context).unfocus();
      _startOffset = offset;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _controller,
      child: widget.child,
    );
  }
}
