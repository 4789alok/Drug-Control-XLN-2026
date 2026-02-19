import 'package:get/get.dart';

class CheckboxController extends GetxController {
  var alumiumSection = false.obs;
  var drawers = false.obs;
  var pellets = false.obs;
  var woodenFurniture = false.obs;
  var glassSection = false.obs;
  var racks = false.obs;
  var anyOther = false.obs;
}

class Formsection2Controller extends GetxController {
  var allo_r_20 = false.obs;
  var allo_r_21 = false.obs;
  var allo_w_20b = false.obs;
  var allo_w_21b = false.obs;
  var restricted_20a = false.obs;
  var restricted_21a = false.obs;
  var homeopathy20_c = false.obs;
  var homeopathy20_d = false.obs;
  var schedule_x_20f = false.obs;
  var schedule_x_20g = false.obs;
  var mobile21bb = false.obs;
  var mobile20bb = false.obs;
}

class RegistredPharmacistcontroller extends GetxController {
  var bpharm = false.obs;
  var dpharm = false.obs;
  var experienced = false.obs;
  var mpharm = false.obs;
  var phd = false.obs;
  var qualified = false.obs;
}

class Competentpersoncontroller extends GetxController {
  var bcom = false.obs;
  var bsc = false.obs;
  var mcom = false.obs;
  var msc = false.obs;
  var postgraduate = false.obs;
  var ba = false.obs;
  //
  var ma = false.obs;
  var graduate = false.obs;
  var others = false.obs;
  var ssc = false.obs;
}

class Generalfirmformcontroller extends GetxController {
  var selectedoption = "yes".obs;
  void setselectedoption(value) {
    selectedoption.value = value;
  }
}
