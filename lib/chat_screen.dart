import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';

import 'commands/exchange_rate_command.dart';
import 'commands/ggc_command.dart';
import 'commands/image_query_command.dart';
import 'commands/storage_query_command.dart';
import 'commands/text_send_command.dart';
import 'data/system_instruction.dart';
import 'generated_content.dart';
import 'prompt_text_field.dart';
import 'tools/exchange_rate_tool.dart';
import 'tools/ggc_current_chapter.dart';
import 'tools/ggc_current_gardener.dart';
import 'tools/ggc_find_gardeners.dart';
import 'tools/ggc_find_gardens.dart';

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
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  final List<({Image? image, String? text, bool fromUser})> _generatedContent =
      <({Image? image, String? text, bool fromUser})>[];
  bool _working = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initFirebase().then((value) {
        _model = FirebaseVertexAI.instance.generativeModel(
            model: 'gemini-1.5-flash-latest', // 'gemini-1.5-flash-preview-0514'
            systemInstruction: Content.system(systemInstruction));
        _functionCallModel = FirebaseVertexAI.instance.generativeModel(
          model: 'gemini-1.5-flash-latest',
          systemInstruction: Content.system(systemInstruction),
          tools: [
            Tool(functionDeclarations: [
              exchangeRateTool,
              ggcFindGardenersTool,
              ggcFindGardensTool,
              ggcCurrentChapterTool,
              ggcCurrentGardenerTool
            ])
          ],
          toolConfig: ToolConfig(
            functionCallingConfig:
                FunctionCallingConfig(mode: FunctionCallingMode.any),
          ),
        );
        _chat = _model!.startChat();
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
                        functionCallModel: _functionCallModel,
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
