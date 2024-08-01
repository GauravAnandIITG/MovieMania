import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:movieapp/API/apiurl.dart';

class TopRated extends StatefulWidget {
  const TopRated({super.key});

  @override
  State<TopRated> createState() => _TopRatedState();
}


class _TopRatedState extends State<TopRated> {
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
  @override
  void initState(){
    super.initState();
    topratedmovies();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
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
              height: 400,
              viewportFraction: 1,
              autoPlay: true,
              autoPlayCurve: Curves.fastOutSlowIn,
              autoPlayAnimationDuration: Duration(seconds:3)
          ) ),);
  }
}
