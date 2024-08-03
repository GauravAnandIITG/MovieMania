import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movieapp/API/apiurl.dart';

import 'category/nowplaying.dart';
import 'category/toprated.dart';
import 'category/upcoming.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  List<Map<String,dynamic>> trendingdata=[];
  Future<void> trendingmovies() async{
    var trendingresponse= await http.get(Uri.parse(trending));
    if (trendingresponse.statusCode==200){
      var tempdata= jsonDecode(trendingresponse.body);
      var trendingjson = tempdata["results"];
      for (var i= 0;i<trendingjson.length;i++){
        trendingdata.add({
          "id": trendingjson[i]["id"],
          "poster_path": trendingjson[i]["poster_path"],
          "vote_average": trendingjson[i]["vote_average"],
          "media_type": trendingjson[i]["media_type"],
          "indexno": i,
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List<Map<String,dynamic>> trendingdata=[];
  Future<void> trendingmovies() async{
    var trendingresponse= await http.get(Uri.parse(trending));
    if (trendingresponse.statusCode==200){
      var tempdata= jsonDecode(trendingresponse.body);
      var trendingjson = tempdata["results"];
      for (var i= 0;i<trendingjson.length;i++){
        trendingdata.add({
          "id": trendingjson[i]["id"],
          "poster_path": trendingjson[i]["poster_path"],
          "vote_average": trendingjson[i]["vote_average"],
          "media_type": trendingjson[i]["media_type"],
          "indexno": i,
        });
      }
    }
  }
  @override
  void initState(){
    super.initState();
      trendingmovies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text("Movies Mania",style: TextStyle(color: Colors.white,fontSize: 37,fontWeight: FontWeight.bold,),),
      ),
      body: FutureBuilder(
        future: trendingmovies(),
        builder: (context,snapshot) {
    if (snapshot.connectionState==ConnectionState.done){
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 20,),
                Text("Trending Movies",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.red),),
                SizedBox(height: 10,),
                Container(
                  child: CarouselSlider(
                      items: trendingdata.map((i){
                        return Container(
                              width:MediaQuery.of(context).size.width*0.8 ,
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20),image: DecorationImage(image: NetworkImage('https://image.tmdb.org/t/p/w500${i['poster_path']}',),fit: BoxFit.fill,)),

                            );
                          }).toList(),
            options:CarouselOptions(
              enlargeCenterPage: true,
                  height: 400,
              viewportFraction: 1,
              autoPlay: true,
              autoPlayCurve: Curves.fastOutSlowIn,
              autoPlayAnimationDuration: Duration(seconds:3)
                ) ),),
                SizedBox(height: 20,),
                NowPlaying(),
                SizedBox(height: 20,),
                TopRated(),

              ]),
          );}
    else{

      return Center(
        child: CircularProgressIndicator(color: Colors.red,),
      );

    }
        }
      ),
    );
  }
}
