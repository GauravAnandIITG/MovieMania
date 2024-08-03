import 'package:flutter/material.dart';
import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:movieapp/API/apiurl.dart';
class NowPlaying extends StatefulWidget {
  const NowPlaying({super.key});

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  List<Map<String,dynamic>> nowplayingdata=[];


  Future<void> nowplayingmovies() async{
    var nowresponse= await http.get(Uri.parse(nowplaying));
    if (nowresponse.statusCode==200){
      var tempdata= jsonDecode(nowresponse.body);
      var nowjson = tempdata["results"];
      for (var i= 0;i<nowjson.length;i++){
        nowplayingdata.add({
          "id": nowjson[i]["id"],
          "name": nowjson[i]["name"],
          "poster_path": nowjson[i]["poster_path"],
          "vote_average": nowjson[i]["vote_average"],
          "Date": nowjson[i]["release_date"],
          "indexno": i,
        });
      }
    } else{
      print(nowresponse.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: nowplayingmovies(),
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
                  child: Text("Now Playing",style: TextStyle(color: Colors.redAccent,fontSize: 30,fontWeight: FontWeight.bold),),
                ),
                Container(
                  height: 250,
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: nowplayingdata.length,
                      itemBuilder: (context,index){
                        return GestureDetector(
                          onTap: (){},
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius:BorderRadius.circular(15),
                                image: DecorationImage(image: NetworkImage('https://image.tmdb.org/t/p/w500${nowplayingdata[index]["poster_path"]}'),fit: BoxFit.fill),

                              ),
                              margin: EdgeInsets.only(left: 12),
                              width: 180,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(padding: EdgeInsets.only(top: 3,left: 8),
                                    child: Text(nowplayingdata[index]["Date"],style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
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
                                            child: Text(nowplayingdata[index]["vote_average"].toString(),style: TextStyle(color: Colors.white,),),
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
