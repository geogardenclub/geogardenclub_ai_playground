import 'package:firebase_vertexai/firebase_vertexai.dart';

// Returns a list of gardener names
Future<Map<String, Object?>> ggcFindGardeners(
  Map<String, Object?> arguments,
) async =>
    {
      'gardeners': [
        {'name': '@joe'},
        {'name': '@jane'},
        {'name': '@jim'}
      ]
    };

final ggcFindGardenersTool = FunctionDeclaration('ggcFindGardeners',
    'Returns a list of the gardener usernames in GeoGardenClub', null);
