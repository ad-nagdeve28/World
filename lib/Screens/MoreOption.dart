import 'dart:io';
import 'dart:async';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:math' show pi;

import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'player_widget.dart';


typedef OnError = void Function(Exception exception);

const kUrl1= 'ttps://luan.xyz/files/audio/ambient_c_motion.mp3';
const kUrl2 = 'https://luan.xyz/files/audio/nasa_on_a_mission.mp3';
const kUrl3 = 'http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio1xtra_mf_p';


class PlayButton extends StatefulWidget{
  final Icon playIcon;
  final Icon pauseIcon;
  final bool initialIsPlaying;
  final VoidCallback onPressed;

  PlayButton({
    this.initialIsPlaying = false,
    this.pauseIcon = const Icon(Icons.pause), 
    this.playIcon = const Icon(Icons.play_arrow),
    @required this.onPressed
  }): assert(onPressed != null);

  @override
  _playButton createState()=> _playButton();
}

class _playButton extends State<PlayButton> with TickerProviderStateMixin{

  bool isPlaying;

  AnimationController _rotationController;
  AnimationController _scaleController;
  
  double _rotation = 0;
  double _scale = 0.85;

  bool get _showWaves => !_scaleController.isDismissed;

  static const _kToggleDuration = Duration(milliseconds: 300);
  static const _kRotationDuration = Duration(seconds: 5);

  void _updateRotation() => _rotation = _rotationController.value * 2 * pi;
  void _updateScale() => _scale = (_scaleController.value * 0.2) + 0.85;

  @override
  void initState(){
    isPlaying = widget.initialIsPlaying;
    _rotationController = AnimationController(vsync: this, duration: _kRotationDuration)
      ..addListener(()=> setState(_updateRotation))
      ..repeat();


    _scaleController = AnimationController(vsync: this, duration: _kToggleDuration)
      ..addListener(()=> setState(_updateScale));


    super.initState();
  }

  void _onToggle(){
    setState(() =>
      isPlaying =! isPlaying
    );
    if(_scaleController.isCompleted){
      _scaleController.reverse();
    } else{
      _scaleController.forward();
    }
    widget.onPressed();
  }

  Widget _buildIcon(bool isPlaying){
    return SizedBox.expand(
      key: ValueKey<bool>(isPlaying),
      child: IconButton(
          icon: isPlaying ? widget.pauseIcon : widget.playIcon,
          onPressed: _onToggle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(minWidth: 40, minHeight: 40),
      child: Stack(
        children: [
          if(_showWaves)...[
            Blod(
              color: Color(0xff0092ff),
              scale: _scale,
              rotation: _rotation,
            ),
            Blod(
              color: Color(0xff4ac7b7),
              scale: _scale,
              rotation: _rotation * 2 - 30,
            ),
            Blod(
              color: Color(0xffa4a6f6),
              scale: _scale,
              rotation: _rotation * 3 -45,
            ),
          ],
          Container(
            constraints: BoxConstraints.expand(),
            child: AnimatedSwitcher(
                child: _buildIcon(isPlaying),
                duration: _kToggleDuration,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white70
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose(){
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }
}

class Blod extends StatelessWidget{

  final double rotation;
  final double scale;
  final Color color;

  const Blod({
    this.color,
    this.scale = 1,
    this.rotation = 0,
  }): assert(color != null);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
        scale: scale,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(150),
                topRight: Radius.circular(240),
                bottomLeft: Radius.circular(220),
                bottomRight: Radius.circular(180),
              )
          ),
        ),
      ),
    );
  }
}


class ExampleApp extends StatefulWidget{
  @override
  _ExampleApp createState()=> _ExampleApp();
}

class _ExampleApp extends State<ExampleApp>{

  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();
  String LocalFilePath;
  String localAudioCacheURI;

  @override
  void initState(){
    super.initState();
    if(kIsWeb){
      return;
    }
    if(Platform.isIOS){
      audioCache.fixedPlayer.notificationService.startHeadlessService();
      advancedPlayer.notificationService.startHeadlessService();
    }
  }

  Future _loadFile() async{
    final bytes = await readBytes(Uri.parse(kUrl1));
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/audio.mp3');

    await file.writeAsBytes(bytes);
    if(file.existsSync()){
      setState(() => LocalFilePath = file.path
      );
    }
  }

