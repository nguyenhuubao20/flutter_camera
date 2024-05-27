import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Return true if token is expire
Future<bool> expireToken() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //convert datetime type to the same format to compare
    DateTime now =
        DateFormat("yyyy-MM-dd hh:mm:ss").parse(DateTime.now().toString());
    DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss")
        .parse(prefs.getString('expireDate') ?? now.toString());

    return tempDate.compareTo(now) < 0;
  } catch (e) {
    return true;
  }
}

Future<bool> setToken(String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString('token', value);
}

Future<String?> getToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

Future<void> deleteToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
}

Future<bool> setStoreId(String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString('storeId', value);
}

Future<String?> getStoreId() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('storeId');
}

Future<void> deleteStoreId() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('storeId');
}

Future<void> deleteUserInfo() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("userInfo");
}

Future<int?> getTableNumber() async {
  int? number = 20;
  final SharedPreferences pref = await SharedPreferences.getInstance();
  if (pref.containsKey("numberOfTable")) {
    number = pref.getInt("numberOfTable");
  }
  return number;
}
