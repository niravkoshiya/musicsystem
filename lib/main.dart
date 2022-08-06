import 'package:flutter/material.dart';
import 'package:musicsystem/playmusic.dart';
import 'package:on_audio_query/on_audio_query.dart';

void main() {
  runApp(MaterialApp(
    home: allmusic(),
    debugShowCheckedModeBanner: false,
  ));
}

class allmusic extends StatefulWidget {
  const allmusic({Key? key}) : super(key: key);

  @override
  State<allmusic> createState() => _allmusicState();
}

class _allmusicState extends State<allmusic> {
  OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<SongModel>> getsong() async {
    List<SongModel> songlist = await _audioQuery.querySongs();
    return songlist;
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0)
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    else
      return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MUSIC"),),
      body: FutureBuilder(
        future: getsong(),
        builder: (context, snapshot) {
          print(snapshot.connectionState);
          if (snapshot.connectionState == ConnectionState.done) {
            List<SongModel> val = snapshot.data as List<SongModel>;
            return ListView.builder(
              itemBuilder: (context, index) {
                SongModel songModel = val[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return fullscreen(val, index);
                      },
                    ));
                  },
                  title: Text("${songModel.title}"),
                  subtitle: Text("${songModel.album}"),
                  trailing: Text(printDuration(
                      Duration(milliseconds: songModel.duration!))),
                );
              },
              itemCount: val.length,
            );
          } else {
            return Container(
              child: Text("hello"),
            );
          }
        },
      ),
    );
  }
}
