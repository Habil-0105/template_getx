import 'dart:async';

import 'package:alice/alice.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:template_getx/features/auth/presentation/pages/splash_page.dart';
import 'package:template_getx/injector.dart';
import 'package:upgrader/upgrader.dart';

import 'shared/services/notification/app_notification.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final Alice alice = Alice(navigatorKey: navigatorKey);

Future<void> main() async {
  runZonedGuarded<Future<void>>(() async{
    WidgetsFlutterBinding.ensureInitialized();

    /// Wajib memanggil kode berikut untuk menggunakan service local storage
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDirectory.path);

    /// Wajib dipanggil dalam menggunakan package flutter_screenutil supaya lebih responsive
    await ScreenUtil.ensureScreenSize();

    /// Wajib dipanggil untuk menginisialisasi controller dan repository
    injectorSetup();

    /// Wajib memanggil kode berikut untuk menggunakan service notification
    await AppNotification.instance.initializeNotification();
    await AppNotification.instance.getInitialFCMNotification();
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await SentryFlutter.init((options) {
        options.dsn = '';
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
        // We recommend adjusting this value in production.
        options.tracesSampleRate = 1.0;
        // The sampling rate for profiling is relative to tracesSampleRate
        // Setting to 1.0 will profile 100% of sampled transactions:
        options.profilesSampleRate = 1.0;
      },
      appRunner: () => runApp(const SentryWidget(child: MyApp())),
    );
  }, (error, stack)async{
    await Sentry.captureException(error, stackTrace: stack);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark
        )
    );

    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        var shortestSide = MediaQuery.of(context).size.shortestSide;
        final bool isTablet = shortestSide > 600;

        if(isTablet){
          ScreenUtil.init(context);
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: GetMaterialApp(
            navigatorKey: navigatorKey,
            title: "",
            debugShowCheckedModeBanner: false,
            home: UpgradeAlert(
              child: const SplashPage(),
            ),
          ),
        );
      },
    );
  }
}
