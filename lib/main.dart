import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter demo',
      theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: SpeechScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SpeechScreen extends StatefulWidget{
  @override
  _SpeechScreenState createState() => _SpeechScreenState();

}

class _SpeechScreenState extends State<SpeechScreen>{

  late stt.SpeechToText _speech;
  bool _islistening = false;
  String _textSpeech ="press button to speak";

  void onListen() async{
    if(!_islistening){
      bool available = await _speech.initialize(
          onStatus: (val) => print('onstatus:$val'),
          onError: (val) =>print('onerror:$val')
      );
      if( available){
        setState(() {
          _islistening=true;
        });
        _speech.listen(
            onResult: (val) => setState(() {
              _textSpeech= val.recognizedWords;
            })
        );
      }
    } else{
      setState(() {
        _islistening=false;
        _speech.stop();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _speech=stt.SpeechToText();

  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title:Text('text to speech')),
      floatingActionButton: AvatarGlow(
        animate: _islistening,
        glowColor:Theme.of(context).primaryColor,
        endRadius:80,
        duration:Duration(milliseconds: 2000),
        repeatPauseDuration:Duration(milliseconds: 100),
        repeat:true,
        child: FloatingActionButton(
          onPressed: () => onListen(),
          child: Icon(_islistening ? Icons.mic :Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: EdgeInsets.fromLTRB(25, 25, 25, 150),
          child: Text(
            _textSpeech,
            style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.w500
            ),

          ),
        ),
      ),

    );
  }

}