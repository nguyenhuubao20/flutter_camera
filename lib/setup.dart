import 'package:get/get.dart';
import 'package:smart_pos/view_models/index.dart';

void createRouteBindings() async {
  Get.put(StartUpViewModel());
  Get.put(LoginViewModel());
  Get.put(CartViewModel());
  Get.put(MenuViewModel());
}
