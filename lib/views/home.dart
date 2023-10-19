import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:m04/helper/httphelper.dart';
import 'package:m04/model/chipModel.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  late Map<String, dynamic> dataJSON;
  late httpHelper helper;
  var selectedChoice;

  final listChoices = <ItemChoice>[
    ItemChoice("Latest", "latest"),
    ItemChoice("Now Playing", "now_playing"),
    ItemChoice("Popular", "popular"),
    ItemChoice("Top Rated", "top_rated"),
    ItemChoice("Upcoming", "upcoming"),
  ];

  @override
  void initState() {
    super.initState();
    helper = httpHelper();
    dataJSON = {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Movie"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Silahkan Pilih:"),
              Wrap(
                children: listChoices
                    .map((e) => ChoiceChip(
                          label: Text(e.label),
                          selected: selectedChoice == e.format,
                          onSelected: (value) {
                            getMovieBy(e.format);
                            setState(() {
                              selectedChoice = e.format;
                            });
                          },
                        ))
                    .toList(),
                spacing: 8,
              ),
              SizedBox(height: 20),
              MovieList(data: dataJSON)
            ],
          ),
        ),
      ),
    );
  }

  getMovieBy(String format) async {
    return await helper.getMovie(format).then((value) {
      setState(() {
        dataJSON = jsonDecode(value);
      });
    });
  }
}

class MovieList extends StatelessWidget {
  final Map<String, dynamic> data;

  MovieList({required this.data});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> movies =
        data.containsKey('results') ? data['results'] : [data];

    if (data.isEmpty) {
      return Container();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: movies
            .map((movie) => ListTile(
                  leading: movie['poster_path'] != null
                      ? Image.network(
                          "https://image.tmdb.org/t/p/w500/${movie['poster_path']}")
                      : null,
                  title: Text(
                    movie['original_title'],
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text("Release Date: ${movie['release_date']}"),
                ))
            .toList(),
      );
    }
  }
}
