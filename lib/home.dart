import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'details.dart';
import 'models/tracks.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  // Web service 
  Future <List<Track>> fetchData() async{
    
    final String apiEndPoint = "https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=${dotenv.env['API_KEY']}";
    final Uri url = Uri.parse(apiEndPoint);
    final response = await http.get(url);
    
    if (response.statusCode == 200) {

    List jsonResponse = json.decode(response.body)['message']['body']['track_list'];

    
      return jsonResponse.map((data) => Track.fromJson(data['track'])).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
  }

  late  Future <List<Track>> futureData;
  
  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

 //bookmark nav 
final _saved = <Track>{}; 

void _pushBookmarked(){

  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (context){
        final tiles = _saved.map(
          (track){
            return ListTile(
              title: Text(
                track.trackName,
              ),
              onTap: (){
                Navigator.push(
                        context,              
                        MaterialPageRoute(
                        builder: (context) =>  TrackDetails(track : track),
                      ),
                  );
              },
            );
          }
          );

          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                  color: Colors.blueGrey,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Favourites'),
            ),
            body: ListView(children: divided),
          );

      }
    )
  );
}




  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
        child: Text('Lyrics App')
        ),

        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              ),
            onPressed: _pushBookmarked,
          )
        ] 
      ),


      body: Center(
          child: FutureBuilder <List<Track>>(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                
                List<Track> data = snapshot.data ?? <Track>[];
                return 
                ListView.separated(
                separatorBuilder:(constext, index) => const Divider(
                  color: Colors.blueGrey,
                  ),
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  
                  final bookmarked = _saved.contains(data[index]);

                  return ListTile(
                    title: Text(data[index].trackName),
                    subtitle: Text(data[index].artistName),
                    onTap: (){
                      Navigator.push(
                        context,              
                        MaterialPageRoute(
                        builder: (context) =>  TrackDetails(track : data[index]),
                      ),
                      );
                    },
                    trailing:  IconButton(
                      icon: Icon(
                    bookmarked ? Icons.bookmark_add : Icons.bookmark_add_outlined,

                    semanticLabel: bookmarked ? 'Remove from saved' : 'Save',
                      ),
                    onPressed:(){
                      setState(() {
                if (bookmarked){
                _saved.remove(data[index]);
                }
                else{
                  _saved.add(data[index]);
                }
                      }
                      );
                    }
                 ),
                  );
                  },
                  );  
                }
              
               else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),  
    );
  }
}