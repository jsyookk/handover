import 'package:get/get.dart';
import 'en_US.dart';
import 'ko_KR.dart';

class AppTranslations extends Translations {

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': en_US,
    'ko_KR': ko_KR
  };
}