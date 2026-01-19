import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants/colors.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'BOC Banking',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.bocGold,
          scaffoldBackgroundColor: AppColors.bocBlack,
          textTheme: GoogleFonts.interTextTheme(
            ThemeData.dark().textTheme,
          ),
        ),
        home: const WelcomeScreen(),
      ),
    );
  }
}
