import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
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
      _token = data['idToken'];
      _userId = data['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            data['expiresIn'],
          ),
        ),
      );

      notifyListeners();
      _automaticallySignOut();
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
  }

  void _automaticallySignOut() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }

    final timeToExpiry = _expiryDate!.difference(DateTime.now());

    _authTimer = Timer(Duration(seconds: timeToExpiry.inSeconds), signOut);
  }
}
