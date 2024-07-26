import 'package:firebase_vertexai/firebase_vertexai.dart';

import '../data/mockup_db.dart';

Future<Map<String, Object?>> ggcVarietyData(
    Map<String, Object?> arguments) async {
  return mockupDb.getVarietyData(
      arguments['crop']! as String, arguments['variety']! as String);
}

final ggcVarietyDataTool = FunctionDeclaration(
    'ggcVarietyData',
    'Returns the gardens, gardeners, number of plantings, and plantings associated with the variety. '
        'gardens is a list naming the gardens containing this crop. '
        'gardeners is a list naming the usernames that own gardens with this crop. '
        'numPlantings is an integer indicating the number of plantings associated with this crop. '
        'plantings is a list of objects with data about the plantings associated with this crop. ',
    Schema(
      SchemaType.object,
      properties: {
        'crop': Schema(
          SchemaType.string,
          description: 'The name of a crop, such as "Carrot".',
        ),
        'variety': Schema(
          SchemaType.string,
          description: 'The name of a variety, such as "Scarlet Nantes".',
        ),
      },
    ));
