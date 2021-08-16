import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/utils/movieProvider.dart';
import 'package:provider/provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'model/movie_model.dart';

class AddMovies extends StatefulWidget {
  @override
  _AddMovies createState() => _AddMovies();
}

class _AddMovies extends State<AddMovies> {
  String imagePath="default";
  final ImagePicker _picker =ImagePicker();
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _movieName = TextEditingController();
    final TextEditingController _directorName = TextEditingController();

    return Consumer<MovieProvider>(builder: (context, movieData, child) {
      return Scaffold(
        backgroundColor: Color(0xff031435),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color(0xff031435),
          title: Text(
            "Add Movies",
            style: TextStyle(color: Color(0xff99FFFF)),
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
                      onTap: ()async {
                        final image = await _picker.pickImage(source: ImageSource.gallery);
                        setState(() {
                          imagePath =image!.path;
                        });

                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.4,
                        width:MediaQuery.of(context).size.height*0.4 ,
                        child: (imagePath=="default")?DottedBorder(
                          color: Color(0xff36476A),
                          strokeWidth: 2,
                          dashPattern: [1.0],
                          child: Card(
                            color: Colors.transparent,
                            child: Center(child: Icon(Icons.add_a_photo_outlined,color:Color(0xff36476A) ,)),
                          ),
                        ):Image.file(File(imagePath))

                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
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
                    SizedBox(
                      height: 20,
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
                            backgroundColor: MaterialStateProperty.all(
                                Color(0xff2866ED)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(20)))),
                        onPressed: () {
                          if (_formKey.currentState!.validate()&&imagePath!="default") {
                            print(imagePath);
                            setState(() {
                              movieData.addMovie(Movie(
                                name: _movieName.text,
                                director: _directorName.text,
                                watched: false,imagePath: imagePath
                              ));
                            });
                            Navigator.of(context).pop();
                          }
                          if(imagePath=="default")
                            {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Select an Image")));
                            }
                        },
                        child: Text("Save"))
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
