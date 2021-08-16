import 'package:hive/hive.dart';
part 'movie_model.g.dart';

@HiveType(typeId:0)
class Movie extends HiveObject{
  @HiveField(0)
   String name;

  @HiveField(1)
   String director;

  @HiveField(2)
  bool watched;

  @HiveField(3)
  String imagePath;


  Movie({required this.name, required this.director,required this.watched,this.imagePath="default"});

}
