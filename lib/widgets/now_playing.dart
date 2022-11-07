import 'package:untitled1/bloc/get_movies_bloc.dart';
import 'package:untitled1/model/movie.dart';
import 'package:untitled1/model/movie_response.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/style/theme.dart' as Style;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_indicator/page_indicator.dart';

class NowPlaying extends StatefulWidget {
  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  PageController pageController =
  PageController(viewportFraction: 1, keepPage: true);

  @override
  void initState() {
    super.initState();
    moviesBloc..getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
        stream: moviesBloc.subject.stream,
        builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
          var snp = snapshot.data;
          if (snapshot.hasData) {
            if (snapshot.data?.error != null) {
              return _buildErrorWidget("Error");
            }
            return _buildHomeWidget(snp!);
          } else if (snapshot.hasError) {
            return _buildErrorWidget("Error");
          } else {
            return _buildLoadingWidget();
          }
          return _buildLoadingWidget();
        });
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

  Widget _buildHomeWidget(MovieResponse data) {
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
      return Container(
        height: 220.0,
        child: PageIndicatorContainer(
          align: IndicatorAlign.bottom,
          length: movies.take(5).length,
          indicatorSpace: 8.0,
          padding: const EdgeInsets.all(5.0),
          indicatorColor: Style.Colors.titleColor,
          indicatorSelectorColor: Style.Colors.secondColor,
          shape: IndicatorShape.circle(size: 5.0),
          child: PageView.builder(
            controller: pageController,
            scrollDirection: Axis.horizontal,
            itemCount: movies.take(5).length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  debugPrint("https://image.tmdb.org/t/p/original" + movies[index].backPoster);
                },
                child: Stack(
                  children: <Widget>[
                    Hero(
                      tag: movies[index].id,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 220.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: new DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "https://image.tmdb.org/t/p/original" +
                                        movies[index].backPoster)),
                          )),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: [
                              0.0,
                              0.9
                            ],
                            colors: [
                              Style.Colors.mainColor.withOpacity(1.0),
                              Style.Colors.mainColor.withOpacity(0.0)
                            ]),
                      ),
                    ),
                    Positioned(
                        bottom: 0.0,
                        top: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Icon(
                          FontAwesomeIcons.playCircle,
                          color: Style.Colors.secondColor,
                          size: 40.0,
                        )),
                    Positioned(
                        bottom: 30.0,
                        child: Container(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          width: 250.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                movies[index].title,
                                style: TextStyle(
                                    height: 1.5,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              );
            },
          ),
        ),
      );
  }
}