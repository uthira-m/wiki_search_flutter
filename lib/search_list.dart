import 'package:flutter/material.dart';
import 'package:wiki_search/wiki_details.dart';
import 'search_response.dart';

class SearchList extends StatelessWidget {
  final List<SearchResult> searchResult;

  const SearchList({Key key, this.searchResult}) : super(key: key);

  Widget _displayMedia(String imageUrl) {
    if (imageUrl == null) {
      return Image.asset('images/default.jpg', width: 50, height: 50);
    }
    return Image.network(imageUrl, fit: BoxFit.cover, width: 50, height: 50,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes
              : null,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: searchResult.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WikiDetailsScreen(
                          pageId: searchResult[index].pageId,
                          title: searchResult[index].title)),
                ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(children: [
                    _displayMedia(searchResult[index].imageUrl),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              searchResult[index].title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            searchResult[index].description,
                            style: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
                ),
              ),
            ));
      },
    );
  }
}
