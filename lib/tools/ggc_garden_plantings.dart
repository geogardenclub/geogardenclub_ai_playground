import 'package:firebase_vertexai/firebase_vertexai.dart';

import '../data/mockup_db.dart';

Future<Map<String, Object?>> ggcGardenPlantings(
    Map<String, Object?> arguments) async {
  return {
    'plantings': mockupDb.getGardenPlantings(arguments['garden']! as String)
  };
}

final ggcGardenPlantingsTool = FunctionDeclaration(
    'ggcGardenPlantings',
    'Returns the plantings associated with this garden. '
        'plantings is a list of objects with data about the plantings associated with this crop. '
        'Planting data includes the garden name, the gardener username, the crop name, the variety name, '
        'the planting start date, the planting pull date, whether or not a greenhouse was used to start the plant '
        'the germination outcome, the appearance outcome, the yield outcome, the flavor outcome, and the resistance outcome',
    Schema(
      SchemaType.object,
      properties: {
        'garden': Schema(
          SchemaType.string,
          description: 'The name of a garden.',
        ),
      },
    ));
