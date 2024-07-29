import 'package:firebase_vertexai/firebase_vertexai.dart';

import '../data/mockup_db.dart';

Future<Map<String, Object?>> ggcCropData(Map<String, Object?> arguments) async {
  return mockupDb.getCropData(arguments['crop']! as String);
}

final ggcCropDataTool = FunctionDeclaration(
    'ggcCropData',
    'Returns the gardens, gardeners, varieties, number of plantings, and plantings associated with the crop name. '
        'gardens is a list naming the gardens containing this crop. '
        'gardeners is a list naming the usernames that own gardens with this crop. '
        'varieties is a list of the variety names associated with this crop. '
        'numPlantings is an integer indicating the number of plantings associated with this crop. '
        'plantings is a list of objects with data about the plantings associated with this crop. '
        'Planting data includes the garden name, the gardener username, the crop name, the variety name, '
        'the planting start date, the planting pull date, whether or not a greenhouse was used to start the plant '
        'the germination outcome, the appearance outcome, the yield outcome, the flavor outcome, and the resistance outcome',
    Schema(
      SchemaType.object,
      properties: {
        'crop': Schema(
          SchemaType.string,
          description: 'The name of a crop.',
        ),
      },
    ));
