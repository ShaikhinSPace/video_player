import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  Color? color;
  final void Function() onTap;
  IconData? icon;
  ActionButton({
    super.key,
    required this.onTap,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).primaryColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon),
      ),
    );
  }
}
