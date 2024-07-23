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
    print('Usernames: ${getUsernames()}');
  }

  int getCount(DbType dbType) {
    return data[dbType]!.length;
  }

  List<String> getUsernames() {
    return data[DbType.user]!.map<String>((user) => user['username']).toList();
  }
}

final mockupDb = MockupDb();
