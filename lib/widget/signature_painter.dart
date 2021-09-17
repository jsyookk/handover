import 'package:flutter/material.dart';
import 'package:handover/controllers/painting_controller.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class SignaturePainter extends CustomPainter {

  final BuildContext context;
  final PaintingController controller;
  final ui.Image backimg;

  SignaturePainter({@required this.context , this.backimg , this.controller});

  @override
  void paint(Canvas canvas, Size size) {

    //background image
    if(backimg!= null){
      canvas.drawImage(backimg, Offset.zero, Paint());
    }

    var _points = controller.points;
    var _painters = controller.painters;

    try {
      for (int i = 0; i < _points.length - 1; i++) {
        if (_points[i] != null && _points[i + 1] != null) {
          canvas.drawLine(_points[i], _points[i + 1], _painters[i]);
        } else if (_points[i] != null && _points[i + 1] == null) {
          canvas.drawPoints(ui.PointMode.points, [_points[i]], _painters[i]);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) => true;
}