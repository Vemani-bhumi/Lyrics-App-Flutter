import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TrackDetails extends StatefulWidget {
  final int? trackId;
  const TrackDetails({Key? key,  int? this.trackId}) : super(key: key);

  @override
  State<TrackDetails> createState() => _TrackDetailsState();
}

class _TrackDetailsState extends State<TrackDetails> {

  Future<String>fetchLyrics() async{

    final apiEndPoint = "https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=${widget.trackId}&apikey=${dotenv.env['API_KEY']}";
    final Uri url = Uri.parse(apiEndPoint);
    final response = await http.get(url);
    
    if (response.statusCode == 200) {

    String jsonResponse = json.decode(response.body)['message']['body']['lyrics']['lyrics_body'];

    
      return jsonResponse;
  } else {
    throw Exception('Unexpected error occured!');
  }
  }

  late Future<String> lyrics;

@override
  void initState() {
    super.initState();
    lyrics = fetchLyrics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lyrics"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: lyrics,
          builder: (context,snapshot){
            //print(snapshot);
          if(snapshot.hasData){
            return Text(snapshot.data.toString());
          }
          else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default show a loading spinner.
                return const CircularProgressIndicator();
        }),
      )
      );

      
}
}