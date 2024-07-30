import 'package:firebase_vertexai/firebase_vertexai.dart';

import '../data/mockup_db.dart';

Future<Map<String, Object?>> ggcGardenData(
    Map<String, Object?> arguments) async {
  return {'garden': mockupDb.getGardenData(arguments['garden']! as String)};
}

final ggcGardenDataTool = FunctionDeclaration(
    'ggcGardenData',
    'Returns the owner, beds, crops, varieties, and plantings associated with this garden. '
        'owner is the username of the gardener who owns this garden. '
        'beds is a list of strings naming the beds in this garden. '
        'crops is a list of strings naming the crops that have been grown in this garden. '
        'varieties is a list of strings naming the varieties that have been grown in this garden. '
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
