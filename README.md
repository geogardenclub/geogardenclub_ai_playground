# GeoGardenClub_AI_Playground

GeoGardenClub_AI_Playground is a refactored and extended version of the [sample app](https://github.com/firebase/flutterfire/tree/master/packages/firebase_vertexai/firebase_vertexai/example) in [Get started with the Gemini API using the Vertex AI for Firebase SDKs](https://firebase.google.com/docs/vertex-ai/get-started?platform=flutter). 

The original sample app is pretty cool because it provides a nice illustration of several important concepts:

1. How to choose and initialize a Gemini model in Flutter, using the (currently recommended) Firebase VertexAI interface.
2. How to implement a UI in Flutter for displaying a chat session between a user and the Gemini model. This includes preventing the user from initiating another request while the model is still working on the previous request.
3. How to use several important Gemini interaction modalities, including text only, text plus images, text plus Firebase Storage files, and text plus a "Gemini Function Call" (which is the way you get Gemini models to interact with external APIs).

For this app, the original sample app was first refactored from a single main.dart file containing all of the code into a dozen files.  This refactoring helps to clarify the design and separates the UI code from model code. It also makes it easier to extend the system with new functionality to explore the integration of Gemini models with GeoGardenClub data, and solicit help in the design of the integration by encapsulating GGC specific code into a few files.   

## Installation

Install this system according to the documentation in [Get started with the Gemini API using the Vertex AI for Firebase SDKs](https://firebase.google.com/docs/vertex-ai/get-started?platform=flutter). 

Specifically, you must [Set up a Firebase project and connect your app to Firebase](https://firebase.google.com/docs/vertex-ai/get-started?platform=flutter).   You do not need to perform the remaining steps in the documentation page ("Add the SDK", "Initialize the Vertex AI service and the generative model", "Call the Vertex AI Gemini API"); these have already been done in the app.

Note that GeoGardeClub_AI_Playground does not actually read or write to the connected Firebase project; you just need this connection in order to define and use the Gemini models through the Vertex AI APIs.

Once you've connected your instance of the app to Firebase, you should be able to run the app as a normal Flutter project. For example, with:

```
flutter run
```

If all goes as planned, then the app will come up. Typing a query such as "Where is Bellingham?" and hitting return should result in a screen like this, which verifies that the app is successfully interacting with a Gemini model:

<img width="300px" src="example-screen.png">

Note that the number and type of icons at the bottom of the screen may differ from what appears in this image. That's because each icon is connected to a different "command" (explained below) and not all of them might be displayed in the UI at any one time.

## Design

As noted above, I refactored the single main.dart file of the sample app into a set of files in order to more clearly indicate its structure, and to facilitate its use to explore what the Gemini model can do when provided with GGC data.

The current structure encapsulates each type of interaction with the Gemini model as an instance of a "command".  This makes it straightforward to create a new "command" like "GgcDataCommand" that sets up function calls to the GGC database and allows the user to ask questions about it. 

The main.dart file invokes FirebaseVertexAiExample to kick things off.

The two top-level classes are:

* GeoGardenClubAiExample: Creates a MaterialApp that displays a ChatScreen.
* ChatScreen: Selects and initializes a Gemini AI model. Then displays a screen that processes a "command" invoked the user. Each command gathers some data, passes the data to the Gemini model, and displays the data and the response.

The ChatScreen UI is implemented using the following classes:
* MessageWidget: Displays a single command from the user and the results from the AI in the ChatWidget window to that prompt.
* GeneratedContent: A Widget displaying the sequence of commands and responses as a list of MessageWidgets.

At the bottom of the ChatScreen is a row of "commands" that enable the user to interact with the Gemini model in various ways. These commands are located in the commands/ subdirectory. Here are the currently implemented commands:

* ExchangeRateCommand (Sigma icon): Illustrates how to define and invoke a Gemini "function call". In this case, the command implements a fake API to an exchange rate application. Pressing the icon generates a fake user prompt and call to the API which is processed by the Gemini model and whose response is printed.
* TextFieldCommand (Text field): The user can enter any text into the field and press return (or the Send icon). The prompt is sent to the Gemini model and this prompt as well as the response is printed.
* TokenCountCommand (hashtag icon): Pressing this icon illustrates how to obtain the token count and billable characters associated with a prompt. This information is printed to the console.
* ImageQueryCommand (image icon): Pressing this icon sends a hardcoded image to the Gemini model, along with the text provided by the user in the TextField. You can edit the image to be sent by editing the code in the ImageQueryCommand class. 
* StorageQueryCommand (folder icon): This works just like the ImageQueryCommand, except that rather than sending an image (encoded as a byte stream) to the Gemini Model, the command instead sends the URI to a Google Storage file along with the text provided by the user. This URI is hardcoded in the StorageQueryCommand file.
* TextSendCommand (send icon): Sends the text in the TextField. Equivalent to pressing "return" in the TextField. Both the text and the Gemini model's response are printed.
