import '../models/index.dart';
import '../utils/request.dart';

class MenuData {
  Future<Menu?> getMenuOfStore() async {
    final res = await request.get(
      'stores/menus',
    );
    var jsonList = res.data;
    Menu menu = Menu.fromJson(jsonList);
    return menu;
  }
}
