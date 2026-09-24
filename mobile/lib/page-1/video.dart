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
        // videoEjW (398:19)
        padding: EdgeInsets.fromLTRB(3 * fem, 21 * fem, 0 * fem, 2 * fem),
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/page-1/images/video-bg.png',
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // group11DUx (398:27)
              margin: EdgeInsets.fromLTRB(19 * fem, 0 * fem, 0 * fem, 15 * fem),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // pmv8U (398:28)
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
                    // autogroupfy82mun (TqGg7NNJ8KQUAzdeJAFy82)
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 1 * fem, 0 * fem, 0 * fem),
                    width: 131 * fem,
                    height: 19 * fem,
                    child: Stack(
                      children: [
                        Positioned(
                          // signalHt8 (398:29)
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
                          // wifiqYG (398:30)
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
                          // batteryfullJgk (398:31)
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
              // autogroup57yso7i (TqGcJp38hCJq3mXhjM57YS)
              margin: EdgeInsets.fromLTRB(5 * fem, 0 * fem, 3 * fem, 1 * fem),
              width: double.infinity,
              height: 276 * fem,
              child: Stack(
                children: [
                  Positioned(
                    // rectangle206SwN (398:20)
                    left: 0 * fem,
                    top: 0 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 379 * fem,
                        height: 220 * fem,
                        child: Image.asset(
                          'assets/page-1/images/rectangle-206.png',
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // group24YzQ (486:244)
                    left: 7.5 * fem,
                    top: 222 * fem,
                    child: SizedBox(
                      width: 346 * fem,
                      height: 44 * fem,
                      child: Stack(
                        children: [
                          Positioned(
                            // comedyvedios2022gKv (398:38)
                            left: 3.5 * fem,
                            top: 19 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 213 * fem,
                                height: 25 * fem,
                                child: Text(
                                  'Comedy Vedios  2022',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Inter',
                                    fontSize: 20 * ffem,
                                    fontWeight: FontWeight.w600,
                                    height: 1.2125 * ffem / fem,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // newentertainmenttopfunnybestwW (398:39)
                            left: 0 * fem,
                            top: 0 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 346 * fem,
                                height: 25 * fem,
                                child: Text(
                                  'New Entertainment Top Funny Best ',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Inter',
                                    fontSize: 20 * ffem,
                                    fontWeight: FontWeight.w600,
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
                  ),
                  Positioned(
                    // kviews14hoursyyE (398:40)
                    left: 16 * fem,
                    top: 263 * fem,
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
                    // moreztL (398:43)
                    left: 126 * fem,
                    top: 263 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 33 * fem,
                        height: 13 * fem,
                        child: Text(
                          '...more',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 10 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // pauseeT6 (398:33)
                    left: 148.5 * fem,
                    top: 106 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 64 * fem,
                        height: 31 * fem,
                        child: Text(
                          'pause',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Font Awesome 6 Free',
                            fontSize: 24 * ffem,
                            fontWeight: FontWeight.w900,
                            height: 1.2575 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // stepforward64C (398:34)
                    left: 195 * fem,
                    top: 112 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 94 * fem,
                        height: 19 * fem,
                        child: Text(
                          'step-forWARD',
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
                  Positioned(
                    // stepbackwardaEG (398:35)
                    left: 57.5 * fem,
                    top: 112 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 115 * fem,
                        height: 19 * fem,
                        child: Text(
                          'STEP-BACKWARD',
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
                  Positioned(
                    // line81rxU (398:65)
                    left: 0 * fem,
                    top: 221 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 208 * fem,
                        height: 3 * fem,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xffcaaaff),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // line82mJk (398:66)
                    left: 171 * fem,
                    top: 221 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 208 * fem,
                        height: 3 * fem,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xffa27dde),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // ssa (398:67)
                    left: 165 * fem,
                    top: 176 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 15 * fem,
                        height: 61 * fem,
                        child: Text(
                          '.',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 48 * ffem,
                            fontWeight: FontWeight.w900,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xffe62a9b),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // gearZVW (398:69)
                    left: 342 * fem,
                    top: 5 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 40 * fem,
                        height: 26 * fem,
                        child: Text(
                          'gear',
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
                  Positioned(
                    // Ft8 (398:196)
                    left: 11 * fem,
                    top: 199 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 79 * fem,
                        height: 17 * fem,
                        child: Text(
                          '3:08/40:30',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Inter',
                            fontSize: 14 * ffem,
                            fontWeight: FontWeight.w600,
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
            Container(
              // autogroupnojnLPn (TqGcpP2CS6iAgL72TWNoJn)
              margin: EdgeInsets.fromLTRB(21 * fem, 0 * fem, 22 * fem, 7 * fem),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // ellipse54r7E (398:45)
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 5 * fem, 5 * fem, 0 * fem),
                    width: 24 * fem,
                    height: 22 * fem,
                    child: Image.asset(
                      'assets/page-1/images/ellipse-54.png',
                      width: 24 * fem,
                      height: 22 * fem,
                    ),
                  ),
                  Container(
                    // funnydaykyJ (398:46)
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 6 * fem, 3 * fem, 0 * fem),
                    child: Text(
                      'Funny Day',
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont(
                        'Inter',
                        fontSize: 10 * ffem,
                        fontWeight: FontWeight.w600,
                        height: 1.2125 * ffem / fem,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                  Container(
                    // mGgk (398:47)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 8 * fem, 183 * fem, 0 * fem),
                    child: Text(
                      '5.1M',
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont(
                        'Inter',
                        fontSize: 7 * ffem,
                        fontWeight: FontWeight.w300,
                        height: 1.2125 * ffem / fem,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                  Container(
                    // autogroupvua2xpU (TqGd2dAo9Z9Wu24VAVVUA2)
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 4 * fem),
                    width: 66 * fem,
                    height: 23 * fem,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff000000)),
                      borderRadius: BorderRadius.circular(5 * fem),
                      gradient: const LinearGradient(
                        begin: Alignment(0, -1),
                        end: Alignment(0, 1),
                        colors: <Color>[Color(0xffcaaaff), Color(0xffd6f5ff)],
                        stops: <double>[0, 1],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Suscribe',
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
                ],
              ),
            ),
            Container(
              // autogroupwnwjL4L (TqGdBnaCN2pcAS3NiLwNWJ)
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 88 * fem, 6 * fem),
              width: double.infinity,
              height: 25 * fem,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // autogroupdawxeKv (TqGdWXXyDHFCfKjHRmdAwx)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 6.72 * fem, 0 * fem),
                    width: 212 * fem,
                    height: double.infinity,
                    child: Stack(
                      children: [
                        Positioned(
                          // rectangle211kNx (398:52)
                          left: 25 * fem,
                          top: 0 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 87 * fem,
                              height: 24 * fem,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10 * fem),
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
                          // thumbsdownoME (398:49)
                          left: 40.5 * fem,
                          top: 6 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 104 * fem,
                              height: 19 * fem,
                              child: Text(
                                'tHUMBS-DOWN',
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
                        Positioned(
                          // thumbsupt7n (398:48)
                          left: 0 * fem,
                          top: 3 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 83 * fem,
                              height: 19 * fem,
                              child: Text(
                                'THUMBS-UP',
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
                        Positioned(
                          // knU4 (398:53)
                          left: 51 * fem,
                          top: 5 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 21 * fem,
                              height: 13 * fem,
                              child: Text(
                                '2.6K',
                                textAlign: TextAlign.center,
                                style: SafeGoogleFont(
                                  'Outfit',
                                  fontSize: 10 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.26 * ffem / fem,
                                  color: const Color(0xff000000),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // line805i4 (398:55)
                          left: 75.9999999637 * fem,
                          top: 3 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 0 * fem,
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
                          // rectangle212oe4 (398:56)
                          left: 125 * fem,
                          top: 0 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 87 * fem,
                              height: 24 * fem,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10 * fem),
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
                          // downloadGGk (398:50)
                          left: 101 * fem,
                          top: 4 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 79 * fem,
                              height: 19 * fem,
                              child: Text(
                                'DOWNLOAD',
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
                        Positioned(
                          // downloadYk4 (398:58)
                          left: 148 * fem,
                          top: 4 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 60 * fem,
                              height: 17 * fem,
                              child: Text(
                                'Download',
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
                      ],
                    ),
                  ),
                  SizedBox(
                    // autogroupwfciSKe (TqGdiSMnnuDpWMuSSaWFCi)
                    width: 83.28 * fem,
                    height: 24 * fem,
                    child: Stack(
                      children: [
                        Positioned(
                          // rectangle213NUC (398:57)
                          left: 6.2817382449 * fem,
                          top: 0 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 77 * fem,
                              height: 24 * fem,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10 * fem),
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
                          // sharedQ8 (398:51)
                          left: 0 * fem,
                          top: 2.999985205 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 46 * fem,
                              height: 19 * fem,
                              child: Text(
                                'SHARE',
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
                        Positioned(
                          // shareLJY (398:60)
                          left: 36.2817382449 * fem,
                          top: 2 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 34 * fem,
                              height: 17 * fem,
                              child: Text(
                                'Share',
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // rectangle208doS (398:22)
              margin: EdgeInsets.fromLTRB(21 * fem, 0 * fem, 26 * fem, 0 * fem),
              width: double.infinity,
              height: 125 * fem,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff000000)),
                image: const DecorationImage(
                  image: AssetImage(
                    'assets/page-1/images/rectangle-208-bg.png',
                  ),
                ),
              ),
            ),
            Container(
              // autogroupsg38jrU (TqGdzbZXqvaFcTHjY8sg38)
              margin: EdgeInsets.fromLTRB(24 * fem, 0 * fem, 0 * fem, 3 * fem),
              width: 369.5 * fem,
              height: 51 * fem,
              child: Stack(
                children: [
                  Positioned(
                    // group18T1n (398:70)
                    left: 0 * fem,
                    top: 0 * fem,
                    child: SizedBox(
                      width: 369.5 * fem,
                      height: 39 * fem,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            // ellipse54mYG (398:73)
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 1 * fem, 1 * fem),
                            width: 34 * fem,
                            height: 34 * fem,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(17 * fem),
                              border:
                                  Border.all(color: const Color(0xff000000)),
                              image: const DecorationImage(
                                image: AssetImage(
                                  'assets/page-1/images/ellipse-54-bg-2ZS.png',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            // autogroupvjgj5J4 (TqGeEB1F6irXKkNR1pvjGJ)
                            width: 334.5 * fem,
                            height: double.infinity,
                            child: Stack(
                              children: [
                                Positioned(
                                  // group231xQ (486:243)
                                  left: 0 * fem,
                                  top: 0 * fem,
                                  child: SizedBox(
                                    width: 277 * fem,
                                    height: 39 * fem,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          // comedyvedios2022LUt (398:71)
                                          left: 1 * fem,
                                          top: 19 * fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 171 * fem,
                                              height: 20 * fem,
                                              child: Text(
                                                'Comedy Vedios  2022',
                                                textAlign: TextAlign.center,
                                                style: SafeGoogleFont(
                                                  'Inter',
                                                  fontSize: 16 * ffem,
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
                                          // newentertainmenttopfunnybestdD (398:72)
                                          left: 0 * fem,
                                          top: 0 * fem,
                                          child: Align(
                                            child: SizedBox(
                                              width: 277 * fem,
                                              height: 20 * fem,
                                              child: Text(
                                                'New Entertainment Top Funny Best ',
                                                textAlign: TextAlign.center,
                                                style: SafeGoogleFont(
                                                  'Inter',
                                                  fontSize: 16 * ffem,
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
                                Positioned(
                                  // ellipsisv7PA (403:197)
                                  left: 269.5 * fem,
                                  top: 9 * fem,
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    // funnydaybp8 (398:74)
                    left: 37 * fem,
                    top: 38 * fem,
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
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // mJTe (398:127)
                    left: 94 * fem,
                    top: 38 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 22 * fem,
                        height: 13 * fem,
                        child: Text(
                          '5.1M',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Inter',
                            fontSize: 10 * ffem,
                            fontWeight: FontWeight.w600,
                            height: 1.2125 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // monthsagoBGY (398:128)
                    left: 121 * fem,
                    top: 38 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 67 * fem,
                        height: 13 * fem,
                        child: Text(
                          '6 Months ago',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Inter',
                            fontSize: 10 * ffem,
                            fontWeight: FontWeight.w600,
                            height: 1.2125 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // fSc (398:129)
                    left: 88 * fem,
                    top: 29 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 5 * fem,
                        height: 20 * fem,
                        child: Text(
                          '.',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Inter',
                            fontSize: 16 * ffem,
                            fontWeight: FontWeight.w600,
                            height: 1.2125 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // xRi (398:130)
                    left: 116 * fem,
                    top: 29 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 5 * fem,
                        height: 20 * fem,
                        child: Text(
                          '.',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Inter',
                            fontSize: 16 * ffem,
                            fontWeight: FontWeight.w600,
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
            Container(
              // rectangle209F9v (398:24)
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 7 * fem, 0 * fem),
              width: 343 * fem,
              height: 137 * fem,
              child: Image.asset(
                'assets/page-1/images/rectangle-209.png',
              ),
            ),
            Container(
              // autogroupzdsny5v (TqGeQvCLhvDas1K171zDSN)
              margin: EdgeInsets.fromLTRB(21 * fem, 0 * fem, 0 * fem, 1 * fem),
              width: 370.5 * fem,
              height: 51 * fem,
              child: Stack(
                children: [
                  Positioned(
                    // group19gW8 (398:187)
                    left: 0 * fem,
                    top: 0 * fem,
                    child: SizedBox(
                      width: 370.5 * fem,
                      height: 39 * fem,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            // ellipse54bsz (398:190)
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 1 * fem, 1 * fem),
                            width: 34 * fem,
                            height: 34 * fem,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(17 * fem),
                              border:
                                  Border.all(color: const Color(0xff000000)),
                              image: const DecorationImage(
                                image: AssetImage(
                                  'assets/page-1/images/ellipse-54-bg.png',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            // autogroupbfjnJGc (TqGefQnC5mGN6qnmjhBfJN)
                            width: 335.5 * fem,
                            height: double.infinity,
                            child: Stack(
                              children: [
                                Positioned(
                                  // comedyvedios20223EC (398:188)
                                  left: 1 * fem,
                                  top: 19 * fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 171 * fem,
                                      height: 20 * fem,
                                      child: Text(
                                        'Comedy Vedios  2022',
                                        textAlign: TextAlign.center,
                                        style: SafeGoogleFont(
                                          'Inter',
                                          fontSize: 16 * ffem,
                                          fontWeight: FontWeight.w600,
                                          height: 1.2125 * ffem / fem,
                                          color: const Color(0xff000000),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // newentertainmenttopfunnybestir (398:189)
                                  left: 0 * fem,
                                  top: 0 * fem,
                                  child: Align(
                                    child: SizedBox(
                                      width: 277 * fem,
                                      height: 20 * fem,
                                      child: Text(
                                        'New Entertainment Top Funny Best ',
                                        textAlign: TextAlign.center,
                                        style: SafeGoogleFont(
                                          'Inter',
                                          fontSize: 16 * ffem,
                                          fontWeight: FontWeight.w600,
                                          height: 1.2125 * ffem / fem,
                                          color: const Color(0xff000000),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // ellipsisvQDA (403:198)
                                  left: 270.5 * fem,
                                  top: 10 * fem,
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    // funnydaygRa (398:191)
                    left: 37 * fem,
                    top: 38 * fem,
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
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // mmhv (398:192)
                    left: 94 * fem,
                    top: 38 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 22 * fem,
                        height: 13 * fem,
                        child: Text(
                          '5.1M',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Inter',
                            fontSize: 10 * ffem,
                            fontWeight: FontWeight.w600,
                            height: 1.2125 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // monthsagoHAU (398:193)
                    left: 121 * fem,
                    top: 38 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 67 * fem,
                        height: 13 * fem,
                        child: Text(
                          '6 Months ago',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Inter',
                            fontSize: 10 * ffem,
                            fontWeight: FontWeight.w600,
                            height: 1.2125 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // BWk (398:194)
                    left: 88 * fem,
                    top: 29 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 5 * fem,
                        height: 20 * fem,
                        child: Text(
                          '.',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Inter',
                            fontSize: 16 * ffem,
                            fontWeight: FontWeight.w600,
                            height: 1.2125 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // Ukk (398:195)
                    left: 116 * fem,
                    top: 29 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 5 * fem,
                        height: 20 * fem,
                        child: Text(
                          '.',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Inter',
                            fontSize: 16 * ffem,
                            fontWeight: FontWeight.w600,
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
            Container(
              // autogroupoyzxZnC (TqGeoQYsKpKu4UY6MvoyZx)
              margin:
                  EdgeInsets.fromLTRB(148 * fem, 0 * fem, 153 * fem, 10 * fem),
              width: double.infinity,
              height: 32 * fem,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff000000)),
                borderRadius: BorderRadius.circular(5 * fem),
                gradient: const LinearGradient(
                  begin: Alignment(0, -1),
                  end: Alignment(0, 1),
                  colors: <Color>[Color(0xb5a27dde), Color(0xb5d6f5ff)],
                  stops: <double>[0, 1],
                ),
              ),
              child: Center(
                child: Text(
                  'Veiw All',
                  textAlign: TextAlign.center,
                  style: SafeGoogleFont(
                    'Outfit',
                    fontSize: 15 * ffem,
                    fontWeight: FontWeight.w700,
                    height: 1.26 * ffem / fem,
                    color: const Color(0xff000000),
                  ),
                ),
              ),
            ),
            Container(
              // autogroupuv2wn9A (TqGex4y6qYJtmQr2NWuV2W)
              margin:
                  EdgeInsets.fromLTRB(47.5 * fem, 0 * fem, 78 * fem, 0 * fem),
              width: double.infinity,
              height: 42 * fem,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    // autogroupwnrzhmv (TqGf84gStc8oxxHB9owNrz)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 10 * fem, 0 * fem),
                    width: 61 * fem,
                    height: 40 * fem,
                    child: Stack(
                      children: [
                        Positioned(
                          // home2JQ (359:232)
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
                          // home7qe (359:236)
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
                    // autogroupa85ucXW (TqGfDECWV4H8kYtQPYa85U)
                    width: 193.5 * fem,
                    height: double.infinity,
                    child: Stack(
                      children: [
                        Positioned(
                          // smilekNp (359:233)
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
                          // stethoscopepda (359:234)
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
                          // bellWWQ (359:235)
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
                          // mood1TA (359:237)
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
                          // therepyJBN (359:238)
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
                          // reminderaua (359:239)
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
