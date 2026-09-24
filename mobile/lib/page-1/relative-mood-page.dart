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
        // relativemoodpageyY8 (243:18)
        padding: EdgeInsets.fromLTRB(17 * fem, 26 * fem, 0 * fem, 2 * fem),
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/page-1/images/relative-mood-page-bg.png',
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // group11s7i (359:272)
              margin: EdgeInsets.fromLTRB(8 * fem, 0 * fem, 0 * fem, 22 * fem),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // pmbpQ (359:273)
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
                    // autogroup2ify6WG (TqJHbmRZ64iFDvL6sX2iFY)
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 1 * fem, 0 * fem, 0 * fem),
                    width: 131 * fem,
                    height: 19 * fem,
                    child: Stack(
                      children: [
                        Positioned(
                          // signalcDi (359:274)
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
                          // wifi6eg (359:275)
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
                          // batteryfullyyN (359:276)
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
              // autogrouphlescmS (TqJC46LD9rjsoVf5a9hLES)
              margin:
                  EdgeInsets.fromLTRB(0 * fem, 0 * fem, 127 * fem, 35 * fem),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // barsJeG (359:310)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 61 * fem, 3 * fem),
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
                  Text(
                    // relativemoodQSQ (250:37)
                    ' RELATIVE MOOD',
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont(
                      'Outfit',
                      fontSize: 20 * ffem,
                      fontWeight: FontWeight.w500,
                      height: 1.26 * ffem / fem,
                      color: const Color(0xff000000),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // autogroupgepyjzU (TqJCX5ZF6Y543FvngSgePY)
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 16 * fem, 59 * fem),
              padding:
                  EdgeInsets.fromLTRB(0 * fem, 12 * fem, 0 * fem, 146 * fem),
              width: 360 * fem,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff000000)),
                borderRadius: BorderRadius.circular(10 * fem),
                gradient: const LinearGradient(
                  begin: Alignment(0, -1),
                  end: Alignment(0, 1),
                  colors: <Color>[Color(0xffd6f5ff), Color(0xffffe9e9)],
                  stops: <double>[0, 0.818],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // autogroupurh8kua (TqJDCUbGKb4wgY3cLouRh8)
                    margin: EdgeInsets.fromLTRB(
                        13 * fem, 0 * fem, 34 * fem, 11 * fem),
                    width: double.infinity,
                    height: 74 * fem,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // ellipse395S4 (292:4)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 6.5 * fem, 9 * fem),
                          width: 51 * fem,
                          height: 49 * fem,
                          child: Image.asset(
                            'assets/page-1/images/ellipse-39.png',
                            width: 51 * fem,
                            height: 49 * fem,
                          ),
                        ),
                        SizedBox(
                          // autogrouplu9ca7v (TqJDTJVtqGaTJ2JgffLU9c)
                          width: 255.5 * fem,
                          height: double.infinity,
                          child: Stack(
                            children: [
                              Positioned(
                                // sentflowerstoherWXN (250:46)
                                left: 3.5 * fem,
                                top: 55 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 127 * fem,
                                    height: 19 * fem,
                                    child: Text(
                                      'Sent Flowers to her',
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
                                // haniafeelingsadBdW (250:44)
                                left: 0 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 191 * fem,
                                    height: 26 * fem,
                                    child: Text(
                                      'HANIA FEELING SAD',
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
                                // ellipse38smE (250:45)
                                left: 193.5 * fem,
                                top: 2 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 62 * fem,
                                    height: 61 * fem,
                                    child: Image.asset(
                                      'assets/page-1/images/ellipse-38.png',
                                      width: 62 * fem,
                                      height: 61 * fem,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // showmoreo96 (292:5)
                                left: 134 * fem,
                                top: 57 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 82 * fem,
                                    height: 17 * fem,
                                    child: Text(
                                      'show more.....',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Outfit',
                                        fontSize: 13 * ffem,
                                        fontWeight: FontWeight.w300,
                                        height: 1.26 * ffem / fem,
                                        color: const Color(0xffa27dde),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // rectangle137GoN (292:7)
                                left: 2.5 * fem,
                                top: 30 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 65 * fem,
                                    height: 21 * fem,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5 * fem),
                                        border: Border.all(
                                            color: const Color(0xff000000)),
                                        color: const Color(0xb5caaaff),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // sisteraJG (292:6)
                                left: 19 * fem,
                                top: 31 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 33 * fem,
                                    height: 17 * fem,
                                    child: Text(
                                      'Sister',
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // line31g6Q (250:39)
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 7 * fem),
                    width: double.infinity,
                    height: 1 * fem,
                    decoration: const BoxDecoration(
                      color: Color(0xff000000),
                    ),
                  ),
                  Container(
                    // autogroup7uvp1uN (TqJDidPh3hn4TzEiXn7uVp)
                    margin: EdgeInsets.fromLTRB(
                        12 * fem, 0 * fem, 33 * fem, 15 * fem),
                    width: double.infinity,
                    height: 76 * fem,
                    child: Stack(
                      children: [
                        Positioned(
                          // ellipse40Y8c (347:81)
                          left: 0 * fem,
                          top: 17 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 51 * fem,
                              height: 49 * fem,
                              child: Image.asset(
                                'assets/page-1/images/ellipse-40-rNG.png',
                                width: 51 * fem,
                                height: 49 * fem,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // rectangle1383LG (347:85)
                          left: 56 * fem,
                          top: 33 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 85 * fem,
                              height: 20 * fem,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5 * fem),
                                  border: Border.all(
                                      color: const Color(0xff000000)),
                                  color: const Color(0xb5caaaff),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // juliefeelingtiredkVa (347:93)
                          left: 49 * fem,
                          top: 0 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 198 * fem,
                              height: 26 * fem,
                              child: Text(
                                'JULIE FEELING TIRED',
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
                          // bestfriendStC (347:97)
                          left: 65.5 * fem,
                          top: 34 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 66 * fem,
                              height: 17 * fem,
                              child: Text(
                                'Best Friend',
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
                          // sentflowerstoherKh6 (373:36)
                          left: 55 * fem,
                          top: 57 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 127 * fem,
                              height: 19 * fem,
                              child: Text(
                                'Sent Flowers to her',
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
                          // showmoreD1n (347:89)
                          left: 186.5 * fem,
                          top: 58 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 82 * fem,
                              height: 17 * fem,
                              child: Text(
                                'show more.....',
                                textAlign: TextAlign.center,
                                style: SafeGoogleFont(
                                  'Outfit',
                                  fontSize: 13 * ffem,
                                  fontWeight: FontWeight.w300,
                                  height: 1.26 * ffem / fem,
                                  color: const Color(0xffa27dde),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // ellipse44hxY (419:381)
                          left: 260 * fem,
                          top: 5 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 55 * fem,
                              height: 51 * fem,
                              child: Image.asset(
                                'assets/page-1/images/ellipse-44.png',
                                width: 55 * fem,
                                height: 51 * fem,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // line32RtY (250:40)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 0 * fem, 11 * fem),
                    width: double.infinity,
                    height: 1 * fem,
                    decoration: const BoxDecoration(
                      color: Color(0xff000000),
                    ),
                  ),
                  Container(
                    // autogrouphlb8Zzk (TqJDzNSTgS45c1tt1chLb8)
                    margin: EdgeInsets.fromLTRB(
                        12 * fem, 0 * fem, 25 * fem, 5 * fem),
                    width: double.infinity,
                    height: 73 * fem,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // ellipse416Dz (347:82)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 1.5 * fem, 12 * fem),
                          width: 51 * fem,
                          height: 49 * fem,
                          child: Image.asset(
                            'assets/page-1/images/ellipse-41.png',
                            width: 51 * fem,
                            height: 49 * fem,
                          ),
                        ),
                        SizedBox(
                          // autogroup1aknoPJ (TqJEF2ghdCLE2gGJVP1akN)
                          width: 270.5 * fem,
                          height: double.infinity,
                          child: Stack(
                            children: [
                              Positioned(
                                // rectangle139YLt (347:86)
                                left: 5.5 * fem,
                                top: 26 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 73 * fem,
                                    height: 19 * fem,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5 * fem),
                                        border: Border.all(
                                            color: const Color(0xff000000)),
                                        color: const Color(0xb5caaaff),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // showmoreqKz (347:90)
                                left: 135 * fem,
                                top: 49 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 82 * fem,
                                    height: 17 * fem,
                                    child: Text(
                                      'show more.....',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Outfit',
                                        fontSize: 13 * ffem,
                                        fontWeight: FontWeight.w300,
                                        height: 1.26 * ffem / fem,
                                        color: const Color(0xffa27dde),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // bunnyfeelingstressed95n (347:94)
                                left: 0 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 253 * fem,
                                    height: 26 * fem,
                                    child: Text(
                                      'BUNNY FEELING STRESSED',
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
                                // fianceczx (347:99)
                                left: 21 * fem,
                                top: 26 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 39 * fem,
                                    height: 17 * fem,
                                    child: Text(
                                      'Fiance',
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
                                // sentflowerstoherjZn (373:37)
                                left: 4.5 * fem,
                                top: 48 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 127 * fem,
                                    height: 19 * fem,
                                    child: Text(
                                      'Sent Flowers to her',
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
                                // ellipse46qMv (419:383)
                                left: 215.5 * fem,
                                top: 22 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 55 * fem,
                                    height: 51 * fem,
                                    child: Image.asset(
                                      'assets/page-1/images/ellipse-46.png',
                                      width: 55 * fem,
                                      height: 51 * fem,
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
                    // line33Yn8 (250:41)
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 8 * fem),
                    width: double.infinity,
                    height: 1 * fem,
                    decoration: const BoxDecoration(
                      color: Color(0xff000000),
                    ),
                  ),
                  Container(
                    // autogroupudysgtL (TqJEWc55h1Nsyt2p88UDYS)
                    margin: EdgeInsets.fromLTRB(
                        12 * fem, 0 * fem, 25 * fem, 8 * fem),
                    width: double.infinity,
                    height: 73 * fem,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // ellipse42bkQ (347:83)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 1.5 * fem, 6 * fem),
                          width: 51 * fem,
                          height: 49 * fem,
                          child: Image.asset(
                            'assets/page-1/images/ellipse-42.png',
                            width: 51 * fem,
                            height: 49 * fem,
                          ),
                        ),
                        SizedBox(
                          // autogroupwhhqKAc (TqJEjMCr7DWKm3fENNwHHQ)
                          width: 270.5 * fem,
                          height: double.infinity,
                          child: Stack(
                            children: [
                              Positioned(
                                // rectangle140rgL (347:87)
                                left: 5.5 * fem,
                                top: 25 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 68 * fem,
                                    height: 19 * fem,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5 * fem),
                                        border: Border.all(
                                            color: const Color(0xff000000)),
                                        color: const Color(0xb5caaaff),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // showmorem2c (347:91)
                                left: 134 * fem,
                                top: 48 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 82 * fem,
                                    height: 17 * fem,
                                    child: Text(
                                      'show more.....',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Outfit',
                                        fontSize: 13 * ffem,
                                        fontWeight: FontWeight.w300,
                                        height: 1.26 * ffem / fem,
                                        color: const Color(0xffa27dde),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // tiffnayfeelinghappyfNt (347:95)
                                left: 0 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 235 * fem,
                                    height: 26 * fem,
                                    child: Text(
                                      'TIFFNAY FEELING HAPPY',
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
                                // classmatewrC (347:103)
                                left: 7 * fem,
                                top: 26 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 64 * fem,
                                    height: 17 * fem,
                                    child: Text(
                                      'Class mate',
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
                                // sentflowerstoherF6C (373:38)
                                left: 3.5 * fem,
                                top: 46 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 127 * fem,
                                    height: 19 * fem,
                                    child: Text(
                                      'Sent Flowers to her',
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
                                // ellipse45wji (419:382)
                                left: 215.5 * fem,
                                top: 22 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 55 * fem,
                                    height: 51 * fem,
                                    child: Image.asset(
                                      'assets/page-1/images/ellipse-45.png',
                                      width: 55 * fem,
                                      height: 51 * fem,
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
                    // line344pL (250:42)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 0 * fem, 10 * fem),
                    width: double.infinity,
                    height: 1 * fem,
                    decoration: const BoxDecoration(
                      color: Color(0xff000000),
                    ),
                  ),
                  Container(
                    // autogroupdw74bpG (TqJEyFyLVrFKqzXDYFDw74)
                    margin: EdgeInsets.fromLTRB(
                        13 * fem, 0 * fem, 27 * fem, 14 * fem),
                    width: double.infinity,
                    height: 72 * fem,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // ellipse43w7S (347:84)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 5 * fem, 2 * fem, 0 * fem),
                          width: 51 * fem,
                          height: 49 * fem,
                          child: Image.asset(
                            'assets/page-1/images/ellipse-43.png',
                            width: 51 * fem,
                            height: 49 * fem,
                          ),
                        ),
                        SizedBox(
                          // autogroupm2ucqyW (TqJF8fsKZhmTteLarjM2uC)
                          width: 267 * fem,
                          height: double.infinity,
                          child: Stack(
                            children: [
                              Positioned(
                                // rectangle141aw6 (347:88)
                                left: 4 * fem,
                                top: 32 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 64 * fem,
                                    height: 19 * fem,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5 * fem),
                                        border: Border.all(
                                            color: const Color(0xff000000)),
                                        color: const Color(0xb5caaaff),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // showmoreV2U (347:92)
                                left: 130.5 * fem,
                                top: 54 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 82 * fem,
                                    height: 17 * fem,
                                    child: Text(
                                      'show more.....',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Outfit',
                                        fontSize: 13 * ffem,
                                        fontWeight: FontWeight.w300,
                                        height: 1.26 * ffem / fem,
                                        color: const Color(0xffa27dde),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // luciferfeelingexcitedxwe (347:96)
                                left: 4 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 252 * fem,
                                    height: 26 * fem,
                                    child: Text(
                                      'LUCIFER FEELING EXCITED',
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
                                // cousinT7i (347:104)
                                left: 13.6224601939 * fem,
                                top: 32.000011161 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 39 * fem,
                                    height: 17 * fem,
                                    child: Text(
                                      'Cousin',
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
                                // sentflowerstoherYur (373:39)
                                left: 0 * fem,
                                top: 53 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 127 * fem,
                                    height: 19 * fem,
                                    child: Text(
                                      'Sent Flowers to her',
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
                                // ellipse47eCC (419:384)
                                left: 212 * fem,
                                top: 21 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 55 * fem,
                                    height: 51 * fem,
                                    child: Image.asset(
                                      'assets/page-1/images/ellipse-47.png',
                                      width: 55 * fem,
                                      height: 51 * fem,
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
                    // line35xig (250:43)
                    width: double.infinity,
                    height: 1 * fem,
                    decoration: const BoxDecoration(
                      color: Color(0xff000000),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // autogroupy6rcJnY (TqJG1PuoPASCE51n56Y6RC)
              margin:
                  EdgeInsets.fromLTRB(34.5 * fem, 0 * fem, 77 * fem, 0 * fem),
              width: double.infinity,
              height: 42 * fem,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    // autogroupunj2S84 (TqJGBySWRSZtaW4iKCUnJ2)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 10 * fem, 0 * fem),
                    width: 61 * fem,
                    height: 40 * fem,
                    child: Stack(
                      children: [
                        Positioned(
                          // homexs6 (279:48)
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
                          // homeTJ4 (279:52)
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
                    // autogroup7xwwMuE (TqJGH8xa1tiDN6fwYw7XWW)
                    width: 193.5 * fem,
                    height: double.infinity,
                    child: Stack(
                      children: [
                        Positioned(
                          // smileuQx (279:49)
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
                          // stethoscopezxC (279:50)
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
                          // belltXn (279:51)
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
                          // moodbSC (279:53)
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
                          // therepyJLc (279:54)
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
                          // reminderbac (279:55)
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
          ],
        ),
      ),
    );
  }
}
