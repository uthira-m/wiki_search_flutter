import 'dart:async';

import 'package:wiki_search/search_api.dart';

import 'api_response.dart';
import 'search_response.dart';

class SearchBloc {
  SearchApiRepository _searchApiRepository;

  StreamController _searchListController;

  StreamSink<ApiResponse<List<SearchResult>>> get searchListSink =>
      _searchListController.sink;

  Stream<ApiResponse<List<SearchResult>>> get searchListStream =>
      _searchListController.stream;

  SearchBloc() {
    _searchListController = StreamController<ApiResponse<List<SearchResult>>>();
    _searchApiRepository = SearchApiRepository();
  }

  fetchSearchList(String key) async {
    searchListSink.add(ApiResponse.loading('Searching'));
    try {
      List<SearchResult> movies =
          await _searchApiRepository.getSearchResult(key);
      searchListSink.add(ApiResponse.completed(movies));
    } catch (e) {
      searchListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _searchListController?.close();
  }
}
