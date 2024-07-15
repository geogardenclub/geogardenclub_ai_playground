import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';

class TextFieldCommand extends StatelessWidget {
  const TextFieldCommand(
      {super.key,
      required this.textFieldFocus,
      required this.textController,
      required this.setLoading,
      required this.addGeneratedContent,
      required this.showError,
      required this.chat});

  final void Function(bool, {bool scrollDown}) setLoading;
  final void Function(({Image? image, String? text, bool fromUser}))
      addGeneratedContent;
  final ChatSession? chat;
  final void Function(String) showError;

  final FocusNode textFieldFocus;
  final TextEditingController textController;

  Future<void> _sendChatMessage(String message) async {
    setLoading(true);
    try {
      addGeneratedContent((image: null, text: message, fromUser: true));
      var response = await chat!.sendMessage(
        Content.text(message),
      );
      var text = response.text;
      addGeneratedContent((image: null, text: text, fromUser: false));

      if (text == null) {
        showError('No response from API.');
        return;
      } else {
        setLoading(false, scrollDown: true);
      }
    } catch (e) {
      showError(e.toString());
      setLoading(false);
    } finally {
      textController.clear();
      setLoading(false);
      textFieldFocus.requestFocus();
    }
  }

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
        onSubmitted: _sendChatMessage,
      ),
    );
  }
}
