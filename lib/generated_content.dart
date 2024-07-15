import 'package:flutter/material.dart';

import 'MessageWidget.dart';

class GeneratedContent extends StatelessWidget {
  const GeneratedContent(
      {super.key,
      required this.scrollController,
      required this.generatedContent});

  final ScrollController scrollController;
  final List<({Image? image, String? text, bool fromUser})> generatedContent;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        itemBuilder: (context, idx) {
          var content = generatedContent[idx];
          return MessageWidget(
            text: content.text,
            image: content.image,
            isFromUser: content.fromUser,
          );
        },
        itemCount: generatedContent.length,
      ),
    );
  }
}
