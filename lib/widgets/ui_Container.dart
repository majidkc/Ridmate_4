import 'package:flutter/material.dart';

class UiContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final double width;

  UiContainer({required this.child, required this.color, required this.width, required Color backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
