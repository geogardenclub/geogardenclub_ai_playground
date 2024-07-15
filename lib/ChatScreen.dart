import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ExchangeRateTool.dart';
import 'GeneratedContent.dart';
import 'TextPrompt.dart';
import 'file_path.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.title});
  final String title;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final GenerativeModel _model;
  late final GenerativeModel _functionCallModel;
  late final ChatSession _chat;
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
      _chat = _model.startChat();
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

  void setLoading(bool loading) {
    setState(() {
      _loading = loading;
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
                    IconButton(
                      tooltip: 'tokenCount Test',
                      onPressed: !_loading
                          ? () async {
                              await _testCountToken();
                            }
                          : null,
                      icon: Icon(
                        Icons.numbers,
                        color: _loading
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    IconButton(
                      tooltip: 'function calling Test',
                      onPressed: !_loading
                          ? () async {
                              await _testFunctionCalling();
                            }
                          : null,
                      icon: Icon(
                        Icons.functions,
                        color: _loading
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    IconButton(
                      tooltip: 'image prompt',
                      onPressed: !_loading
                          ? () async {
                              await _sendImagePrompt(_textController.text);
                            }
                          : null,
                      icon: Icon(
                        Icons.image,
                        color: _loading
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
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
    setState(() {
      _loading = true;
    });
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

      var response = await _model.generateContent(content);
      var text = response.text;
      _generatedContent.add((image: null, text: text, fromUser: false));

      if (text == null) {
        _showError('No response from API.');
        return;
      } else {
        setState(() {
          _loading = false;
          _scrollDown();
        });
      }
    } catch (e) {
      _showError(e.toString());
      setState(() {
        _loading = false;
      });
    } finally {
      _textController.clear();
      setState(() {
        _loading = false;
      });
      _textFieldFocus.requestFocus();
    }
  }

  Future<void> _sendImagePrompt(String message) async {
    setState(() {
      _loading = true;
    });
    try {
      ByteData catBytes = await rootBundle.load('assets/images/cat.jpg');
      ByteData sconeBytes = await rootBundle.load('assets/images/scones.jpg');
      ByteData cherryTomatoBytes =
          await rootBundle.load(FilePath.tomatoSeedPackage);
      final content = [
        Content.multi([
          TextPart(message),
          // The only accepted mime types are image/*.
          DataPart('image/jpeg', cherryTomatoBytes.buffer.asUint8List()),
          // DataPart('image/jpeg', sconeBytes.buffer.asUint8List()),
        ]),
      ];
      _generatedContent.add(
        (
          image: Image.asset('assets/images/cat.jpg'),
          text: message,
          fromUser: true
        ),
      );
      _generatedContent.add(
        (
          image: Image.asset('assets/images/scones.jpg'),
          text: null,
          fromUser: true
        ),
      );

      var response = await _model.generateContent(content);
      var text = response.text;
      _generatedContent.add((image: null, text: text, fromUser: false));

      if (text == null) {
        _showError('No response from API.');
        return;
      } else {
        setState(() {
          _loading = false;
          _scrollDown();
        });
      }
    } catch (e) {
      _showError(e.toString());
      setState(() {
        _loading = false;
      });
    } finally {
      _textController.clear();
      setState(() {
        _loading = false;
      });
      _textFieldFocus.requestFocus();
    }
  }

  Future<void> _sendChatMessage(String message) async {
    setLoading(true);
    try {
      _generatedContent.add((image: null, text: message, fromUser: true));
      var response = await _chat.sendMessage(
        Content.text(message),
      );
      var text = response.text;
      _generatedContent.add((image: null, text: text, fromUser: false));

      if (text == null) {
        _showError('No response from API.');
        return;
      } else {
        setState(() {
          _loading = false;
          _scrollDown();
        });
      }
    } catch (e) {
      _showError(e.toString());
      setState(() {
        _loading = false;
      });
    } finally {
      _textController.clear();
      setState(() {
        _loading = false;
      });
      _textFieldFocus.requestFocus();
    }
  }

  Future<void> _testFunctionCalling() async {
    setState(() {
      _loading = true;
    });
    final chat = _functionCallModel.startChat();
    const prompt = 'How much is 50 US dollars worth in Swedish krona?';

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
      _generatedContent.add((image: null, text: text, fromUser: false));
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _testCountToken() async {
    setState(() {
      _loading = true;
    });

    const prompt = 'tell a short story';
    var response = await _model.countTokens([Content.text(prompt)]);
    print(
      'token: ${response.totalTokens}, billable characters: ${response.totalBillableCharacters}',
    );

    setState(() {
      _loading = false;
    });
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
