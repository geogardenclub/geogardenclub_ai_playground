import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:intl/intl.dart';

Future<Map<String, Object?>> todaysDate(Map<String, Object?> arguments) async {
  return {'date': DateFormat('yyyy-MM-dd').format(DateTime.now())};
}

final todaysDateTool = FunctionDeclaration(
    'todaysDate', 'Returns the current date in YYYY-MM-DD format.', null);
