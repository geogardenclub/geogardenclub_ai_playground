# firebase_vertexai_example

Sample app to show how to use Vertex AI for Firebase, modified to facilitate GGC Development.

This is referenced as the "sample app" in [Get started with the Gemini API using the Vertex AI for Firebase SDKs](https://firebase.google.com/docs/vertex-ai/get-started?platform=flutter). 

The documentation states it needs to be connected to a Firebase project, so I've connected it to the Firebase ggc_app database following the instructions in the Getting Started page referenced above.

Once the app was working, I refactored the single main.dart file into a set of files in order to more clearly indicate its structure:

* main.dart:  Runs FirebaseVertexAiExample.
* FirebaseVertexAiExample.dart: Creates a MaterialApp that displays a ChatScreen.
* ChatScreen: Creates a Scaffold that displays a ChatWidget.
* ChatWidget: This is where the magic happens. Takes a prompt from the user and passes it to the AI model. Results are displayed using MessageWidget.
* MessageWidget: Displays the prompt from the user and the results from the AI in the ChatWidget window.
