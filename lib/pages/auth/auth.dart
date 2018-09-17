import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/auth.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.5),
        BlendMode.dstATop,
      ),
      image: AssetImage('assets/background.jpg'),
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'E-Mail',
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        String emailRegExp =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        if (value.isEmpty || !RegExp(emailRegExp).hasMatch(value)) {
          return "Please enter a valid E-mail";
        }
        return null;
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      controller: _passwordTextController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (String value) {
        if (value.isEmpty || value.length < 4) {
          return "Invalid Password";
        }
        return null;
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Confirm password',
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (String value) {
        if (_passwordTextController.text != value) {
          return "Password do not match";
        }
        return null;
      },
    );
  }

  Widget _buildAcceptSwitch() {
    return SwitchListTile(
      title: Text('Accept terms'),
      value: _formData['acceptTerms'],
      onChanged: (bool value) {
        setState(() {
          _formData['acceptTerms'] = value;
        });
      },
    );
  }

  void _submitForm(Function authenticate) async {
    if (!_formKey.currentState.validate() || !_formData['acceptTerms']) return;
    _formKey.currentState.save();

    Map<String, dynamic> successInformation = await authenticate(
        _formData['email'], _formData['password'], _authMode);

    if (successInformation['success']) {
      Navigator.pushReplacementNamed(context, '/');
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('An Error Ocurred!'),
              content: Text(successInformation['message']),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok'),
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      // body: ProductManager(startingProduct:'Food Tester')
      body: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
            image: _buildBackgroundImage(),
          ),
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: targetWidth,
                child: Column(
                  children: <Widget>[
                    _buildEmailTextField(),
                    SizedBox(height: 10.0),
                    _buildPasswordTextField(),
                    SizedBox(height: 10.0),
                    _authMode == AuthMode.Signup
                        ? _buildPasswordConfirmTextField()
                        : Container(),
                    _buildAcceptSwitch(),
                    SizedBox(height: 10.0),
                    FlatButton(
                      child: Text(
                          'Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}'),
                      onPressed: () {
                        setState(() {
                          _authMode = _authMode == AuthMode.Login
                              ? AuthMode.Signup
                              : AuthMode.Login;
                        });
                      },
                    ),
                    SizedBox(height: 10.0),
                    ScopedModelDescendant<MainModel>(
                      builder: (BuildContext context, Widget child,
                          MainModel model) {
                        return model.isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : RaisedButton(
                                child: Text(_authMode == AuthMode.Login
                                    ? 'Login'
                                    : 'Signup'),
                                onPressed: () =>
                                    _submitForm(model.authenticate),
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
