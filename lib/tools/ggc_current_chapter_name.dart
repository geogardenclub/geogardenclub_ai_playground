// Given a gardener name, returns a (possibly empty) list of their gardens.
import 'package:firebase_vertexai/firebase_vertexai.dart';

import '../data/mockup_db.dart';

Future<Map<String, Object?>> ggcCurrentChapterName(
    Map<String, Object?> arguments) async {
  return {
    'name': mockupDb.getCurrentChapterName(),
  };
}

final ggcCurrentChapterNameTool = FunctionDeclaration('ggcCurrentChapterName',
    'Returns the name of the current GeoGardenClub chapter.', null);
