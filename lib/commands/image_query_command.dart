import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../file_path.dart';

class ImageQueryCommand extends StatelessWidget {
  const ImageQueryCommand(
      {super.key,
      required this.loading,
      required this.setLoading,
      required this.addGeneratedContent,
      required this.model,
      required this.showError,
      required this.textController,
      required this.textFieldFocus});

  final bool loading;
  final void Function(bool, {bool scrollDown}) setLoading;
  final void Function(({Image? image, String? text, bool fromUser}))
      addGeneratedContent;
  final GenerativeModel? model;
  final void Function(String) showError;
  final TextEditingController textController;
  final FocusNode textFieldFocus;

  Future<void> _sendImagePrompt(String message) async {
    setLoading(true);
    try {
      ByteData catBytes = await rootBundle.load('assets/images/cat.jpg');
      ByteData sconeBytes = await rootBundle.load('assets/images/scones.jpg');
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
      tooltip: 'image prompt',
      onPressed: !loading
          ? () async {
              await _sendImagePrompt(textController.text);
            }
          : null,
      icon: Icon(
        Icons.image,
        color: loading
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.primary,
      ),
    );
  }
}