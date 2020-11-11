import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:wiki_search/api_response.dart';
import 'package:wiki_search/database_helper.dart';
import 'package:wiki_search/history_list.dart';
import 'package:wiki_search/search_bloc.dart';
import 'package:wiki_search/search_list.dart';
import 'package:wiki_search/search_loder.dart';

import 'search_response.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wiki Search',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Wiki Search'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SearchBloc _bloc;
  SearchBar searchBar;
  String searchValue;
  final dbHelper = DatabaseHelper.instance;

  _MyHomePageState() {
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        hintText: "Wiki Search",
        onSubmitted: onSubmitted,
        onCleared: () {
          print("cleared");
        },
        onClosed: () {
          print("closed");
        });
  }

  @override
  void initState() {
    super.initState();
    _bloc = SearchBloc();
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('Wiki Search'),
        actions: [searchBar.getSearchAction(context)]);
  }

  void onSubmitted(String value) {
    searchValue = value;
    dbHelper.insertSearchText(SearchHistory(text: value));
    _bloc.fetchSearchList(value);
  }

  void onSearch(String value) {
    searchValue = value;
    _bloc.fetchSearchList(value);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: searchBar.build(context),
      body: StreamBuilder<ApiResponse<List<SearchResult>>>(
        stream: _bloc.searchListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("status$snapshot.data.status");
            switch (snapshot.data.status) {
              case Status.LOADING:
                return LoadingListPage();
                break;
              case Status.COMPLETED:
                if (snapshot.data.data != null) {
                  return SearchList(searchResult: snapshot.data.data);
                } else {
                  return Empty("Empty Search Result");
                }
                break;
              case Status.ERROR:
                return Error(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () => _bloc.fetchSearchList(searchValue),
                );
                break;
            }
          }

          return FutureBuilder<List<SearchHistory>>(
              future: dbHelper.getAllSearchHistories(),
              initialData: List(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data.length > 0) {
                  return HistoryList(
                      searchHistory: snapshot.data, onTapped: onSearch);
                } else {
                  return Empty("Start search Wiki");
                }
              });
        },
      ),
    );
  }
}

class Error extends StatelessWidget {
  final String errorMessage;

  final Function onRetryPressed;

  const Error({Key key, this.errorMessage, this.onRetryPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.lightGreen,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          RaisedButton(
            color: Colors.lightGreen,
            child: Text('Retry', style: TextStyle(color: Colors.white)),
            onPressed: onRetryPressed,
          )
        ],
      ),
    );
  }
}
