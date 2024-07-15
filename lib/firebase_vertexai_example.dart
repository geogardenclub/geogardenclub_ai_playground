import 'package:flutter/material.dart';

import 'chat_screen.dart';

class FirebaseVertexAiExample extends StatelessWidget {
  const FirebaseVertexAiExample({super.key});

  @override
  Widget build(BuildContext context) {
    String title = 'Flutter + Vertex AI';
    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color.fromARGB(255, 171, 222, 244),
        ),
        useMaterial3: true,
      ),
      home: ChatScreen(title: title),
    );
  }
}
