import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';

import '../tools/ggc_crop_data.dart';
import '../tools/ggc_garden_data.dart';
import '../tools/ggc_gardener_data.dart';
import '../tools/ggc_my_chapter_data.dart';
import '../tools/ggc_my_chapter_name.dart';
import '../tools/ggc_my_username.dart';
import '../tools/ggc_variety_data.dart';
import '../tools/todays_date.dart';
import 'command_button.dart';

class GgcCommand extends StatelessWidget {
  const GgcCommand(
      {super.key,
      required this.working,
      required this.setWorking,
      required this.chat,
      required this.addGeneratedContent,
      required this.textFieldFocus,
      required this.showError,
      required this.textController});

  final void Function(bool) setWorking;
  final bool working;
  final ChatSession? chat;
  final void Function(({Image? image, String? text, bool fromUser}))
      addGeneratedContent;
  final TextEditingController textController;
  final FocusNode textFieldFocus;
  final void Function(String) showError;

  Future<void> _ggcChat(String message) async {
    setWorking(true);
    try {
      addGeneratedContent((image: null, text: message, fromUser: true));

      // Send the message to the generative model.
      GenerateContentResponse response =
          await chat!.sendMessage(Content.text(message));
      List<FunctionCall> functionCalls = response.functionCalls.toList();

      // While the model responds with a desire to call functions, do it.
      while (functionCalls.isNotEmpty) {
        FunctionCall functionCall = functionCalls.first;
        print(
            'About to call: ${functionCall.name} with ${functionCall.args}. There are ${functionCalls.length} function calls requested.');
        Map<String, Object?> result = switch (functionCall.name) {
          // Forward arguments to the mockup GGC API.
          'ggcMyChapterData' => await ggcMyChapterData(functionCall.args),
          'ggcMyUsername' => await ggcMyUsername(functionCall.args),
          'ggcGardenerData' => await ggcGardenerData(functionCall.args),
          'ggcGardenData' => await ggcGardenData(functionCall.args),
          'ggcCropData' => await ggcCropData(functionCall.args),
          'ggcVarietyData' => await ggcVarietyData(functionCall.args),
          'ggcMyChapterName' => await ggcMyChapterName(functionCall.args),
          'todaysDate' => await todaysDate(functionCall.args),
          _ => throw UnimplementedError(
              'Not implemented: ${functionCall.name}. Please add it to the ggcCommand widget.')
        };
        // Send the response to the model.
        response = await chat!
            .sendMessage(Content.functionResponse(functionCall.name, result));
        // see if the model wants to call more functions
        functionCalls = response.functionCalls.toList();
      }

      // When the model responds with non-null text content, print it.
      if (response.text case final text?) {
        addGeneratedContent((image: null, text: text, fromUser: false));
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
        icon: Icons.yard,
        working: working,
        onPressed: () async {
          await _ggcChat(textController.text);
        });
  }
}
