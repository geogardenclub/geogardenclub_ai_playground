import 'package:flutter/material.dart';

class TextPrompt extends StatelessWidget {
  const TextPrompt(
      {super.key,
      required this.textFieldFocus,
      required this.textController,
      required this.sendChatMessage});

  final FocusNode textFieldFocus;
  final TextEditingController textController;
  final void Function(String) sendChatMessage;

  @override
  Widget build(BuildContext context) {
    final textFieldDecoration = InputDecoration(
      contentPadding: const EdgeInsets.all(15),
      hintText: 'Enter a prompt...',
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
    return Expanded(
      child: TextField(
        autofocus: true,
        focusNode: textFieldFocus,
        decoration: textFieldDecoration,
        controller: textController,
        onSubmitted: sendChatMessage,
      ),
    );
  }
}
