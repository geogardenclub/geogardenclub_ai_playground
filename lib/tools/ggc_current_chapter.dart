// Given a gardener name, returns a (possibly empty) list of their gardens.
import 'package:firebase_vertexai/firebase_vertexai.dart';

Future<Map<String, Object?>> ggcCurrentChapter(
    Map<String, Object?> arguments) async {
  return {
    'name': 'Whatcom, WA',
    'location': 'Whatcom County, Washington, USA',
  };
}

final ggcCurrentChapterTool = FunctionDeclaration(
    'ggcCurrentChapter',
    'Returns the name and geographic location of the current GeoGardenClub chapter.',
    null);
