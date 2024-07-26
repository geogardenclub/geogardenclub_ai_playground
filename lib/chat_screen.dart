import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:geogardenclub_ai_playground/tools/ggc_crop_data.dart';
import 'package:geogardenclub_ai_playground/tools/ggc_gardener_data.dart';
import 'package:geogardenclub_ai_playground/tools/ggc_my_username.dart';
import 'package:geogardenclub_ai_playground/tools/ggc_variety_data.dart';

import 'commands/exchange_rate_command.dart';
import 'commands/ggc_command.dart';
import 'commands/image_query_command.dart';
import 'commands/storage_query_command.dart';
import 'commands/text_send_command.dart';
import 'data/system_instruction.dart';
import 'generated_content.dart';
import 'prompt_text_field.dart';
import 'tools/exchange_rate_tool.dart';
import 'tools/ggc_my_chapter_data.dart';
import 'tools/ggc_my_chapter_name.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.title});
  final String title;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  GenerativeModel? _model;
  GenerativeModel? _functionCallModel;
  ChatSession? _chat;
  ChatSession? _functionCallChat;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  final List<({Image? image, String? text, bool fromUser})> _generatedContent =
      <({Image? image, String? text, bool fromUser})>[];
  bool _working = false;
  final String _initialMessage = 'Welcome to GeoBot, a chatbot '
      'for answering questions about this GeoGardenClub Chapter. '
      'For example, try typing "Describe my chapter" '
      'and then pressing the flower icon to submit your question. '
      'GeoBot is in initial development and may not answer correctly.';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initFirebase().then((value) {
        _model = FirebaseVertexAI.instance.generativeModel(
          model: 'gemini-1.5-flash', // 'gemini-1.5-flash-preview-0514'
          // systemInstruction: Content.system(systemInstruction)
        );
        _functionCallModel = FirebaseVertexAI.instance.generativeModel(
          model: 'gemini-1.5-flash',
          systemInstruction: Content.system(systemInstruction),
          generationConfig: GenerationConfig(temperature: 0),
          tools: [
            Tool(functionDeclarations: [
              exchangeRateTool,
              ggcMyChapterDataTool,
              ggcMyChapterNameTool,
              ggcMyUsernameTool,
              ggcGardenerDataTool,
              ggcCropDataTool,
              ggcVarietyDataTool,
            ])
          ],
          // gemini pro required for FunctionCallingMode.any, so let's try without for now.
          // toolConfig: ToolConfig(
          //   functionCallingConfig:
          //       FunctionCallingConfig(mode: FunctionCallingMode.any),
          // ),
        );
        _chat = _model!.startChat();
        _functionCallChat = _functionCallModel!.startChat();
        _generatedContent
            .add((image: null, text: _initialMessage, fromUser: false));
        setState(() {});
      });
    });
  }

  Future<void> initFirebase() async {
    await Firebase.initializeApp();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  void setWorking(bool working) {
    setState(() {
      _working = working;
      if (!working) {
        _scrollDown();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GeneratedContent(
                scrollController: _scrollController,
                generatedContent: _generatedContent,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 25,
                    horizontal: 15,
                  ),
                  child: Column(children: [
                    Row(children: [
                      PromptTextField(
                          textFieldFocus: _textFieldFocus,
                          textController: _textController,
                          setWorking: setWorking)
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      ExchangeRateCommand(
                          working: _working,
                          setWorking: setWorking,
                          textController: _textController,
                          textFieldFocus: _textFieldFocus,
                          showError: _showError,
                          functionCallModel: _functionCallModel,
                          addGeneratedContent: (content) =>
                              _generatedContent.add(content)),
                      ImageQueryCommand(
                          working: _working,
                          setWorking: setWorking,
                          addGeneratedContent: (content) =>
                              _generatedContent.add(content),
                          model: _model,
                          showError: _showError,
                          textController: _textController,
                          textFieldFocus: _textFieldFocus),
                      StorageQueryCommand(
                          working: _working,
                          setWorking: setWorking,
                          addGeneratedContent: (content) =>
                              _generatedContent.add(content),
                          model: _model,
                          showError: _showError,
                          textController: _textController,
                          textFieldFocus: _textFieldFocus),
                      TextSendCommand(
                        textFieldFocus: _textFieldFocus,
                        working: _working,
                        textController: _textController,
                        setWorking: setWorking,
                        addGeneratedContent: (content) =>
                            _generatedContent.add(content),
                        showError: _showError,
                        chat: _chat,
                      ),
                      GgcCommand(
                        working: _working,
                        setWorking: setWorking,
                        chat: _functionCallChat,
                        textController: _textController,
                        textFieldFocus: _textFieldFocus,
                        showError: _showError,
                        addGeneratedContent: (content) =>
                            _generatedContent.add(content),
                      ),
                      if (_working) const CircularProgressIndicator(),
                    ]),
                  ])),
            ],
          ),
        ));
  }

  void _showError(String message) {
    print(message);
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Something went wrong'),
          content: SingleChildScrollView(
            child: SelectableText(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
