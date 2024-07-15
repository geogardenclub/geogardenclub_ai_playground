import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';

class TokenCountCommand extends StatelessWidget {
  const TokenCountCommand(
      {super.key,
      required this.loading,
      required this.setLoading,
      required this.model});

  final void Function(bool, {bool scrollDown}) setLoading;
  final bool loading;
  final GenerativeModel? model;

  Future<void> testTokenCount() async {
    setLoading(true);

    if (model != null) {
      const prompt = 'tell a short story';
      var response = await model!.countTokens([Content.text(prompt)]);
      print(
        'token: ${response.totalTokens}, billable characters: ${response.totalBillableCharacters}',
      );
    }
    setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'tokenCount Test',
      onPressed: !loading
          ? () async {
              await testTokenCount();
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