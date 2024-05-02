import 'package:flutter/material.dart';
import 'package:frontend/challenge/create/create_challenge_screen_fir.dart';
import 'package:frontend/challenge/detail/detail_challenge_screen.dart';
import 'package:frontend/community/tab_community_screen.dart';
import 'package:frontend/login/login_screen.dart';
import 'package:frontend/model/controller/user_controller.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:frontend/main/main_screen.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:frontend/model/data/global_variables.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initializeDateFormatting('ko_KR', null);

  bool isLoggedIn = await checkIfLoggedIn();
  FlutterNativeSplash.remove();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  // This widgets is the root of your application.
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());

    return ScreenUtilInit(
        designSize: const Size(375, 844),
        minTextAdapt: true,
        builder: (context, child) {
          return GetMaterialApp(
              theme: ThemeData(primaryColor: Colors.white),
              // navigatorObservers: <NavigatorObserver>[observer],
              initialRoute: widget.isLoggedIn ? 'main' : 'login',
              routes: {
                // SplashScreen.routeName: (context) => SplashScreen(),
                'login': (context) => const LoginScreen(),
                'main': (context) => const MainScreen(),
                'create_challenge': (context) => CreateChallenge_fir(),
                'detail_challenge': (context) => ChallengeDetailScreen(),
                // 'state_challenge' : (context) => ChallengeStateScreen(),
                'community': (context) => TabCommunityScreen(),
              });
        });
  }
}

Future<bool> checkIfLoggedIn() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? accessToken = prefs.getString('access_token');

  bool isLoggedIn = accessToken != null;

  return isLoggedIn;
}
