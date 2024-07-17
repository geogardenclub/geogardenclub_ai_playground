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

  final void Function(bool) setWorking;
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
    GenerateContentResponse response =
        await chat.sendMessage(Content.text(message));
    List<FunctionCall> functionCalls = response.functionCalls.toList();

    // While the model responds with a desire to call functions, do it.
    while (functionCalls.isNotEmpty) {
      FunctionCall functionCall = functionCalls.first;
      print('Function call: ${functionCall.name}');
      Map<String, Object?> result = switch (functionCall.name) {
        // Forward arguments to the mockup GGC API.
        'findGgcGardeners' => await findGgcGardeners(functionCall.args),
        'findGgcGardens' => await findGgcGardens(functionCall.args),
        _ => throw UnimplementedError('Not implemented: ${functionCall.name}')
      };
      // Send the response to the model.
      response = await chat
          .sendMessage(Content.functionResponse(functionCall.name, result));
      // see if the model wants to call more functions
      functionCalls = response.functionCalls.toList();
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
