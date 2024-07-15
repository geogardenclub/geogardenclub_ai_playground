import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';

import '../file_path.dart';

class StorageQueryCommand extends StatelessWidget {
  const StorageQueryCommand(
      {super.key,
      required this.working,
      required this.setLoading,
      required this.addGeneratedContent,
      required this.model,
      required this.showError,
      required this.textController,
      required this.textFieldFocus});

  final bool working;
  final void Function(bool, {bool scrollDown}) setLoading;
  final void Function(({Image? image, String? text, bool fromUser}))
      addGeneratedContent;
  final GenerativeModel? model;
  final void Function(String) showError;
  final TextEditingController textController;
  final FocusNode textFieldFocus;

  Future<void> _sendStorageUriPrompt(String message) async {
    setLoading(true);
    try {
      final content = [
        Content.multi([
          TextPart(message),
          FileData(
            'image/jpeg',
            FilePath.chapterStorage,
          ),
        ]),
      ];
      addGeneratedContent((image: null, text: message, fromUser: true));

      var response = await model!.generateContent(content);
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
    return IconButton(
      tooltip: 'storage prompt',
      onPressed: !working
          ? () async {
              await _sendStorageUriPrompt(textController.text);
            }
          : null,
      icon: Icon(
        Icons.folder,
        color: working
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
