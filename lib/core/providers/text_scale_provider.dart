import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextScaleProvider extends ChangeNotifier {
  static const String _prefKey = 'virar_text_scale_factor';
  static const double minScale = 1.0;
  static const double maxScale = 1.5;

  double _scale = 1.0;

  TextScaleProvider() {
    _loadFromPrefs();
  }

  double get scale => _scale;
  bool get isDefault => _scale == minScale;

  void _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getDouble(_prefKey) ?? minScale;
      _scale = saved.clamp(minScale, maxScale);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> setScale(double value) async {
    final clamped = value.clamp(_scale, maxScale);
    if ((clamped - _scale).abs() < 0.001) return;
    _scale = clamped;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_prefKey, _scale);
    } catch (_) {}
  }

  void increase() => setScale(_scale + 0.1);
  void increaseTo(double target) => setScale(target);
}
