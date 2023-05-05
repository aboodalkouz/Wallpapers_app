import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wallpapers_app/model/photosModel.dart';

class ApiOperations {
  static List<PhotosModel> trendingWallpapers = [];
  static List<PhotosModel> searchWallpapersList = [];
  static Future<List<PhotosModel>> getTrendingWallpapers() async {
    await http.get(Uri.parse("https://api.pexels.com/v1/curated"), headers: {
      "Authorization":
          "jZ9tzxs5z19ykV17fWcaU1jdmTVenpiZZfmOqmlqhMqlylEFE418jKj5"
    }).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      List photos = jsonData['photos'];
      photos.forEach((element) {
        Map<String, dynamic> src = element['src'];
        // print(src['portrait']);
        trendingWallpapers.add(PhotosModel.fromAPIToApp(element));
      });
    });
    return trendingWallpapers;
  }

  static searchWallpapers(
    String query,
  ) async {
    if (query == "") {
      return searchWallpapersList;
    }
    await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=$query&per_page=30&page=1"),
        headers: {
          "Authorization":
              "jZ9tzxs5z19ykV17fWcaU1jdmTVenpiZZfmOqmlqhMqlylEFE418jKj5",
          // "query": query,
          // "per_page": 30.toString(),
          // "page": 1.toString(),
        }).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      List photos = jsonData['photos'];
      searchWallpapersList.clear();
      photos.forEach((element) {
        Map<String, dynamic> src = element['src'];
        // print(src['portrait']);

        searchWallpapersList.add(PhotosModel.fromAPIToApp(element));
      });
    });
    return searchWallpapersList;
  }
}
