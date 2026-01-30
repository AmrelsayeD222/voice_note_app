import 'package:flutter/material.dart';

class ActionIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const ActionIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: color, size: 20),
      onPressed: onPressed,
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.all(8),
    );
  }
}
