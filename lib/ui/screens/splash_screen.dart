import 'package:flutter/material.dart';
import 'package:tipitaka_pali/data/constants.dart';
import 'package:tipitaka_pali/utils/shared_preferences_provider.dart';

import 'home/home.dart';
import 'initial_setup.dart';

enum DatabaseStatus { uptoDate, outOfDate, notExist }

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder<DatabaseStatus>(
          future: _getDatabaseStatus(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final databaseStatus = snapshot.data;
              switch (databaseStatus) {
                case DatabaseStatus.notExist:
                  return InitialSetup();
                  break;
                case DatabaseStatus.outOfDate:
                  return InitialSetup(isUpdateMode: true);
                  break;
                default:
                  return Home();
                  break;
              }
            }
            return Container();
          }),
    );
  }

  Future<DatabaseStatus> _getDatabaseStatus() async {
    final isExist =
        await SharedPrefProvider.getBool(key: k_key_isDatabaseSaved);
    if (isExist == null) return DatabaseStatus.notExist;

    final dbVersion =
        await SharedPrefProvider.getInt(key: k_key_databaseVersion);
    if (k_currentDatabaseVersion != dbVersion) return DatabaseStatus.outOfDate;

    return DatabaseStatus.uptoDate;
  }
}
