import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_app/editWatchNow.dart';
import 'package:movie_app/model/movie_model.dart';
import 'package:movie_app/utils/movieProvider.dart';
import 'package:provider/provider.dart';

class WatchNowMovieList extends StatelessWidget {
  bool absorbing;
  WatchNowMovieList(this.absorbing);
  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(builder: (context, movieProvider, child) {
      movieProvider.getWatchNowMovies();
      return movieProvider.watchNowMovieCount == 0
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
              ),
              SizedBox(height: 20,),
              Text(
                "Add Movies",
                style: TextStyle(
                    color: Color(0xff99FFFF), fontWeight: FontWeight.bold,fontFamily: 'Raleway'),
              )
            ],
          ))
          : ListView.builder(
              itemCount: movieProvider.watchNowMovieCount,
              itemBuilder: (context, index) {
                Movie movie = movieProvider.getWatchNowMovie(index);
                return AbsorbPointer(
                  absorbing: !absorbing,
                  child: Dismissible(
                    background: slideRight(),
                    secondaryBackground: slideLeft(),
                    onDismissed: (direction) {
                      if (direction == DismissDirection.startToEnd) {
                        Movie nmovie = Movie(name:
                            movie.name,director:
                             movie.director,watched:
                             true);
                         movieProvider.watchNowToWatched(movie.key,nmovie,index);
                      } else {

                         movieProvider.deleteWatchNowMovie(movie.key,index);
                      }
                    },
                    key:Key(movie.name),
                    child: Card(
                      color: Color(0xff36476A),
                      child: ExpansionTile(
                        iconColor: Color(0xff99FFFF),
                        collapsedIconColor: Color(0xff99FFFF),
                        leading: CircleAvatar(
                          backgroundImage: (movie.imagePath=="default")?AssetImage('assets/popcorn.jpg'):FileImage(File(movie.imagePath)) as ImageProvider,
                          radius: 30,

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
                                  style: TextStyle(color: Color(0xff99FFFF),fontFamily: 'Lato')),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () =>
                                    movieProvider.deleteWatchNowMovie(movie.key,index),
                                child: Text("Delete", style: TextStyle(color: Color(0xff99FFFF),fontFamily: 'Lato')),
                              ),
                              TextButton(
                                onPressed: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>MovieEdit(movie)));
                                },
                                child: Text("Edit", style: TextStyle(color: Color(0xff99FFFF),fontFamily: 'Lato')),
                              ),
                              TextButton(
                                onPressed: () {
                                  Movie nmovie = Movie(name:
                                       movie.name,director:
                                       movie.director,
                                      watched: true);
                                  movieProvider.watchNowToWatched(
                                      movie.key, nmovie,index);
                                },
                                child: Text("Watched", style: TextStyle(color: Color(0xff99FFFF),fontFamily: 'Lato')),
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
            SizedBox(
              width: 20,
            )
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget slideRight() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.check_circle_outline_outlined,
              color: Colors.white,
            ),
            Text(
              "Watched",
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
