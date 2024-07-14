import 'package:firebase_vertexai/firebase_vertexai.dart';

Future<Map<String, Object?>> findExchangeRate(
  Map<String, Object?> arguments,
) async =>
    // This hypothetical API returns a JSON such as:
// {"base":"USD","date":"2024-04-17","rates":{"SEK": 0.091}}
    {
      'date': arguments['currencyDate'],
      'base': arguments['currencyFrom'],
      'rates': <String, Object?>{arguments['currencyTo']! as String: 0.091},
    };

final exchangeRateTool = FunctionDeclaration(
  'findExchangeRate',
  'Returns the exchange rate between currencies on given date.',
  Schema(
    SchemaType.object,
    properties: {
      'currencyDate': Schema(
        SchemaType.string,
        description: 'A date in YYYY-MM-DD format or '
            'the exact value "latest" if a time period is not specified.',
      ),
      'currencyFrom': Schema(
        SchemaType.string,
        description: 'The currency code of the currency to convert from, '
            'such as "USD".',
      ),
      'currencyTo': Schema(
        SchemaType.string,
        description: 'The currency code of the currency to convert to, '
            'such as "USD".',
      ),
    },
  ),
);
