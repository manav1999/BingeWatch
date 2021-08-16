
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/addMovie.dart';
import 'package:movie_app/model/quotes.dart';
import 'package:movie_app/utils/movieProvider.dart';
import 'package:movie_app/utils/quotesUtil.dart';
import 'package:movie_app/watchNowMovieList.dart';
import 'package:movie_app/watchedMovieList.dart';
import 'package:provider/provider.dart';
import '/utils/firebaseUtil.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isSignIn = false;
  User? _user = FirebaseAuth.instance.currentUser;
  Quotes q=QuotesUtil().getRandomQuote();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (context) => MovieProvider(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Color(0xff031435),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(35),
            child: AppBar(
              elevation: 0.0,
              backgroundColor: Color(0xff031435),
              foregroundColor: Color(0xff99FFFF),
              actions: [
                IconButton(
                    onPressed: () {
                      if (_isSignIn == true) {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text("Log Out",style: TextStyle(fontFamily: 'Raleway'),),
                                  content: Text("Are you sure ?",style: TextStyle(fontFamily: 'Lato')),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel',style: TextStyle(fontFamily: 'Lato')),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Auth.signOut(context: context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Sign Out SuccessFul")));
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Yes',style: TextStyle(fontFamily: 'Lato')),
                                    ),
                                  ],
                                ));
                        setState(() {
                          _isSignIn = false;
                        });
                      } else
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("Sign In ")));
                    },
                    icon: Icon(
                      Icons.logout,
                      color: Color(0xff99FFFF),
                    ))
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            label: const Text("Add Movie"),
            backgroundColor: Color(0xff2866ED),
            icon: const Icon(Icons.add),
            onPressed: () {
              if (_isSignIn)
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => AddMovies()));
              else
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Sign In to Add Movies")));
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  height: height * 0.3,
                  child: Column(children: [
                    Container(
                      height: height * 0.23,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                () {
                                  if (_user != null && _isSignIn) {
                                    return "Hello, ${_user!.displayName}";
                                  } else
                                    return "Hello, Guest";
                                }(),
                                style: TextStyle(
                                    color: Color(0xff99FFFF), fontSize: 36,fontFamily: 'Raleway'),
                              ),
                            ),
                          ),
                          (_isSignIn)
                              ? Container(
                            padding: EdgeInsets.all(8),
                                  width: width * 0.5,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${q.quote}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic,fontSize: 20,fontFamily: 'Lato'),
                                    ),
                                  ))
                              : Center(
                                  child: Container(
                                    width: width * 0.5,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Color(0xff2866ED)),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)))),
                                      onPressed: () async {
                                        _user = await Auth.signInWithGoogle(
                                            context: context);
                                        setState(() {
                                          _isSignIn = true;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Sign In SuccessFul")));
                                      },
                                      child: Text("Sign In with google"),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0.2, 0, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TabBar(
                            labelColor: Color(0xff9FFFF5),
                            indicator: UnderlineTabIndicator(
                                borderSide: BorderSide(
                                    width: 4, color: Color(0xff2866ED))),
                            isScrollable: true,
                            tabs: [
                              Tab(
                                text: "Watch Now",
                              ),
                              Tab(
                                text: "Watched",
                              )
                            ]),
                      ),
                    )
                  ]),
                ),
                Expanded(
                  child: Container(
                    color: Color(0xff031841),
                    child: TabBarView(
                      children: [
                        WatchNowMovieList(_isSignIn),
                        WatchedMovieList(_isSignIn)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
