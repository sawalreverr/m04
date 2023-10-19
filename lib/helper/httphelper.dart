import 'dart:io';

import 'package:http/http.dart' as http;

class httpHelper {
  final String _urlKey = "?api_key=18b89a60063c48afafb7248665905811";
  final String _urlBase = "https://api.themoviedb.org/";

  Future<String> getMovie(String film) async {
    var url = Uri.parse(_urlBase + '/3/movie/' + film + _urlKey);
    http.Response result = await http.get(url);

    if (result.statusCode == HttpStatus.ok) {
      String responseBody = result.body;
      return responseBody;
    }

    return result.statusCode.toString();
  }
}
