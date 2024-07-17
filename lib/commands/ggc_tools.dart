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
