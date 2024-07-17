import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:geogardenclub_ai_playground/commands/ggc_tools.dart';

import 'command_button.dart';

class GgcCommand extends StatelessWidget {
  const GgcCommand(
      {super.key,
      required this.working,
      required this.setWorking,
      required this.functionCallModel,
      required this.addGeneratedContent,
      required this.textFieldFocus,
      required this.textController});

  final void Function(bool, {bool scrollDown}) setWorking;
  final bool working;
  final GenerativeModel? functionCallModel;
  final void Function(({Image? image, String? text, bool fromUser}))
      addGeneratedContent;
  final TextEditingController textController;
  final FocusNode textFieldFocus;

  Future<void> _ggcChat(String message) async {
    setWorking(true);
    final chat = functionCallModel!.startChat();
    addGeneratedContent((image: null, text: message, fromUser: true));

    // Send the message to the generative model.
    var response = await chat.sendMessage(Content.text(message));

    final functionCalls = response.functionCalls.toList();
    // When the model response with a function call, invoke the function.
    if (functionCalls.isNotEmpty) {
      final functionCall = functionCalls.first;
      final result = switch (functionCall.name) {
        // Forward arguments to the mockup GGC API.
        'findGgcGardeners' => await findGgcGardeners(functionCall.args),
        // Throw an exception if the model attempted to call a function that was
        // not declared.
        _ => throw UnimplementedError(
            'Function not implemented: ${functionCall.name}',
          )
      };
      // Send the response to the model so that it can use the result to generate
      // text for the user.
      response = await chat
          .sendMessage(Content.functionResponse(functionCall.name, result));
    }
    // When the model responds with non-null text content, print it.
    if (response.text case final text?) {
      addGeneratedContent((image: null, text: text, fromUser: false));
      textController.clear();
      setWorking(false);
      textFieldFocus.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommandButton(
        icon: Icons.yard,
        working: working,
        onPressed: () async {
          await _ggcChat(textController.text);
        });
  }
}
