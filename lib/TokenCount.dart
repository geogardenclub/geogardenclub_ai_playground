import 'package:flutter/material.dart';

class TokenCount extends StatelessWidget {
  const TokenCount({super.key, required this.loading});

  final bool loading;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'tokenCount Test',
      onPressed: !loading
          ? () async {
              //await _testCountToken();
            }
          : null,
      icon: Icon(
        Icons.numbers,
        color: loading
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
