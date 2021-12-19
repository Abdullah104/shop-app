import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/http_exception.dart';
import '../providers/auth.dart';
import '../routes/authentication_route.dart';

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final _key = GlobalKey<FormState>();
  var _authMode = AuthenticationMode.signIn;
  final _authData = {'email': '', 'password': ''};
  var _isLoading = false;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      child: Container(
        height: _authMode == AuthenticationMode.signUp ? 320 : 260,
        width: MediaQuery.of(context).size.width * 0.75,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthenticationMode.signUp ? 320 : 260,
        ),
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null) {
                      if (value.isNotEmpty || value.contains('@')) {
                        return null;
                      }
                    }

                    return 'Invalid email!';
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _controller,
                  validator: (value) {
                    if (value != null) {
                      if (value.length >= 5) {
                        return null;
                      }
                    }

                    return 'Password must be at least 5 characters long';
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                if (_authMode == AuthenticationMode.signUp)
                  TextFormField(
                    enabled: _authMode == AuthenticationMode.signUp,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                    ),
                    validator: _authMode == AuthenticationMode.signUp
                        ? (value) {
                            if (value != null) {
                              if (value == _controller.text) {
                                return null;
                              } else {
                                return 'Passwords do not match';
                              }
                            } else {
                              return 'You must confirm your password';
                            }
                          }
                        : null,
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                else
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 8,
                      ),
                      primary: theme.primaryColor,
                      textStyle: TextStyle(
                        color: theme.primaryTextTheme.button!.color,
                      ),
                    ),
                    child: Text(
                      _authMode == AuthenticationMode.signIn
                          ? 'SIGN IN'
                          : 'SIGN UP',
                    ),
                  ),
                TextButton(
                  onPressed: _toggleAuthMode,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 4,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: TextStyle(
                      color: theme.primaryColor,
                    ),
                  ),
                  child: Text(
                    '${_authMode == AuthenticationMode.signIn ? "SIGN UP" : "SIGN IN"} INSTEAD',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  Future<void> _submit() async {
    if (_key.currentState!.validate()) {
      final provider = context.read<Auth>();

      _key.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      try {
        if (_authMode == AuthenticationMode.signIn) {
          await provider.signIn(
            _authData['email']!,
            _authData['password']!,
          );
        } else {
          await provider.signUp(
            _authData['email']!,
            _authData['password']!,
          );
        }
      } on HttpException catch (error) {
        var message = 'Authentication failed: ';

        if (error.toString().contains('EMAIL_EXISTS')) {
          message += 'The email already exists';
        } else if (error.toString().contains('INVALID_EMAIL')) {
          message += 'This is not a valid email';
        } else if (error.toString().contains('WEAK_PASSWORD')) {
          message += 'This password is too weak';
        } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
          message += 'Could not find a user with the given email';
        } else if (error.toString().contains('INVALID_PASSWORD')) {
          message += 'Invalid password';
        }

        _showErrorDialog(message);
      } catch (_) {
        const message = 'Could not authenticate you. Please try again later.';

        _showErrorDialog(message);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleAuthMode() {
    const authenticationModeValues = AuthenticationMode.values;

    setState(() {
      _authMode = authenticationModeValues[
          (authenticationModeValues.indexOf(_authMode) + 1) %
              authenticationModeValues.length];
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error Occured'),
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }
}
