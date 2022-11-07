import 'package:untitled1/bloc/get_movies_bloc.dart';
import 'package:untitled1/model/movie.dart';
import 'package:untitled1/model/movie_response.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/style/theme.dart' as Style;

class TopMovies extends StatefulWidget {
  @override
  _TopMoviesState createState() => _TopMoviesState();
}

class _TopMoviesState extends State<TopMovies> {
  @override
  void initState() {
    super.initState();
    moviesBloc..getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, top: 20),
          child: Text(
            "Top Rated Movies".toUpperCase(),
            style: TextStyle(
                color: Style.Colors.titleColor,
                fontWeight: FontWeight.w500,
                fontSize: 12),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        StreamBuilder<MovieResponse>(
            stream: moviesBloc.subject.stream,
            builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
              var snp = snapshot.data;
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  if (snapshot.data?.error != null) {
                    return _buildErrorWidget("Error");
                  }else {
                    return _buildMoviesWidget(snp!);
                  }
                }
              } else {
                return _buildErrorWidget("No data");
              }
              return _buildLoadingWidget();
            })
      ],
    );
  }

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

  Widget _buildMoviesWidget(MovieResponse data) {
    List<Movie> movies = data.movies;
    if (movies.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "No More Movies",
                  style: TextStyle(color: Colors.black45),
                )
              ],
            )
          ],
        ),
      );
    } else
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                    top: 10.0, bottom: 10.0, right: 5.0, left: 5.0),
                child: GestureDetector(
                  onTap: () {
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      movies[index].poster == null
                          ? Container(
                        decoration: new BoxDecoration(
                          color: Style.Colors.secondColor,
                          borderRadius:
                          BorderRadius.all(Radius.circular(50.0)),
                          shape: BoxShape.rectangle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              EvaIcons.filmOutline,
                              color: Colors.white,
                              size: 60.0,
                            )
                          ],
                        ),
                      )
                          : Container(
                          height: 250.0,
                          decoration: new BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                            shape: BoxShape.rectangle,
                            image: new DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "https://image.tmdb.org/t/p/w200/" +
                                        movies[index].poster)),
                          )),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        child: Text(
                          movies[index].title,
                          maxLines: 2,
                          style: TextStyle(
                              height: 1.4,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            movies[index].rating.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
  }
}