// SPDX-FileCopyrightText: 2026 Délia Cheminot <delia@cheminot.net>
//
// SPDX-License-Identifier: AGPL-3.0-only

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DismissKeyboardSingleChildScrollView extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double scrollThreshold;

  const DismissKeyboardSingleChildScrollView({
    required this.child,
    this.padding,
    this.scrollThreshold = 50,
  });

  @override
  State<DismissKeyboardSingleChildScrollView> createState() =>
      _DismissKeyboardSingleChildScrollViewState();
}

class _DismissKeyboardSingleChildScrollViewState
    extends State<DismissKeyboardSingleChildScrollView> {
  double _accumulatedDelta = 0;
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        // on ne compte que le scroll initié par l’utilisateur
        if (notification is UserScrollNotification) {
          _dragging = notification.direction != ScrollDirection.idle;
        }

        if (notification is ScrollUpdateNotification && _dragging) {
          _accumulatedDelta += notification.scrollDelta ?? 0;

          if (_accumulatedDelta.abs() > widget.scrollThreshold) {
            FocusScope.of(context).unfocus();
            _accumulatedDelta = 0;
          }
        }
        return false;
      },
      child: SingleChildScrollView(
        padding: widget.padding,
        child: widget.child,
      ),
    );
  }
}
