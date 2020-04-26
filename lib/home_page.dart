import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {

  String image = "";
  String name = "";

  @override
  void initState() {
    _initPrefrences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('build executing');
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 140,
            ),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              backgroundImage: CachedNetworkImageProvider(
                  image),
            ),
            SizedBox(height: 30,),
            Text(name)
          ],
        ),
      ),
      body: _HomePageBody(),
    );
  }

  void _initPrefrences() async {

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    print('_initPrefrences executed');
    setState(() {
      name = _prefs.getString("name");
      image = _prefs.getString("image");
    });
  }
}

class _HomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
