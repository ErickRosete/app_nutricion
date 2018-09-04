import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  String _emailValue = "";
  String _passwordValue = "";
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      // body: ProductManager(startingProduct:'Food Tester')
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'E-Mail'),
              keyboardType: TextInputType.emailAddress,
              onChanged: (String value) {
                setState(() {
                  _emailValue = value;
                });
              },
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              onChanged: (String value) {
                setState(() {
                  _passwordValue = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Accept terms'),
              value: _acceptTerms,
              onChanged: (bool value) {
                setState(() {
                  _acceptTerms = value;
                });
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              child: Text("Login"),
              onPressed: () {
                if (_emailValue == "erick@gnerd.guru" &&
                    _passwordValue == "gnerd.guru") {
                  Navigator.pushReplacementNamed(context, '/products');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
