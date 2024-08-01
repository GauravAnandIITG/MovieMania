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
  List<Map<String,dynamic>> toprateddata=[];
  Future<void> topratedmovies() async{
    var trendingresponse= await http.get(Uri.parse(toprated));
    if (trendingresponse.statusCode==200){
      var tempdata= jsonDecode(trendingresponse.body);
      var topjson = tempdata["results"];
      for (var i= 0;i<topjson.length;i++){
        toprateddata.add({
          "id": topjson[i]["id"],
          "poster_path": topjson[i]["poster_path"],
          "vote_average": topjson[i]["vote_average"],
          "media_type": topjson[i]["media_type"],
          "indexno": i,
        });
      }
    }
  }
  List<Map<String,dynamic>> nowdata=[];
  Future<void> nowmovies() async{
    var trendingresponse= await http.get(Uri.parse(nowplaying));
    if (trendingresponse.statusCode==200){
      var tempdata= jsonDecode(trendingresponse.body);
      var nowjson = tempdata["results"];
      for (var i= 0;i<nowjson.length;i++){
        nowdata.add({
          "id": nowjson[i]["id"],
          "poster_path": nowjson[i]["poster_path"],
          "vote_average": nowjson[i]["vote_average"],
          "media_type": nowjson[i]["media_type"],
          "indexno": i,
        });
      }
    }
  }
  @override
  void initState(){
    super.initState();
      trendingmovies();
     topratedmovies();
     nowmovies();
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
              children: [
                SizedBox(height: 20,),
                Text("Trending Movies",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.red),),
                SizedBox(height: 10,),
                Container(
                  child: CarouselSlider(
                      items: trendingdata.map((i){
                        return Container(
                              width:MediaQuery.of(context).size.width ,
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20)),
                               child: Image.network('https://image.tmdb.org/t/p/w500${i['poster_path']}',fit: BoxFit.fill,),
                            );
                          }).toList(),
            options:CarouselOptions(
                  height: 400,
              viewportFraction: 1,
              autoPlay: true,
              autoPlayCurve: Curves.fastOutSlowIn,
              autoPlayAnimationDuration: Duration(seconds:3)
                ) ),),
                SizedBox(height: 20,),
                Text("Now Playing",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.redAccent),),
                SizedBox(height: 20,),
                Container(
                  child: CarouselSlider(
                      items: nowdata.map((i){
                        return Container(
                          width:MediaQuery.of(context).size.width ,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20)),
                          child: Image.network('https://image.tmdb.org/t/p/w500${i['poster_path']}',fit: BoxFit.fill,),
                        );
                      }).toList(),
                      options:CarouselOptions(
                          height:250,
                          viewportFraction: .5,
                          autoPlay: true,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          autoPlayAnimationDuration: Duration(seconds:3)
                      ) ),),
                SizedBox(height: 20,),
                Text("Top Rated",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.redAccent),),
                SizedBox(height: 20,),
                Container(
                  child: CarouselSlider(
                      items: toprateddata.map((i){
                        return Container(
                          width:MediaQuery.of(context).size.width ,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20)),
                          child: Image.network('https://image.tmdb.org/t/p/w500${i['poster_path']}',fit: BoxFit.fill,),
                        );
                      }).toList(),
                      options:CarouselOptions(
                          height:250,
                          viewportFraction: .5,
                          autoPlay: true,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          autoPlayAnimationDuration: Duration(seconds:3)
                      ) ),),
                SizedBox(height: 30,),


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
