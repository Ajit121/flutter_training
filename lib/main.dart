import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_training/constants.dart';
import 'package:flutter_training/model/user_data.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      home: HomePage()/*Scaffold(
        appBar: AppBar(
          title: Text("App bar"),
        ),
        body: LoginPage(),
      ),*/
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int count = 0;
  TextEditingController _usernameController, _passwordController;
  final _formKey = GlobalKey<FormState>();
  bool showLoader = false;

  @override
  void initState() {
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(60),
              child: Image.asset('images/logo.png'),
            ),
            SizedBox(
              height: 90,
              child: TextFormField(
                controller: _usernameController,
                validator: (text) {
                  if (text.isEmpty) {
                    return "Please enter username";
                  }
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Username'),
              ),
            ),
            SizedBox(
              height: 90,
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                validator: (text) {
                  if (text.isEmpty) {
                    return "Please enter password";
                  }
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Password'),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                showLoader
                    ? CircularProgressIndicator()
                    : RaisedButton(
                  onPressed: () {
                    bool isValid = _formKey.currentState.validate();
                    if (isValid) {
                      String name = _usernameController.text.trim();
                      String password = _passwordController.text.trim();
                      print('name: $name and password: $password');
                      _login(name, password);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    child: Text(
                      'SUMBIT',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future _login(String name, String password) async {
    setState(() {
      showLoader = true;
    });
    Map _data = Map.from({
      'username': name,
      'device_token': "adsjflksfklslkfs",
      'device_type':
      Theme
          .of(context)
          .platform == TargetPlatform.android ? "1" : "2",
      'password': password
    });
    print('params $_data \nurl $LOGIN_URL');
    var apiResponse = await http.post(LOGIN_URL, body: _data);
    setState(() {
      showLoader = false;
    });
    try {
      print('response ${apiResponse.statusCode}');
      print('response body ${json.decode(apiResponse.body).toString()}');
      if (apiResponse.statusCode == 200) {
        print('response body ${apiResponse.body}');
        Map<String, dynamic> responseObj = json.decode(apiResponse.body);
        int responseCode = responseObj['responseCode'];
        print('responseCode $responseCode');
        if (responseCode == 0) {
          String name = responseObj['data']['user_data']['name'];

          UserData userDart =
          UserData.fromJson(responseObj['data']['user_data']);
          String token = responseObj['data']['auth']['access_token'];
          _saveData(userDart, token);
          print('name ${userDart.name}  value of json ${name}');
        } else {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(responseObj['responseText']),
            ),
          );
        }
      }
      if (apiResponse.statusCode == 500) {
        print("sever error");
      }
    } catch (ex) {
      print('exception happened $ex');
    }
  }

  void _saveData(UserData userDart, String token) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString("token", token);
    await _prefs.setString('name', userDart.name);
    await _prefs.setString("image", userDart.image);

    MaterialPageRoute _route = MaterialPageRoute(builder: (context) {
      return HomePage();
    });
    Navigator.of(context).push(_route);
  }
}
