import 'package:flutter/material.dart';
import 'package:myapp/page-1/sign-in.dart';
import 'package:myapp/utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Add a delay and navigate to the login page
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 393;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return SizedBox(
      width: double.infinity,
      child: Container(
        // splashscreenYck (1:2)
        padding: EdgeInsets.fromLTRB(60 * fem, 280 * fem, 73 * fem, 285 * fem),
        width: double.infinity,
        height: 852 * fem,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/page-1/images/splash-screen-bg.png',
            ),
          ),
        ),
        child: SizedBox(
          // splashlogoDit (31:14)
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Positioned(
                // wehappylogoZXr (1:3)
                left: 0 * fem,
                top: 0 * fem,
                child: Align(
                  child: SizedBox(
                    width: 260 * fem,
                    height: 174 * fem,
                    child: Image.asset(
                      'assets/page-1/images/we-happy-logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                // smilewehappysmilemakinglifebea (2:6)
                left: 1 * fem,
                top: 170 * fem,
                child: Align(
                  child: SizedBox(
                    width: 255 * fem,
                    height: 125 * fem,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: SafeGoogleFont(
                          'Inter',
                          fontSize: 10 * ffem,
                          fontWeight: FontWeight.w400,
                          height: 1.2102272511 * ffem / fem,
                          color: const Color(0xffa27dde),
                        ),
                        children: [
                          WidgetSpan(
                            child: SizedBox(
                              width: 28 * ffem,
                              height: 28 * ffem,
                              child: Center(
                                child: Text(
                                  '😊', // Unicode for smiley emoji
                                  style: TextStyle(
                                    fontSize: 28 * ffem,
                                    fontWeight: FontWeight.w900,
                                    height: 1.2575 * ffem / fem,
                                    color: const Color(0xa8e62a9b),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TextSpan(
                            text: ' MINDMENTA ',
                            style: SafeGoogleFont(
                              'Inter',
                              fontSize: 22 * ffem,
                              fontWeight: FontWeight.w800,
                              height: 1.2125 * ffem / fem,
                              color: const Color(0xa8e62a9b),
                            ),
                          ),
                          WidgetSpan(
                            child: SizedBox(
                              width: 28 * ffem,
                              height: 28 * ffem,
                              child: Center(
                                child: Text(
                                  '😊', // Unicode for smiley emoji
                                  style: TextStyle(
                                    fontSize: 28 * ffem,
                                    fontWeight: FontWeight.w900,
                                    height: 1.2575 * ffem / fem,
                                    color: const Color(0xa8e62a9b),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TextSpan(
                            text: ' \n',
                            style: SafeGoogleFont(
                              'Inter',
                              fontSize: 28 * ffem,
                              fontWeight: FontWeight.w800,
                              height: 1.2125 * ffem / fem,
                              color: const Color(0xa8e62a9b),
                            ),
                          ),
                          TextSpan(
                            text: '\n',
                            style: SafeGoogleFont(
                              'Inter',
                              fontSize: 15 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.2125 * ffem / fem,
                              color: const Color(0xffa27dde),
                            ),
                          ),
                          TextSpan(
                            text: 'Making Life Beautiful and Happier',
                            style: SafeGoogleFont(
                              'Inter',
                              fontSize: 15 * ffem,
                              fontWeight: FontWeight.w700,
                              height: 1.2125 * ffem / fem,
                              color: const Color(0xffa27dde),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
