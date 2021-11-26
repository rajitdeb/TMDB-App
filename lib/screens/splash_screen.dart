import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tmdb/style/theme.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: MyColors.mainColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            SizedBox(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 100.0,
                    height: 72.0,
                    child: const Text(
                      "TMDB",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MyColors.secondColor,
                        fontSize: 72.0,
                        fontWeight: FontWeight.w800,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8.0,),

                  const Text(
                    "Everything about entertainment",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 150.0,
              child: Lottie.asset("assets/cinema_news_ffbg.json")
            )

          ],
        ),
      ),
    );
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    Get.offAll(() => const HomeScreen());
  }
}
