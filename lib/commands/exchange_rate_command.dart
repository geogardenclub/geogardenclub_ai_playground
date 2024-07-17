import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';

import 'exchange_rate_tool.dart';

class ExchangeRateCommand extends StatelessWidget {
  const ExchangeRateCommand(
      {super.key,
      required this.working,
      required this.setWorking,
      required this.functionCallModel,
      required this.addGeneratedContent});

  final void Function(bool) setWorking;
  final bool working;
  final GenerativeModel? functionCallModel;
  final void Function(({Image? image, String? text, bool fromUser}))
      addGeneratedContent;

  Future<void> _exchangeRateChat() async {
    setWorking(true);
    final chat = functionCallModel!.startChat();
    const prompt = 'How much is 50 US dollars worth in Euros?';
    addGeneratedContent((image: null, text: prompt, fromUser: true));

    // Send the message to the generative model.
    var response = await chat.sendMessage(Content.text(prompt));

    final functionCalls = response.functionCalls.toList();
    // When the model response with a function call, invoke the function.
    if (functionCalls.isNotEmpty) {
      final functionCall = functionCalls.first;
      final result = switch (functionCall.name) {
        // Forward arguments to the hypothetical API.
        'findExchangeRate' => await findExchangeRate(functionCall.args),
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
      setWorking(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'function calling Test',
      onPressed: !working
          ? () async {
              await _exchangeRateChat();
            }
          : null,
      icon: Icon(
        Icons.functions,
        color: working
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
