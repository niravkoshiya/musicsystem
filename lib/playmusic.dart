import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class fullscreen extends StatefulWidget {

  List<SongModel> songModel;
  int pos;
  fullscreen(this.songModel,this.pos);
  @override
  State<fullscreen> createState() => _fullscreenState();
}

class _fullscreenState extends State<fullscreen> {
  bool play=false;
  AudioPlayer player = AudioPlayer();
  double currenval=0;
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
  void initState() {
    // TODO: implement initState
    super.initState();

    player.onPositionChanged.listen((Duration  d) {
      setState(() {
        currenval=(d.inMilliseconds).toDouble();
      });
    });
    player.onPlayerComplete.listen((event) {
      setState(() {
        widget.pos=widget.pos+1;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Text("${widget.songModel[widget.pos].title}"),
            Spacer(),
            Slider(
              onChangeStart: (value) async {
                await player.pause();
              },
              onChangeEnd: (value) async {
                await player.seek(Duration(milliseconds: value.toInt()));
                await player.resume();
              },
              onChanged:(value) {
                setState(() {
                  currenval=value;
                });
              },value: currenval,
              min: 0,
              max: (widget.songModel[widget.pos].duration!).toDouble(),),
            Row(
              children: [
                Text(printDuration(Duration(milliseconds: currenval.toInt()))),
                Spacer(),
                Text(printDuration(Duration(milliseconds: widget.songModel[widget.pos].duration!)))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(onPressed: () {
                  setState(() {
                    widget.pos=widget.pos-1;
                  });
                }, icon: Icon(Icons.skip_previous)),
                play?IconButton(onPressed: () async {
                  setState(() {
                    play=!play;
                  });
                  await player.pause();
                }, icon: Icon(Icons.pause)):
                IconButton(onPressed: () async {
                  setState(() {
                    play=!play;
                  });
                  print( widget.songModel[widget.pos].data);
                  await player.play(DeviceFileSource(widget.songModel[widget.pos].data));
                }, icon: Icon(Icons.play_arrow)),
                IconButton(onPressed: () {
                  setState(() {
                    widget.pos=widget.pos+1;
                  });
                }, icon: Icon(Icons.skip_next)),
              ],
            )
          ],
        )
    );
  }
}