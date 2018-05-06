abstract class SettingsMigration {
  const SettingsMigration();

  Map<String, dynamic> migrate(Map<String, dynamic> oldMap) {
    Map<String, dynamic> newMap = new Map<String, dynamic>.from(oldMap);
    newMap['serialVersionID'] = endVersion;
    return newMap;
  }

  int get startVersion;
  int get endVersion;
}
