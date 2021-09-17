
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';


enum penType {
  pen,
  erase
}

class PaintingController extends ChangeNotifier{


  //펜 타입
  penType type = penType.pen;

  //Defalut Painter
   Paint _currentPainter = Paint()
    ..color = Colors.black
     ..isAntiAlias = true
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 5.0;

  List<Offset> _points = <Offset>[];
  List<Paint> _painters = <Paint>[];

  //Pen sound
  AudioCache _audioCache = AudioCache(prefix : 'audio/');
  AudioPlayer _audioPlayer;

  List<Offset> get points{
    return _points;
  }

  List<Paint> get painters{
    return _painters;
  }

  Paint get painter => _currentPainter;

  bool isPendown = false;

  void _playPenSound(String sound) async{
    if(type == penType.pen){

      if(_audioPlayer?.state != PlayerState.PLAYING && isPendown){
        print('in sound play : ${_audioPlayer?.state}');
        _audioPlayer = await _audioCache.play(sound , mode: PlayerMode.LOW_LATENCY);
        _audioPlayer.state = PlayerState.PLAYING;
      }
    }
  }

  void _playPenSoundPause() {

    if(_audioPlayer?.state == PlayerState.PLAYING && !isPendown) {
      print('in sound pause :  ${_audioPlayer?.state}');
      _audioPlayer?.pause();
      _audioPlayer.state = PlayerState.STOPPED;
    }
  }

  void setPenType(penType type){
    this.type = type;
  }

  void setColor(Color color){
    _currentPainter.color = color;
  }

  void setPainter(Paint paint){
    _currentPainter = paint;
  }

  void setWidth(double width){
    _currentPainter.strokeWidth = width;
  }

  void addPoint(Offset point){

    if(type == penType.pen){
      //현재 좌표 저장
      _points.add(point);
      //Paint를 새로 만드는 이유는 이전 Painter 값이 일괄 변경 되기 때문이다.
      _painters.add(new Paint()
        ..isAntiAlias = true
        ..strokeCap = _currentPainter.strokeCap
        ..color=_currentPainter.color
        ..strokeWidth=_currentPainter.strokeWidth);
      //좌표가 찍히는 동안
      if(point != null){
        isPendown = true;
        _playPenSound('write on paper_1.wav');
      }else{
        isPendown = false;
        _playPenSoundPause();
      }
    }else if(type == penType.erase){
        _points.add(point);
        _painters.add(new Paint()
          ..strokeCap = StrokeCap.square
          ..color = _currentPainter.color
          ..style = PaintingStyle.fill
          ..isAntiAlias = true
          ..strokeWidth = 15.0
        );

       //지우개 기능
        /*
        _points.removeWhere((element) => element != null &&
            (element.dx <= (point.dx + ERASE_DX_RANGE) && element.dx >= (point.dx - ERASE_DX_RANGE))
            && ((element.dy <= (point.dy + ERASE_DY_RANGE) && (element.dy >= point.dy - ERASE_DY_RANGE))));
        */

    }
    notifyListeners();
  }

  void clear(){
    _painters.clear();
    _points.clear();
    _audioCache.clearAll();
    _audioPlayer.dispose();
    notifyListeners();
  }
}