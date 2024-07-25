// Given a gardener name, returns a (possibly empty) list of their gardens.
import 'package:firebase_vertexai/firebase_vertexai.dart';

import '../data/mockup_db.dart';

Future<Map<String, Object?>> ggcMyChapterName(
    Map<String, Object?> arguments) async {
  return {
    'name': mockupDb.getMyChapterName(),
  };
}

final ggcMyChapterNameTool = FunctionDeclaration(
    'ggcMyChapterName', 'Returns the name of my GeoGardenClub chapter.', null);
