import 'package:flutter/material.dart';
import 'package:untitled1/bloc/get_movies_bloc.dart';
import 'package:untitled1/model/movie.dart';
import 'package:untitled1/model/movie_response.dart';
import 'package:untitled1/widgets/now_playing.dart';
import 'package:untitled1/widgets/top_movies.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:untitled1/style/theme.dart' as Style;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      appBar: AppBar(
        backgroundColor: Style.Colors.mainColor,
        centerTitle: true,
        leading: Icon(
          EvaIcons.menu2Outline,
          color: Colors.white,
        ),
        title: Text("Movie App"),
        actions: [
          IconButton(
              icon: Icon(
                EvaIcons.searchOutline,
                color: Colors.white,
              ),
              onPressed: () {
                showSearch(context: (context), delegate: MovieSearch());
              })
        ],
      ),
      drawer: Drawer(),
      body: ListView(
        children: [NowPlaying(), TopMovies()],
      ),
    );
  }
}

class MovieSearch extends SearchDelegate<String> {
  Widget _buildLoadingWidget() {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 25.0,
              width: 25.0,
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 4.0,
              ),
            )
          ],
        ));
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Error occured: $error"),
          ],
        ));
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, "null");
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return context.widget;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    moviesBloc.getMovies();
    return StreamBuilder<MovieResponse>(
        stream: moviesBloc.subject.stream,
        builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data?.error != null ) {
              return _buildErrorWidget("Error");
            } else if (snapshot.data?.error.isEmpty != null) {
              return _buildErrorWidget("Error");
            } else {
              // return listWidget(snapshot.data);
            }
          } else {
            return _buildLoadingWidget();
          }
          return _buildLoadingWidget();
        });
  }

  @override
  Widget listWidget(MovieResponse data) {
    final List<Movie> SuggestionList = query.isEmpty
        ? data.movies.take(10).toList()
        : data.movies.where((q) => q.title.startsWith(query)).toList();

    return ListView.builder(
        itemCount: SuggestionList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
            },
            child: ListTile(
              leading: Icon(
                Icons.movie,
                color: Style.Colors.secondColor,
              ),
              title: Text(SuggestionList[index].title),
            ),
          );
        });
  }
}