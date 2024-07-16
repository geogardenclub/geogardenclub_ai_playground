import 'package:flutter/material.dart';

import 'chat_screen.dart';

class GeoGardenClubAiPlayground extends StatelessWidget {
  const GeoGardenClubAiPlayground({super.key});

  @override
  Widget build(BuildContext context) {
    String title = 'GeoGardenClub AI Playground';
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
