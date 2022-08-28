import 'package:flutter/material.dart';
import 'package:tipitaka_pali/data/constants.dart';
import 'package:tipitaka_pali/services/prefs.dart';

import 'home/home_container.dart';
import 'initial_setup.dart';

enum DatabaseStatus { uptoDate, outOfDate, notExist }

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final databaseStatus = _getDatabaseStatus();
    late final Widget child;

    switch (databaseStatus) {
      case DatabaseStatus.notExist:
        child =  const InitialSetup();
        break;
      case DatabaseStatus.outOfDate:
        child =  const InitialSetup(isUpdateMode: true);
        break;
      case DatabaseStatus.uptoDate:
        child = const Home();
        break;
      default:
        child = const Home();
        break;
    }

    return Material(child: child);
  }

  DatabaseStatus _getDatabaseStatus() {
    final isExist = Prefs.isDatabaseSaved;
    if (!isExist) return DatabaseStatus.notExist;

    final dbVersion = Prefs.databaseVersion;
    if (DatabaseInfo.version == dbVersion) return DatabaseStatus.uptoDate;

    return DatabaseStatus.outOfDate;
  }
}
