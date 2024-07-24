// Given a gardener name, returns a (possibly empty) list of their gardens.
import 'package:firebase_vertexai/firebase_vertexai.dart';

import '../data/mockup_db.dart';

Future<Map<String, Object?>> ggcCurrentGardenerUsername(
    Map<String, Object?> arguments) async {
  return {'gardener': mockupDb.getCurrentGardenerUsername()};
}

final ggcCurrentGardenerUsernameTool = FunctionDeclaration(
    'ggcCurrentGardenerUsername',
    'Returns the username of the GeoGardenClub gardener using the system.',
    null);
