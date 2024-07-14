import 'package:flutter/material.dart';

import 'ChatScreen.dart';

class FirebaseVertexAiExample extends StatelessWidget {
  const FirebaseVertexAiExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter + Vertex AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color.fromARGB(255, 171, 222, 244),
        ),
        useMaterial3: true,
      ),
      home: const ChatScreen(title: 'Flutter + Vertex AI'),
    );
  }
}