  Widget remoteUrl(){
    return const SingleChildScrollView(
      child: _Tab(
        children:[
            Text('Sample 1 ($kUrl1)',
            key: Key('Url1'),
          style: TextStyle(fontWeight: FontWeight.bold,),
            ),
          PlayerWidget(url: kUrl1),
          Text("Sample 2 ($kUrl2)",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          PlayerWidget(url: kUrl2),
          Text('Sample 3 ($kUrl3)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          PlayerWidget(url: kUrl3),
          Text("Sample 4 (Low Latency mode) ($kUrl1)",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          PlayerWidget(url: kUrl1, mode: PlayerMode.LOW_LATENCY),
          ]
      ),
    );
  }

  Widget localFile(){
    return _Tab(
      children: [
        const Text("--manually load bytes (no web!) --"),
        const Text("File: $kUrl1"),
        _Btn(txt: 'Download file to your Device', onPressed: _loadFile),
        Text('Current local file path: $LocalFilePath'),
        if(localAudioCacheURI != null) PlayerWidget(url: localAudioCacheURI),
        Container(
          constraints: const BoxConstraints.expand(width: 1.0, height: 20.0),
        ),
        const Text('__ via AudioCache__'),
        const Text('File: $kUrl2'),
        _Btn(txt: 'Download File to your Device', onPressed: _loadFileAC,),
        Text("Current AC loaded: $localAudioCacheURI"),
        if(localAudioCacheURI != null) PlayerWidget(url: localAudioCacheURI),
      ],
    );
  }

  void _loadFileAC() async{
    final uri = await audioCache.load(kUrl2);
    setState(() => localAudioCacheURI = uri.toString());
  }
  
  Widget localAsset() {
    return SingleChildScrollView(
      child: _Tab(
        children: [
          const Text("Play Local Asset 'audio.mp3':"),
          _Btn(txt: 'Play', onPressed: () => audioCache.play('audio.mp3')),
          const Text("Play Local Asset (via byte source) 'audio.mp3':"),
          _Btn(
            txt: 'Play',
            onPressed: () async {
              final bytes = await (await audioCache.loadAsFile('audio.mp3'))
                  .readAsBytes();
              audioCache.playBytes(bytes);
            },
          ),
          const Text("Loop Local Asset 'audio.mp3':"),
          _Btn(txt: 'Loop', onPressed: () => audioCache.loop('audio.mp3')),
          const Text("Loop Local Asset (via byte source) 'audio.mp3':"),
          _Btn(
            txt: 'Loop',
            onPressed: () async {
              final bytes = await (await audioCache.loadAsFile('audio.mp3'))
                  .readAsBytes();
              audioCache.playBytes(bytes, loop: true);
            },
          ),
          const Text("Play Local Asset 'audio2.mp3':"),
          _Btn(txt: 'Play', onPressed: () => audioCache.play('audio2.mp3')),
          const Text("Play Local Asset In Low Latency 'audio.mp3':"),
          _Btn(
            txt: 'Play',
            onPressed: () {
              audioCache.play('audio.mp3', mode: PlayerMode.LOW_LATENCY);
            },
          ),
          const Text(
            "Play Local Asset Concurrently In Low Latency 'audio.mp3':",
          ),
          _Btn(
            txt: 'Play',
            onPressed: () async {
              await audioCache.play(
                'audio.mp3',
                mode: PlayerMode.LOW_LATENCY,
              );
              await audioCache.play(
                'audio2.mp3',
                mode: PlayerMode.LOW_LATENCY,
              );
            },
          ),
          const Text("Play Local Asset In Low Latency 'audio2.mp3':"),
          _Btn(
            txt: 'Play',
            onPressed: () {
              audioCache.play('audio2.mp3', mode: PlayerMode.LOW_LATENCY);
            },
          ),
          getLocalFileDuration(),
        ],
      ),
    );
  }

  Future<int> _getDuration() async{
    final uri = await audioCache.load('audio2.mp3');
    await advancedPlayer.setUrl(uri.toString());
    return Future.delayed(
      const Duration(seconds: 2),
          ()=> advancedPlayer.getDuration(),
    );
  }

  FutureBuilder<int> getLocalFileDuration(){
    return FutureBuilder<int>(
      future: _getDuration(),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.none:
            return const Text('No Connection..');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return const Text('Awaiting result....');
          case ConnectionState.done:
            if(snapshot.hasError){
              return Text('Error: ${snapshot.error}');
            }
            return Text(
              'audio2.mp3 duration is : ${Duration(milliseconds: snapshot.data)}'
            );
          default:
            return Container();
        }
      },
    );
  }
  
  Widget notification() {
    return _Tab(
      children: [
        const Text("Play notification sound: 'messenger.mp3' :"),
        _Btn(
          txt: 'Play',
          onPressed: ()=> audioCache.play('messenger.mp3', isNotification: true),
        )
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        StreamProvider<Duration>.value(
          initialData: const Duration(),
          value: advancedPlayer.onAudioPositionChanged,
        ),
      ],
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Remote Url'),
                Tab(text: 'Local File'),
                Tab(text: 'Local Asset'),
                Tab(text: 'Notification'),
                Tab(text: 'Advanced'),
              ],
            ),
            title: const Text('audioplayers Example'),
          ),
          body: TabBarView(
            children: [
              remoteUrl(),
              localFile(),
              localAsset(),
              notification(),
              Advanced(advancedPlayer: advancedPlayer),
            ],
          ),
        ),
      ),
    );
  }
}

