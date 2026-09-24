import 'package:flutter/material.dart';
import 'package:myapp/utils.dart';

class ExcercisePage extends StatelessWidget {
  const ExcercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 393;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return SizedBox(
      width: double.infinity,
      child: Container(
        // excercisepagexiY (196:7)
        width: double.infinity,
        height: 852 * fem,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/page-1/images/excercise-page-bg.png',
            ),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              // autogroupfzseUB6 (TqHxiJtrtqN7p817HLFZSE)
              left: 57.5 * fem,
              top: 803 * fem,
              child: SizedBox(
                width: 264.5 * fem,
                height: 42 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      // autogroup3rjlBrC (TqHxvoY3TfeWp3o3kx3RjL)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 10 * fem, 0 * fem),
                      width: 61 * fem,
                      height: 40 * fem,
                      child: Stack(
                        children: [
                          Positioned(
                            // homevHz (196:39)
                            left: 0 * fem,
                            top: 0 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 61 * fem,
                                height: 31 * fem,
                                child: Text(
                                  'home',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Font Awesome 5 Free',
                                    fontSize: 24 * ffem,
                                    fontWeight: FontWeight.w900,
                                    height: 1.2575 * ffem / fem,
                                    color: const Color(0x72353463),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // homeDH6 (196:43)
                            left: 15.5 * fem,
                            top: 26 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 28 * fem,
                                height: 14 * fem,
                                child: Text(
                                  'HOME',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Exo',
                                    fontSize: 10 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.33 * ffem / fem,
                                    color: const Color(0x72353463),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      // autogroupuagvhi4 (TqHy2PD5UQsFZi8QcQUAgv)
                      width: 193.5 * fem,
                      height: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            // smile3mv (196:40)
                            left: 0 * fem,
                            top: 2 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 59 * fem,
                                height: 31 * fem,
                                child: Text(
                                  'smile',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Font Awesome 5 Free',
                                    fontSize: 24 * ffem,
                                    fontWeight: FontWeight.w900,
                                    height: 1.2575 * ffem / fem,
                                    color: const Color(0x72353463),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // stethoscopekRS (196:41)
                            left: 19 * fem,
                            top: 4 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 158 * fem,
                                height: 31 * fem,
                                child: Text(
                                  'STETHOSCOPE',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Font Awesome 6 Free',
                                    fontSize: 24 * ffem,
                                    fontWeight: FontWeight.w900,
                                    height: 1.2575 * ffem / fem,
                                    color: const Color(0x72353463),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // bellLuS (196:42)
                            left: 147.7363019958 * fem,
                            top: 0 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 41 * fem,
                                height: 31 * fem,
                                child: Text(
                                  'bell',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Font Awesome 5 Free',
                                    fontSize: 24 * ffem,
                                    fontWeight: FontWeight.w900,
                                    height: 1.2575 * ffem / fem,
                                    color: const Color(0x72353463),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // moodEzp (196:44)
                            left: 16.5 * fem,
                            top: 28 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 29 * fem,
                                height: 14 * fem,
                                child: Text(
                                  'MOOD',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Exo',
                                    fontSize: 10 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.33 * ffem / fem,
                                    color: const Color(0x72353463),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // therepyZ1W (196:45)
                            left: 80 * fem,
                            top: 28 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 43 * fem,
                                height: 14 * fem,
                                child: Text(
                                  'THEREPY',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Exo',
                                    fontSize: 10 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.33 * ffem / fem,
                                    color: const Color(0x72353463),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // reminderT6t (196:46)
                            left: 144.5 * fem,
                            top: 27 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 49 * fem,
                                height: 14 * fem,
                                child: Text(
                                  'REMINDER',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Exo',
                                    fontSize: 10 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.33 * ffem / fem,
                                    color: const Color(0x72353463),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              // autogroupfimkwXr (TqHuD5QAVAEU6mX2jhFimk)
              left: 16 * fem,
              top: 49 * fem,
              child: SizedBox(
                width: 233 * fem,
                height: 116 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // bars46g (359:307)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 21 * fem, 65 * fem, 0 * fem),
                      child: Text(
                        'bars',
                        textAlign: TextAlign.center,
                        style: SafeGoogleFont(
                          'Font Awesome 5 Free',
                          fontSize: 15 * ffem,
                          fontWeight: FontWeight.w900,
                          height: 1.2575 * ffem / fem,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                    SizedBox(
                      // rectangle103AQc (202:49)
                      width: 138 * fem,
                      height: 116 * fem,
                      child: Image.asset(
                        'assets/page-1/images/rectangle-103.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              // progressJWp (203:53)
              left: 47 * fem,
              top: 204 * fem,
              child: Align(
                child: SizedBox(
                  width: 55 * fem,
                  height: 18 * fem,
                  child: Text(
                    'Progress',
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont(
                      'Outfit',
                      fontSize: 14 * ffem,
                      fontWeight: FontWeight.w500,
                      height: 1.26 * ffem / fem,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // autogroup7w8iaz8 (TqHuWejDMz3WHsyNXW7w8i)
              left: 32 * fem,
              top: 233 * fem,
              child: SizedBox(
                width: 301 * fem,
                height: 27 * fem,
                child: Stack(
                  children: [
                    Positioned(
                      // checkJQL (203:54)
                      left: 5 * fem,
                      top: 5 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 35 * fem,
                          height: 17 * fem,
                          child: Text(
                            'check',
                            textAlign: TextAlign.center,
                            style: SafeGoogleFont(
                              'Font Awesome 5 Free',
                              fontSize: 13 * ffem,
                              fontWeight: FontWeight.w900,
                              height: 1.2575 * ffem / fem,
                              color: const Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // circleaMr (203:55)
                      left: 0 * fem,
                      top: 1 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 45 * fem,
                          height: 26 * fem,
                          child: Text(
                            'circle',
                            textAlign: TextAlign.center,
                            style: SafeGoogleFont(
                              'Font Awesome 5 Free',
                              fontSize: 20 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.2575 * ffem / fem,
                              color: const Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // circleH1N (203:56)
                      left: 44 * fem,
                      top: 0 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 45 * fem,
                          height: 26 * fem,
                          child: Text(
                            'circle',
                            textAlign: TextAlign.center,
                            style: SafeGoogleFont(
                              'Font Awesome 5 Free',
                              fontSize: 20 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.2575 * ffem / fem,
                              color: const Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // circleb24 (203:57)
                      left: 129.5 * fem,
                      top: 0 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 45 * fem,
                          height: 26 * fem,
                          child: Text(
                            'circle',
                            textAlign: TextAlign.center,
                            style: SafeGoogleFont(
                              'Font Awesome 5 Free',
                              fontSize: 20 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.2575 * ffem / fem,
                              color: const Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // circleUrY (203:58)
                      left: 88 * fem,
                      top: 0 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 45 * fem,
                          height: 26 * fem,
                          child: Text(
                            'circle',
                            textAlign: TextAlign.center,
                            style: SafeGoogleFont(
                              'Font Awesome 5 Free',
                              fontSize: 20 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.2575 * ffem / fem,
                              color: const Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // circlencL (203:59)
                      left: 212 * fem,
                      top: 0 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 45 * fem,
                          height: 26 * fem,
                          child: Text(
                            'circle',
                            textAlign: TextAlign.center,
                            style: SafeGoogleFont(
                              'Font Awesome 5 Free',
                              fontSize: 20 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.2575 * ffem / fem,
                              color: const Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // circle5rL (203:60)
                      left: 171 * fem,
                      top: 0 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 45 * fem,
                          height: 26 * fem,
                          child: Text(
                            'circle',
                            textAlign: TextAlign.center,
                            style: SafeGoogleFont(
                              'Font Awesome 5 Free',
                              fontSize: 20 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.2575 * ffem / fem,
                              color: const Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // circleao6 (203:61)
                      left: 256 * fem,
                      top: 0 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 45 * fem,
                          height: 26 * fem,
                          child: Text(
                            'circle',
                            textAlign: TextAlign.center,
                            style: SafeGoogleFont(
                              'Font Awesome 5 Free',
                              fontSize: 20 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.2575 * ffem / fem,
                              color: const Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // checkgr8 (203:63)
                      left: 134 * fem,
                      top: 4 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 35 * fem,
                          height: 17 * fem,
                          child: Text(
                            'check',
                            textAlign: TextAlign.center,
                            style: SafeGoogleFont(
                              'Font Awesome 5 Free',
                              fontSize: 13 * ffem,
                              fontWeight: FontWeight.w900,
                              height: 1.2575 * ffem / fem,
                              color: const Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              // autogroup6wr2B2C (TqHusDyGTL17qrTTYu6Wr2)
              left: 49.5 * fem,
              top: 265 * fem,
              child: SizedBox(
                width: 267 * fem,
                height: 20 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // m5dN (203:64)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 3 * fem, 33.5 * fem, 0 * fem),
                      child: Text(
                        'M',
                        textAlign: TextAlign.center,
                        style: SafeGoogleFont(
                          'Font Awesome 5 Free',
                          fontSize: 13 * ffem,
                          fontWeight: FontWeight.w900,
                          height: 1.2575 * ffem / fem,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                    Container(
                      // tbrc (203:65)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 3 * fem, 36 * fem, 0 * fem),
                      child: Text(
                        'T',
                        textAlign: TextAlign.center,
                        style: SafeGoogleFont(
                          'Font Awesome 5 Free',
                          fontSize: 13 * ffem,
                          fontWeight: FontWeight.w900,
                          height: 1.2575 * ffem / fem,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                    Container(
                      // wWya (203:66)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 33 * fem, 1 * fem),
                      child: Text(
                        'W',
                        textAlign: TextAlign.center,
                        style: SafeGoogleFont(
                          'Font Awesome 5 Free',
                          fontSize: 13 * ffem,
                          fontWeight: FontWeight.w900,
                          height: 1.2575 * ffem / fem,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                    Container(
                      // t2h2 (203:67)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 1 * fem, 34.5 * fem, 0 * fem),
                      child: Text(
                        'T',
                        textAlign: TextAlign.center,
                        style: SafeGoogleFont(
                          'Font Awesome 5 Free',
                          fontSize: 13 * ffem,
                          fontWeight: FontWeight.w900,
                          height: 1.2575 * ffem / fem,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                    Container(
                      // f9me (203:68)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 1 * fem, 35 * fem, 0 * fem),
                      child: Text(
                        'F',
                        textAlign: TextAlign.center,
                        style: SafeGoogleFont(
                          'Font Awesome 5 Free',
                          fontSize: 13 * ffem,
                          fontWeight: FontWeight.w900,
                          height: 1.2575 * ffem / fem,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                    Container(
                      // ssSk (203:69)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 34 * fem, 1 * fem),
                      child: Text(
                        'S',
                        textAlign: TextAlign.center,
                        style: SafeGoogleFont(
                          'Font Awesome 5 Free',
                          fontSize: 13 * ffem,
                          fontWeight: FontWeight.w900,
                          height: 1.2575 * ffem / fem,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                    Container(
                      // sarx (203:70)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 3 * fem),
                      child: Text(
                        'S',
                        textAlign: TextAlign.center,
                        style: SafeGoogleFont(
                          'Font Awesome 5 Free',
                          fontSize: 13 * ffem,
                          fontWeight: FontWeight.w900,
                          height: 1.2575 * ffem / fem,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              // autogroupql4nJHA (TqHvAiU83hCUSYxyRAQL4N)
              left: 26.5 * fem,
              top: 303 * fem,
              child: SizedBox(
                width: 301 * fem,
                height: 17 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // timestarted7hrs53minpmJ (203:71)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 38 * fem, 0 * fem),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 13 * ffem,
                            fontWeight: FontWeight.w300,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xffa27dde),
                          ),
                          children: [
                            const TextSpan(
                              text: 'Time Started -',
                            ),
                            TextSpan(
                              text: ' 7hrs 53min',
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 13 * ffem,
                                fontWeight: FontWeight.w300,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xb5caaaff),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    RichText(
                      // dailystreak2dayshCp (203:72)
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: SafeGoogleFont(
                          'Outfit',
                          fontSize: 13 * ffem,
                          fontWeight: FontWeight.w300,
                          height: 1.26 * ffem / fem,
                          color: const Color(0xff000000),
                        ),
                        children: [
                          TextSpan(
                            text: 'Daily Streak-',
                            style: SafeGoogleFont(
                              'Outfit',
                              fontSize: 13 * ffem,
                              fontWeight: FontWeight.w300,
                              height: 1.26 * ffem / fem,
                              color: const Color(0xffa27dde),
                            ),
                          ),
                          const TextSpan(
                            text: ' ',
                          ),
                          TextSpan(
                            text: '2days',
                            style: SafeGoogleFont(
                              'Outfit',
                              fontSize: 13 * ffem,
                              fontWeight: FontWeight.w300,
                              height: 1.26 * ffem / fem,
                              color: const Color(0xb5caaaff),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              // autogroupeddxo9N (TqHvM8LSX46ocA8FpBEDdx)
              left: 33 * fem,
              top: 334 * fem,
              child: SizedBox(
                width: 330 * fem,
                height: 18 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // yourpracticesVnt (203:73)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 200 * fem, 1 * fem),
                      child: Text(
                        'Your Practices',
                        textAlign: TextAlign.center,
                        style: SafeGoogleFont(
                          'Outfit',
                          fontSize: 13 * ffem,
                          fontWeight: FontWeight.w500,
                          height: 1.26 * ffem / fem,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                    Container(
                      // viewallAPE (204:143)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 1 * fem, 0 * fem, 0 * fem),
                      child: Text(
                        'View All',
                        style: SafeGoogleFont(
                          'Font Awesome 5 Free',
                          fontSize: 13 * ffem,
                          fontWeight: FontWeight.w900,
                          height: 1.2575 * ffem / fem,
                          color: const Color(0xffa27dde),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              // autogroup1mqx3T2 (TqHxPV6tm8KqipNNeN1Mqx)
              left: 37 * fem,
              top: 641 * fem,
              child: SizedBox(
                width: 327 * fem,
                height: 22 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // allyogastyles7hn (203:78)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 198 * fem, 5 * fem),
                      child: Text(
                        'All yoga styles',
                        textAlign: TextAlign.center,
                        style: SafeGoogleFont(
                          'Outfit',
                          fontSize: 13 * ffem,
                          fontWeight: FontWeight.w500,
                          height: 1.26 * ffem / fem,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                    Container(
                      // viewallnov (205:144)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 5 * fem, 0 * fem, 0 * fem),
                      child: Text(
                        'View All',
                        style: SafeGoogleFont(
                          'Font Awesome 5 Free',
                          fontSize: 13 * ffem,
                          fontWeight: FontWeight.w900,
                          height: 1.2575 * ffem / fem,
                          color: const Color(0xffa27dde),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              // sessionsGDJ (204:79)
              left: 33 * fem,
              top: 450 * fem,
              child: Align(
                child: SizedBox(
                  width: 49 * fem,
                  height: 17 * fem,
                  child: Text(
                    'Sessions',
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont(
                      'Outfit',
                      fontSize: 13 * ffem,
                      fontWeight: FontWeight.w500,
                      height: 1.26 * ffem / fem,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // autogroupe6bx7Dv (TqHvZCpefbJne2C4g5E6Bx)
              left: 38 * fem,
              top: 359 * fem,
              child: SizedBox(
                width: 284 * fem,
                height: 81 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // autogroupjbdqz2p (TqHvjsBYzL4AasBpqijBDQ)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 88 * fem, 0 * fem),
                      padding: EdgeInsets.fromLTRB(
                          5 * fem, 0 * fem, 5 * fem, 0 * fem),
                      width: 98 * fem,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff000000)),
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            'assets/page-1/images/rectangle-105-bg.png',
                          ),
                        ),
                      ),
                      child: Align(
                        // homeyogaSQc (204:127)
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: 35 * fem,
                            ),
                            child: Text(
                              'Home Yoga',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 13 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // autogroupklc6LVz (TqHvoSuvC4WX6cqMY7kLc6)
                      padding: EdgeInsets.fromLTRB(
                          3.5 * fem, 0 * fem, 3.5 * fem, 0 * fem),
                      width: 98 * fem,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff000000)),
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            'assets/page-1/images/rectangle-114-bg.png',
                          ),
                        ),
                      ),
                      child: Align(
                        // yogaforbackpain27v (204:128)
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: 57 * fem,
                            ),
                            child: Text(
                              'Yoga For Back Pain',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 13 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              // autogroup94hcH3r (TqHvw7MpJH7KgboNUB94HC)
              left: 24 * fem,
              top: 473 * fem,
              child: SizedBox(
                width: 335.5 * fem,
                height: 45 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // autogroupri6rmDv (TqHwB28JgurKmYfMe3Ri6r)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 42.5 * fem, 0 * fem),
                      width: 148.5 * fem,
                      height: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            // rectangle107t3e (204:117)
                            left: 0 * fem,
                            top: 0 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 134 * fem,
                                height: 45 * fem,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(20 * fem),
                                    border: Border.all(
                                        color: const Color(0xff000000)),
                                    color: const Color(0x47e62a9b),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // session01Ytt (204:129)
                            left: 16 * fem,
                            top: 15 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 62 * fem,
                                height: 17 * fem,
                                child: Text(
                                  'Session-01',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Outfit',
                                    fontSize: 13 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.26 * ffem / fem,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // circleplaySUU (204:136)
                            left: 61.5 * fem,
                            top: 13 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 87 * fem,
                                height: 26 * fem,
                                child: Text(
                                  'circle-play',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Font Awesome 6 Free',
                                    fontSize: 20 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2575 * ffem / fem,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      // autogroupj3upwAL (TqHwGWy9RCTNvo3tZxJ3up)
                      width: 144.5 * fem,
                      height: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            // rectangle108URA (204:118)
                            left: 0 * fem,
                            top: 0 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 134 * fem,
                                height: 45 * fem,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(20 * fem),
                                    border: Border.all(
                                        color: const Color(0xff000000)),
                                    color: const Color(0x47e62a9b),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // session02yMv (204:130)
                            left: 17 * fem,
                            top: 15 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 65 * fem,
                                height: 17 * fem,
                                child: Text(
                                  'Session-02',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Outfit',
                                    fontSize: 13 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.26 * ffem / fem,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // circleplayrgc (204:137)
                            left: 57.5 * fem,
                            top: 14 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 87 * fem,
                                height: 26 * fem,
                                child: Text(
                                  'circle-play',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Font Awesome 6 Free',
                                    fontSize: 20 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2575 * ffem / fem,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              // autogroupwxa6Lrg (TqHwU6UBryyGQBSjtawXa6)
              left: 24 * fem,
              top: 522 * fem,
              child: SizedBox(
                width: 329 * fem,
                height: 51 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // autogroupd214sbi (TqHweRWK3tFuyNfCN4D214)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 6 * fem, 46.5 * fem, 0 * fem),
                      width: 148.5 * fem,
                      height: 45 * fem,
                      child: Stack(
                        children: [
                          Positioned(
                            // rectangle110bGp (204:120)
                            left: 0 * fem,
                            top: 0 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 134 * fem,
                                height: 45 * fem,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(20 * fem),
                                    border: Border.all(
                                        color: const Color(0xff000000)),
                                    color: const Color(0x47e62a9b),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // session03V7J (204:131)
                            left: 16 * fem,
                            top: 15 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 65 * fem,
                                height: 17 * fem,
                                child: Text(
                                  'Session-03',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Outfit',
                                    fontSize: 13 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.26 * ffem / fem,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // circleplayBF2 (204:138)
                            left: 61.5 * fem,
                            top: 14 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 87 * fem,
                                height: 26 * fem,
                                child: Text(
                                  'circle-play',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Font Awesome 6 Free',
                                    fontSize: 20 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2575 * ffem / fem,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // autogroupdkxet9S (TqHwk1BM4dUej2zZDWdkxe)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 6 * fem),
                      padding: EdgeInsets.fromLTRB(
                          14 * fem, 16 * fem, 12 * fem, 10 * fem),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff000000)),
                        color: const Color(0xb5caaaff),
                        borderRadius: BorderRadius.circular(20 * fem),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // session04yRn (204:132)
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 2 * fem, 18 * fem, 0 * fem),
                            child: Text(
                              'Session-04',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 13 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                          Container(
                            // lockHxG (204:141)
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 0 * fem, 2 * fem),
                            child: Text(
                              'lock',
                              style: SafeGoogleFont(
                                'Font Awesome 5 Free',
                                fontSize: 13 * ffem,
                                fontWeight: FontWeight.w900,
                                height: 1.2575 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              // autogrouphecvDL8 (TqHwwagPWQzYCRPQY9HEcv)
              left: 27 * fem,
              top: 573 * fem,
              child: SizedBox(
                width: 327 * fem,
                height: 52 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // autogroupsxc2Xbi (TqHx7fDvqwS8zNmPEysXc2)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 7 * fem, 59 * fem, 0 * fem),
                      padding: EdgeInsets.fromLTRB(
                          13 * fem, 12 * fem, 12 * fem, 14 * fem),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff000000)),
                        color: const Color(0xb5caaaff),
                        borderRadius: BorderRadius.circular(20 * fem),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // session05cNG (204:133)
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 19 * fem, 2 * fem),
                            child: Text(
                              'Session-05',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 13 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                          Container(
                            // lockXEL (204:140)
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 2 * fem, 0 * fem, 0 * fem),
                            child: Text(
                              'lock',
                              style: SafeGoogleFont(
                                'Font Awesome 5 Free',
                                fontSize: 13 * ffem,
                                fontWeight: FontWeight.w900,
                                height: 1.2575 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // autogroupjgzcpjE (TqHxDEtxrgesk36k6SJGZc)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 7 * fem),
                      padding: EdgeInsets.fromLTRB(
                          14 * fem, 14 * fem, 13 * fem, 13 * fem),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff000000)),
                        color: const Color(0xb5caaaff),
                        borderRadius: BorderRadius.circular(20 * fem),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // session067TS (204:135)
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 17 * fem, 1 * fem),
                            child: Text(
                              'Session-06',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 13 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                          Container(
                            // lock24c (204:142)
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 1 * fem, 0 * fem, 0 * fem),
                            child: Text(
                              'lock',
                              style: SafeGoogleFont(
                                'Font Awesome 5 Free',
                                fontSize: 13 * ffem,
                                fontWeight: FontWeight.w900,
                                height: 1.2575 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              // autogroupc5gaLqz (TqHxXZhmHe14Gs4XC9C5GA)
              left: 33 * fem,
              top: 664 * fem,
              child: SizedBox(
                width: 339 * fem,
                height: 83 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // rectangle113Fxx (204:123)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 19 * fem, 0 * fem),
                      width: 97 * fem,
                      height: 83 * fem,
                      child: Image.asset(
                        'assets/page-1/images/rectangle-113.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      // rectangle115ytx (204:125)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 29 * fem, 0 * fem),
                      width: 97 * fem,
                      height: 83 * fem,
                      child: Image.asset(
                        'assets/page-1/images/rectangle-115.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      // rectangle116i5r (204:126)
                      width: 97 * fem,
                      height: 83 * fem,
                      child: Image.asset(
                        'assets/page-1/images/rectangle-116.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              // group1149i (228:165)
              left: 24 * fem,
              top: 22 * fem,
              child: SizedBox(
                width: 383.5 * fem,
                height: 20 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // pmpo6 (228:166)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 201.5 * fem, 1 * fem),
                      child: Text(
                        '1:25 PM',
                        textAlign: TextAlign.center,
                        style: SafeGoogleFont(
                          'Outfit',
                          fontSize: 15 * ffem,
                          fontWeight: FontWeight.w400,
                          height: 1.26 * ffem / fem,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                    Container(
                      // autogroupnnbx8on (TqHzdvMZ9jkrsLgJLSnNbx)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 1 * fem, 0 * fem, 0 * fem),
                      width: 131 * fem,
                      height: 19 * fem,
                      child: Stack(
                        children: [
                          Positioned(
                            // signal3fr (228:167)
                            left: 0 * fem,
                            top: 0 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 50 * fem,
                                height: 19 * fem,
                                child: Text(
                                  'SIGNAL',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Font Awesome 5 Free',
                                    fontSize: 15 * ffem,
                                    fontWeight: FontWeight.w900,
                                    height: 1.2575 * ffem / fem,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // wifiwWL (228:168)
                            left: 39 * fem,
                            top: 0 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 30 * fem,
                                height: 19 * fem,
                                child: Text(
                                  'WIFI',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Font Awesome 5 Free',
                                    fontSize: 15 * ffem,
                                    fontWeight: FontWeight.w900,
                                    height: 1.2575 * ffem / fem,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // batteryfullr7W (228:169)
                            left: 33 * fem,
                            top: 0 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 98 * fem,
                                height: 19 * fem,
                                child: Text(
                                  'BATTERY-FULL',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Font Awesome 5 Free',
                                    fontSize: 15 * ffem,
                                    fontWeight: FontWeight.w900,
                                    height: 1.2575 * ffem / fem,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
