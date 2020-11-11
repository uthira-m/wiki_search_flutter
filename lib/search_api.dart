import 'api_helper.dart';
import 'search_response.dart';

class SearchApiRepository {
  //https://en.wikipedia.org/w/api.php?
  // action=query&format=json&prop=pageimages%7Cpageterms&gpslimit=10&
  // generator=prefixsearch&piprop=thumbnail&pithumbsize=50&gpssearch=Einstein&

  final String _action = "query";
  final String _format = "json";
  final String _prop = "pageimages%7Cpageterms";
  final String _gpslimit = "20";
  final String _generator = "prefixsearch";
  final String _piprop = "thumbnail";
  final String _pithumbsize = "50";

  ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<SearchResult>> getSearchResult(String _query) async {
    final response = await _helper.get(
        "api.php?formatversion=2&action=$_action&format=$_format&prop=$_prop&gpslimit=$_gpslimit"
        "&generator=$_generator&piprop=$_piprop&pithumbsize=$_pithumbsize"
        "&gpssearch=$_query");
    print("ut_log response=$response");
    return SearchResponse.fromJson(response).results;
  }
}
