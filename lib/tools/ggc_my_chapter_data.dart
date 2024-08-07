// Given a gardener name, returns a (possibly empty) list of their gardens.
import 'package:firebase_vertexai/firebase_vertexai.dart';

import '../data/mockup_db.dart';

Future<Map<String, Object?>> ggcMyChapterData(
    Map<String, Object?> arguments) async {
  return mockupDb.getMyChapterData();
}

final ggcMyChapterDataTool = FunctionDeclaration(
    'ggcMyChapterData',
    'Returns the name, countryCode, postalCodes, gardens, gardenerUserNames, crops, '
        'and varieties in my Chapter. '
        'name is a string that is the name of the Chapter. '
        'countryCode is a two character string that indicates the country of the Chapter. '
        'postalCodes is a list of strings, each of which is a zip code in the Chapter. '
        'gardens is a list of strings, each of which is the name of a garden in the Chapter. '
        'gardenerUserNames is a list of strings, each of which is the username of a gardener in the Chapter. '
        'crops is a list of strings, each of which is the name of a crop in the Chapter. '
        'varieties is a list of strings, each of which is the name of a plant variety in the Chapter.',
    null);
