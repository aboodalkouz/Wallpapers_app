import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import '../../controller/favorites_operations.dart';
import '../../controller/permision_handler.dart';

class FullScreenPage extends StatelessWidget {
  String? imgUrl;
  FullScreenPage({super.key, required this.imgUrl});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<void> downloadWallpaper(
      String wallpaperUrl, BuildContext context) async {
    var permissionResult = await requestStoragePermission();
    if (permissionResult == 'done') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Downloading Started...')));
      try {
        var imageId = await GallerySaver.saveImage(wallpaperUrl);

        if (imageId == null) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Downloaded Successfully'),
          ),
        );
        print('Image Downloaded');
      } on PlatformException catch (error) {
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Something Went Wrong While Downloading Image')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'favorite_btn',
            onPressed: () async {
              inFavorites = false;
              await checkIfInFavorites(database, imgUrl, context).then((value) {
                print('done done done');
              });
            },
            child: Icon(
              Icons.favorite_border,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            heroTag: 'download_btn',
            onPressed: () async {
              await downloadWallpaper(imgUrl.toString(), context);
            },
            child: Icon(
              Icons.download,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imgUrl.toString()),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
