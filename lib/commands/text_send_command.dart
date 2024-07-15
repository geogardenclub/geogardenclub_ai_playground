import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';

class TextSendCommand extends StatelessWidget {
  const TextSendCommand(
      {super.key,
      required this.textFieldFocus,
      required this.textController,
      required this.setWorking,
      required this.addGeneratedContent,
      required this.showError,
      required this.chat});

  final void Function(bool, {bool scrollDown}) setWorking;
  final void Function(({Image? image, String? text, bool fromUser}))
      addGeneratedContent;
  final ChatSession? chat;
  final void Function(String) showError;

  final FocusNode textFieldFocus;
  final TextEditingController textController;

  Future<void> _sendChatMessage(String message) async {
    setWorking(true);
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
        setWorking(false, scrollDown: true);
      }
    } catch (e) {
      showError(e.toString());
      setWorking(false);
    } finally {
      textController.clear();
      setWorking(false);
      textFieldFocus.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await _sendChatMessage(textController.text);
      },
      icon: Icon(
        Icons.send,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
