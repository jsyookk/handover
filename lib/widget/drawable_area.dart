import 'package:flutter/material.dart';
import 'package:handover/controllers/painting_controller.dart';
import 'package:provider/provider.dart';
import 'package:handover/widget/signature_painter.dart';
import 'dart:ui' as ui;

class DrawableArea extends StatelessWidget {
  final GlobalKey globakey;
  final ui.Image backImg;
  final bool isDraw;

  DrawableArea(this.globakey , this.backImg , this.isDraw);

  @override
  Widget build(BuildContext context) {
    final drawabbleSize = MediaQuery.of(context).size;

    return  Consumer<PaintingController>(
            builder: (context, controller, child) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0)
                ),
                child: RepaintBoundary(
                    key: globakey,
                    child: GestureDetector(
                      onPanDown: (details) {
                        //Pen sound
                        RenderBox referenceBox = context.findRenderObject();
                        Offset localPosition =
                        referenceBox.globalToLocal(details.globalPosition);
                        controller.addPoint(localPosition);
                      },
                      onPanUpdate: (details) {
                        RenderBox referenceBox = context.findRenderObject();
                        Offset localPosition =
                        referenceBox.globalToLocal(details.globalPosition);
                        controller.addPoint(localPosition);
                      },
                      onPanEnd: (details) {
                        controller.addPoint(null);
                      },
                      child: CustomPaint(
                          size: isDraw ? drawabbleSize : Size(drawabbleSize.width , 150),
                          willChange: true,
                          painter: SignaturePainter(context: context , backimg: this.backImg , controller: controller)),
                    )
                ),
              );
            });
  }
}