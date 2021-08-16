import 'package:flutter/material.dart';
import 'dart:io';
import 'package:movie_app/model/movie_model.dart';
import 'package:movie_app/utils/movieProvider.dart';
import 'package:provider/provider.dart';

class WatchedMovieList extends StatelessWidget {
   bool absorbing;
  WatchedMovieList(this.absorbing);
  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(builder: (context, movieProvider, child) {
      movieProvider.getWatchNowMovies();
      return movieProvider.watchedMovieCount == 0
          ? Container(
              child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Nothing to see Here",
                  style: TextStyle(
                      color: Color(0xff99FFFF), fontWeight: FontWeight.bold,fontFamily: 'Raleway'),
                ),
                Image(
                  image: AssetImage('assets/void.png'),
                  height: MediaQuery.of(context).size.width * 0.7,
                  width: MediaQuery.of(context).size.width * 0.7,
                )
              ],
            ))
          : ListView.builder(
              itemCount: movieProvider.watchedMovieCount,
              itemBuilder: (context, index) {
                Movie movie = movieProvider.getWatchedMovie(index);
                return AbsorbPointer(
                  absorbing: !absorbing,
                  child: Dismissible(
                    background: slideLeft(),
                    onDismissed: (direction) {
                      movieProvider.deleteWatchedMovie(movie.key, index);
                    },
                    key: Key(movie.name),
                    child: Card(
                      color: Color(0xff36476A),
                      child: ExpansionTile(
                        iconColor: Color(0xff99FFFF),
                        collapsedIconColor: Color(0xff99FFFF),
                        leading: CircleAvatar(
                          backgroundImage: (movie.imagePath=="default")?AssetImage('assets/popcorn.jpg'):FileImage(File(movie.imagePath)) as ImageProvider,
                        ),
                        title: Text(
                          movie.name,
                          style: TextStyle(color: Color(0xff99FFFF),fontFamily: 'Raleway'),
                        ),
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Directed By : ${movie.director}',
                                  style: TextStyle(color: Color(0xff99FFFF),fontFamily: 'Raleway')),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () => movieProvider.deleteWatchedMovie(
                                    movie.key, index),
                                child: Text("Delete", style: TextStyle(color: Color(0xff99FFFF),fontFamily: 'Lato')),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
    });
  }

  Widget slideLeft() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              "Delete",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              textAlign: TextAlign.right,
            ),

          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}
