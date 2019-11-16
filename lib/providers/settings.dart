import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './setting.dart';

class Settings with ChangeNotifier {
  List<Setting> _settings = [];
  String authToken;
  String userId;

  Settings(this.authToken, this.userId, this._settings);

  List<Setting> get settings {
    return [..._settings];
  }

  Future<void> addSetting(Setting setting) async {
    try {
      final url =
          'https://monthly-expenses-d56f8.firebaseio.com/settings/$userId.json?auth=$authToken';

       await http.put(
        url,
        body: json.encode(
          {
            '${setting.setTitle}': setting.setValue,
          },
        ),
      );

      final newSetting = Setting(
        setTitle: setting.setTitle,
        setValue: setting.setValue,
      );

      _settings.add(newSetting);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getUserSettings() async {
    final url =
        'https://monthly-expenses-d56f8.firebaseio.com/settings/$userId.json?auth=$authToken';

    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      List<Setting> loadedSettings = [];

      if (extractedData == null) {
        return;
      }

      extractedData.forEach((setting, value) {
        loadedSettings.add(Setting(
          setTitle: setting,
          setValue: value,
        ));
      });

      _settings = loadedSettings;
    } catch (error) {
      throw error;
    }
  }

  String getSettingValue(String setTitle) {
    final sett =
        _settings.firstWhere((s) => s.setTitle == setTitle, orElse: () => null);
    if (sett != null) {
      return sett.setValue;
    }
    notifyListeners();
    return '';
  }
}
