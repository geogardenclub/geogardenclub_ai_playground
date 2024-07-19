// Given a gardener name, returns a (possibly empty) list of their gardens.
import 'package:firebase_vertexai/firebase_vertexai.dart';

Future<Map<String, Object?>> ggcFindGardens(
    Map<String, Object?> arguments) async {
  final gardenMap = {
    '@joe': ["Joe's Garden 1", "Joe's Garden 2"],
    '@jane': ["Jane's Garden 1"],
    '@jim': ["Jim's Garden 1", "Jim's Garden 2", "Jim's Garden 3"]
  };
  String gardener = arguments['gardener']! as String;
  return {
    'gardens': gardenMap[gardener] ?? [],
  };
}

final ggcFindGardensTool = FunctionDeclaration(
    'ggcFindGardens',
    'Returns a list of garden names associated with a gardener in GeoGardenClub',
    Schema(
      SchemaType.object,
      properties: {
        'gardener': Schema(
          SchemaType.string,
          description: 'The name of a gardener in GeoGardenClub.',
        ),
      },
    ));
