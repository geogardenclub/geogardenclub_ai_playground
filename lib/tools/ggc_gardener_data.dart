import 'package:firebase_vertexai/firebase_vertexai.dart';

import '../data/mockup_db.dart';

Future<Map<String, Object?>> ggcGardenerData(
    Map<String, Object?> arguments) async {
  return mockupDb.getGardenerData(arguments['username']! as String);
}

final ggcGardenerDataTool = FunctionDeclaration(
    'ggcGardenerData',
    'Returns the garden names, crop names, variety names, and number of plantings associated with a gardener username. '
        'gardensOwned is a list naming the gardens that this gardener owns. '
        'gardensEdited is a list naming the gardens that this gardener can edit. '
        'crops is a list naming the crops that have been grown in the gardens owned or edited by this gardener. '
        'varieties is a list naming the varieties that have been grown in the gardens owned or edited by this gardener. '
        'numPlantings is an integer indicating the number of plantings in the gardens owned or edited by this gardener. '
        'plantings is a list of objects with data about the plantings associated with this crop. '
        'Planting data includes the garden name, the gardener username, the crop name, the variety name, '
        'the planting start date, the planting pull date, whether or not a greenhouse was used to start the plant '
        'the germination outcome, the appearance outcome, the yield outcome, the flavor outcome, and the resistance outcome',
    Schema(
      SchemaType.object,
      properties: {
        'username': Schema(
          SchemaType.string,
          description: 'The username of a gardener in GeoGardenClub.',
        ),
      },
    ));
