class Track{
  final int trackId;
  final String trackName;
  final String artistName;

  Track({required this.trackId,required this.trackName,required this.artistName});

  factory Track.fromJson(Map<String, dynamic> json){
    return Track(
      trackId: json['track_id'],
      trackName: json['track_name'],
      artistName: json['artist_name'],
    );
  }
}