class Advanced extends StatefulWidget {
  final AudioPlayer advancedPlayer;

  const Advanced({Key key, @required this.advancedPlayer}) : super(key: key);

  @override
  _AdvancedState createState() => _AdvancedState();
}

class _AdvancedState extends State<Advanced> {
  bool seekDone;

  @override
  void initState() {
    widget.advancedPlayer.onSeekComplete
        .listen((event) => setState(() => seekDone = true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final audioPosition = Provider.of<Duration>(context);
    return SingleChildScrollView(
      child: _Tab(
        children: [
          Column(
            children: [
              const Text('Source Url'),
              Row(
                children: [
                  _Btn(
                    txt: 'Audio 1',
                    onPressed: () => widget.advancedPlayer.setUrl(kUrl1),
                  ),
                  _Btn(
                    txt: 'Audio 2',
                    onPressed: () => widget.advancedPlayer.setUrl(kUrl2),
                  ),
                  _Btn(
                    txt: 'Stream',
                    onPressed: () => widget.advancedPlayer.setUrl(kUrl3),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
            ],
          ),
          Column(
            children: [
              const Text('Release Mode'),
              Row(
                children: [
                  _Btn(
                    txt: 'STOP',
                    onPressed: () =>
                        widget.advancedPlayer.setReleaseMode(ReleaseMode.STOP),
                  ),
                  _Btn(
                    txt: 'LOOP',
                    onPressed: () =>
                        widget.advancedPlayer.setReleaseMode(ReleaseMode.LOOP),
                  ),
                  _Btn(
                    txt: 'RELEASE',
                    onPressed: () => widget.advancedPlayer
                        .setReleaseMode(ReleaseMode.RELEASE),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
            ],
          ),
          Column(
            children: [
              const Text('Volume'),
              Row(
                children: [0.0, 0.3, 0.5, 1.0, 1.1, 2.0].map((e) {
                  return _Btn(
                    txt: e.toString(),
                    onPressed: () => widget.advancedPlayer.setVolume(e),
                  );
                }).toList(),
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
            ],
          ),
          Column(
            children: [
              const Text('Control'),
              Row(
                children: [
                  _Btn(
                    txt: 'resume',
                    onPressed: () => widget.advancedPlayer.resume(),
                  ),
                  _Btn(
                    txt: 'pause',
                    onPressed: () => widget.advancedPlayer.pause(),
                  ),
                  _Btn(
                    txt: 'stop',
                    onPressed: () => widget.advancedPlayer.stop(),
                  ),
                  _Btn(
                    txt: 'release',
                    onPressed: () => widget.advancedPlayer.release(),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
            ],
          ),
          Column(
            children: [
              const Text('Seek in milliseconds'),
              Row(
                children: [
                  _Btn(
                    txt: '100ms',
                    onPressed: () {
                      widget.advancedPlayer.seek(
                        Duration(
                          milliseconds: audioPosition.inMilliseconds + 100,
                        ),
                      );
                      setState(() => seekDone = false);
                    },
                  ),
                  _Btn(
                    txt: '500ms',
                    onPressed: () {
                      widget.advancedPlayer.seek(
                        Duration(
                          milliseconds: audioPosition.inMilliseconds + 500,
                        ),
                      );
                      setState(() => seekDone = false);
                    },
                  ),
                  _Btn(
                    txt: '1s',
                    onPressed: () {
                      widget.advancedPlayer.seek(
                        Duration(seconds: audioPosition.inSeconds + 1),
                      );
                      setState(() => seekDone = false);
                    },
                  ),
                  _Btn(
                    txt: '1.5s',
                    onPressed: () {
                      widget.advancedPlayer.seek(
                        Duration(
                          milliseconds: audioPosition.inMilliseconds + 1500,
                        ),
                      );
                      setState(() => seekDone = false);
                    },
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
            ],
          ),
          Column(
            children: [
              const Text('Rate'),
              Row(
                children: [0.5, 1.0, 1.5, 2.0, 5.0].map((e) {
                  return _Btn(
                    txt: e.toString(),
                    onPressed: () {
                      widget.advancedPlayer.setPlaybackRate(playbackRate: e);
                    },
                  );
                }).toList(),
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
            ],
          ),
          Text('Audio Position: $audioPosition'),
          if (seekDone != null) Text(seekDone ? 'Seek Done' : 'Seeking...'),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget{

  final List<Widget> children;
  const _Tab({Key key, @required this.children}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: children.map(
                    (w) => Container(
                      child: w,
                      padding: const EdgeInsets.all(6.0),
                    )
            ).toList(),
          ),
        ),
      ),
    );
  }
}

class _Btn extends StatelessWidget{

  final String txt;
  final VoidCallback onPressed;

  const _Btn({
    Key key,
    @required this.txt,
    @required this.onPressed
  }): super(key: key);


  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 48.0,
        child: ElevatedButton(
          child: Text(txt),
          onPressed: onPressed,
        )
    );
  }
}