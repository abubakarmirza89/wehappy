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
        // laughpageqDE (343:4)
        width: double.infinity,
        height: 852 * fem,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/page-1/images/laugh-page-bg.png',
            ),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              // autogroupdg2aKeC (TqJWLEYR2XEZeFBjjddG2a)
              left: 6 * fem,
              top: 138 * fem,
              child: SizedBox(
                width: 391.5 * fem,
                height: 78 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // autogrouppswueAg (TqJWx3r53qn6mmf2hbpswU)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 2 * fem, 2.5 * fem, 1 * fem),
                      width: 128 * fem,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff000000)),
                        image: const DecorationImage(
                          image: AssetImage(
                            'assets/page-1/images/rectangle-182-bg.png',
                          ),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            // rectangle200XkG (398:6)
                            left: 91 * fem,
                            top: 56 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 35 * fem,
                                height: 16 * fem,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(5 * fem),
                                    border: Border.all(
                                        color: const Color(0xff000000)),
                                    color: const Color(0x77caaaff),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // Dd6 (394:5)
                            left: 94 * fem,
                            top: 58 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 29 * fem,
                                height: 13 * fem,
                                child: Text(
                                  '40:30',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Inter',
                                    fontSize: 10 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2125 * ffem / fem,
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
                      // autogroupdbcaukp (TqJX5iHyA4NuMkd3dfDbca)
                      width: 261 * fem,
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            // autogroupruruFZn (TqJXHNdCtJWURYxisqRURU)
                            width: double.infinity,
                            height: 29 * fem,
                            child: Stack(
                              children: [
                                Positioned(
                                  // ellipsisvbtY (388:56)
                                  left: 196 * fem,
                                  top: 2 * fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 65 * fem,
                                      height: 21 * fem,
                                      child: Text(
                                        'ellipsis-v',
                                        textAlign: TextAlign.center,
                                        style: SafeGoogleFont(
                                          'Font Awesome 6 Free',
                                          fontSize: 16 * ffem,
                                          fontWeight: FontWeight.w900,
                                          height: 1.2575 * ffem / fem,
                                          color: const Color(0xffcaaaff),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // group30gQC (486:250)
                                  left: 0 * fem,
                                  top: 0 * fem,
                                  child: SizedBox(
                                    width: 208 * fem,
                                    height: 29 * fem,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          // comedyvedios2022CdS (388:60)
                                          left: 1.5 * fem,
                                          top: 14 * fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 128 * fem,
                                              height: 15 * fem,
                                              child: Text(
                                                'Comedy Vedios  2022',
                                                textAlign: TextAlign.center,
                                                style: SafeGoogleFont(
                                                  'Inter',
                                                  fontSize: 12 * ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.2125 * ffem / fem,
                                                  color:
                                                      const Color(0xff000000),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          // newentertainmenttopfunnybestVc (388:61)
                                          left: 0 * fem,
                                          top: 0 * fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 208 * fem,
                                              height: 15 * fem,
                                              child: Text(
                                                'New Entertainment Top Funny Best ',
                                                textAlign: TextAlign.center,
                                                style: SafeGoogleFont(
                                                  'Inter',
                                                  fontSize: 12 * ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.2125 * ffem / fem,
                                                  color:
                                                      const Color(0xff000000),
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
                          Container(
                            // autogroupmbujmpx (TqJXkrqQXjXkDnuPXPmBUJ)
                            padding: EdgeInsets.fromLTRB(
                                0.5 * fem, 0 * fem, 0.5 * fem, 0 * fem),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  // autogroup3nh46sE (TqJXRNPt8Ma1PBi3W53nh4)
                                  margin: EdgeInsets.fromLTRB(
                                      3 * fem, 0 * fem, 0 * fem, 0 * fem),
                                  width: 109 * fem,
                                  height: 13 * fem,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        // kviews14hoursDwr (388:19)
                                        left: 0 * fem,
                                        top: 0 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 109 * fem,
                                            height: 13 * fem,
                                            child: Text(
                                              '2426k views  14 Hours',
                                              textAlign: TextAlign.center,
                                              style: SafeGoogleFont(
                                                'Inter',
                                                fontSize: 10 * ffem,
                                                fontWeight: FontWeight.w500,
                                                height: 1.2125 * ffem / fem,
                                                color: const Color(0xffa27dde),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        // circle6kk (388:28)
                                        left: 56.5 * fem,
                                        top: 5 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 10 * fem,
                                            height: 4 * fem,
                                            child: Text(
                                              'CIRCLE',
                                              textAlign: TextAlign.center,
                                              style: SafeGoogleFont(
                                                'Font Awesome 6 Free',
                                                fontSize: 3 * ffem,
                                                fontWeight: FontWeight.w900,
                                                height: 1.2575 * ffem / fem,
                                                color: const Color(0xffa27dde),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  // autogrouppvynBnC (TqJXXT45qrUqhKiMtnpvYN)
                                  margin: EdgeInsets.fromLTRB(
                                      2 * fem, 0 * fem, 0 * fem, 0 * fem),
                                  width: 235 * fem,
                                  height: 22 * fem,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        // funnydayvDz (388:20)
                                        left: 21 * fem,
                                        top: 0 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 51 * fem,
                                            height: 13 * fem,
                                            child: Text(
                                              'Funny Day',
                                              textAlign: TextAlign.center,
                                              style: SafeGoogleFont(
                                                'Inter',
                                                fontSize: 10 * ffem,
                                                fontWeight: FontWeight.w600,
                                                height: 1.2125 * ffem / fem,
                                                color: const Color(0xffa27dde),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        // hellodearviewsthisisafunnypage (388:21)
                                        left: 1 * fem,
                                        top: 13 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 234 * fem,
                                            height: 9 * fem,
                                            child: Text(
                                              'Hello ! Dear views this is a funny page & please check our new vedio....',
                                              textAlign: TextAlign.center,
                                              style: SafeGoogleFont(
                                                'Inter',
                                                fontSize: 7 * ffem,
                                                fontWeight: FontWeight.w400,
                                                height: 1.2125 * ffem / fem,
                                                color: const Color(0xff000000),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        // ellipse52VAc (388:24)
                                        left: 0 * fem,
                                        top: 0 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 18 * fem,
                                            height: 14 * fem,
                                            child: Image.asset(
                                              'assets/page-1/images/ellipse-52.png',
                                              width: 18 * fem,
                                              height: 14 * fem,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        // checkcirclePmn (388:25)
                                        left: 47 * fem,
                                        top: 2 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 66 * fem,
                                            height: 13 * fem,
                                            child: Text(
                                              'CHECK-CIRCLE',
                                              textAlign: TextAlign.center,
                                              style: SafeGoogleFont(
                                                'Font Awesome 6 Free',
                                                fontSize: 10 * ffem,
                                                fontWeight: FontWeight.w900,
                                                height: 1.2575 * ffem / fem,
                                                color: const Color(0xff279238),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  // autogroupjrb8tiY (TqJXeXgcxrms8R4bN3JrB8)
                                  width: 28 * fem,
                                  height: 14 * fem,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff000000)),
                                    borderRadius:
                                        BorderRadius.circular(5 * fem),
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
                                  child: Center(
                                    child: Text(
                                      'NEW',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Inter',
                                        fontSize: 8 * ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.2125 * ffem / fem,
                                        color: const Color(0xff000000),
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
                  ],
                ),
              ),
            ),
            Positioned(
              // autogroupr7rvKYx (TqJhazd5xnhSXkM9erR7rv)
              left: 63.5 * fem,
              top: 802 * fem,
              child: SizedBox(
                width: 264.5 * fem,
                height: 42 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      // autogroupqzqve5S (TqJho57J7KuRZcQxWkQzQv)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 10 * fem, 0 * fem),
                      width: 61 * fem,
                      height: 40 * fem,
                      child: Stack(
                        children: [
                          Positioned(
                            // homeNXE (359:248)
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
                            // homefFS (359:252)
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
                      // autogrouphldtZLp (TqJhtZx8qcWUiroVSfHLDt)
                      width: 193.5 * fem,
                      height: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            // smileHnc (359:249)
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
                            // stethoscopemxg (359:250)
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
                            // bellGeY (359:251)
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
                            // moodNSg (359:253)
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
                            // therepy5bz (359:254)
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
                            // reminderAtL (359:255)
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
              // group114Tv (359:292)
              left: 24 * fem,
              top: 28 * fem,
              child: SizedBox(
                width: 383.5 * fem,
                height: 20 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // pmz6g (359:293)
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
                      // autogroupjhkuW52 (TqJiwhrw8S5YDtdy43JHKU)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 1 * fem, 0 * fem, 0 * fem),
                      width: 131 * fem,
                      height: 19 * fem,
                      child: Stack(
                        children: [
                          Positioned(
                            // signal2p4 (359:294)
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
                            // wifijCg (359:295)
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
                            // batteryfulle4k (359:296)
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
            Positioned(
              // autogroupkviijM6 (TqJYVb7D798wbaqG7XKvii)
              left: 6 * fem,
              top: 240 * fem,
              child: SizedBox(
                width: 391.5 * fem,
                height: 78 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      // autogroupyquj3sa (TqJYxuf2BevrCztGuzYqUJ)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 2.5 * fem, 0 * fem),
                      width: 128 * fem,
                      height: 75 * fem,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff000000)),
                        image: const DecorationImage(
                          image: AssetImage(
                            'assets/page-1/images/rectangle-183-bg.png',
                          ),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            // rectangle205jkQ (398:17)
                            left: 91 * fem,
                            top: 56 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 35 * fem,
                                height: 16 * fem,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(5 * fem),
                                    border: Border.all(
                                        color: const Color(0xff000000)),
                                    color: const Color(0x77caaaff),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // dqn (398:18)
                            left: 94 * fem,
                            top: 58 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 29 * fem,
                                height: 13 * fem,
                                child: Text(
                                  '40:30',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Inter',
                                    fontSize: 10 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2125 * ffem / fem,
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
                      // autogrouppkrajdv (TqJZ6QSXixJHc9xdzxpkrA)
                      width: 261 * fem,
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            // autogrouppdqaUrQ (TqJZJUvjsVWGe22SrrpdQA)
                            width: double.infinity,
                            height: 41 * fem,
                            child: Stack(
                              children: [
                                Positioned(
                                  // kviews14hoursRme (388:93)
                                  left: 0.5 * fem,
                                  top: 28 * fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 109 * fem,
                                      height: 13 * fem,
                                      child: Text(
                                        '2426k views  14 Hours',
                                        textAlign: TextAlign.center,
                                        style: SafeGoogleFont(
                                          'Inter',
                                          fontSize: 10 * ffem,
                                          fontWeight: FontWeight.w500,
                                          height: 1.2125 * ffem / fem,
                                          color: const Color(0xffa27dde),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // circleJqS (388:100)
                                  left: 60 * fem,
                                  top: 34 * fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 10 * fem,
                                      height: 4 * fem,
                                      child: Text(
                                        'CIRCLE',
                                        textAlign: TextAlign.center,
                                        style: SafeGoogleFont(
                                          'Font Awesome 6 Free',
                                          fontSize: 3 * ffem,
                                          fontWeight: FontWeight.w900,
                                          height: 1.2575 * ffem / fem,
                                          color: const Color(0xffa27dde),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // ellipsisv1jr (388:101)
                                  left: 196 * fem,
                                  top: 2 * fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 65 * fem,
                                      height: 21 * fem,
                                      child: Text(
                                        'ellipsis-v',
                                        textAlign: TextAlign.center,
                                        style: SafeGoogleFont(
                                          'Font Awesome 6 Free',
                                          fontSize: 16 * ffem,
                                          fontWeight: FontWeight.w900,
                                          height: 1.2575 * ffem / fem,
                                          color: const Color(0xffcaaaff),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // group297H6 (486:249)
                                  left: 0 * fem,
                                  top: 0 * fem,
                                  child: SizedBox(
                                    width: 208 * fem,
                                    height: 29 * fem,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          // comedyvedios2022eH2 (388:103)
                                          left: 1.5 * fem,
                                          top: 14 * fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 128 * fem,
                                              height: 15 * fem,
                                              child: Text(
                                                'Comedy Vedios  2022',
                                                textAlign: TextAlign.center,
                                                style: SafeGoogleFont(
                                                  'Inter',
                                                  fontSize: 12 * ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.2125 * ffem / fem,
                                                  color:
                                                      const Color(0xff000000),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          // newentertainmenttopfunnybestjJ (388:104)
                                          left: 0 * fem,
                                          top: 0 * fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 208 * fem,
                                              height: 15 * fem,
                                              child: Text(
                                                'New Entertainment Top Funny Best ',
                                                textAlign: TextAlign.center,
                                                style: SafeGoogleFont(
                                                  'Inter',
                                                  fontSize: 12 * ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.2125 * ffem / fem,
                                                  color:
                                                      const Color(0xff000000),
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
                          Container(
                            // autogroupwrqpRSC (TqJZdDtWijvs8uiMaHWRqp)
                            padding: EdgeInsets.fromLTRB(
                                0.5 * fem, 1 * fem, 0.5 * fem, 0 * fem),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  // autogroupmji6xS8 (TqJZT4Wn6ksakYPYwuMji6)
                                  margin: EdgeInsets.fromLTRB(
                                      2 * fem, 0 * fem, 0 * fem, 0 * fem),
                                  width: 235 * fem,
                                  height: 22 * fem,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        // funnyday4VA (388:94)
                                        left: 21 * fem,
                                        top: 0 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 51 * fem,
                                            height: 13 * fem,
                                            child: Text(
                                              'Funny Day',
                                              textAlign: TextAlign.center,
                                              style: SafeGoogleFont(
                                                'Inter',
                                                fontSize: 10 * ffem,
                                                fontWeight: FontWeight.w600,
                                                height: 1.2125 * ffem / fem,
                                                color: const Color(0xffa27dde),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        // hellodearviewsthisisafunnypage (388:95)
                                        left: 1 * fem,
                                        top: 13 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 234 * fem,
                                            height: 9 * fem,
                                            child: Text(
                                              'Hello ! Dear views this is a funny page & please check our new vedio....',
                                              textAlign: TextAlign.center,
                                              style: SafeGoogleFont(
                                                'Inter',
                                                fontSize: 7 * ffem,
                                                fontWeight: FontWeight.w400,
                                                height: 1.2125 * ffem / fem,
                                                color: const Color(0xff000000),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        // ellipse53c9J (388:98)
                                        left: 0 * fem,
                                        top: 0 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 18 * fem,
                                            height: 14 * fem,
                                            child: Image.asset(
                                              'assets/page-1/images/ellipse-53.png',
                                              width: 18 * fem,
                                              height: 14 * fem,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        // checkcirclev9z (388:99)
                                        left: 47 * fem,
                                        top: 2 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 66 * fem,
                                            height: 13 * fem,
                                            child: Text(
                                              'CHECK-CIRCLE',
                                              textAlign: TextAlign.center,
                                              style: SafeGoogleFont(
                                                'Font Awesome 6 Free',
                                                fontSize: 10 * ffem,
                                                fontWeight: FontWeight.w900,
                                                height: 1.2575 * ffem / fem,
                                                color: const Color(0xff279238),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  // autogroupfgnspWG (TqJZYUXRYarxKNqFxGfgNS)
                                  width: 28 * fem,
                                  height: 14 * fem,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff000000)),
                                    borderRadius:
                                        BorderRadius.circular(5 * fem),
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
                                  child: Center(
                                    child: Text(
                                      'NEW',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Inter',
                                        fontSize: 8 * ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.2125 * ffem / fem,
                                        color: const Color(0xff000000),
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
                  ],
                ),
              ),
            ),
            Positioned(
              // autogrouptle2SGk (TqJaRx3evB4pzX1tUXtLE2)
              left: 6 * fem,
              top: 342 * fem,
              child: SizedBox(
                width: 391.5 * fem,
                height: 78 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      // autogroupcstaMuW (TqJaqrXVMsdkH1K2RhCstA)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 2.5 * fem, 0 * fem),
                      width: 128 * fem,
                      height: 75 * fem,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff000000)),
                        image: const DecorationImage(
                          image: AssetImage(
                            'assets/page-1/images/rectangle-185-bg.png',
                          ),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            // rectangle204TBr (398:15)
                            left: 92 * fem,
                            top: 55 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 35 * fem,
                                height: 16 * fem,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(5 * fem),
                                    border: Border.all(
                                        color: const Color(0xff000000)),
                                    color: const Color(0x77caaaff),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // MHE (398:16)
                            left: 95 * fem,
                            top: 57 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 29 * fem,
                                height: 13 * fem,
                                child: Text(
                                  '40:30',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Inter',
                                    fontSize: 10 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2125 * ffem / fem,
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
                      // autogroup3cqerzg (TqJayS9CBdcsGaLDSD3CQe)
                      width: 261 * fem,
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            // autogroupt5uszb6 (TqJbAgKTVag2NJwm4fT5US)
                            width: double.infinity,
                            height: 41 * fem,
                            child: Stack(
                              children: [
                                Positioned(
                                  // kviews14hourswWL (388:105)
                                  left: 0.5 * fem,
                                  top: 28 * fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 109 * fem,
                                      height: 13 * fem,
                                      child: Text(
                                        '2426k views  14 Hours',
                                        textAlign: TextAlign.center,
                                        style: SafeGoogleFont(
                                          'Inter',
                                          fontSize: 10 * ffem,
                                          fontWeight: FontWeight.w500,
                                          height: 1.2125 * ffem / fem,
                                          color: const Color(0xffa27dde),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // circleSCC (388:112)
                                  left: 60 * fem,
                                  top: 34 * fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 10 * fem,
                                      height: 4 * fem,
                                      child: Text(
                                        'CIRCLE',
                                        textAlign: TextAlign.center,
                                        style: SafeGoogleFont(
                                          'Font Awesome 6 Free',
                                          fontSize: 3 * ffem,
                                          fontWeight: FontWeight.w900,
                                          height: 1.2575 * ffem / fem,
                                          color: const Color(0xffa27dde),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // ellipsisvYFE (388:113)
                                  left: 196 * fem,
                                  top: 2 * fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 65 * fem,
                                      height: 21 * fem,
                                      child: Text(
                                        'ellipsis-v',
                                        textAlign: TextAlign.center,
                                        style: SafeGoogleFont(
                                          'Font Awesome 6 Free',
                                          fontSize: 16 * ffem,
                                          fontWeight: FontWeight.w900,
                                          height: 1.2575 * ffem / fem,
                                          color: const Color(0xffcaaaff),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // group28eJG (486:248)
                                  left: 0 * fem,
                                  top: 0 * fem,
                                  child: SizedBox(
                                    width: 208 * fem,
                                    height: 29 * fem,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          // comedyvedios2022NVA (388:115)
                                          left: 1.5 * fem,
                                          top: 14 * fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 128 * fem,
                                              height: 15 * fem,
                                              child: Text(
                                                'Comedy Vedios  2022',
                                                textAlign: TextAlign.center,
                                                style: SafeGoogleFont(
                                                  'Inter',
                                                  fontSize: 12 * ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.2125 * ffem / fem,
                                                  color:
                                                      const Color(0xff000000),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          // newentertainmenttopfunnybestfU (388:116)
                                          left: 0 * fem,
                                          top: 0 * fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 208 * fem,
                                              height: 15 * fem,
                                              child: Text(
                                                'New Entertainment Top Funny Best ',
                                                textAlign: TextAlign.center,
                                                style: SafeGoogleFont(
                                                  'Inter',
                                                  fontSize: 12 * ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.2125 * ffem / fem,
                                                  color:
                                                      const Color(0xff000000),
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
                          Container(
                            // autogroupxtznxTN (TqJbWauxKFiBAysEhhxTzn)
                            padding: EdgeInsets.fromLTRB(
                                0.5 * fem, 1 * fem, 0.5 * fem, 0 * fem),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  // autogroupnbxuguA (TqJbKg4U997kSu2zmRnBXU)
                                  margin: EdgeInsets.fromLTRB(
                                      2 * fem, 0 * fem, 0 * fem, 0 * fem),
                                  width: 235 * fem,
                                  height: 22 * fem,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        // funnydaybmE (388:106)
                                        left: 21 * fem,
                                        top: 0 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 51 * fem,
                                            height: 13 * fem,
                                            child: Text(
                                              'Funny Day',
                                              textAlign: TextAlign.center,
                                              style: SafeGoogleFont(
                                                'Inter',
                                                fontSize: 10 * ffem,
                                                fontWeight: FontWeight.w600,
                                                height: 1.2125 * ffem / fem,
                                                color: const Color(0xffa27dde),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        // hellodearviewsthisisafunnypage (388:107)
                                        left: 1 * fem,
                                        top: 13 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 234 * fem,
                                            height: 9 * fem,
                                            child: Text(
                                              'Hello ! Dear views this is a funny page & please check our new vedio....',
                                              textAlign: TextAlign.center,
                                              style: SafeGoogleFont(
                                                'Inter',
                                                fontSize: 7 * ffem,
                                                fontWeight: FontWeight.w400,
                                                height: 1.2125 * ffem / fem,
                                                color: const Color(0xff000000),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        // ellipse54xVJ (388:110)
                                        left: 0 * fem,
                                        top: 0 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 18 * fem,
                                            height: 14 * fem,
                                            child: Image.asset(
                                              'assets/page-1/images/ellipse-54-udn.png',
                                              width: 18 * fem,
                                              height: 14 * fem,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        // checkcirclet84 (388:111)
                                        left: 47 * fem,
                                        top: 2 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 66 * fem,
                                            height: 13 * fem,
                                            child: Text(
                                              'CHECK-CIRCLE',
                                              textAlign: TextAlign.center,
                                              style: SafeGoogleFont(
                                                'Font Awesome 6 Free',
                                                fontSize: 10 * ffem,
                                                fontWeight: FontWeight.w900,
                                                height: 1.2575 * ffem / fem,
                                                color: const Color(0xff279238),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  // autogroupkinjnjE (TqJbRRPtioZrPPG1TyKinJ)
                                  width: 28 * fem,
                                  height: 14 * fem,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff000000)),
                                    borderRadius:
                                        BorderRadius.circular(5 * fem),
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
                                  child: Center(
                                    child: Text(
                                      'NEW',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Inter',
                                        fontSize: 8 * ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.2125 * ffem / fem,
                                        color: const Color(0xff000000),
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
                  ],
                ),
              ),
            ),
            Positioned(
              // autogroup84dcRnC (TqJcAUzUS3dn8pyBkH84dC)
              left: 6 * fem,
              top: 447 * fem,
              child: SizedBox(
                width: 391.5 * fem,
                height: 78 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      // autogroupbrs4Yrp (TqJcYUMqMC3zmpXKTvbRs4)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 2.5 * fem, 0 * fem),
                      width: 128 * fem,
                      height: 75 * fem,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff000000)),
                        image: const DecorationImage(
                          image: AssetImage(
                            'assets/page-1/images/rectangle-190-bg.png',
                          ),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            // rectangle200eex (398:7)
                            left: 91 * fem,
                            top: 57 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 35 * fem,
                                height: 16 * fem,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(5 * fem),
                                    border: Border.all(
                                        color: const Color(0xff000000)),
                                    color: const Color(0x77caaaff),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // MZN (398:8)
                            left: 94 * fem,
                            top: 59 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 29 * fem,
                                height: 13 * fem,
                                child: Text(
                                  '40:30',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Inter',
                                    fontSize: 10 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2125 * ffem / fem,
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
                      // autogroupdk8eEdA (TqJcgU8WbF7XjTGe6ADk8e)
                      width: 261 * fem,
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            // autogroupn1kuah2 (TqJcuTkrrq62HrjY73N1KU)
                            width: double.infinity,
                            height: 41 * fem,
                            child: Stack(
                              children: [
                                Positioned(
                                  // kviews14hoursWqa (388:226)
                                  left: 0.5 * fem,
                                  top: 28 * fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 109 * fem,
                                      height: 13 * fem,
                                      child: Text(
                                        '2426k views  14 Hours',
                                        textAlign: TextAlign.center,
                                        style: SafeGoogleFont(
                                          'Inter',
                                          fontSize: 10 * ffem,
                                          fontWeight: FontWeight.w500,
                                          height: 1.2125 * ffem / fem,
                                          color: const Color(0xffa27dde),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // circleDEC (388:233)
                                  left: 60 * fem,
                                  top: 34 * fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 10 * fem,
                                      height: 4 * fem,
                                      child: Text(
                                        'CIRCLE',
                                        textAlign: TextAlign.center,
                                        style: SafeGoogleFont(
                                          'Font Awesome 6 Free',
                                          fontSize: 3 * ffem,
                                          fontWeight: FontWeight.w900,
                                          height: 1.2575 * ffem / fem,
                                          color: const Color(0xffa27dde),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // ellipsisv7Ka (388:234)
                                  left: 196 * fem,
                                  top: 2 * fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 65 * fem,
                                      height: 21 * fem,
                                      child: Text(
                                        'ellipsis-v',
                                        textAlign: TextAlign.center,
                                        style: SafeGoogleFont(
                                          'Font Awesome 6 Free',
                                          fontSize: 16 * ffem,
                                          fontWeight: FontWeight.w900,
                                          height: 1.2575 * ffem / fem,
                                          color: const Color(0xffcaaaff),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // group271vk (486:247)
                                  left: 0 * fem,
                                  top: 0 * fem,
                                  child: SizedBox(
                                    width: 208 * fem,
                                    height: 29 * fem,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          // comedyvedios2022MDv (388:236)
                                          left: 1.5 * fem,
                                          top: 14 * fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 128 * fem,
                                              height: 15 * fem,
                                              child: Text(
                                                'Comedy Vedios  2022',
                                                textAlign: TextAlign.center,
                                                style: SafeGoogleFont(
                                                  'Inter',
                                                  fontSize: 12 * ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.2125 * ffem / fem,
                                                  color:
                                                      const Color(0xff000000),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          // newentertainmenttopfunnybesteT (388:237)
                                          left: 0 * fem,
                                          top: 0 * fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 208 * fem,
                                              height: 15 * fem,
                                              child: Text(
                                                'New Entertainment Top Funny Best ',
                                                textAlign: TextAlign.center,
                                                style: SafeGoogleFont(
                                                  'Inter',
                                                  fontSize: 12 * ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.2125 * ffem / fem,
                                                  color:
                                                      const Color(0xff000000),
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
                          Container(
                            // autogroups6vluue (TqJdQhR9Tu2dYmXZ92S6VL)
                            padding: EdgeInsets.fromLTRB(
                                0.5 * fem, 1 * fem, 0.5 * fem, 0 * fem),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  // autogroup2ensFTi (TqJdAczGWM4GGzmv852eNS)
                                  margin: EdgeInsets.fromLTRB(
                                      2 * fem, 0 * fem, 0 * fem, 0 * fem),
                                  width: 235 * fem,
                                  height: 22 * fem,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        // funnydayNHS (388:227)
                                        left: 21 * fem,
                                        top: 0 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 51 * fem,
                                            height: 13 * fem,
                                            child: Text(
                                              'Funny Day',
                                              textAlign: TextAlign.center,
                                              style: SafeGoogleFont(
                                                'Inter',
                                                fontSize: 10 * ffem,
                                                fontWeight: FontWeight.w600,
                                                height: 1.2125 * ffem / fem,
                                                color: const Color(0xffa27dde),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        // hellodearviewsthisisafunnypage (388:228)
                                        left: 1 * fem,
                                        top: 13 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 234 * fem,
                                            height: 9 * fem,
                                            child: Text(
                                              'Hello ! Dear views this is a funny page & please check our new vedio....',
                                              textAlign: TextAlign.center,
                                              style: SafeGoogleFont(
                                                'Inter',
                                                fontSize: 7 * ffem,
                                                fontWeight: FontWeight.w400,
                                                height: 1.2125 * ffem / fem,
                                                color: const Color(0xff000000),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        // ellipse559Bi (388:231)
                                        left: 0 * fem,
                                        top: 0 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 18 * fem,
                                            height: 14 * fem,
                                            child: Image.asset(
                                              'assets/page-1/images/ellipse-55.png',
                                              width: 18 * fem,
                                              height: 14 * fem,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        // checkcircleSgc (388:232)
                                        left: 47 * fem,
                                        top: 2 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 66 * fem,
                                            height: 13 * fem,
                                            child: Text(
                                              'CHECK-CIRCLE',
                                              textAlign: TextAlign.center,
                                              style: SafeGoogleFont(
                                                'Font Awesome 6 Free',
                                                fontSize: 10 * ffem,
                                                fontWeight: FontWeight.w900,
                                                height: 1.2575 * ffem / fem,
                                                color: const Color(0xff279238),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  // autogroupsxp89b2 (TqJdK2uvAhCDChFNN2SxP8)
                                  width: 28 * fem,
                                  height: 14 * fem,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff000000)),
                                    borderRadius:
                                        BorderRadius.circular(5 * fem),
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
                                  child: Center(
                                    child: Text(
                                      'NEW',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Inter',
                                        fontSize: 8 * ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.2125 * ffem / fem,
                                        color: const Color(0xff000000),
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
                  ],
                ),
              ),
            ),
            Positioned(
              // autogroup42qvndz (TqJeAveT9Zi7bzUJLx42Qv)
              left: 6 * fem,
              top: 549 * fem,
              child: SizedBox(
                width: 391.5 * fem,
                height: 78 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      // autogroupho4juic (TqJeYah2vsfbsLF8NRHo4J)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 2.5 * fem, 0 * fem),
                      width: 128 * fem,
                      height: 75 * fem,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff000000)),
                        image: const DecorationImage(
                          image: AssetImage(
                            'assets/page-1/images/rectangle-191-bg.png',
                          ),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            // rectangle203iAG (398:13)
                            left: 91 * fem,
                            top: 55 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 35 * fem,
                                height: 16 * fem,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(5 * fem),
                                    border: Border.all(
                                        color: const Color(0xff000000)),
                                    color: const Color(0x77caaaff),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // cmS (398:14)
                            left: 94 * fem,
                            top: 57 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 29 * fem,
                                height: 13 * fem,
                                child: Text(
                                  '40:30',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Inter',
                                    fontSize: 10 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2125 * ffem / fem,
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
                      // autogroupdkysKQx (TqJefaVNmRLwi1eXv8DKYS)
                      width: 261 * fem,
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            // autogroupqcs8Gb6 (TqJerQWff5KgqgXwvrqCs8)
                            width: double.infinity,
                            height: 41 * fem,
                            child: Stack(
                              children: [
                                Positioned(
                                  // kviews14hoursRD6 (388:238)
                                  left: 0.5 * fem,
                                  top: 28 * fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 109 * fem,
                                      height: 13 * fem,
                                      child: Text(
                                        '2426k views  14 Hours',
                                        textAlign: TextAlign.center,
                                        style: SafeGoogleFont(
                                          'Inter',
                                          fontSize: 10 * ffem,
                                          fontWeight: FontWeight.w500,
                                          height: 1.2125 * ffem / fem,
                                          color: const Color(0xffa27dde),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // circleHFJ (388:245)
                                  left: 60 * fem,
                                  top: 34 * fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 10 * fem,
                                      height: 4 * fem,
                                      child: Text(
                                        'CIRCLE',
                                        textAlign: TextAlign.center,
                                        style: SafeGoogleFont(
                                          'Font Awesome 6 Free',
                                          fontSize: 3 * ffem,
                                          fontWeight: FontWeight.w900,
                                          height: 1.2575 * ffem / fem,
                                          color: const Color(0xffa27dde),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // ellipsisvvJG (388:246)
                                  left: 196 * fem,
                                  top: 2 * fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 65 * fem,
                                      height: 21 * fem,
                                      child: Text(
                                        'ellipsis-v',
                                        textAlign: TextAlign.center,
                                        style: SafeGoogleFont(
                                          'Font Awesome 6 Free',
                                          fontSize: 16 * ffem,
                                          fontWeight: FontWeight.w900,
                                          height: 1.2575 * ffem / fem,
                                          color: const Color(0xffcaaaff),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // group25z3E (486:245)
                                  left: 0 * fem,
                                  top: 0 * fem,
                                  child: SizedBox(
                                    width: 208 * fem,
                                    height: 29 * fem,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          // comedyvedios2022uvt (388:248)
                                          left: 1.5 * fem,
                                          top: 14 * fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 128 * fem,
                                              height: 15 * fem,
                                              child: Text(
                                                'Comedy Vedios  2022',
                                                textAlign: TextAlign.center,
                                                style: SafeGoogleFont(
                                                  'Inter',
                                                  fontSize: 12 * ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.2125 * ffem / fem,
                                                  color:
                                                      const Color(0xff000000),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          // newentertainmenttopfunnybestbH (388:249)
                                          left: 0 * fem,
                                          top: 0 * fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 208 * fem,
                                              height: 15 * fem,
                                              child: Text(
                                                'New Entertainment Top Funny Best ',
                                                textAlign: TextAlign.center,
                                                style: SafeGoogleFont(
                                                  'Inter',
                                                  fontSize: 12 * ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.2125 * ffem / fem,
                                                  color:
                                                      const Color(0xff000000),
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
                          Container(
                            // autogrouptpgi5Tz (TqJfCUmZ3fbCqBM5QzTPgi)
                            padding: EdgeInsets.fromLTRB(
                                0.5 * fem, 1 * fem, 0.5 * fem, 0 * fem),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  // autogroup56xwCoW (TqJf1z53Hr5C5AEy6S56xW)
                                  margin: EdgeInsets.fromLTRB(
                                      2 * fem, 0 * fem, 0 * fem, 0 * fem),
                                  width: 235 * fem,
                                  height: 22 * fem,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        // funnydayKdE (388:239)
                                        left: 21 * fem,
                                        top: 0 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 51 * fem,
                                            height: 13 * fem,
                                            child: Text(
                                              'Funny Day',
                                              textAlign: TextAlign.center,
                                              style: SafeGoogleFont(
                                                'Inter',
                                                fontSize: 10 * ffem,
                                                fontWeight: FontWeight.w600,
                                                height: 1.2125 * ffem / fem,
                                                color: const Color(0xffa27dde),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        // hellodearviewsthisisafunnypage (388:240)
                                        left: 1 * fem,
                                        top: 13 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 234 * fem,
                                            height: 9 * fem,
                                            child: Text(
                                              'Hello ! Dear views this is a funny page & please check our new vedio....',
                                              textAlign: TextAlign.center,
                                              style: SafeGoogleFont(
                                                'Inter',
                                                fontSize: 7 * ffem,
                                                fontWeight: FontWeight.w400,
                                                height: 1.2125 * ffem / fem,
                                                color: const Color(0xff000000),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        // ellipse56HiU (388:243)
                                        left: 0 * fem,
                                        top: 0 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 18 * fem,
                                            height: 14 * fem,
                                            child: Image.asset(
                                              'assets/page-1/images/ellipse-56.png',
                                              width: 18 * fem,
                                              height: 14 * fem,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        // checkcircleQYC (388:244)
                                        left: 47 * fem,
                                        top: 2 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 66 * fem,
                                            height: 13 * fem,
                                            child: Text(
                                              'CHECK-CIRCLE',
                                              textAlign: TextAlign.center,
                                              style: SafeGoogleFont(
                                                'Font Awesome 6 Free',
                                                fontSize: 10 * ffem,
                                                fontWeight: FontWeight.w900,
                                                height: 1.2575 * ffem / fem,
                                                color: const Color(0xff279238),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  // autogroupjswai36 (TqJf7u4rSRkfCUMde4jSWa)
                                  width: 28 * fem,
                                  height: 14 * fem,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff000000)),
                                    borderRadius:
                                        BorderRadius.circular(5 * fem),
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
                                  child: Center(
                                    child: Text(
                                      'NEW',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Inter',
                                        fontSize: 8 * ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.2125 * ffem / fem,
                                        color: const Color(0xff000000),
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
                  ],
                ),
              ),
            ),
            Positioned(
              // autogroupicgnwRe (TqJfqo2iBFD2e8qEzkiCGn)
              left: 6 * fem,
              top: 651 * fem,
              child: SizedBox(
                width: 391.5 * fem,
                height: 78 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      // autogroupwo1gFx8 (TqJgAhesbQrzKrQoZGWo1g)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 2.5 * fem, 0 * fem),
                      width: 128 * fem,
                      height: 75 * fem,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff000000)),
                        image: const DecorationImage(
                          image: AssetImage(
                            'assets/page-1/images/rectangle-192-bg.png',
                          ),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            // rectangle202YRS (398:11)
                            left: 89 * fem,
                            top: 55 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 35 * fem,
                                height: 16 * fem,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(5 * fem),
                                    border: Border.all(
                                        color: const Color(0xff000000)),
                                    color: const Color(0x77caaaff),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // rS8 (398:12)
                            left: 92 * fem,
                            top: 57 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 29 * fem,
                                height: 13 * fem,
                                child: Text(
                                  '40:30',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Inter',
                                    fontSize: 10 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2125 * ffem / fem,
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
                      // autogroupfv6jxEG (TqJgJ2mzZo14YBbWo9fv6J)
                      width: 261 * fem,
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            // autogroupqbiejeL (TqJgV2Tg2NDArgNaeyQbiE)
                            width: double.infinity,
                            height: 41 * fem,
                            child: Stack(
                              children: [
                                Positioned(
                                  // kviews14hoursrU4 (388:250)
                                  left: 0.5 * fem,
                                  top: 28 * fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 109 * fem,
                                      height: 13 * fem,
                                      child: Text(
                                        '2426k views  14 Hours',
                                        textAlign: TextAlign.center,
                                        style: SafeGoogleFont(
                                          'Inter',
                                          fontSize: 10 * ffem,
                                          fontWeight: FontWeight.w500,
                                          height: 1.2125 * ffem / fem,
                                          color: const Color(0xffa27dde),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // circleux8 (388:257)
                                  left: 60 * fem,
                                  top: 34 * fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 10 * fem,
                                      height: 4 * fem,
                                      child: Text(
                                        'CIRCLE',
                                        textAlign: TextAlign.center,
                                        style: SafeGoogleFont(
                                          'Font Awesome 6 Free',
                                          fontSize: 3 * ffem,
                                          fontWeight: FontWeight.w900,
                                          height: 1.2575 * ffem / fem,
                                          color: const Color(0xffa27dde),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // ellipsisvR9n (388:258)
                                  left: 196 * fem,
                                  top: 2 * fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 65 * fem,
                                      height: 21 * fem,
                                      child: Text(
                                        'ellipsis-v',
                                        textAlign: TextAlign.center,
                                        style: SafeGoogleFont(
                                          'Font Awesome 6 Free',
                                          fontSize: 16 * ffem,
                                          fontWeight: FontWeight.w900,
                                          height: 1.2575 * ffem / fem,
                                          color: const Color(0xffcaaaff),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // group26uqe (486:246)
                                  left: 0 * fem,
                                  top: 0 * fem,
                                  child: SizedBox(
                                    width: 208 * fem,
                                    height: 29 * fem,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          // comedyvedios2022Sqa (388:260)
                                          left: 1.5 * fem,
                                          top: 14 * fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 128 * fem,
                                              height: 15 * fem,
                                              child: Text(
                                                'Comedy Vedios  2022',
                                                textAlign: TextAlign.center,
                                                style: SafeGoogleFont(
                                                  'Inter',
                                                  fontSize: 12 * ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.2125 * ffem / fem,
                                                  color:
                                                      const Color(0xff000000),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          // newentertainmenttopfunnybestKe (388:261)
                                          left: 0 * fem,
                                          top: 0 * fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 208 * fem,
                                              height: 15 * fem,
                                              child: Text(
                                                'New Entertainment Top Funny Best ',
                                                textAlign: TextAlign.center,
                                                style: SafeGoogleFont(
                                                  'Inter',
                                                  fontSize: 12 * ffem,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.2125 * ffem / fem,
                                                  color:
                                                      const Color(0xff000000),
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
                          Container(
                            // autogroupso3cCyA (TqJgpGQcaNKrv3jSufSo3c)
                            padding: EdgeInsets.fromLTRB(
                                0.5 * fem, 1 * fem, 0.5 * fem, 0 * fem),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  // autogroupctxeYXE (TqJgegrEwbaMga2Rk6CtxE)
                                  margin: EdgeInsets.fromLTRB(
                                      2 * fem, 0 * fem, 0 * fem, 0 * fem),
                                  width: 235 * fem,
                                  height: 22 * fem,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        // funnydayTu6 (388:251)
                                        left: 21 * fem,
                                        top: 0 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 51 * fem,
                                            height: 13 * fem,
                                            child: Text(
                                              'Funny Day',
                                              textAlign: TextAlign.center,
                                              style: SafeGoogleFont(
                                                'Inter',
                                                fontSize: 10 * ffem,
                                                fontWeight: FontWeight.w600,
                                                height: 1.2125 * ffem / fem,
                                                color: const Color(0xffa27dde),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        // hellodearviewsthisisafunnypage (388:252)
                                        left: 1 * fem,
                                        top: 13 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 234 * fem,
                                            height: 9 * fem,
                                            child: Text(
                                              'Hello ! Dear views this is a funny page & please check our new vedio....',
                                              textAlign: TextAlign.center,
                                              style: SafeGoogleFont(
                                                'Inter',
                                                fontSize: 7 * ffem,
                                                fontWeight: FontWeight.w400,
                                                height: 1.2125 * ffem / fem,
                                                color: const Color(0xff000000),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        // ellipse57qPr (388:255)
                                        left: 0 * fem,
                                        top: 0 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 18 * fem,
                                            height: 14 * fem,
                                            child: Image.asset(
                                              'assets/page-1/images/ellipse-57.png',
                                              width: 18 * fem,
                                              height: 14 * fem,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        // checkcircle9vL (388:256)
                                        left: 47 * fem,
                                        top: 2 * fem,
                                        child: Align(
                                          child: SizedBox(
                                            width: 66 * fem,
                                            height: 13 * fem,
                                            child: Text(
                                              'CHECK-CIRCLE',
                                              textAlign: TextAlign.center,
                                              style: SafeGoogleFont(
                                                'Font Awesome 6 Free',
                                                fontSize: 10 * ffem,
                                                fontWeight: FontWeight.w900,
                                                height: 1.2575 * ffem / fem,
                                                color: const Color(0xff279238),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  // autogroupxstx3F2 (TqJgk22h6xx3ezXJpuxSTx)
                                  width: 28 * fem,
                                  height: 14 * fem,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff000000)),
                                    borderRadius:
                                        BorderRadius.circular(5 * fem),
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
                                  child: Center(
                                    child: Text(
                                      'NEW',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Inter',
                                        fontSize: 8 * ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.2125 * ffem / fem,
                                        color: const Color(0xff000000),
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
                  ],
                ),
              ),
            ),
            Positioned(
              // autogroupeqxwFrt (TqJhS5iGbgsQ3aCjsdeQxW)
              left: 136 * fem,
              top: 744 * fem,
              child: Container(
                width: 115 * fem,
                height: 41 * fem,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff000000)),
                  color: const Color(0xb5caaaff),
                  borderRadius: BorderRadius.circular(20 * fem),
                ),
                child: Center(
                  child: Text(
                    'Show More',
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont(
                      'Outfit',
                      fontSize: 15 * ffem,
                      fontWeight: FontWeight.w500,
                      height: 1.26 * ffem / fem,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // autogroupzrcj6cc (TqJV6GcKr3gm1YTr7WzRcJ)
              left: 16 * fem,
              top: 68 * fem,
              child: SizedBox(
                width: 253.5 * fem,
                height: 25 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      // barspYc (388:330)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 72.5 * fem, 0 * fem),
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
                    Container(
                      // trytonotlaugh956 (388:328)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 4 * fem),
                      child: Text(
                        'TRY TO NOT LAUGH',
                        textAlign: TextAlign.center,
                        style: SafeGoogleFont(
                          'Outfit',
                          fontSize: 16 * ffem,
                          fontWeight: FontWeight.w600,
                          height: 1.26 * ffem / fem,
                          color: const Color(0xff000000),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              // autogroupjygs3RN (TqJVWB6AHkFgJ2kz4gJyGS)
              left: 63 * fem,
              top: 103 * fem,
              child: SizedBox(
                width: 288 * fem,
                height: 29 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // autogrouph82r9zC (TqJVuaaq2h8W23PAUaH82r)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 2 * fem, 12 * fem, 1 * fem),
                      width: 41 * fem,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff000000)),
                        borderRadius: BorderRadius.circular(10 * fem),
                        gradient: const LinearGradient(
                          begin: Alignment(0, -1),
                          end: Alignment(0, 1),
                          colors: <Color>[Color(0xffd6f5ff), Color(0xffffe9e9)],
                          stops: <double>[0, 1],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'All',
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
                    Container(
                      // autogroupzumcmEt (TqJVzF7ivPajFAKSB3ZUMc)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 13 * fem, 0 * fem),
                      width: 71 * fem,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff000000)),
                        borderRadius: BorderRadius.circular(10 * fem),
                        gradient: const LinearGradient(
                          begin: Alignment(0, -1),
                          end: Alignment(0, 1),
                          colors: <Color>[Color(0xffd6f5ff), Color(0xffffe9e9)],
                          stops: <double>[0, 1],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Laugh',
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
                    Container(
                      // autogroup3pwgP1N (TqJW4VVePnxYWDXaFo3pwG)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 9 * fem, 0 * fem),
                      width: 71 * fem,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff000000)),
                        borderRadius: BorderRadius.circular(10 * fem),
                        gradient: const LinearGradient(
                          begin: Alignment(0, -1),
                          end: Alignment(0, 1),
                          colors: <Color>[Color(0xffd6f5ff), Color(0xffffe9e9)],
                          stops: <double>[0, 1],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Related',
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
                    Container(
                      // autogroupkbmp12k (TqJW8KibSuFwoD1aipkBmp)
                      width: 71 * fem,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff000000)),
                        borderRadius: BorderRadius.circular(10 * fem),
                        gradient: const LinearGradient(
                          begin: Alignment(0, -1),
                          end: Alignment(0, 1),
                          colors: <Color>[Color(0xffd6f5ff), Color(0xffffe9e9)],
                          stops: <double>[0, 1],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'More',
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
