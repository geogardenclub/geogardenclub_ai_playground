import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:vertex_ai_example/commands/ExchangeRateCommand.dart';
import 'package:vertex_ai_example/commands/ImageQueryCommand.dart';

import 'ExchangeRateTool.dart';
import 'GeneratedContent.dart';
import 'TextPrompt.dart';
import 'commands/TokenCountCommand.dart';

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
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    initFirebase().then((value) {
      _model = FirebaseVertexAI.instance.generativeModel(
        model: 'gemini-1.5-flash-preview-0514',
      );
      _functionCallModel = FirebaseVertexAI.instance.generativeModel(
        model: 'gemini-1.5-flash-preview-0514',
        tools: [
          Tool(functionDeclarations: [exchangeRateTool]),
        ],
      );
      _chat = _model!.startChat();
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

  void setLoading(bool loading, {bool scrollDown = false}) {
    setState(() {
      _loading = loading;
      if (scrollDown) {
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
                child: Row(
                  children: [
                    TextPrompt(
                      textFieldFocus: _textFieldFocus,
                      textController: _textController,
                      sendChatMessage: _sendChatMessage,
                    ),
                    const SizedBox.square(
                      dimension: 15,
                    ),
                    TokenCountCommand(
                      loading: _loading,
                      setLoading: setLoading,
                      model: _model,
                    ),
                    ExchangeRateCommand(
                        loading: _loading,
                        setLoading: setLoading,
                        functionCallModel: _functionCallModel,
                        addGeneratedContent: (content) =>
                            _generatedContent.add(content)),
                    ImageQueryCommand(
                        loading: _loading,
                        setLoading: setLoading,
                        addGeneratedContent: (content) =>
                            _generatedContent.add(content),
                        model: _model,
                        showError: _showError,
                        textController: _textController,
                        textFieldFocus: _textFieldFocus),
                    IconButton(
                      tooltip: 'storage prompt',
                      onPressed: !_loading
                          ? () async {
                              await _sendStorageUriPrompt(_textController.text);
                            }
                          : null,
                      icon: Icon(
                        Icons.folder,
                        color: _loading
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    if (!_loading)
                      IconButton(
                        onPressed: () async {
                          await _sendChatMessage(_textController.text);
                        },
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )
                    else
                      const CircularProgressIndicator(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> _sendStorageUriPrompt(String message) async {
    setLoading(true);
    try {
      final content = [
        Content.multi([
          TextPart(message),
          FileData(
            'image/jpeg',
            'gs://ggc-app-2de7b.appspot.com/chapter-001/chapter-001.jpg',
          ),
        ]),
      ];
      _generatedContent.add((image: null, text: message, fromUser: true));

      var response = await _model!.generateContent(content);
      var text = response.text;
      _generatedContent.add((image: null, text: text, fromUser: false));

      if (text == null) {
        _showError('No response from API.');
        return;
      } else {
        setLoading(false, scrollDown: true);
      }
    } catch (e) {
      _showError(e.toString());
      setLoading(false);
    } finally {
      _textController.clear();
      setLoading(false);
      _textFieldFocus.requestFocus();
    }
  }

  Future<void> _sendChatMessage(String message) async {
    setLoading(true);
    try {
      _generatedContent.add((image: null, text: message, fromUser: true));
      var response = await _chat!.sendMessage(
        Content.text(message),
      );
      var text = response.text;
      _generatedContent.add((image: null, text: text, fromUser: false));

      if (text == null) {
        _showError('No response from API.');
        return;
      } else {
        setLoading(false, scrollDown: true);
      }
    } catch (e) {
      _showError(e.toString());
      setLoading(false);
    } finally {
      _textController.clear();
      setLoading(false);
      _textFieldFocus.requestFocus();
    }
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
