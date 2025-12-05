import 'package:flutter/material.dart';
import '../../domain/entities/profile.dart';
import '../../domain/usecases/get_profiles.dart';

class SwipeProvider extends ChangeNotifier {
  final GetProfiles getProfiles;
  List<Profile> _profiles = [];
  int _currentIndex = 0;
  bool _wasLiked = false;

  SwipeProvider(this.getProfiles);

  List<Profile> get profiles => _profiles;
  int get currentIndex => _currentIndex;
  bool get wasLiked => _wasLiked;
  Profile? get currentProfile => _currentIndex < _profiles.length ? _profiles[_currentIndex] : null;

  Future<void> loadProfiles() async {
    _profiles = await getProfiles();
    notifyListeners();
  }

  void like() {
    if (_currentIndex < _profiles.length) {
      _wasLiked = true;
      _currentIndex++;
      notifyListeners();
    }
  }

  void skip() {
    if (_currentIndex < _profiles.length) {
      _wasLiked = false;
      _currentIndex++;
      notifyListeners();
    }
  }
}
