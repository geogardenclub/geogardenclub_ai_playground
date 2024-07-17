import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../file_path.dart';
import 'command_button.dart';

class ImageQueryCommand extends StatelessWidget {
  const ImageQueryCommand(
      {super.key,
      required this.working,
      required this.setWorking,
      required this.addGeneratedContent,
      required this.model,
      required this.showError,
      required this.textController,
      required this.textFieldFocus});

  final bool working;
  final void Function(bool, {bool scrollDown}) setWorking;
  final void Function(({Image? image, String? text, bool fromUser}))
      addGeneratedContent;
  final GenerativeModel? model;
  final void Function(String) showError;
  final TextEditingController textController;
  final FocusNode textFieldFocus;

  Future<void> _sendImagePrompt(String message) async {
    setWorking(true);
    try {
      ByteData cherryTomatoBytes =
          await rootBundle.load(FilePath.tomatoSeedPackage);
      final content = [
        Content.multi([
          TextPart(message),
          // The only accepted mime types are image/*.
          DataPart('image/jpeg', cherryTomatoBytes.buffer.asUint8List()),
          // DataPart('image/jpeg', sconeBytes.buffer.asUint8List()),
        ]),
      ];
      addGeneratedContent(
        (
          image: Image.asset(FilePath.tomatoSeedPackage),
          text: message,
          fromUser: true
        ),
      );

      var response = await model!.generateContent(content);
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
    return CommandButton(
        icon: Icons.image,
        working: working,
        onPressed: () async {
          await _sendImagePrompt(textController.text);
        });
  }
}
