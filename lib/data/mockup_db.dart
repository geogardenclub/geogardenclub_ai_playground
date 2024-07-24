import 'dart:convert';

import 'package:flutter/services.dart';

enum DbType {
  bed,
  chapter,
  crop,
  editor,
  garden,
  gardener,
  outcome,
  planting,
  seed,
  task,
  user,
  variety
}

class MockupDb {
  late Map<DbType, List<dynamic>> data = {};

  Future<void> initializeDb() async {
    String path = 'assets/mockup-data/fixture1';
    data[DbType.bed] =
        json.decode(await rootBundle.loadString('$path/bedData.json'));
    data[DbType.chapter] =
        json.decode(await rootBundle.loadString('$path/chapterData.json'));
    data[DbType.crop] =
        json.decode(await rootBundle.loadString('$path/cropData.json'));
    data[DbType.editor] =
        json.decode(await rootBundle.loadString('$path/editorData.json'));
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
    data[DbType.task] =
        json.decode(await rootBundle.loadString('$path/taskData.json'));
    data[DbType.user] =
        json.decode(await rootBundle.loadString('$path/userData.json'));
    data[DbType.variety] =
        json.decode(await rootBundle.loadString('$path/varietyData.json'));
    print('MockupDb initialized with ${getCount(DbType.bed)} beds, '
        '${getCount(DbType.chapter)} chapters, ${getCount(DbType.crop)} crops, '
        '${getCount(DbType.editor)} editors, ${getCount(DbType.garden)} gardens, '
        '${getCount(DbType.gardener)} gardeners, ${getCount(DbType.outcome)} outcomes, '
        '${getCount(DbType.planting)} plantings, ${getCount(DbType.seed)} seeds, '
        '${getCount(DbType.task)} tasks, ${getCount(DbType.user)} users, and '
        '${getCount(DbType.variety)} varieties.');
    print('ChapterData: ${getChapterData()}');
    print('Current Chapter Name: ${getCurrentChapterName()}');
    print('Current Gardener Username: ${getCurrentGardenerUsername()}');
    print(
        'Gardener data: ${getGardenerData(getCurrentGardenerUsername()).toString()}');
  }

  int getCount(DbType dbType) {
    return data[dbType]!.length;
  }

  List<String> getUsernames() {
    return data[DbType.user]!.map<String>((user) => user['username']).toList();
  }

  String getCurrentGardenerUsername() {
    Map<String, dynamic> chapterData = getChapterData();
    return chapterData['gardenerUsernames'][0];
  }

  String getCurrentChapterName() {
    Map<String, dynamic> chapterData = getChapterData();
    return chapterData['name'];
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
    };
  }

  Map<String, dynamic> getChapterData() {
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
