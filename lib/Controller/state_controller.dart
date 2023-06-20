import 'package:get/get.dart';

class StateController extends GetxController {
  String enteredCity = 'None';

  void updateCity(String cityValue) {
    enteredCity = cityValue;
    update();
  }
}
