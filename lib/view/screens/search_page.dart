import 'package:flutter/material.dart';
import 'package:wallpapers_app/controller/api_operation.dart';
import 'package:wallpapers_app/model/photosModel.dart';
import 'full_screen_image.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<PhotosModel> searchResults = [];
  getSearchResults() async {
    searchResults =
        await ApiOperations.searchWallpapers(_searchController.text);
    setState(() {});
  }

  @override
  // void initState() {
  //   super.initState();
  //   getSearchResults();
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Wallpapers',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.0,
      ),
      // searchResults.isEmpty? Container() :
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              child: Container(
                margin: EdgeInsets.all(10.0),
                child: TextFormField(
                  onFieldSubmitted: (value) {
                    searchResults.clear();
                    getSearchResults();
                  },
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for wallpaper',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        searchResults.clear();
                        getSearchResults();
                      },
                    ),
                  ),
                ),
              ),
            ),
            searchResults.isEmpty
                ? Container()
                : Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    height: MediaQuery.of(context).size.height - 170,
                    child: GridView.builder(
                      physics: BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 300,
                        crossAxisCount: 2,
                        childAspectRatio: 0.5,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 5.0,
                      ),
                      itemCount: searchResults.length,
                      itemBuilder: ((context, index) => GridTile(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenPage(
                                      imgUrl: searchResults[index].imgsrc,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                height: MediaQuery.of(context).size.height / 2,
                                child: Hero(
                                  tag: searchResults[index].imgsrc.toString(),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      searchResults[index].imgsrc.toString(),
                                      fit: BoxFit.cover,
                                      filterQuality: FilterQuality.high,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
