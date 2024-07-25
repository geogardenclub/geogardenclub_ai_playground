// Given a gardener name, returns a (possibly empty) list of their gardens.
import 'package:firebase_vertexai/firebase_vertexai.dart';

import '../data/mockup_db.dart';

Future<Map<String, Object?>> ggcMyUsername(
    Map<String, Object?> arguments) async {
  return {'gardener': mockupDb.getMyUsername()};
}

final ggcMyUsernameTool = FunctionDeclaration(
    'ggcMyUsername', 'Returns my GeoGardenClub username.', null);
