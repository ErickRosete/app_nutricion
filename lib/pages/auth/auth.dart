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
        labelText: 'Correo electrónico',
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        String emailRegExp =
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
        if (value.isEmpty || !RegExp(emailRegExp).hasMatch(value)) {
          return "Correo electrónico válido";
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
        labelText: 'Contraseña',
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (String value) {
        if (value.isEmpty || value.length < 4) {
          return "Contraseña inválida";
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

  Widget _buildLogoImage() {
    return new Container(
      margin: EdgeInsets.all(20.0),
      width: 190.0,
      height: 190.0,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        image: new DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/logo.jpg'),
        ),
      ),
    );
  }

  void _submitForm(Function authenticate) async {
    if (!_formKey.currentState.validate() ||
        (_authMode == AuthMode.Signup && !_formData['acceptTerms'])) return;

    _formKey.currentState.save();

    Map<String, dynamic> successInformation = await authenticate(
        _formData['email'], _formData['password'], AuthMode.Login);

    if (successInformation['success']) {
      Navigator.pushReplacementNamed(context, '/');
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Ha ocurrido un error!'),
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
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: _buildBackgroundImage(),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildLogoImage(),
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
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
                          _authMode == AuthMode.Signup
                              ? _buildAcceptSwitch()
                              : Container(),
                          SizedBox(height: 20.0),
                          // FlatButton(
                          //   child: Text(
                          //       'Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}'),
                          //   onPressed: () {
                          //     setState(() {
                          //       _authMode = _authMode == AuthMode.Login
                          //           ? AuthMode.Signup
                          //           : AuthMode.Login;
                          //     });
                          //   },
                          // ),
                          // SizedBox(height: 10.0),
                          ScopedModelDescendant<MainModel>(
                            builder: (BuildContext context, Widget child,
                                MainModel model) {
                              return model.isLoading
                                  ? Center(child: CircularProgressIndicator())
                                  : RaisedButton(
                                      color: Theme.of(context).primaryColor,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 50.0, vertical: 10.0),
                                      child: Text(
                                        _authMode == AuthMode.Login
                                            ? 'LOGIN'
                                            : 'Signup',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white),
                                      ),
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
            ],
          ),
        ),
      ),
    );
  }
}
