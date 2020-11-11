import 'package:flutter/material.dart';
import 'package:wiki_search/database_helper.dart';
import 'package:wiki_search/wiki_details.dart';
import 'search_response.dart';

class HistoryList extends StatelessWidget {
  final List<SearchHistory> searchHistory;
  final Function(String) onTapped;

  const HistoryList({Key key, this.searchHistory, this.onTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: searchHistory.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onTapped(searchHistory[index].text),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              searchHistory[index].text,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
          ),
        );
      },
    );
  }
}
