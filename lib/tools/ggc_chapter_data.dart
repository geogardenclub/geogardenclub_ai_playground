// Given a gardener name, returns a (possibly empty) list of their gardens.
import 'package:firebase_vertexai/firebase_vertexai.dart';

import '../data/mockup_db.dart';

Future<Map<String, Object?>> ggcChapterData(
    Map<String, Object?> arguments) async {
  return mockupDb.getChapterData();
}

final ggcChapterDataTool = FunctionDeclaration(
    'ggcChapterData',
    'Returns the name, postalCodes, gardenNames, gardenerUserNames, cropNames, '
        'and varietyNames in the current Chapter. '
        'Name is a string that is the name of the Chapter. '
        'postalCodes is a list of strings, each of which is a zip code in the Chapter. '
        'gardenNames is a list of strings, each of which is the name of a garden in the Chapter. '
        'gardenerUserNames is a list of strings, each of which is the username of a gardener in the Chapter. '
        'cropNames is a list of strings, each of which is the name of a crop in the Chapter. '
        'varietyNames is a list of strings, each of which is the name of a plant variety in the Chapter.',
    null);
