import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:silver_app_bar/src/models/cat_model.dart';

class CatsRepository extends Disposable {
  final String api = "https://api.thecatapi.com/v1/images";

  Future<List<CatModel>> fetchImages(int limit) async {
    final response = await http.get("$api/search?limit=$limit");
    print(response.body); 
    return decode(response.body, response.statusCode, response.reasonPhrase);
  }

  List<CatModel> decode(String body, int statusCode, String reasonPhrase) {
    if (statusCode == 200) {
      List<dynamic> decoded = jsonDecode(body);
      var cats = List<CatModel>();

      decoded.forEach((cat) {
        cats.add(CatModel.fromJson(cat));
      });

      return cats;
    } else {
      throw Exception('Erro ' + statusCode.toString() + ': ' + reasonPhrase);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
