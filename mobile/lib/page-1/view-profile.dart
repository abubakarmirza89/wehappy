import 'package:flutter/material.dart';
import 'package:myapp/utils.dart';

class Scene extends StatelessWidget {
  const Scene({super.key});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 393;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return SizedBox(
      width: double.infinity,
      child: Container(
        // viewprofileiCk (409:318)
        width: double.infinity,
        height: 852 * fem,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/page-1/images/view-profile-bg.png',
            ),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              // autogroupwxuyQrG (TqK8XwimgWGKmmky3CWXuY)
              left: 0 * fem,
              top: 624 * fem,
              child: Container(
                padding:
                    EdgeInsets.fromLTRB(28 * fem, 16 * fem, 28 * fem, 11 * fem),
                width: 393 * fem,
                height: 228 * fem,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // autogroupvy9x6DJ (TqK6raMLx55KB9j4r8Vy9x)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 64 * fem, 5 * fem),
                      width: double.infinity,
                      height: 46 * fem,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            // ellipse641bA (415:361)
                            width: 53 * fem,
                            height: 46 * fem,
                            child: Image.asset(
                              'assets/page-1/images/ellipse-64.png',
                              width: 53 * fem,
                              height: 46 * fem,
                            ),
                          ),
                          Container(
                            // autogroupfpju9SU (TqK799i4RPWAFJqVZQfPjU)
                            padding: EdgeInsets.fromLTRB(
                                2 * fem, 2 * fem, 0 * fem, 2 * fem),
                            height: double.infinity,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  // autogroupd4sjH2t (TqK72pZGrWkH9vzhQ4D4SJ)
                                  margin: EdgeInsets.fromLTRB(
                                      0 * fem, 0 * fem, 4 * fem, 0 * fem),
                                  width: 90 * fem,
                                  height: 33 * fem,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        // sarahedwardCQk (415:360)
                                        left: 0 * fem,
                                        top: 0 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 90 * fem,
                                            height: 18 * fem,
                                            child: Text(
                                              'Sarah Edward',
                                              textAlign: TextAlign.center,
                                              style: SafeGoogleFont(
                                                'Outfit',
                                                fontSize: 14 * ffem,
                                                fontWeight: FontWeight.w600,
                                                height: 1.26 * ffem / fem,
                                                color: const Color(0xff000000),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        // nov5tHa (415:363)
                                        left: 2 * fem,
                                        top: 19 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 28 * fem,
                                            height: 14 * fem,
                                            child: Text(
                                              'Nov 5',
                                              textAlign: TextAlign.center,
                                              style: SafeGoogleFont(
                                                'Outfit',
                                                fontSize: 11 * ffem,
                                                fontWeight: FontWeight.w400,
                                                height: 1.26 * ffem / fem,
                                                color: const Color(0xff000000),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        // NyS (415:364)
                                        left: 31 * fem,
                                        top: 5 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 6 * fem,
                                            height: 26 * fem,
                                            child: Text(
                                              '.',
                                              textAlign: TextAlign.center,
                                              style: SafeGoogleFont(
                                                'Outfit',
                                                fontSize: 20 * ffem,
                                                fontWeight: FontWeight.w400,
                                                height: 1.26 * ffem / fem,
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
                                  // updatehisprofilepicturegUL (415:362)
                                  margin: EdgeInsets.fromLTRB(
                                      0 * fem, 2 * fem, 0 * fem, 0 * fem),
                                  child: Text(
                                    'update his profile picture.',
                                    textAlign: TextAlign.center,
                                    style: SafeGoogleFont(
                                      'Outfit',
                                      fontSize: 11 * ffem,
                                      fontWeight: FontWeight.w400,
                                      height: 1.26 * ffem / fem,
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
                    Container(
                      // line88aZi (415:365)
                      margin: EdgeInsets.fromLTRB(
                          15.99 * fem, 0 * fem, 0 * fem, 8 * fem),
                      width: 0.01 * fem,
                      height: 1 * fem,
                      decoration: const BoxDecoration(
                        color: Color(0xff000000),
                      ),
                    ),
                    Container(
                      // worrylesssmilemoreh8Y (415:366)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 16 * fem),
                      width: double.infinity,
                      child: Text(
                        'worry less, smile more.',
                        textAlign: TextAlign.center,
                        style: SafeGoogleFont(
                          'Orelega One',
                          fontSize: 15 * ffem,
                          fontWeight: FontWeight.w400,
                          height: 1.09 * ffem / fem,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                    Container(
                      // autogroup4qrnBZW (TqK7PE8wNwUXX5b8aN4qrN)
                      margin: EdgeInsets.fromLTRB(
                          20 * fem, 0 * fem, 49 * fem, 0 * fem),
                      width: double.infinity,
                      height: 108 * fem,
                      child: Stack(
                        children: [
                          Positioned(
                            // homeVKJ (409:319)
                            left: 3.5 * fem,
                            top: 68 * fem,
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
                            // smilemnc (409:320)
                            left: 74.5 * fem,
                            top: 68 * fem,
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
                            // stethoscopesKr (409:321)
                            left: 93.5 * fem,
                            top: 70 * fem,
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
                            // bellMVv (409:322)
                            left: 222.2363019958 * fem,
                            top: 66 * fem,
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
                            // homefFi (409:323)
                            left: 19 * fem,
                            top: 94 * fem,
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
                          Positioned(
                            // moodZM6 (409:324)
                            left: 91 * fem,
                            top: 94 * fem,
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
                            // therepy4Yk (409:325)
                            left: 154.5 * fem,
                            top: 94 * fem,
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
                            // reminderYyi (409:326)
                            left: 219 * fem,
                            top: 93 * fem,
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
                          Positioned(
                            // dontregretjustlearnandgrowF7S (415:367)
                            left: 0 * fem,
                            top: 0 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 218 * fem,
                                height: 17 * fem,
                                child: Text(
                                  'Don’t regret, just learn and grow.',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Orelega One',
                                    fontSize: 15 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.09 * ffem / fem,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // seetranslationuBz (415:368)
                            left: 35 * fem,
                            top: 28 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 85 * fem,
                                height: 17 * fem,
                                child: Text(
                                  'see translation',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Outfit',
                                    fontSize: 13 * ffem,
                                    fontWeight: FontWeight.w300,
                                    height: 1.26 * ffem / fem,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // kyJ (415:369)
                            left: 29 * fem,
                            top: 14 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 6 * fem,
                                height: 26 * fem,
                                child: Text(
                                  '.',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Outfit',
                                    fontSize: 20 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.26 * ffem / fem,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // chevrondown3Sc (415:370)
                            left: 60.5673822715 * fem,
                            top: 37.5501568693 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 157 * fem,
                                height: 31 * fem,
                                child: Text(
                                  'chevron-down',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Font Awesome 6 Free',
                                    fontSize: 24 * ffem,
                                    fontWeight: FontWeight.w900,
                                    height: 1.2575 * ffem / fem,
                                    color: const Color(0xffa27dde),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // gearLAp (415:372)
                            left: 3.5 * fem,
                            top: 29 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 30 * fem,
                                height: 19 * fem,
                                child: Text(
                                  'gear',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Font Awesome 6 Free',
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
            Positioned(
              // autogroupjbyrcu2 (TqK7oiS8orMDxTW3zLJBYr)
              left: 0 * fem,
              top: 0 * fem,
              child: Container(
                padding:
                    EdgeInsets.fromLTRB(16 * fem, 13 * fem, 0 * fem, 4 * fem),
                width: 393 * fem,
                height: 84 * fem,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // group11v92 (409:327)
                      margin: EdgeInsets.fromLTRB(
                          9 * fem, 0 * fem, 0 * fem, 16 * fem),
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // pmeap (409:328)
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
                            // autogroupw4mkA3N (TqK81NmNY6Uo2FqjEWW4Mk)
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 1 * fem, 0 * fem, 0 * fem),
                            width: 131 * fem,
                            height: 19 * fem,
                            child: Stack(
                              children: [
                                Positioned(
                                  // signalgXW (409:329)
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
                                  // wifimor (409:330)
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
                                  // batteryfullt7n (409:331)
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
                    Container(
                      // autogroupabr8yuv (TqK5DTRAt2VjbgDUakaBR8)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 43 * fem, 0 * fem),
                      width: 334 * fem,
                      height: 31 * fem,
                      child: Stack(
                        children: [
                          Positioned(
                            // searchi6p (409:332)
                            left: 28 * fem,
                            top: 0 * fem,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(
                                  13.5 * fem, 5 * fem, 11 * fem, 6 * fem),
                              width: 306 * fem,
                              height: 31 * fem,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20 * fem),
                                image: const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    'assets/page-1/images/rectangle-75-p3E.png',
                                  ),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    // searchaui (409:334)
                                    margin: EdgeInsets.fromLTRB(
                                        0 * fem, 0 * fem, 186.5 * fem, 1 * fem),
                                    child: Text(
                                      'Search ',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Outfit',
                                        fontSize: 15 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.26 * ffem / fem,
                                        color: const Color(0xffaaa4a4),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // searchhzL (409:335)
                                    margin: EdgeInsets.fromLTRB(
                                        0 * fem, 1 * fem, 0 * fem, 0 * fem),
                                    child: Text(
                                      'search',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Font Awesome 5 Free',
                                        fontSize: 15 * ffem,
                                        fontWeight: FontWeight.w900,
                                        height: 1.2575 * ffem / fem,
                                        color: const Color(0xffaaa4a4),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            // bars2Fv (415:371)
                            left: 0 * fem,
                            top: 7 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 30 * fem,
                                height: 19 * fem,
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
              // autogroupbdmpWgt (TqK5V7dkEJA59Hvp93bDMp)
              left: 0 * fem,
              top: 84 * fem,
              child: SizedBox(
                width: 404 * fem,
                height: 190 * fem,
                child: Stack(
                  children: [
                    Positioned(
                      // rectangle2263gp (409:336)
                      left: 0 * fem,
                      top: 0 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 404 * fem,
                          height: 151 * fem,
                          child: Image.asset(
                            'assets/page-1/images/rectangle-226.png',
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // ellipse63Zv4 (409:338)
                      left: 121 * fem,
                      top: 80 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 123 * fem,
                          height: 110 * fem,
                          child: Image.asset(
                            'assets/page-1/images/ellipse-63.png',
                            width: 123 * fem,
                            height: 110 * fem,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              // sarahedwardHLG (409:340)
              left: 118 * fem,
              top: 274 * fem,
              child: Align(
                child: SizedBox(
                  width: 129 * fem,
                  height: 26 * fem,
                  child: Text(
                    'Sarah Edward',
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont(
                      'Outfit',
                      fontSize: 20 * ffem,
                      fontWeight: FontWeight.w600,
                      height: 1.26 * ffem / fem,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // autogroupehxtP8Q (TqK5frpqqVX8gYsQEEehXt)
              left: 59 * fem,
              top: 316 * fem,
              child: SizedBox(
                width: 334 * fem,
                height: 36 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // autogroupuaaa74Q (TqK5u6wmxTLg2CAn1kUAAa)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 24.5 * fem, 0 * fem),
                      width: 107 * fem,
                      height: 33 * fem,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff000000)),
                        borderRadius: BorderRadius.circular(5 * fem),
                        gradient: const LinearGradient(
                          begin: Alignment(0, -1),
                          end: Alignment(0, 1),
                          colors: <Color>[Color(0xffd6f5ff), Color(0xffffe9e9)],
                          stops: <double>[0, 1],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Follow',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 16 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      // autogroupxwkeKwA (TqK5yMKhRriVHFNv6VxWkE)
                      width: 202.5 * fem,
                      height: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            // rectangle228UJG (409:342)
                            left: 11.5 * fem,
                            top: 0 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 107 * fem,
                                height: 33 * fem,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(5 * fem),
                                    border: Border.all(
                                        color: const Color(0xff000000)),
                                    gradient: const LinearGradient(
                                      begin: Alignment(0, -1),
                                      end: Alignment(0, 1),
                                      colors: <Color>[
                                        Color(0xffd6f5ff),
                                        Color(0xffffe9e9)
                                      ],
                                      stops: <double>[0, 1],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // ellipsisv49z (409:343)
                            left: 104.5 * fem,
                            top: 5 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 98 * fem,
                                height: 31 * fem,
                                child: Text(
                                  'ellipsis-v',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Font Awesome 6 Free',
                                    fontSize: 24 * ffem,
                                    fontWeight: FontWeight.w900,
                                    height: 1.2575 * ffem / fem,
                                    color: const Color(0xffcaaaff),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // messagewDn (409:348)
                            left: 47.5 * fem,
                            top: 6 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 63 * fem,
                                height: 21 * fem,
                                child: Text(
                                  'Message',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Outfit',
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.26 * ffem / fem,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // messageFEU (415:376)
                            left: 0 * fem,
                            top: 11 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 63 * fem,
                                height: 21 * fem,
                                child: Text(
                                  'message',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Font Awesome 6 Free',
                                    fontSize: 16 * ffem,
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
            Positioned(
              // line849ak (409:344)
              left: 0 * fem,
              top: 368 * fem,
              child: Align(
                child: SizedBox(
                  width: 393 * fem,
                  height: 1 * fem,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xff000000),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // detailsfJC (409:345)
              left: 25 * fem,
              top: 377 * fem,
              child: Align(
                child: SizedBox(
                  width: 63 * fem,
                  height: 26 * fem,
                  child: Text(
                    'Details',
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont(
                      'Outfit',
                      fontSize: 20 * ffem,
                      fontWeight: FontWeight.w500,
                      height: 1.26 * ffem / fem,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // autogroupfutam6L (TqK8F7sUMozRvNp4ZHfutA)
              left: 0 * fem,
              top: 403 * fem,
              child: Container(
                padding:
                    EdgeInsets.fromLTRB(0 * fem, 9 * fem, 0 * fem, 3.02 * fem),
                width: 393 * fem,
                height: 154 * fem,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // autogroupkd8rFGQ (TqK696YTdYhMhYyb7AKD8r)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 12 * fem),
                      width: 271.5 * fem,
                      height: 23 * fem,
                      child: Stack(
                        children: [
                          Positioned(
                            // studiedatwontonuniversitymEk (409:349)
                            left: 47 * fem,
                            top: 0 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 203 * fem,
                                height: 21 * fem,
                                child: Text(
                                  'Studied at wonton University',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Outfit',
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.26 * ffem / fem,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // graduationcapF9v (415:377)
                            left: 0 * fem,
                            top: 2 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 111 * fem,
                                height: 21 * fem,
                                child: Text(
                                  'graduation-cap',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Font Awesome 6 Free',
                                    fontSize: 16 * ffem,
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
                    Container(
                      // autogroupekbtvmr (TqK6J6HUH795n94poveKBt)
                      margin: EdgeInsets.fromLTRB(
                          14 * fem, 0 * fem, 0 * fem, 12 * fem),
                      width: 150 * fem,
                      height: 22 * fem,
                      child: Stack(
                        children: [
                          Positioned(
                            // fromukukrainTFz (415:350)
                            left: 38 * fem,
                            top: 0 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 112 * fem,
                                height: 21 * fem,
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: SafeGoogleFont(
                                      'Outfit',
                                      fontSize: 16 * ffem,
                                      fontWeight: FontWeight.w400,
                                      height: 1.26 * ffem / fem,
                                      color: const Color(0xff000000),
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: 'From ',
                                      ),
                                      TextSpan(
                                        text: 'Uk,Ukrain',
                                        style: SafeGoogleFont(
                                          'Outfit',
                                          fontSize: 16 * ffem,
                                          fontWeight: FontWeight.w500,
                                          height: 1.26 * ffem / fem,
                                          color: const Color(0xff000000),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // homeMEt (415:373)
                            left: 0 * fem,
                            top: 3 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 39 * fem,
                                height: 19 * fem,
                                child: Text(
                                  'home',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Font Awesome 6 Free',
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
                    Container(
                      // autogroup4dcaejn (TqK6SWD7wTH2hqYH3t4dCa)
                      margin: EdgeInsets.fromLTRB(
                          6 * fem, 0 * fem, 0 * fem, 13 * fem),
                      width: 220 * fem,
                      height: 24 * fem,
                      child: Stack(
                        children: [
                          Positioned(
                            // livesincanadakantekynb6 (415:351)
                            left: 45 * fem,
                            top: 0 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 175 * fem,
                                height: 21 * fem,
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: SafeGoogleFont(
                                      'Outfit',
                                      fontSize: 16 * ffem,
                                      fontWeight: FontWeight.w400,
                                      height: 1.26 * ffem / fem,
                                      color: const Color(0xff000000),
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: 'Lives in ',
                                      ),
                                      TextSpan(
                                        text: 'Canada,Kanteky',
                                        style: SafeGoogleFont(
                                          'Outfit',
                                          fontSize: 16 * ffem,
                                          fontWeight: FontWeight.w500,
                                          height: 1.26 * ffem / fem,
                                          color: const Color(0xff000000),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // locationkgL (415:374)
                            left: 0 * fem,
                            top: 5 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 55 * fem,
                                height: 19 * fem,
                                child: Text(
                                  'location',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Font Awesome 6 Free',
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
                    SizedBox(
                      // autogrouptlsgTKr (TqK6aAf23fsqHpWHywTLsg)
                      width: 216.98 * fem,
                      height: 35.98 * fem,
                      child: Stack(
                        children: [
                          Positioned(
                            // seesarahsaboutinfonsv (415:352)
                            left: 51 * fem,
                            top: 0 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 159 * fem,
                                height: 21 * fem,
                                child: Text(
                                  'See Sarah’s About Info',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Outfit',
                                    fontSize: 16 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.26 * ffem / fem,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // ellipsisv56L (415:375)
                            left: 0 * fem,
                            top: 9.9802246094 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 82 * fem,
                                height: 26 * fem,
                                child: Text(
                                  'ellipsis-v',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Font Awesome 6 Free',
                                    fontSize: 20 * ffem,
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
            Positioned(
              // line85a36 (415:353)
              left: 0 * fem,
              top: 557 * fem,
              child: Align(
                child: SizedBox(
                  width: 393 * fem,
                  height: 1 * fem,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xff000000),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // line86Vfr (415:354)
              left: 0 * fem,
              top: 589 * fem,
              child: Align(
                child: SizedBox(
                  width: 393 * fem,
                  height: 1 * fem,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xff000000),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // line871u6 (415:355)
              left: 0 * fem,
              top: 623 * fem,
              child: Align(
                child: SizedBox(
                  width: 393 * fem,
                  height: 1 * fem,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xff000000),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // friendsLwN (415:358)
              left: 37 * fem,
              top: 563 * fem,
              child: Align(
                child: SizedBox(
                  width: 53 * fem,
                  height: 21 * fem,
                  child: Text(
                    'Friends',
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont(
                      'Outfit',
                      fontSize: 16 * ffem,
                      fontWeight: FontWeight.w500,
                      height: 1.26 * ffem / fem,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // autogroup7furFYY (TqK6iuuSqrUWbAm3v57FUr)
              left: 0 * fem,
              top: 595 * fem,
              child: SizedBox(
                width: 87 * fem,
                height: 26 * fem,
                child: Stack(
                  children: [
                    Positioned(
                      // photosa52 (415:359)
                      left: 37 * fem,
                      top: 0 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 49 * fem,
                          height: 21 * fem,
                          child: Text(
                            'Photos',
                            textAlign: TextAlign.center,
                            style: SafeGoogleFont(
                              'Outfit',
                              fontSize: 16 * ffem,
                              fontWeight: FontWeight.w500,
                              height: 1.26 * ffem / fem,
                              color: const Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // imageTPi (415:378)
                      left: 0 * fem,
                      top: 0 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 52 * fem,
                          height: 26 * fem,
                          child: Text(
                            'image',
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
            ),
          ],
        ),
      ),
    );
  }
}
