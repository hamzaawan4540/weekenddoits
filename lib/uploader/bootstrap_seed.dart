import 'package:weekenddoit/data/dummy_packages.dart';

import '../screens/repositories/travel_package_repository.dart';

class BootstrapSeed {
  static Future<void> run() async {
    final repo = TravelPackageRepository();
    await repo.seedIfEmpty(dummyPackages);
  }
}
