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

  // Saving this as an illustration of how to support error handling.
  // Future<void> _sendChatMessage(String message) async {
  //   setWorking(true);
  //   try {
  //     addGeneratedContent((image: null, text: message, fromUser: true));
  //     var response = await chat!.sendMessage(
  //       Content.text(message),
  //     );
  //     var text = response.text;
  //     addGeneratedContent((image: null, text: text, fromUser: false));
  //
  //     if (text == null) {
  //       showError('No response from API.');
  //       return;
  //     } else {
  //       setWorking(false, scrollDown: true);
  //     }
  //   } catch (e) {
  //     showError(e.toString());
  //     setWorking(false);
  //   } finally {
  //     textController.clear();
  //     setWorking(false);
  //     textFieldFocus.requestFocus();
  //   }
  // }

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
