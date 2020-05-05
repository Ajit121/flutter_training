import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_training/model/comment_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

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
              backgroundImage: CachedNetworkImageProvider(image),
            ),
            SizedBox(
              height: 30,
            ),
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

class _HomePageBody extends StatefulWidget {
  @override
  __HomePageBodyState createState() => __HomePageBodyState();
}

class __HomePageBodyState extends State<_HomePageBody> {
  bool isLoading = true;
  List<CommentData> _comments;

  @override
  void initState() {
    super.initState();
    _comments = List();
    _getComments();
  }

  List<String> _name = ['A', 'B', 'C'];

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.separated(
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemBuilder: (context, index) {
              CommentData commentData = _comments[index];
              return Container(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_comments[index].name),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        _onLikeCliked(commentData, index);
                      },
                      child: SvgPicture.asset(
                        'images/love-and-romance.svg',
                        color: commentData.isLike ? Colors.red : Colors.grey,
                        width: 20,
                        height: 20,
                      ),
                    )
                  ],
                ),
              );
            },
            itemCount: _comments.length,
          );
  }

  void _getComments() async {
    try {
      http.Response response = await http.get(COMMENT_URL);

      List<dynamic> _responseData = jsonDecode(response.body);
      print('api response ${_responseData.length}');

      List<CommentData> _cData = List();
      _responseData.forEach((element) {
        _cData.add(CommentData.fromJson(element));
      });

      List<CommentData> _comments = _responseData.map((e) {
        return CommentData.fromJson(e);
      }).toList();
      setState(() {
        this._comments = _comments;
        isLoading = false;
      });
      print('comment list   ${_comments.length}');
    } catch (ex) {
      setState(() {
        isLoading = false;
      });
      print('exception $ex');
    }
  }

  void _onLikeCliked(CommentData commentData, int index) {
    commentData.isLike = !commentData.isLike;
    setState(() {});
  }
}
