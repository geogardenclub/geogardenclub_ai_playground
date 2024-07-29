import 'dart:convert';

import 'package:flutter/services.dart';

enum DbType {
  chapter,
  crop,
  garden,
  gardener,
  outcome,
  planting,
  seed,
  user,
  variety
}

class MockupDb {
  late Map<DbType, List<dynamic>> data = {};

  Future<void> initializeDb() async {
    String path = 'assets/mockup-data/fixture1';
    data[DbType.chapter] =
        json.decode(await rootBundle.loadString('$path/chapterData.json'));
    data[DbType.crop] =
        json.decode(await rootBundle.loadString('$path/cropData.json'));
    data[DbType.garden] =
        json.decode(await rootBundle.loadString('$path/gardenData.json'));
    data[DbType.gardener] =
        json.decode(await rootBundle.loadString('$path/gardenerData.json'));
    data[DbType.outcome] =
        json.decode(await rootBundle.loadString('$path/outcomeData.json'));
    data[DbType.planting] =
        json.decode(await rootBundle.loadString('$path/plantingData.json'));
    data[DbType.seed] =
        json.decode(await rootBundle.loadString('$path/seedData.json'));
    data[DbType.user] =
        json.decode(await rootBundle.loadString('$path/userData.json'));
    data[DbType.variety] =
        json.decode(await rootBundle.loadString('$path/varietyData.json'));
    print('MockupDb initialized with '
        '${getCount(DbType.chapter)} chapters, ${getCount(DbType.crop)} crops, '
        '${getCount(DbType.garden)} gardens, '
        '${getCount(DbType.gardener)} gardeners, ${getCount(DbType.outcome)} outcomes, '
        '${getCount(DbType.planting)} plantings, ${getCount(DbType.seed)} seeds, '
        '${getCount(DbType.user)} users, and '
        '${getCount(DbType.variety)} varieties.');
    // print('ChapterData: ${getMyChapterData()}');
    // print('My Chapter Name: ${getMyChapterName()}');
    // print('My Username: ${getMyUsername()}');
    // print('Bean data: ${getCropData('Bean')}');
    // print('Carrot data: ${getVarietyData('Carrot', 'Scarlet Nantes')}');
    // print('todays date: ${await todaysDate({})}');
    // print(
    // 'outcomes ${getPlantingsWithOutcomes(outcomeType: 'germination', outcomeValue: 0)}');
    print('gardener data: ${getGardenerData('@fluke')}');
  }

  int getCount(DbType dbType) {
    return data[dbType]!.length;
  }

  List<String> getUsernames() {
    return data[DbType.user]!.map<String>((user) => user['username']).toList();
  }

  String getMyUsername() {
    Map<String, dynamic> chapterData = getMyChapterData();
    return chapterData['gardenerUsernames'][0];
  }

  String getMyChapterName() {
    Map<String, dynamic> chapterData = getMyChapterData();
    return chapterData['name'];
  }

  Map<String, dynamic> getVarietyData(String cropName, String varietyName) {
    List<dynamic> plantings = data[DbType.planting]!
        .where((planting) =>
            (planting['cachedCropName'] == cropName) &&
            (planting['cachedVarietyName'] == varietyName) &&
            (planting['isVendor'] == false))
        .toList();
    List<String> gardenNames = plantings
        .map<String>((planting) => planting['gardenID'])
        .map<String>((gardenID) => getGardenName(gardenID))
        .toSet()
        .toList();
    List<String> gardenerUsernames = plantings
        .map<String>((planting) => planting['gardenID'])
        .map<String>((gardenID) => getUsernameFromGardenID(gardenID))
        .toSet()
        .toList();
    List<Map<String, dynamic>> plantingData = plantings
        .map<Map<String, dynamic>>((planting) => makePlanting(planting))
        .toList();
    return {
      'gardens': gardenNames,
      'gardeners': gardenerUsernames,
      'numPlantings': plantings.length,
      'plantings': plantingData,
    };
  }

