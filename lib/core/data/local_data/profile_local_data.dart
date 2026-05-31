import 'package:hive/hive.dart';

class ProfileLocalData {
  ProfileLocalData._();
  static ProfileLocalData? _instance;
  static late Box<String> _profileBox;

  static Future<ProfileLocalData> get instance async {
    if (!Hive.isBoxOpen('profile')) {
      await Hive.openBox<String>('profile');
    }
    _profileBox = Hive.box<String>('profile');
    return _instance ??= ProfileLocalData._();
  }

  Future<void> saveAvatarPath(String path) async {
    await _profileBox.put('avatar_path', path);
  }

  String? getAvatarPath() {
    return _profileBox.get('avatar_path');
  }

  Future<void> clearProfileData() async {
    await _profileBox.clear();
  }
}
