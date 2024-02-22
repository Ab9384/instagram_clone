import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagram_clone/firebase_options.dart';
import 'package:instagram_clone/provider/app_data.dart';
import 'package:instagram_clone/provider/settings.dart';
import 'package:instagram_clone/screens/deciding_screen.dart';
import 'package:instagram_clone/utils/app_colors.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
        create: (BuildContext context) => SettingsProvider()),
    ChangeNotifierProvider(create: (BuildContext context) => AppData())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        Provider.of<SettingsProvider>(context, listen: false).toggleTheme();
      },
      child: MaterialApp(
        title: 'Instagram Clone',
        debugShowCheckedModeBanner: false,
        theme: getTheme(context),
        home: const DecidingScreen(),
      ),
    );
  }

  // get device current theme
  ThemeData getTheme(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Provider.of<SettingsProvider>(context).isDark
          ? Brightness.light
          : Brightness.dark,
    ));
    // only portrait mode
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final settings = Provider.of<SettingsProvider>(context);
    return settings.isDark ? AppColors().darkTheme : AppColors().lightTheme;
  }
}