  Map<String, dynamic> getCropData(String cropName) {
    List<dynamic> plantings = data[DbType.planting]!
        .where((planting) =>
            (planting['cachedCropName'] == cropName) &&
            (planting['isVendor'] == false))
        .toList();
    List<String> gardenNames = plantings
        .map<String>((planting) => planting['gardenID'])
        .map<String>((gardenID) => getGardenName(gardenID))
        .toSet()
        .toList();
    List<String> gardenerUsernames = plantings
        .map<String>((planting) => planting['gardenID'])
        .map<String>((gardenID) => getUsernameFromGardenID(gardenID))
        .toSet()
        .toList();
    Set<String> varietySet = {};
    for (var planting in plantings) {
      if (planting['cachedVarietyName'] != null) {
        varietySet.add(planting['cachedVarietyName']!);
      }
    }
    List<String> varieties = varietySet.toList();
    List<Map<String, dynamic>> plantingData = plantings
        .map<Map<String, dynamic>>((planting) => makePlanting(planting))
        .toList();
    return {
      'gardens': gardenNames,
      'gardeners': gardenerUsernames,
      'varieties': varieties,
      'numPlantings': plantings.length,
      'plantings': plantingData,
    };
  }

  Map<String, dynamic> makePlanting(Map<String, dynamic> planting) {
    return {
      'garden': getGardenName(planting['gardenID']),
      'gardener': getUsernameFromGardenID(planting['gardenID']),
      'variety': planting['cachedVarietyName'],
      //'${planting["cachedCropName"]} (${planting["cachedVarietyName"]})',
      'crop': planting['cachedCropName'],
      'startDate': planting['startDate'],
      'pullDate': planting['pullDate'],
      'usedGreenhouse': planting['usedGreenhouse'],
      'germination': getDbOutcome(planting['plantingID'], 'germination'),
      'yield': getDbOutcome(planting['plantingID'], 'yieldd'),
      'appearance': getDbOutcome(planting['plantingID'], 'appearance'),
      'flavor': getDbOutcome(planting['plantingID'], 'flavor'),
      'resistance': getDbOutcome(planting['plantingID'], 'resistance'),
    };
  }

  int getDbOutcome(String plantingID, String dbOutcomeType) {
    Map<String, dynamic>? outcome = data[DbType.outcome]!.firstWhere(
        (outcome) => outcome['plantingID'] == plantingID,
        orElse: () => null);
    if (outcome == null) {
      return 0;
    }
    if (outcome[dbOutcomeType] == null) {
      return 0;
    }
    return outcome[dbOutcomeType];
  }

  Map<String, dynamic> getGardenerData(String username) {
    String userID = data[DbType.user]!
        .firstWhere((user) => user['username'] == username)['userID'];
    List<dynamic> ownedGardens = data[DbType.garden]!
        .where((garden) => garden['ownerID'] == userID)
        .toList();
    List<String> ownedGardenNames =
        ownedGardens.map<String>((garden) => garden['name']).toList();
    return {
      'username': username,
      'gardensOwned': ownedGardenNames,
      'gardensEdited': [],
      'numPlantings': getNumPlantings(gardens: ownedGardenNames),
      'plantings': getGardensPlantings(ownedGardenNames),
      'cropNames': getCrops(gardens: ownedGardenNames),
      'varietyNames': getVarieties(gardens: ownedGardenNames),
    };
  }

  int getNumPlantings({List<String> gardens = const []}) {
    int numPlantings = 0;
    for (String gardenName in gardens) {
      String gardenID = getGardenID(gardenName);
      numPlantings += data[DbType.planting]!
          .where((planting) => planting['gardenID'] == gardenID)
          .length;
    }
    return numPlantings;
  }

