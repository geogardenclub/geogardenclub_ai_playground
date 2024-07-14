# firebase_vertexai_example

[](example-screen.png)

Sample app to show how to use Vertex AI for Firebase, modified to facilitate GGC Development.

This is referenced as the "sample app" in [Get started with the Gemini API using the Vertex AI for Firebase SDKs](https://firebase.google.com/docs/vertex-ai/get-started?platform=flutter). 

## Installation

The documentation states it needs to be connected to a Firebase project, so I've connected it to the Firebase ggc_app database following the instructions in the Getting Started page referenced above.

You should be able to just download and run the app without changes. 

## Structure

Once the app was working, I refactored the single main.dart file into a set of files in order to more clearly indicate its structure:

* main.dart:  Runs FirebaseVertexAiExample.
* FirebaseVertexAiExample.dart: Creates a MaterialApp that displays a ChatScreen.
* ChatScreen: Creates a Scaffold that displays a ChatWidget.
* ChatWidget: This is where the magic happens. Takes a prompt from the user and passes it to the AI model. Results are displayed using MessageWidget.
* MessageWidget: Displays the prompt from the user and the results from the AI in the ChatWidget window.
* ExchangeRateTool: This file illustrates how to connect the AI to an external API.

## Usage

Once the app is running, you can play around with it as follows:

1. Type a text prompt and hit return (or press the Send icon).  This will send the text to the AI and show both your prompt and the AI's response in the screen. Note that you can have follow-on conversations; it remembers the state of the conversation.
2. The "#" icon. Pressing this icon shows how to find out the number of tokens and billable characters for a prompt. The prompt is hard-wired in the code. 
3. The "Sigma" icon. Pressing this icon invokes the ExchangeRateTool with a hard-wired prompt. The AI's response (but not the prompt) is displayed in the screen.
4. The "Image" icon. Pressing this icon (along with your supplied text prompt) sends two pictures (hard-wired) plus your prompt to the AI and provides the response by the AI.  The pictures are of a cat and a plate of food. So, you could provide a prompt like "What is this cat?" or "What is that food?" and the AI will provide a response based on your prompt and the images. 
5. The "Folder" icon. This is supposed to illustrate how to query an image stored in Firebase Storage, but it doesn't seem to work at the moment. 
6. The "Send" icon. See 1 above.
