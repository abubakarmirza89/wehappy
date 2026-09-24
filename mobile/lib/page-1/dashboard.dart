import 'package:flutter/material.dart';
import 'package:myapp/page-1/therapist-list-page.dart';
import 'package:myapp/utils.dart';

import 'home.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 393;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Container(
            // dashboardy3S (21:12)
            padding: EdgeInsets.fromLTRB(0 * fem, 18 * fem, 0 * fem, 0 * fem),
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/page-1/images/dashboard-bg.png',
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // autogroupkj4n4Kn (TqGzPbQhHSWqcA78PBkJ4n)
                  margin:
                      EdgeInsets.fromLTRB(24 * fem, 0 * fem, 0 * fem, 25 * fem),
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        // autogroupe6mlg6G (TqGzhvDViPs28z4uUte6mL)
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 0 * fem, 0 * fem, 5 * fem),
                        width: 131 * fem,
                        height: 21 * fem,
                        child: const Stack(
                          children: [],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // autogroupmczu4W8 (TqGzsL7UnFPABdtGoNmCZU)
                  margin: EdgeInsets.fromLTRB(
                      13 * fem, 0 * fem, 23 * fem, 13 * fem),
                  width: double.infinity,
                  height: 163 * fem,
                  child: Stack(
                    children: [
                      Positioned(
                        // helloalexaaDa (42:3)
                        left: 11 * fem,
                        top: 40 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 113 * fem,
                            height: 21 * fem,
                            child: Text(
                              'HELLO  ALEXA!',
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
                        // howareyoufeelingtodayrgt (47:16)
                        left: 8 * fem,
                        top: 66 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 165 * fem,
                            height: 15 * fem,
                            child: Text(
                              'HOW ARE YOU FEELING TODAY?',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Exo',
                                fontSize: 11 * ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.33 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle3wCY (47:17)
                        left: 7 * fem,
                        top: 88 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 150 * fem,
                            height: 42 * fem,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60 * fem),
                                border:
                                    Border.all(color: const Color(0xff000000)),
                                color: const Color(0xffcaaaff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // selectYourMood2Ut (49:3)
                        left: 14 * fem,
                        top: 99 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 130 * fem,
                            height: 15 * fem,
                            child: Text(
                              'Select Your Mood',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 15 * ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xffffffff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to the Mood screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home(initialIndex: 1)),
                          );
                        },
                      ),
                      Positioned(
                        // dailyreportv4U (51:9)
                        left: 12 * fem,
                        top: 142 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 89 * fem,
                            height: 21 * fem,
                            child: Text(
                              'Daily Report',
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
                        // dashboardaui (136:2)
                        left: 103.1921082386 * fem,
                        top: 0 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 153 * fem,
                            height: 30 * fem,
                            child: Text(
                              'DASHBOARD',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Inter',
                                fontSize: 24 * ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.2125 * ffem / fem,
                                color: const Color(0xffcaaaff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // frame2aHS (211:11)
                        left: 236 * fem,
                        top: 26 * fem,
                        child: SizedBox(
                          width: 121 * fem,
                          height: 121 * fem,
                          child: Stack(
                            children: [
                              Positioned(
                                // ellipse35hN4 (211:12)
                                left: 0 * fem,
                                top: 1 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 120 * fem,
                                    height: 120 * fem,
                                    child: Image.asset(
                                      'assets/page-1/images/ellipse-35.png',
                                      width: 120 * fem,
                                      height: 120 * fem,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // ellipse36Cpc (211:13)
                                left: 1 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 120 * fem,
                                    height: 120 * fem,
                                    child: Image.asset(
                                      'assets/page-1/images/ellipse-36.png',
                                      width: 120 * fem,
                                      height: 120 * fem,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // yourbrainhealthvkc (211:15)
                                left: 35 * fem,
                                top: 23 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 55 * fem,
                                    height: 26 * fem,
                                    child: Text(
                                      'Your \nBrain Health',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Outfit',
                                        fontSize: 10 * ffem,
                                        fontWeight: FontWeight.w300,
                                        height: 1.26 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // goodthumbsupctL (211:20)
                                left: 11 * fem,
                                top: 74 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 103 * fem,
                                    height: 16 * fem,
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        style: SafeGoogleFont(
                                          'Outfit',
                                          fontSize: 12 * ffem,
                                          fontWeight: FontWeight.w300,
                                          height: 1.2599999905 * ffem / fem,
                                          color: const Color(0xff24ff47),
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'GOOD',
                                            style: SafeGoogleFont(
                                              'Outfit',
                                              fontSize: 12 * ffem,
                                              fontWeight: FontWeight.w700,
                                              height: 1.26 * ffem / fem,
                                              color: const Color(0xff24ff47),
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' ',
                                            style: SafeGoogleFont(
                                              'Outfit',
                                              fontSize: 12 * ffem,
                                              fontWeight: FontWeight.w300,
                                              height: 1.26 * ffem / fem,
                                              color: const Color(0xff24ff47),
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Thumbs-up',
                                            style: SafeGoogleFont(
                                              'Font Awesome 5 Free',
                                              fontSize: 12 * ffem,
                                              fontWeight: FontWeight.w900,
                                              height: 1.2575 * ffem / fem,
                                              color: const Color(0xff24ff47),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // JYC (211:16)
                                left: 42 * fem,
                                top: 49 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 38 * fem,
                                    height: 26 * fem,
                                    child: Text(
                                      '70%',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Outfit',
                                        fontSize: 20 * ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.26 * ffem / fem,
                                        color: const Color(0xffcfaaff),
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
                  // autogroup3hzeCda (TqH1N9cny2FMUUxADe3HzE)
                  margin:
                      EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 15 * fem),
                  height: 38 * fem,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // ellipse5v3n (47:13)
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 0 * fem, 12 * fem, 1 * fem),
                        width: 7 * fem,
                        height: 1 * fem,
                        child: Image.asset(
                          'assets/page-1/images/ellipse-5.png',
                          width: 7 * fem,
                          height: 1 * fem,
                        ),
                      ),
                      Container(
                        // autogrouposvkS28 (TqH1myGS8GCbAZJUFFoSVk)
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 4 * fem, 10 * fem, 0 * fem),
                        padding: EdgeInsets.fromLTRB(
                            12 * fem, 3 * fem, 6.65 * fem, 3.65 * fem),
                        height: 34 * fem,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xff000000)),
                          color: const Color(0xffffe9e9),
                          borderRadius: BorderRadius.circular(60 * fem),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // optimisticuwJ (51:16)
                              margin: EdgeInsets.fromLTRB(
                                  0 * fem, 0 * fem, 10 * fem, 2.35 * fem),
                              child: Text(
                                'optimistic',
                                textAlign: TextAlign.center,
                                style: SafeGoogleFont(
                                  'Outfit',
                                  fontSize: 15 * ffem,
                                  fontWeight: FontWeight.w300,
                                  height: 1.26 * ffem / fem,
                                  color: const Color(0xff000000),
                                ),
                              ),
                            ),
                            Container(
                              // autogrouprkmlDh6 (TqH1uy37NKG88C3nsVRkmL)
                              width: 27.35 * fem,
                              height: double.infinity,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    'assets/page-1/images/ellipse-7-fVn.png',
                                  ),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    // ellipse8j9e (51:18)
                                    left: 1.9995747805 * fem,
                                    top: 3 * fem,
                                    child: Align(
                                      child: SizedBox(
                                        width: 21 * fem,
                                        height: 21 * fem,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                10.5 * fem),
                                            color: const Color(0xffebe0ff),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    // qCg (51:19)
                                    left: 4.4995747805 * fem,
                                    top: 7 * fem,
                                    child: Align(
                                      child: SizedBox(
                                        width: 18 * fem,
                                        height: 13 * fem,
                                        child: Text(
                                          '25%',
                                          textAlign: TextAlign.center,
                                          style: SafeGoogleFont(
                                            'Outfit',
                                            fontSize: 10 * ffem,
                                            fontWeight: FontWeight.w600,
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
                          ],
                        ),
                      ),
                      Container(
                        // autogroupvftjj3A (TqH23sybKuhyVQrHaBVftJ)
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 2 * fem, 10 * fem, 1 * fem),
                        width: 114 * fem,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xff000000)),
                          color: const Color(0x5bd5f5ff),
                          borderRadius: BorderRadius.circular(60 * fem),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              // moodd8Y (51:21)
                              left: 24 * fem,
                              top: 7 * fem,
                              child: Align(
                                child: SizedBox(
                                  width: 39 * fem,
                                  height: 19 * fem,
                                  child: Text(
                                    'mood',
                                    textAlign: TextAlign.center,
                                    style: SafeGoogleFont(
                                      'Outfit',
                                      fontSize: 15 * ffem,
                                      fontWeight: FontWeight.w300,
                                      height: 1.26 * ffem / fem,
                                      color: const Color(0xff000000),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              // ellipse9ifn (51:23)
                              left: 80.000007391 * fem,
                              top: 6 * fem,
                              child: Align(
                                child: SizedBox(
                                  width: 22.31 * fem,
                                  height: 24.28 * fem,
                                  child: Image.asset(
                                    'assets/page-1/images/ellipse-9.png',
                                    width: 22.31 * fem,
                                    height: 24.28 * fem,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              // ellipse10pyi (51:24)
                              left: 81 * fem,
                              top: 11 * fem,
                              child: Align(
                                child: SizedBox(
                                  width: 16 * fem,
                                  height: 14 * fem,
                                  child: Image.asset(
                                    'assets/page-1/images/ellipse-10.png',
                                    width: 16 * fem,
                                    height: 14 * fem,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              // A1z (51:25)
                              left: 81.5 * fem,
                              top: 12 * fem,
                              child: Align(
                                child: SizedBox(
                                  width: 15 * fem,
                                  height: 12 * fem,
                                  child: Text(
                                    '16%',
                                    textAlign: TextAlign.center,
                                    style: SafeGoogleFont(
                                      'Outfit',
                                      fontSize: 9 * ffem,
                                      fontWeight: FontWeight.w500,
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
                        // autogrouphye6r9i (TqH2Ci4DQYvLPB3sRrhye6)
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 0 * fem, 0 * fem, 3 * fem),
                        width: 114 * fem,
                        height: 35 * fem,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xff000000)),
                          color: const Color(0x5bd5f5ff),
                          borderRadius: BorderRadius.circular(60 * fem),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              // frame1kkt (56:34)
                              left: 80.9999979734 * fem,
                              top: 4 * fem,
                              child: Container(
                                width: 27.35 * fem,
                                height: 27.35 * fem,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      'assets/page-1/images/ellipse-7.png',
                                    ),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      // ellipse8T9W (215:5)
                                      left: 3.0000020266 * fem,
                                      top: 3 * fem,
                                      child: Align(
                                        child: SizedBox(
                                          width: 21 * fem,
                                          height: 21 * fem,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10.5 * fem),
                                              color: const Color(0xffebe0ff),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      // kuJ (215:3)
                                      left: 5.5000020266 * fem,
                                      top: 7 * fem,
                                      child: Align(
                                        child: SizedBox(
                                          width: 18 * fem,
                                          height: 13 * fem,
                                          child: Text(
                                            '25%',
                                            textAlign: TextAlign.center,
                                            style: SafeGoogleFont(
                                              'Outfit',
                                              fontSize: 10 * ffem,
                                              fontWeight: FontWeight.w600,
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
                            ),
                            Positioned(
                              // dailygoalsejn (51:26)
                              left: 10 * fem,
                              top: 8 * fem,
                              child: Align(
                                child: SizedBox(
                                  width: 71 * fem,
                                  height: 19 * fem,
                                  child: Text(
                                    'daily goals',
                                    textAlign: TextAlign.center,
                                    style: SafeGoogleFont(
                                      'Outfit',
                                      fontSize: 15 * ffem,
                                      fontWeight: FontWeight.w300,
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
                    ],
                  ),
                ),
                Container(
                  // recommendationswit (51:15)
                  margin:
                      EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 21 * fem),
                  width: double.infinity,
                  child: Text(
                    'Recommendations',
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
                Container(
                  // autogroupvtsndrc (TqH2irre8fdTAdEycpvTSn)
                  margin:
                      EdgeInsets.fromLTRB(25 * fem, 0 * fem, 0 * fem, 0 * fem),
                  width: 432 * fem,
                  height: 883 * fem,
                  child: Stack(
                    children: [
                      Positioned(
                        // excerciseJC4 (56:30)
                        left: 7 * fem,
                        top: 85 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 63 * fem,
                            height: 19 * fem,
                            child: Text(
                              'Excercise',
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
                        ),
                      ),
                      Positioned(
                        // ellipse11yoz (56:31)
                        left: 0 * fem,
                        top: 0 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 80 * fem,
                            height: 79 * fem,
                            child: Image.asset(
                              'assets/page-1/images/ellipse-11.png',
                              width: 80 * fem,
                              height: 79 * fem,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // ellipse12VXS (56:36)
                        left: 124 * fem,
                        top: 0 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 80 * fem,
                            height: 79 * fem,
                            child: Image.asset(
                              'assets/page-1/images/ellipse-12.png',
                              width: 80 * fem,
                              height: 79 * fem,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // ellipse13c6G (56:37)
                        left: 247 * fem,
                        top: 0 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 80 * fem,
                            height: 79 * fem,
                            child: Image.asset(
                              'assets/page-1/images/ellipse-13.png',
                              width: 80 * fem,
                              height: 79 * fem,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // consultant image (211:6)
                        left: 247 * fem,
                        top: 0 * fem,
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to the ConsultantPage when the user taps on the text
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const Therapist_list_page()),
                            );
                          },
                          child: Align(
                            child: SizedBox(
                              width: 80 * fem,
                              height: 79 * fem,
                              child: Image.asset(
                                'assets/page-1/images/ellipse-17.png',
                                width: 80 * fem,
                                height: 79 * fem,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // ellipse15qzc (60:5)
                        left: 0 * fem,
                        top: 115 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 80 * fem,
                            height: 79 * fem,
                            child: Image.asset(
                              'assets/page-1/images/ellipse-15.png',
                              width: 80 * fem,
                              height: 79 * fem,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // gratitudeNUk (60:9)
                        left: 135 * fem,
                        top: 85 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 65 * fem,
                            height: 19 * fem,
                            child: Text(
                              'Gratitude',
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
                        ),
                      ),
                      Positioned(
                        // consultantGa8 (60:10)
                        left: 252 * fem,
                        top: 85 * fem,
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to the ConsultantPage when the user taps on the text
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const Therapist_list_page()),
                            );
                          },
                          child: Align(
                            child: SizedBox(
                              width: 72 * fem,
                              height: 19 * fem,
                              child: Text(
                                'Consultant',
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
                          ),
                        ),
                      ),
                      Positioned(
                        // bedtimekkC (60:11)
                        left: 8 * fem,
                        top: 204 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 59 * fem,
                            height: 19 * fem,
                            child: Text(
                              'Bed time',
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
                        ),
                      ),
                      Positioned(
                        // medicalhistory3jJ (209:3)
                        left: 113 * fem,
                        top: 204 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 103 * fem,
                            height: 19 * fem,
                            child: Text(
                              'Medical History',
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
                        ),
                      ),
                      Positioned(
                        // rectangle76Jj6 (182:277)
                        left: 57 * fem,
                        top: 279 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 52 * fem,
                            height: 25 * fem,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xffffe9e9),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle77E6x (182:279)
                        left: 109 * fem,
                        top: 279 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 82 * fem,
                            height: 25 * fem,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xb5caaaff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle78Y7e (182:280)
                        left: 191 * fem,
                        top: 279 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 136 * fem,
                            height: 25 * fem,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xffd5f5ff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle79fCG (182:281)
                        left: 57 * fem,
                        top: 341 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 84 * fem,
                            height: 25 * fem,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xffffe9e9),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle80BRW (182:282)
                        left: 141 * fem,
                        top: 341 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 50 * fem,
                            height: 25 * fem,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xb5caaaff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle816oN (182:283)
                        left: 191 * fem,
                        top: 341 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 136 * fem,
                            height: 25 * fem,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xffd5f5ff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle82pjN (182:284)
                        left: 57 * fem,
                        top: 372 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 72 * fem,
                            height: 25 * fem,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xffffe9e9),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle83k7E (182:285)
                        left: 129 * fem,
                        top: 372 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 163 * fem,
                            height: 25 * fem,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xb5caaaff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle84sSk (182:286)
                        left: 292 * fem,
                        top: 372 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 35 * fem,
                            height: 25 * fem,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xffd5f5ff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // monQBn (182:291)
                        left: 15 * fem,
                        top: 282 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 30 * fem,
                            height: 19 * fem,
                            child: Text(
                              'Mon',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 15 * ffem,
                                fontWeight: FontWeight.w300,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // happyJ2G (196:4)
                        left: 86 * fem,
                        top: 424 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 45 * fem,
                            height: 19 * fem,
                            child: Text(
                              'Happy',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 15 * ffem,
                                fontWeight: FontWeight.w300,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle85Brk (182:287)
                        left: 57 * fem,
                        top: 310 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 39 * fem,
                            height: 25 * fem,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xffffe9e9),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle86hq6 (182:288)
                        left: 96 * fem,
                        top: 310 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 146 * fem,
                            height: 25 * fem,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xb5caaaff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle87oNL (182:289)
                        left: 242 * fem,
                        top: 310 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 85 * fem,
                            height: 25 * fem,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xffd5f5ff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // tuej16 (182:293)
                        left: 15 * fem,
                        top: 313 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 24 * fem,
                            height: 19 * fem,
                            child: Text(
                              'Tue',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 15 * ffem,
                                fontWeight: FontWeight.w300,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // wed1zC (182:294)
                        left: 15 * fem,
                        top: 344 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 31 * fem,
                            height: 19 * fem,
                            child: Text(
                              'Wed',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 15 * ffem,
                                fontWeight: FontWeight.w300,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // thurvLU (182:295)
                        left: 15 * fem,
                        top: 375 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 32 * fem,
                            height: 19 * fem,
                            child: Text(
                              'Thur',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 15 * ffem,
                                fontWeight: FontWeight.w300,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle88RHE (182:296)
                        left: 49 * fem,
                        top: 421 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 30 * fem,
                            height: 25 * fem,
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xff000000)),
                                color: const Color(0xffffe9e9),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle898hS (182:297)
                        left: 141 * fem,
                        top: 418 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 30 * fem,
                            height: 25 * fem,
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xff000000)),
                                color: const Color(0xb5caaaff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle90F1N (182:298)
                        left: 224 * fem,
                        top: 418 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 30 * fem,
                            height: 25 * fem,
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xff000000)),
                                color: const Color(0xffd5f5ff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // stressmEc (196:6)
                        left: 264 * fem,
                        top: 421 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 41 * fem,
                            height: 19 * fem,
                            child: Text(
                              'Stress',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 15 * ffem,
                                fontWeight: FontWeight.w300,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // sad4Uc (196:5)
                        left: 177 * fem,
                        top: 423 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 26 * fem,
                            height: 19 * fem,
                            child: Text(
                              'Sad',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 15 * ffem,
                                fontWeight: FontWeight.w300,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // ellipse18xpt (241:2)
                        left: 247 * fem,
                        top: 119 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 80 * fem,
                            height: 81 * fem,
                            child: Image.asset(
                              'assets/page-1/images/ellipse-18.png',
                              width: 80 * fem,
                              height: 81 * fem,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // relativemoodtCk (241:3)
                        left: 247 * fem,
                        top: 200 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 95 * fem,
                            height: 19 * fem,
                            child: Text(
                              'Relative Mood',
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
                        ),
                      ),
                      Positioned(
                        // ellipse19Ag4 (243:36)
                        left: 125 * fem,
                        top: 119 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 80 * fem,
                            height: 79 * fem,
                            child: Image.asset(
                              'assets/page-1/images/ellipse-19-LA8.png',
                              width: 80 * fem,
                              height: 79 * fem,
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
      ),
    );
  }
}
