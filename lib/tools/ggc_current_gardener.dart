// Given a gardener name, returns a (possibly empty) list of their gardens.
import 'package:firebase_vertexai/firebase_vertexai.dart';

Future<Map<String, Object?>> ggcCurrentGardener(
    Map<String, Object?> arguments) async {
  return {'gardener': '@joe'};
}

final ggcCurrentGardenerTool = FunctionDeclaration(
    'ggcCurrentGardener',
    'Returns the username of the GeoGardenClub gardener asking questions of you.',
    Schema(
      SchemaType.object,
      properties: {'gardener': Schema(SchemaType.string)},
    ));
