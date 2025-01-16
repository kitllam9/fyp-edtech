import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fyp_edtech/config/routes.dart';
import 'package:fyp_edtech/model/user.dart';
import 'package:fyp_edtech/service/local_storage.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/widgets/app_layout.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  getIt.registerSingleton<User>(User());
  getIt.registerSingleton<SharedPreferences>(await LocalStorage.prefs);

  final SharedPreferences prefs = await LocalStorage.prefs;
  String? appSettingBrightness = prefs.getString('brightness');
  if (appSettingBrightness == null) {
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    Globals.darkMode = brightness == Brightness.dark;
    Globals.brightness = AppBrightness.system;
  } else {
    Globals.brightness = appSettingBrightness == 'light' ? AppBrightness.light : AppBrightness.dark;
    Globals.darkMode = Globals.brightness == AppBrightness.dark;
  }

  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      overlayWidgetBuilder: (progress) => Center(
        child: SpinKitSquareCircle(
          color: AppColors.primary,
          size: 50.0,
        ),
      ),
      child: RefreshConfiguration(
        headerBuilder: () => WaterDropHeader(),
        footerBuilder: () => ClassicFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          noDataText: 'You\'ve reached the end.',
          textStyle: TextStyle(color: AppColors.text),
          loadingText: '',
          loadingIcon: SpinKitSquareCircle(
            color: AppColors.primary,
            size: 25.0,
          ),
        ),
        headerTriggerDistance: 80.0,
        maxOverScrollExtent: 100,
        maxUnderScrollExtent: 0,
        enableScrollWhenRefreshCompleted: true,
        enableLoadingWhenFailed: true,
        hideFooterWhenNotFull: false,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const MainApp(),
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: AppColors.scaffold,
            textTheme: GoogleFonts.notoSansTextTheme(),
          ),
          routes: routes,
          navigatorKey: navigatorKey,
        ),
      ),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void didChangeDependencies() {
    Globals.screenWidth = MediaQuery.of(context).size.width;
    Globals.screenHeight = MediaQuery.of(context).size.height;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final User user = getIt.get<User>();
      user.token = GetIt.instance.get<SharedPreferences>().getString('token');
      if (user.loggedIn) {
        await user.getUserData();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(index: 0);
  }
}
