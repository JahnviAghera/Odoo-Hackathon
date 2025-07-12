import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rewear/auth.dart';
import 'package:rewear/supabase_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initializeSupabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'ReWear',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0x004CFF00)),
      ),
      home: OnBoarding00Page(),
    );
  }
}

class OnBoarding00Page extends StatefulWidget {

  @override
  State<OnBoarding00Page> createState() => _OnBoarding00State();
}

class _OnBoarding00State extends State<OnBoarding00Page> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthScreen()),
      );
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo_blue_large.png',height: 80,width: 80),
                  Text(
                    'ReWear',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF202020),
                      fontSize: 52,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.52,
                    ),
                  ),
                  SizedBox(
                    width: 249,
                    height: 59,
                    child: Text(
                      'Reuse fashion, Save the planet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF202020),
                        fontSize: 19,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w400,
                        height: 1.74,
                      ),
                    ),
                  ),
                ],
              ),
            )
        ),
      )
    );
  }
}
class OnBoarding01Page extends StatefulWidget {

  @override
  State<OnBoarding01Page> createState() => _OnBoarding01State();
}

class _OnBoarding01State extends State<OnBoarding01Page> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo_blue_large.png',height: 80,width: 80),
                    Text(
                      'ReWear',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF202020),
                        fontSize: 52,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.52,
                      ),
                    ),
                    SizedBox(
                      width: 249,
                      height: 59,
                      child: Text(
                        'Reuse fashion, Save the planet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF202020),
                          fontSize: 19,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w400,
                          height: 1.74,
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ),
        )
    );
  }
}
