import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_pos/screens/home.dart';
import 'package:smart_pos/screens/payment.dart';
import 'package:smart_pos/screens/take_picture_screen.dart';
import 'package:smart_pos/theme/theme.dart';

import 'screens/login.dart';
import 'screens/not_found_screen.dart';
import 'screens/startup.dart';
import 'setup.dart';
import 'utils/routes_constraints.dart';

List<CameraDescription> cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  createRouteBindings();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatefulWidget {
  final List<CameraDescription> cameras;

  const MyApp({Key? key, required this.cameras}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart POS',
      debugShowCheckedModeBanner: false,
      theme: light(),
      getPages: [
        GetPage(
            name: RouteHandler.WELCOME,
            page: () => const StartUpView(),
            transition: Transition.zoom),
        GetPage(
            name: RouteHandler.LOGIN,
            page: () => const LogInScreen(),
            transition: Transition.zoom),
        GetPage(
            name: RouteHandler.HOME,
            page: () => const HomeScreen(),
            transition: Transition.zoom),
        GetPage(
            name: RouteHandler.TAKE_PICTURE,
            page: () => TakePictureScreen(camera: widget.cameras[1]),
            transition: Transition.zoom),
        GetPage(
            name: RouteHandler.PAYMENT,
            page: () => PaymentScreen(
                  id: Get.parameters['id'] ?? '0',
                ),
            transition: Transition.cupertino),
      ],
      initialRoute: RouteHandler.WELCOME,
      unknownRoute:
          GetPage(name: RouteHandler.NAV, page: () => const NotFoundScreen()),
    );
  }
}
