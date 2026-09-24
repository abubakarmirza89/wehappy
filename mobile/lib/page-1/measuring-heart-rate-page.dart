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
        // measuringheartratepageurt (343:3)
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/page-1/images/measuring-heart-rate-page-bg.png',
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // autogroupey6noSU (TqJSGMKTNxwKM49mJhey6n)
              padding: EdgeInsets.fromLTRB(0 * fem, 32 * fem, 0 * fem, 9 * fem),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // group11WLt (359:297)
                    margin: EdgeInsets.fromLTRB(
                        25 * fem, 0 * fem, 0 * fem, 27 * fem),
                    width: double.infinity,
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [],
                    ),
                  ),
                  Container(
                    // autogroupwscahCQ (TqJQUQJfEH9NspSbBeWscA)
                    margin: EdgeInsets.fromLTRB(
                        17 * fem, 0 * fem, 89 * fem, 12 * fem),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // measuringheartrateYTv (373:35)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 4 * fem, 0 * fem, 0 * fem),
                          child: Text(
                            'Measuring Heart Rate',
                            textAlign: TextAlign.center,
                            style: SafeGoogleFont(
                              'Outfit',
                              fontSize: 24 * ffem,
                              fontWeight: FontWeight.w500,
                              height: 1.26 * ffem / fem,
                              color: const Color(0xff000000),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    // autogroupqyijeWx (TqJQgEJHXSWK8SfvGuqYiJ)
                    width: 394 * fem,
                    height: 315 * fem,
                    child: Stack(
                      children: [
                        Positioned(
                          // ellipse49n7N (372:26)
                          left: 93 * fem,
                          top: 27 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 204 * fem,
                              height: 209 * fem,
                              child: Image.asset(
                                'assets/page-1/images/ellipse-49.png',
                                width: 204 * fem,
                                height: 209 * fem,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // ellipse50UVz (372:27)
                          left: 90 * fem,
                          top: 0 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 202 * fem,
                              height: 200 * fem,
                              child: Image.asset(
                                'assets/page-1/images/ellipse-50.png',
                                width: 202 * fem,
                                height: 200 * fem,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // ellipse51BvC (373:29)
                          left: 106 * fem,
                          top: 13 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 170 * fem,
                              height: 173 * fem,
                              child: Image.asset(
                                'assets/page-1/images/ellipse-51.png',
                                width: 170 * fem,
                                height: 173 * fem,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // htY (373:30)
                          left: 171 * fem,
                          top: 82 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 39 * fem,
                              height: 46 * fem,
                              child: Text(
                                '76',
                                textAlign: TextAlign.center,
                                style: SafeGoogleFont(
                                  'Font Awesome 6 Free',
                                  fontSize: 36 * ffem,
                                  fontWeight: FontWeight.w900,
                                  height: 1.2575 * ffem / fem,
                                  color: const Color(0xff000000),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // bpmCqJ (373:31)
                          left: 172.5 * fem,
                          top: 132 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 40 * fem,
                              height: 26 * fem,
                              child: Text(
                                'BPM',
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
                          // measuringbpmuji (373:32)
                          left: 145 * fem,
                          top: 294 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 111 * fem,
                              height: 21 * fem,
                              child: Text(
                                'Measuring BPM',
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
                          // fingerprintDEc (373:33)
                          left: 0 * fem,
                          top: 230 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 394 * fem,
                              height: 81 * fem,
                              child: Text(
                                'FINGERPRINT',
                                textAlign: TextAlign.center,
                                style: SafeGoogleFont(
                                  'Font Awesome 6 Free',
                                  fontSize: 64 * ffem,
                                  fontWeight: FontWeight.w900,
                                  height: 1.2575 * ffem / fem,
                                  color: const Color(0xff000000),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          // heartiBN (373:34)
                          left: 118 * fem,
                          top: 33 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 144 * fem,
                              height: 61 * fem,
                              child: Text(
                                'HEART',
                                textAlign: TextAlign.center,
                                style: SafeGoogleFont(
                                  'Font Awesome 6 Free',
                                  fontSize: 48 * ffem,
                                  fontWeight: FontWeight.w900,
                                  height: 1.2575 * ffem / fem,
                                  color: const Color(0xfff51818),
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
            SizedBox(
              // autogroupbpa2R5n (TqJQtomfNjQPinQgg5BpA2)
              width: double.infinity,
              height: 272 * fem,
              child: Stack(
                children: [
                  Positioned(
                    // rectangle168ZSt (363:332)
                    left: 0 * fem,
                    top: 0 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 393 * fem,
                        height: 248 * fem,
                        child: Image.asset(
                          'assets/page-1/images/rectangle-168.png',
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // averagefVv (363:333)
                    left: 23 * fem,
                    top: 239 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 90 * fem,
                        height: 31 * fem,
                        child: Text(
                          'Average',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 24 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // minimummJ4 (363:334)
                    left: 142 * fem,
                    top: 240 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 99 * fem,
                        height: 31 * fem,
                        child: Text(
                          'Minimum',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 24 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // maximumTwa (363:335)
                    left: 271 * fem,
                    top: 241 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 106 * fem,
                        height: 31 * fem,
                        child: Text(
                          'Maximum',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 24 * ffem,
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
              // autogrouple6sZji (TqJSoAmSNkZtsouUt2Le6S)
              padding:
                  EdgeInsets.fromLTRB(50 * fem, 10 * fem, 43 * fem, 6 * fem),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // autogroupqimcHQp (TqJR3Z26Av1528fScCqimC)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 0 * fem, 17 * fem),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // autogroupqrqi1rc (TqJRCt5sxJuXUNXz19QRQi)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 78 * fem, 0 * fem),
                          width: 36 * fem,
                          height: 53 * fem,
                          child: Stack(
                            children: [
                              Positioned(
                                // Ldz (363:337)
                                left: 0 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 35 * fem,
                                    height: 41 * fem,
                                    child: Text(
                                      '78',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Outfit',
                                        fontSize: 32 * ffem,
                                        fontWeight: FontWeight.w800,
                                        height: 1.26 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // bpmFW4 (363:340)
                                left: 3 * fem,
                                top: 32 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 33 * fem,
                                    height: 21 * fem,
                                    child: Text(
                                      'BPM',
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
                            ],
                          ),
                        ),
                        Container(
                          // autogrouptb8zx9a (TqJRHDHziAu2Kqgx1STB8z)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 77 * fem, 0 * fem),
                          width: 53 * fem,
                          height: 54 * fem,
                          child: Stack(
                            children: [
                              Positioned(
                                // V9W (363:338)
                                left: 0 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 53 * fem,
                                    height: 41 * fem,
                                    child: Text(
                                      '108',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Outfit',
                                        fontSize: 32 * ffem,
                                        fontWeight: FontWeight.w800,
                                        height: 1.26 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // bpmbCY (363:341)
                                left: 11 * fem,
                                top: 33 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 33 * fem,
                                    height: 21 * fem,
                                    child: Text(
                                      'BPM',
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
                            ],
                          ),
                        ),
                        Container(
                          // autogrouprkkzgzg (TqJRN3VHAnacjnWsYzrKkz)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 1 * fem, 0 * fem, 0 * fem),
                          width: 56 * fem,
                          height: 54 * fem,
                          child: Stack(
                            children: [
                              Positioned(
                                // Dzc (363:339)
                                left: 0 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 56 * fem,
                                    height: 41 * fem,
                                    child: Text(
                                      '245',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Outfit',
                                        fontSize: 32 * ffem,
                                        fontWeight: FontWeight.w800,
                                        height: 1.26 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // bpmji4 (363:342)
                                left: 12 * fem,
                                top: 33 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 33 * fem,
                                    height: 21 * fem,
                                    child: Text(
                                      'BPM',
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // autogroupgcpnFRW (TqJRZHfYUjdmqX8RBTGCpn)
                    margin: EdgeInsets.fromLTRB(
                        7.5 * fem, 0 * fem, 28 * fem, 0 * fem),
                    width: double.infinity,
                    height: 42 * fem,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          // autogroupbjn2nRS (TqJRj7iVxtEKrEfv7fBJN2)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 10 * fem, 0 * fem),
                          width: 61 * fem,
                          height: 40 * fem,
                          child: Stack(
                            children: [
                              Positioned(
                                // homeiZz (359:256)
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
                                // homeQxc (359:260)
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
                          // autogrouphynaK3z (TqJRyMomVMS4JqKCyhhYnA)
                          width: 193.5 * fem,
                          height: double.infinity,
                          child: Stack(
                            children: [
                              Positioned(
                                // smileerx (359:257)
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
                                // stethoscopeXvk (359:258)
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
                                // bellS28 (359:259)
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
                                // moodwUg (359:261)
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
                                // therepyeP6 (359:262)
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
                                // reminder9ak (359:263)
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
          ],
        ),
      ),
    );
  }
}
