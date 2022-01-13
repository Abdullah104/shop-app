import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuthenticated => token != null;

  String? get token {
    if (_expiryDate != null) {
      if (_expiryDate!.isAfter(DateTime.now()) && _token != null) {
        return _token;
      }
    }
  }

  String? get userId => _userId;

  Future<void> signUp(String email, String password) async =>
      await _authenticate(email, password, 'signUp');

  Future<void> signIn(String email, String password) async =>
      await _authenticate(email, password, 'signInWithPassword');

  Future<void> _authenticate(
    String email,
    String password,
    String urlSegment,
  ) async {
    final response = await post(
      Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCzh69vKlFfsi6kzOGZE17Lb46BiAh4Yk0',
      ),
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );

    final data = json.decode(response.body);

    if (data['error'] != null) {
      throw HttpException(data['error']['message']);
    } else {
      final sharedPreferences = await SharedPreferences.getInstance();
      late final String userData;

      _token = data['idToken'];
      _userId = data['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            data['expiresIn'],
          ),
        ),
      );

      userData = json.encode({
        'token': _token,
        'user_id': _userId,
        'expiry_date': _expiryDate!.toIso8601String(),
      });

      _automaticallySignOut();
      notifyListeners();

      sharedPreferences.setString('user_data', userData);
    }
  }

  void signOut() {
    _expiryDate = null;
    _token = null;
    _userId = null;

    if (_authTimer != null) {
      _authTimer!.cancel();

      _authTimer = null;
    }

    notifyListeners();

    SharedPreferences.getInstance()
        .then((sharedPreferences) => sharedPreferences.clear()); 
  }

  void _automaticallySignOut() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }

    final timeToExpiry = _expiryDate!.difference(DateTime.now());

    _authTimer = Timer(Duration(seconds: timeToExpiry.inSeconds), signOut);
  }

  Future<bool> tryAutoLogin() async {
    late final bool autoLoginAttemptResult;
    final sharedPreferences = await SharedPreferences.getInstance();

    if (!sharedPreferences.containsKey('user_data')) {
      autoLoginAttemptResult = false;
    } else {
      final extractedUserData = json.decode(
        sharedPreferences.getString('user_data')!,
      ) as Map<String, dynamic>;

      final expirationDate = DateTime.parse(extractedUserData['expiry_date']);
      final token = extractedUserData['token'];
      final userId = extractedUserData['user_id'];

      if (expirationDate.isAfter(DateTime.now())) {
        _token = token;
        _userId = userId;
        _expiryDate = expirationDate;

        notifyListeners();
        _automaticallySignOut();

        autoLoginAttemptResult = true;
      } else {
        autoLoginAttemptResult = false;
      }
    }

    return autoLoginAttemptResult;
  }
}
