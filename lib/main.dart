import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_training/constants.dart';
import 'package:http/http.dart' as http;

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
      home: Scaffold(
        appBar: AppBar(
          title: Text("App bar"),
        ),
        body: HomePage(

        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return  Container(
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
                 showLoader? CircularProgressIndicator() : RaisedButton(
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
    Map<String, dynamic> _body = Map();
    _body.putIfAbsent("username", () => name);
    _body.putIfAbsent("password", () => password);
    var apiResponse = await http.post(LOGIN_URL,
        body: {"username": "8240280249", "password": "123456"});
    setState(() {
      showLoader = false;
    });
    try {
      print('response ${apiResponse.statusCode}');
      print('response body ${json.decode(apiResponse.body).toString()}');
      if (apiResponse.statusCode == 200) {
        print('response body ${apiResponse.body}');
        //  Map<String,dynamic>responseObj = json.decode(apiResponse.body);

      }
      if (apiResponse.statusCode == 500) {
        print("sever error");
      }
    } catch (ex) {
      print('exception happened $ex');
    }
  }
}
