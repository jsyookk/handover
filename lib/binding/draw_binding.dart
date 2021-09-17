import 'package:get/get.dart';
import 'package:handover/controllers/painting_controller.dart';

class DrawBinding implements Bindings{

  @override
  void dependencies() {
    //controller
    Get.lazyPut<PaintingController>(() => PaintingController());
    //Get.put(PaintingController());
    //api service

  }


}