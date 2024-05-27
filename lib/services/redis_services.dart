import 'dart:async';
import 'package:get/get.dart';
import 'package:redis/redis.dart';
import 'package:smart_pos/widgets/dialog.dart';

class RedisService {
  RedisConnection conn = RedisConnection();
  Future<void> setDataToRedis(String key, String value) async {
    try {
      await conn.connect('127.0.0.1', 6379).then((Command command) {
        command.send_object(["SET", key, value]).then(
            (dynamic response) => print(response));
      });
    } catch (e) {
      Get.snackbar("Lỗi redis server", e.toString());

      return;
    }
  }

  Future<dynamic> getDataFromRedis(String key) async {
    try {
      Command command = await conn.connect('localhost', 6379);
      var res = await command.send_object(["GET", key]);
      return res;
    } catch (e) {
      Get.snackbar("Lỗi redis server", e.toString());
      return;
    }
  }
}
