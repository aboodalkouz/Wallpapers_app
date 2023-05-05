import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

late Database database;
List<Map> favImages = [];
List<Map<dynamic, dynamic>>? fvrtImg;
var inFavorites = false;

void createDatabase() async {
  database = await openDatabase('wallpapers.db', version: 1,
      onCreate: (database, version) {
    print('database created');
    database
        .execute(
            'CREATE TABLE favorites (id INTEGER PRIMARY KEY, imgpath TEXT)')
        .then((value) {
      print('table created');
    }).catchError((error) {
      print('Error when creating table ${error}');
    });
  }, onOpen: (database) {
    print('database opened');
    getDataFromDatabase(database).then((value) {
      favImages = value;
      print(favImages);
    });
  });
}

void insertToDatabase(String imgUrl, BuildContext context) {
  database.transaction((txn) {
    txn
        .rawInsert("INSERT INTO favorites(imgpath) VALUES ('${imgUrl}')")
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image Added To Favorites Successfully'),
        ),
      );

      print('${value} inserted successfully');
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Something Went Wrong While Adding Image To Favorites ${error.toString()}'),
        ),
      );

      print('Error when inserting new record ${error.toString()}');
    });
    return Future.value(null);
  });
}

Future<List<Map>> getDataFromDatabase(database) async {
  return await database.rawQuery('SELECT * FROM favorites');
}

Future checkIfInFavorites(database, imgurl, context) async {
  // createDatabase();
  getDataFromDatabase(database).then((value) {
    for (var i = 0; i < value.length; i++) {
      // print(element);
      print('loop function laffeh ${i}');
      if (value[i]['imgpath'].toString() == imgurl.toString()) {
        inFavorites = true;
        print(inFavorites);
        print('item already in');
        print('${value[i]["imgpath"]} ============= ${imgurl}');
        break;
      }
      print('outside if in the loop');
    }

    if (inFavorites == true) {
      print('if');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image Already Added To Favorites'),
        ),
      );
    } else {
      print('else');
      insertToDatabase(imgurl.toString(), context);
    }
    print('outside the conditions');
    print('before => ${inFavorites}');
    inFavorites = false;
    print('after => ${inFavorites}');
  });
}
