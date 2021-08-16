
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_app/utils/movieProvider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'model/movie_model.dart';

class MovieEdit extends StatefulWidget {
  final Movie currentMovie;


  MovieEdit(this.currentMovie);

  @override
  _MovieEditState createState() => _MovieEditState();
}

class _MovieEditState extends State<MovieEdit> {
  String imagePath="default";

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _movieName = TextEditingController();
    final TextEditingController _directorName = TextEditingController();
    _movieName.text=widget.currentMovie.name;
    _directorName.text=widget.currentMovie.director;


    return Consumer<MovieProvider>(builder: (context, movieData, child) {
      return Scaffold(
        backgroundColor: Color(0xff031435),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color(0xff031435),
          title: Text(
            "Edit ${widget.currentMovie.name}",
            style: TextStyle(
              color: Color(0xff99FFFF),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () async {
                           await _picker.pickImage(
                              source: ImageSource.gallery).then((image){
                                setState(() {
                                  imagePath=image!.path;
                                });
                           });
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.height * 0.4,
                            child:(imagePath=="default")?Image.file(File(widget.currentMovie.imagePath)):
                                 Image.file(File(imagePath))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                       // initialValue: widget.currentMovie.name,
                        style: TextStyle(color: Color(0xff99FFFF)),
                        decoration: InputDecoration(
                            labelText: 'Movie Name',
                            labelStyle: TextStyle(
                                color: Color(0xff99FFFF),
                                fontWeight: FontWeight.bold)),
                        controller: _movieName,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return "Movie name cannot be empty";
                          else
                            return null;
                        },
                      ),
                      TextFormField(
                        style: TextStyle(color: Color(0xff99FFFF)),
                        decoration: InputDecoration(
                            labelText: 'Directed By:',
                            labelStyle: TextStyle(
                                color: Color(0xff99FFFF),
                                fontWeight: FontWeight.bold)),
                        controller: _directorName,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return "Director name cannot be empty";
                          else
                            return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xff2866ED)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)))),
                          onPressed: () {
                            if(imagePath=="default")
                              {
                                imagePath=widget.currentMovie.imagePath;
                              }
                            if (_formKey.currentState!.validate()) {

                              setState(() {
                                movieData.editWatchNowMovie(
                                    movie: Movie(
                                      name: _movieName.text,
                                      director: _directorName.text,
                                      watched: false,imagePath: imagePath
                                    ),
                                    key: widget.currentMovie.key);
                              });
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text("Save"))
                    ],
                  ),
                )),
          ),
        ),
      );
    });
  }
}
