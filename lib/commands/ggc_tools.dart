import 'package:firebase_vertexai/firebase_vertexai.dart';

// Returns a list of gardener names
Future<Map<String, Object?>> findGgcGardeners(
  Map<String, Object?> arguments,
) async =>
    {
      'gardeners': [
        {'name': '@joe'},
        {'name': '@jane'},
        {'name': '@jim'}
      ]
    };

final gardenerNamesTool = FunctionDeclaration(
    'findGgcGardeners',
    'Returns a list of gardener names in GeoGardenClub',
    Schema(
      SchemaType.object,
      properties: {
        'gardeners': Schema(
          SchemaType.array,
          items: Schema(
            SchemaType.object,
            properties: {
              'name': Schema(
                SchemaType.string,
                description: 'The name of a gardener in GeoGardenClub.',
              ),
            },
          ),
        )
      },
    ));

// Given a gardener name, returns a (possibly empty) list of their gardens.
Future<Map<String, Object?>> findGgcGardens(
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

final gardenNamesTool = FunctionDeclaration(
    'findGgcGardens',
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
