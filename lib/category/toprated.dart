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
          "name": topjson[i]["name"],
          "poster_path": topjson[i]["poster_path"],
          "vote_average": topjson[i]["vote_average"],
          "Date": topjson[i]["release_date"],
          "indexno": i,
        });
      }
    } else{
      print(trendingresponse.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: topratedmovies(),
        builder: (context,snapshot,){
      if (snapshot.connectionState==ConnectionState.waiting){
        return Center(
          child: CircularProgressIndicator(
            color:  Colors.redAccent,
          ),
        );
      }
      else{
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.only(left: 10,right: 10,bottom: 40),
            child: Text("Top Rated Movies",style: TextStyle(color: Colors.redAccent,fontSize: 30,fontWeight: FontWeight.bold),),
            ),
            Container(
              height: 250,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: toprateddata.length,
                  itemBuilder: (context,index){
                  return GestureDetector(
                    onTap: (){},
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:BorderRadius.circular(15),
                        image: DecorationImage(image: NetworkImage('https://image.tmdb.org/t/p/w500${toprateddata[index]["poster_path"]}'),fit: BoxFit.fill),

                      ),
                      margin: EdgeInsets.only(left: 12),
                      width: 180,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(padding: EdgeInsets.only(top: 3,left: 8),
                            child: Text(toprateddata[index]["Date"],style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
                          ),
                          SizedBox(width: 8,),

                          Padding(
                            padding: const EdgeInsets.only(top: 3,right: 8),
                            child: Container(
                              decoration: BoxDecoration(color: Colors.black.withOpacity(0.5),borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  Icon(Icons.star,color: Colors.yellow,),
                                  Padding(padding: EdgeInsets.all(2),
                                    child: Text(toprateddata[index]["vote_average"].toString(),style: TextStyle(color: Colors.white,),),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    ),
                  );
                  }),
            )
          ],
        );
      }
        });
  }
}
