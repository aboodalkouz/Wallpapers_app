import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import '../../controller/favorites_operations.dart';

class FullScreenPage extends StatelessWidget {
  String? imgUrl;
  FullScreenPage({super.key, required this.imgUrl});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<void> downloadWallpaper(
      String wallpaperUrl, BuildContext context) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Downloading Started...')));
    try {
      var imageId = await GallerySaver.saveImage(wallpaperUrl);
      // var imageId = await ImageDownloader.downloadImage(wallpaperUrl);
      if (imageId == null) {
        return;
      }

      // var filename = await ImageDownloader.findName(imageId);
      // var path = await ImageDownloader.findPath(imageId);
      // var size = await ImageDownloader.findByteSize(imageId);
      // var mimeType = await ImageDownloader.findMimeType(imageId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Downloaded Successfully'),
          // action: SnackBarAction(
          //     label: 'Open',
          //     onPressed: () {
          //       // OpenFile.open(path);
          //     }),
        ),
      );
      print('Image Downloaded');
    } on PlatformException catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something Went Wrong While Downloading Image')),
      );
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
