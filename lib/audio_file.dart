import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';

class AudioFile extends StatefulWidget {
  final AudioPlayer? advancedPlayer;
  //final String? audioPath;

  const AudioFile({Key? key, this.advancedPlayer}) : super(key: key);

  @override
  _AudioFileState createState() => _AudioFileState();
}

class _AudioFileState extends State<AudioFile> {
  Uint8List? audiobytes;
  Duration _duration = const Duration();
  Duration _position = const Duration();
  bool isPlaying = false;
  bool isPaused = false;
  bool isRepeat = false;
  Color color = Colors.black;
  final List<IconData> _icons = [
    Icons.play_circle_fill,
    Icons.pause_circle_filled,
  ];

  void loadtheAudio() async {
    String audioPath = "assets/balti.mp3";
    ByteData bytes = await rootBundle.load(audioPath); //load audio from assets
    audiobytes =
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }

  @override
  void initState() {
    super.initState();
    loadtheAudio();
    widget.advancedPlayer!.onDurationChanged.listen((d) {
      setState(() {
        _duration = d;
      });
    });
    widget.advancedPlayer!.onAudioPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });

    //widget.advancedPlayer!.setUrl(audiobytes);

    widget.advancedPlayer!.onPlayerCompletion.listen((event) {
      setState(() {
        _position = const Duration(seconds: 0);
        if (isRepeat == true) {
          isPlaying = true;
        } else {
          isPlaying = false;
          isRepeat = false;
        }
      });
    });
  }

  Widget btnStart() {
    return IconButton(
      padding: const EdgeInsets.only(bottom: 5),
      icon: isPlaying == false
          ? Icon(_icons[0], size: 50, color: Colors.blue)
          : Icon(_icons[1], size: 50, color: Colors.blue),
      onPressed: () {
        if (isPlaying == false) {
          // int result = await player.playBytes(audiobytes);
          widget.advancedPlayer!.playBytes(audiobytes!);
          setState(() {
            isPlaying = true;
          });
        } else if (isPlaying == true) {
          widget.advancedPlayer!.pause();
          setState(() {
            isPlaying = false;
          });
        }
      },
    );
  }

  Widget btnFast() {
    return IconButton(
      icon: const ImageIcon(
        AssetImage('assets/forward.png'),
        size: 15,
        color: Colors.black,
      ),
      onPressed: () {
        widget.advancedPlayer!.setPlaybackRate(1.5);
      },
    );
  }

  Widget btnSlow() {
    return IconButton(
      icon: const ImageIcon(
        AssetImage('assets/backword.png'),
        size: 15,
        color: Colors.black,
      ),
      onPressed: () {
        widget.advancedPlayer!.setPlaybackRate(0.5);
      },
    );
  }

  Widget btnLoop() {
    return IconButton(
        onPressed: () {},
        icon: const ImageIcon(
          AssetImage('assets/loop.png'),
          size: 15,
          color: Colors.black,
        ));
  }

  Widget btnRepeat() {
    return IconButton(
      icon: const ImageIcon(
        AssetImage('assets/repeat.png'),
        size: 15,
        color: Colors.black,
      ),
      onPressed: () {
        if (isRepeat == false) {
          widget.advancedPlayer!.setReleaseMode(ReleaseMode.LOOP);
          setState(() {
            isRepeat = true;
            color = Colors.blue;
          });
        } else if (isRepeat == true) {
          widget.advancedPlayer!.setReleaseMode(ReleaseMode.RELEASE);
          color = Colors.black;
          isRepeat = false;
        }
      },
    );
  }

  Widget slider() {
    return Slider(
        activeColor: Colors.red,
        inactiveColor: Colors.grey,
        value: _position.inSeconds.toDouble(),
        min: 0.0,
        max: _duration.inSeconds.toDouble(),
        onChanged: (double value) {
          setState(() {
            changeToSecond(value.toInt());
            value = value;
          });
        });
  }

  void changeToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    widget.advancedPlayer!.seek(newDuration);
  }

  Widget loadAsset() {
    return Container(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          btnRepeat(),
          btnSlow(),
          btnStart(),
          btnFast(),
          btnLoop()
        ]));
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _position.toString().split(".")[0],
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                _duration.toString().split(".")[0],
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 50,
          width: screenWidth * 0.9,
          child: slider(),
        ),
        loadAsset(),
      ],
    );
  }
}
