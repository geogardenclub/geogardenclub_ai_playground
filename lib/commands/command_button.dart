import 'package:flutter/material.dart';

class CommandButton extends StatelessWidget {
  const CommandButton(
      {super.key,
      required this.icon,
      required this.working,
      required this.onPressed});

  final IconData icon;
  final bool working;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: !working ? onPressed : null,
      icon: Icon(
        icon,
        color: working
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
