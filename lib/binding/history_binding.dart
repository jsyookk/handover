import 'package:get/get.dart';
import 'package:handover/controllers/history_controller.dart';

class HistoryBinding implements Bindings{

  @override
  void dependencies() {
    //controller
    Get.lazyPut<HistoryController>(() => HistoryController());
    //api service

  }


}