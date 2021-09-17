import 'package:get/get.dart';
import 'package:handover/controllers/language_controller.dart';

class LanguageBinding implements Bindings{

  @override
  void dependencies() {
    //controller
    Get.put(LanguageController() , permanent : true);
    
  }
}