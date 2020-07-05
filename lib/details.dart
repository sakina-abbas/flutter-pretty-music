import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'constants.dart';
import 'mypainter.dart';

class NowPlayingScreen extends StatefulWidget {
  @override
  _NowPlayingScreenState createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  final String artist = 'Illenium', songTitle = 'Gorgeous';
  final String image = kImageIllenium;

  final assetsAudioPlayer = AssetsAudioPlayer();
  Duration totalDuration; // total Duration of the audio
  bool isPlaying = false;

  @override
  initState() {
    super.initState();
    _setupAudio();
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  /// configure the Audio Player
  _setupAudio() {
    // fetch the audio from assets and load it for playing
    assetsAudioPlayer.open(
      Audio('assets/audios/song1.mp3'),
      autoStart: false,
    );

    // listener to check whether the Player is playing any audio
    // true: playing, false: stopped/paused
    assetsAudioPlayer.isPlaying.listen((event) {
      print('song is playing $event');
      setState(() {
        isPlaying = event;
      });
    });

    // listener to check the current audio that's playing & fetch its total duration
    assetsAudioPlayer.current.listen((event) {
      if (event != null) {
        print(
            'totalDuration: ${_formatDurationToString(event.audio.duration)}');
        setState(() {
          totalDuration = event.audio.duration;
        });
      }
    });
  }

  /// convert Duration to String with mm:ss formatting
  String _formatDurationToString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPurpleColor,
      body: Stack(
        children: <Widget>[
          Positioned(
            child: Column(
              children: <Widget>[
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_drop_down_circle),
                    onPressed: () => print('hello'),
                  ),
                  title: Text('MY MUSIC'),
                  centerTitle: true,
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.playlist_add),
                      onPressed: () => print('hello'),
                    )
                  ],
                ),
                SizedBox(
                  height: 35,
                ),
                CircleAvatar(
                  radius: 120,
                  backgroundColor: kPurpleColor,
                  backgroundImage: NetworkImage(image),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  songTitle,
                  style: kSongTitleTextStyle,
                ),
                SizedBox(
                  height: 6.0,
                ),
                Text(
                  artist,
                  style: kArtistTextStyle,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Stack(
              children: [
                MyArc(
                  diameter: MediaQuery.of(context).size.width,
                ),
                Positioned(
                  top: 50,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.fast_rewind,
                              color: Colors.white54,
                              size: 42.0,
                            ),
                            onPressed: () => print('rewind'),
                          ),
                          SizedBox(width: 32.0),
                          RawMaterialButton(
                            elevation: 15,
                            fillColor: kHotPinkColor,
                            padding: EdgeInsets.all(10),
                            shape: CircleBorder(),
                            child: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              size: 50,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              assetsAudioPlayer.playOrPause();
                            },
                          ),
                          SizedBox(width: 32.0),
                          IconButton(
                            icon: Icon(
                              Icons.fast_forward,
                              color: Colors.white54,
                              size: 42.0,
                            ),
                            onPressed: () => print('forward'),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      StreamBuilder<Duration>(
                          stream: assetsAudioPlayer.currentPosition,
                          builder: (context, snapshot) {
                            return Slider(
                              min: 0,
                              max: totalDuration != null
                                  ? totalDuration.inSeconds.ceilToDouble()
                                  : 10,
                              onChanged: (double value) {
                                assetsAudioPlayer.seek(
                                  Duration(
                                    seconds: value.ceil(),
                                  ),
                                );
                              },
                              value: snapshot.hasData
                                  ? snapshot.data.inSeconds.ceilToDouble()
                                  : 0,
                              activeColor: Colors.white,
//                                inactiveColor: Colors.grey,
                            );
                          }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            StreamBuilder<Duration>(
                                stream: assetsAudioPlayer.currentPosition,
                                builder: (context, snapshot) {
                                  return Text(
                                    snapshot.hasData
                                        ? _formatDurationToString(snapshot.data)
                                        : '0:00',
                                    style: kTimeTextStyle,
                                  );
                                }),
                            StreamBuilder<Duration>(
                                stream: assetsAudioPlayer.currentPosition,
                                builder: (context, snapshot) {
                                  return Text(
                                    snapshot.hasData && totalDuration != null
                                        ? '-${_formatDurationToString(totalDuration - snapshot.data)}'
                                        : '-:--',
                                    style: kTimeTextStyle,
                                  );
                                })
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
