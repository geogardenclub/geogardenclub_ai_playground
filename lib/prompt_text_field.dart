import 'package:flutter/material.dart';

class PromptTextField extends StatelessWidget {
  const PromptTextField(
      {super.key,
      required this.textFieldFocus,
      required this.textController,
      required this.setWorking});

  final void Function(bool) setWorking;
  final FocusNode textFieldFocus;
  final TextEditingController textController;

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
        // onSubmitted: _sendChatMessage,
      ),
    );
  }
}
