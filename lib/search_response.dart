class SearchResponse {
  int page;
  int totalResults;
  int totalPages;
  List<SearchResult> results;

  SearchResponse({this.page, this.totalResults, this.totalPages, this.results});

  SearchResponse.fromJson(Map<String, dynamic> json) {
    // page = json['page'];
    // totalResults = json['total_results'];
    // totalPages = json['total_pages'];
    var query = json['query'];
    print("ut_log query=$query");
    if (query != null) {
      var pages = query['pages'];
      print("ut_log pages=$pages");
      if (pages != null) {
        results = new List<SearchResult>();
        pages.forEach((v) {
          results.add(new SearchResult.fromJson(v));
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['total_results'] = this.totalResults;
    data['total_pages'] = this.totalPages;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchResult {
  String title;
  int pageId;
  String description;
  String imageUrl;

  SearchResult({this.title, this.description, this.imageUrl});

  SearchResult.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    pageId = json['pageid'];
    description = "";
    var terms = json['terms'];
    if (terms != null) {
      var descriptionArray = terms['description'];
      if (descriptionArray != null) {
        description = descriptionArray[0];
      }
    }
    var thumbnail = json['thumbnail'];
    if (thumbnail != null) {
      imageUrl = thumbnail['source'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['pageId'] = this.pageId;
    data['description'] = this.description;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}
