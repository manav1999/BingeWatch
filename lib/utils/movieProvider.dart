import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:movie_app/model/movie_model.dart';

class MovieProvider extends ChangeNotifier {
  static const String _WatchNowMovies = "Movies";
  List<Movie> _watchNowMovies = [];
  List<Movie> _watchedMovies = [];

  //creates a list of movies yet to be watched
  void getWatchNowMovies() async {
    var box = await Hive.openBox<Movie>(_WatchNowMovies);

    _watchNowMovies =
        box.values.where((element) => element.watched == false).toList();
    notifyListeners();
  }

  //creates a list of movies already watched
  void getWatchedMovies() async {
    var box = await Hive.openBox<Movie>(_WatchNowMovies);
    _watchedMovies =
        box.values.where((element) => element.watched == true).toList();
  }

  //gets watchNow movie
  Movie getWatchNowMovie(index) {
    return _watchNowMovies[index];
  }

  //gets watched movie
  Movie getWatchedMovie(index) {
    return _watchedMovies[index];
  }

  //add movies to the box and list
  void addMovie(Movie movie) async {
    var box = await Hive.openBox<Movie>(_WatchNowMovies);
    await box.add(movie);
    _watchNowMovies =
        box.values.where((element) => element.watched == false).toList();

    notifyListeners();
  }

  //delete watch now movies
  void deleteWatchNowMovie(key, index) async {
    _watchNowMovies.removeAt(index);
    var box = await Hive.openBox<Movie>(_WatchNowMovies);
    await box.delete(key);
    // _watchNowMovies =
    //     box.values.where((element) => element.watched == false).toList();
    notifyListeners();
  }

  //delete watched movies
  Future deleteWatchedMovie(key, index) async {
    var box = await Hive.openBox<Movie>(_WatchNowMovies);
    _watchedMovies.removeAt(index);
    await box.delete(key);
    //_watchedMovies =
    //  box.values.where((element) => element.watched == true).toList();

    notifyListeners();
  }

  //edits watch now movies
  void editWatchNowMovie({required Movie movie, required int key}) async {
    var box = await Hive.openBox<Movie>(_WatchNowMovies);
    await box.put(key, movie);
    _watchNowMovies =
        box.values.where((element) => element.watched == false).toList();
    notifyListeners();
  }

  //edits watched movies

  //sets Selected Watch Now Movie

  //sets selected watched movie

  //returns selectedWatchNowMovie

  //return number of watch now movies
  int get watchNowMovieCount {
    return _watchNowMovies.length;
  }

  int get watchedMovieCount {
    return _watchedMovies.length;
  }

  void watchNowToWatched(key, Movie movie, index) async {

      _watchedMovies.add(_watchNowMovies.removeAt(index));

    print(movie.name);
    var box = await Hive.openBox<Movie>(_WatchNowMovies);
    await box.put(key, movie);
    notifyListeners();
  }

}
