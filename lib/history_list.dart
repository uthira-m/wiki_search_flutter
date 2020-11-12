import 'package:flutter/material.dart';
import 'package:wiki_search/database_helper.dart';

class HistoryList extends StatelessWidget {
  final List<SearchHistory> searchHistory;
  final Function(SearchHistory, bool) onTapped;

  const HistoryList({Key key, this.searchHistory, this.onTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: searchHistory.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onTapped(searchHistory[index], false),
          child: Container(
            color: Color(0xf6f6f6),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                ),
                Expanded(
                  child: Text(
                    searchHistory[index].text,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                InkWell(
                  child: new Icon(
                    Icons.delete,
                    size: 20.0,
                    color: Colors.grey[500],
                  ),
                  onTap: () => onTapped(searchHistory[index], true),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                )
              ]),
            ),
          ),
        );
      },
    );
  }
}
