// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:chat/widgets/pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  final bool isLoading;

  const AuthForm(
    this.submitFn,
    this.isLoading,
  ) : super();

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = '';
  String _password = '';
  String _username = '';
  File? _userImageFile;

  void _pickedImage(File pickedImage) {
    _userImageFile = pickedImage;
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (!_isLogin && _userImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please pick an image.'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isValid!) {
      _formKey.currentState!.save();
      widget.submitFn(_email.trim(), _password.trim(), _username.trim(),
          _userImageFile!, _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isLogin) UserImagePicker(_pickedImage),
                TextFormField(
                  autocorrect: false,
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.none,
                  key: const ValueKey('email'),
                  validator: (val) {
                    if (val!.isEmpty || !val.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  onSaved: (val) => _email = val!,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email Address'),
                ),
                if (!_isLogin)
                  TextFormField(
                    autocorrect: true,
                    enableSuggestions: false,
                    textCapitalization: TextCapitalization.words,
                    key: const ValueKey('username'),
                    validator: (val) {
                      if (val!.isEmpty || val.length < 4) {
                        return 'Please enter at least 4 characters';
                      }
                      return null;
                    },
                    onSaved: (val) => _username = val!,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                TextFormField(
                  key: const ValueKey('password'),
                  validator: (val) {
                    if (val!.isEmpty || val.length < 7) {
                      return 'Password must be at least 7 characters';
                    }
                    return null;
                  },
                  onSaved: (val) => _password = val!,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                if (widget.isLoading) const CircularProgressIndicator(),
                if (!widget.isLoading)
                  ElevatedButton(
                    child: Text(_isLogin ? 'Login' : 'Sign Up'),
                    onPressed: _submit,
                  ),
                if (!widget.isLoading)
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                    ),
                    child: Text(_isLogin
                        ? 'Create new account'
                        : 'I already have an account'),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
