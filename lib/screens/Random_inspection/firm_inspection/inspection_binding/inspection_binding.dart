import 'package:get/get.dart';
import 'package:xln2026/screens/Random_inspection/firm_inspection/controller/firm_inspection_controller.dart';

class InspectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InspectionController>(() => InspectionController());
  }
}