  List<Map<String, dynamic>> getPlantingsWithOutcomes(
      {required String outcomeType, required int outcomeValue}) {
    // Create a list of plantings that includes their outcome data.
    List nonVendorPlantings = data[DbType.planting]!
        .where((planting) => planting['isVendor'] == false)
        .toList();
    List<Map<String, dynamic>> plantings =
        nonVendorPlantings.map((planting) => makePlanting(planting)).toList();
    return plantings
        .where((planting) => planting[outcomeType] == outcomeValue)
        .toList();
  }

  List<Map<String, Object?>> getGardenPlantings(String garden) {
    // Create a list of plantings that includes their outcome data.
    String gardenID = getGardenID(garden);
    List dbPlantings = data[DbType.planting]!
        .where((planting) => planting['gardenID'] == gardenID)
        .toList();
    return dbPlantings.map((planting) => makePlanting(planting)).toList();
  }

  List<Map<String, Object?>> getGardensPlantings(List<String> gardens) {
    // Create a list of plantings that includes their outcome data.
    List<Map<String, Object?>> plantings = [];
    for (String garden in gardens) {
      plantings.addAll(getGardenPlantings(garden));
    }
    return plantings;
  }

  List<String> getCrops({List<String> gardens = const []}) {
    Set<String> cropNames = {};
    for (String gardenName in gardens) {
      String gardenID = getGardenID(gardenName);
      cropNames.addAll(data[DbType.planting]!
          .where((planting) => planting['gardenID'] == gardenID)
          .map<String>((planting) => planting['cachedCropName']));
    }
    List<String> cropNameList = cropNames.toList();
    cropNameList.sort();
    return cropNameList;
  }

  List<String> getVarieties({List<String> gardens = const []}) {
    Set<String> varietyNames = {};
    for (String gardenName in gardens) {
      String gardenID = getGardenID(gardenName);
      varietyNames.addAll(data[DbType.planting]!
          .where((planting) => planting['gardenID'] == gardenID)
          .map<String>((planting) =>
              '${planting["cachedCropName"]} (${planting["cachedVarietyName"]})'));
    }
    List<String> varietyNameList = varietyNames.toList();
    varietyNameList.sort();
    return varietyNameList;
  }

  String getGardenID(String gardenName) {
    return data[DbType.garden]!
        .firstWhere((garden) => garden['name'] == gardenName)['gardenID'];
  }

  String getGardenName(String gardenID) {
    return data[DbType.garden]!
        .firstWhere((garden) => garden['gardenID'] == gardenID)['name'];
  }

  String getUsername(String userID) {
    return data[DbType.user]!
        .firstWhere((user) => user['userID'] == userID)['username'];
  }

  String getUsernameFromGardenID(String gardenID) {
    String userID = data[DbType.garden]!
        .firstWhere((garden) => garden['gardenID'] == gardenID)['ownerID'];
    return getUsername(userID);
  }

  Map<String, dynamic> getMyChapterData() {
    Map<String, dynamic> chapterData = data[DbType.chapter]!.first;
    final nonVendorGardens = data[DbType.garden]!
        .where((garden) => garden['isVendor'] == false)
        .toList();
    List<String> gardenNames =
        nonVendorGardens.map<String>((garden) => garden['name']).toList();
    List<String> gardenerUsernames =
        data[DbType.user]!.map<String>((user) => user['username']).toList();
    // Note we really should iterate through the plantings to get crops and varieties
    Set<String> cropNames = {};
    cropNames.addAll(data[DbType.planting]!
        .map<String>((planting) => planting['cachedCropName']));
    Set<String> varietyNames = {};
    varietyNames.addAll(data[DbType.planting]!.map<String>((planting) =>
        '${planting["cachedCropName"]} (${planting["cachedVarietyName"]})'));
    List<String> cropNameList = cropNames.toList();
    cropNameList.sort();
    List<String> varietyNameList = varietyNames.toList();
    varietyNameList.sort();
    chapterData['gardenNames'] = gardenNames;
    chapterData['gardenerUsernames'] = gardenerUsernames;
    chapterData['cropNames'] = cropNameList;
    chapterData['varietyNames'] = varietyNameList;
    return chapterData;
  }
}

final mockupDb = MockupDb();
