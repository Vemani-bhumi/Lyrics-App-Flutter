class Track{
  final int? trackId;
  final String? trackName;
  final String? artistName;

  Track({this.trackId,this.trackName,this.artistName});

  factory Track.fromJson(Map<String, dynamic> json){
    return Track(
      trackId: json['track_id'],
      trackName: json['track_name'],
      artistName: json['artist_name'],
    );
  }
}