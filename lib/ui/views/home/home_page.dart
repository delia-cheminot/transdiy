import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/global/logo.png',
          ),
          Image.asset(
            'assets/homepage/donutstyle.gif',
          ),
        ],
      ),
    );
  }
}
