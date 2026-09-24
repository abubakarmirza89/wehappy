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
        // medicalhistorypageJJx (283:87)
        padding: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 87 * fem),
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/page-1/images/medical-history-page-bg.png',
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // autogroupqsjnArx (TqGswwoxGteVx7aX2HqsJN)
              padding:
                  EdgeInsets.fromLTRB(14 * fem, 32 * fem, 0 * fem, 27 * fem),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // group116Vi (359:277)
                    margin: EdgeInsets.fromLTRB(
                        5 * fem, 0 * fem, 0 * fem, 21 * fem),
                    width: double.infinity,
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [],
                    ),
                  ),
                  Container(
                    // autogroupjza64sn (TqGhkexrmHDQwJ2tQdJZA6)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 112.5 * fem, 0 * fem),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // medicalhistory7LG (349:101)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 18 * fem, 0 * fem, 0 * fem),
                          child: Text(
                            'MEDICAL HISTORY',
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              // autogroupk2htoyn (TqGiHDvFugzwgox8DKK2ht)
              width: double.infinity,
              height: 621 * fem,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // autogroupszc6Lip (TqGjxg7svaodsqvrKvszc6)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 30.5 * fem, 0 * fem),
                    height: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // autogroupvqyasCx (TqGmBok2GUCcaRCUibvqYA)
                          margin: EdgeInsets.fromLTRB(
                              5.5 * fem, 0 * fem, 0 * fem, 66 * fem),
                          width: 400 * fem,
                          height: 223 * fem,
                          child: Stack(
                            children: [
                              Positioned(
                                // line49jW4 (283:90)
                                left: 280.5001872079 * fem,
                                top: 106 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 1.01 * fem,
                                    height: 10 * fem,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // rectangle132cZr (283:66)
                                left: 16.5 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 350 * fem,
                                    height: 223 * fem,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10 * fem),
                                        border: Border.all(
                                            color: const Color(0xff000000)),
                                        gradient: const LinearGradient(
                                          begin: Alignment(-0.054, -1.17),
                                          end: Alignment(-0.054, 0.83),
                                          colors: <Color>[
                                            Color(0xffffe9e9),
                                            Color(0xffd5f5ff)
                                          ],
                                          stops: <double>[0, 1],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // line48ELL (283:107)
                                left: 253.5 * fem,
                                top: 20 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 1.01 * fem,
                                    height: 10 * fem,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xffa27dde),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // line398gc (283:108)
                                left: 202.5 * fem,
                                top: 64 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 10 * fem,
                                    height: 30 * fem,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xffa27dde),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // line55rsW (283:109)
                                left: 279.5 * fem,
                                top: 66 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 1.01 * fem,
                                    height: 10 * fem,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xffa27dde),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // janmUg (283:112)
                                left: 42.5 * fem,
                                top: 192 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 16 * fem,
                                    height: 14 * fem,
                                    child: Text(
                                      'Jan',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Exo',
                                        fontSize: 10 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.33 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // febFek (283:113)
                                left: 69.5 * fem,
                                top: 192 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 17 * fem,
                                    height: 14 * fem,
                                    child: Text(
                                      'Feb',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Exo',
                                        fontSize: 10 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.33 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // mark5i (283:114)
                                left: 94.5 * fem,
                                top: 192 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 18 * fem,
                                    height: 14 * fem,
                                    child: Text(
                                      'Mar',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Exo',
                                        fontSize: 10 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.33 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // aprSUL (283:115)
                                left: 122.5 * fem,
                                top: 192 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 17 * fem,
                                    height: 14 * fem,
                                    child: Text(
                                      'Apr',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Exo',
                                        fontSize: 10 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.33 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // may7qN (283:116)
                                left: 147.5 * fem,
                                top: 192 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 20 * fem,
                                    height: 14 * fem,
                                    child: Text(
                                      'May',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Exo',
                                        fontSize: 10 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.33 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // junRLG (283:117)
                                left: 173.5 * fem,
                                top: 192 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 16 * fem,
                                    height: 14 * fem,
                                    child: Text(
                                      'Jun',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Exo',
                                        fontSize: 10 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.33 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // jul8kU (283:118)
                                left: 200.5 * fem,
                                top: 192 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 13 * fem,
                                    height: 14 * fem,
                                    child: Text(
                                      'Jul',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Exo',
                                        fontSize: 10 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.33 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // augRzU (283:120)
                                left: 224.5 * fem,
                                top: 192 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 19 * fem,
                                    height: 14 * fem,
                                    child: Text(
                                      'Aug',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Exo',
                                        fontSize: 10 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.33 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // sepiCt (283:121)
                                left: 253.5 * fem,
                                top: 192 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 17 * fem,
                                    height: 14 * fem,
                                    child: Text(
                                      'Sep',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Exo',
                                        fontSize: 10 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.33 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // octoVE (283:122)
                                left: 278.5 * fem,
                                top: 192 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 16 * fem,
                                    height: 14 * fem,
                                    child: Text(
                                      'Oct',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Exo',
                                        fontSize: 10 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.33 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // nov6jE (283:123)
                                left: 304.5 * fem,
                                top: 192 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 18 * fem,
                                    height: 14 * fem,
                                    child: Text(
                                      'Nov',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Exo',
                                        fontSize: 10 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.33 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // decCGU (283:124)
                                left: 328.5 * fem,
                                top: 192 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 17 * fem,
                                    height: 14 * fem,
                                    child: Text(
                                      'Dec',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Exo',
                                        fontSize: 10 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.33 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // wellnessHYp (283:125)
                                left: 42.5 * fem,
                                top: 3 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 56 * fem,
                                    height: 18 * fem,
                                    child: Text(
                                      'Wellness',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Exo',
                                        fontSize: 13 * ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.33 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // historymTz (283:126)
                                left: 300.5 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 45 * fem,
                                    height: 18 * fem,
                                    child: Text(
                                      'History',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Exo',
                                        fontSize: 13 * ffem,
                                        fontWeight: FontWeight.w600,
                                        height: 1.33 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // chevrondownUNQ (283:128)
                                left: 308 * fem,
                                top: 2 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 92 * fem,
                                    height: 18 * fem,
                                    child: Text(
                                      'chevron-down',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Font Awesome 6 Free',
                                        fontSize: 14 * ffem,
                                        fontWeight: FontWeight.w900,
                                        height: 1.2575 * ffem / fem,
                                        color: const Color(0xa5000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // wavesquarexYU (297:65)
                                left: 0 * fem,
                                top: 5 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 70 * fem,
                                    height: 16 * fem,
                                    child: Text(
                                      'wave-square',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Font Awesome 6 Free',
                                        fontSize: 12 * ffem,
                                        fontWeight: FontWeight.w900,
                                        height: 1.2575 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // line38FXa (349:97)
                                left: 42.5 * fem,
                                top: 154 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 10 * fem,
                                    height: 37 * fem,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xffcaaaff),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // line36BAL (349:98)
                                left: 42.4999999747 * fem,
                                top: 60 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 0 * fem,
                                    height: 10 * fem,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xffa27dde),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // line42JVr (349:183)
                                left: 70.5 * fem,
                                top: 168 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 10 * fem,
                                    height: 23 * fem,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xffcaaaff),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // line401QG (349:186)
                                left: 98.5 * fem,
                                top: 90 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 10 * fem,
                                    height: 102 * fem,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xffcaaaff),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // line39iZa (349:184)
                                left: 98.5 * fem,
                                top: 60 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 10 * fem,
                                    height: 30 * fem,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xffa27dde),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // line74eCL (353:189)
                                left: 125.5 * fem,
                                top: 40 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 0.01 * fem,
                                    height: 10 * fem,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xffa27dde),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // line41ZaC (353:190)
                                left: 124.5000000429 * fem,
                                top: 129 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 1 * fem,
                                    height: 10 * fem,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xffcaaaff),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // line43Ux4 (353:192)
                                left: 157.5 * fem,
                                top: 174 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 0 * fem,
                                    height: 18 * fem,
                                    child: Image.asset(
                                      'assets/page-1/images/line-43.png',
                                      width: 0 * fem,
                                      height: 18 * fem,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // line46Pp8 (353:193)
                                left: 176.5 * fem,
                                top: 113 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 0.48 * fem,
                                    height: 10 * fem,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xffcaaaff),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // line477VE (353:194)
                                left: 202.5 * fem,
                                top: 79 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 10 * fem,
                                    height: 113 * fem,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xffcaaaff),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // line45qAL (353:195)
                                left: 228.5 * fem,
                                top: 182 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 10 * fem,
                                    height: 9 * fem,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xffcaaaff),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // line50vxU (353:196)
                                left: 254.5 * fem,
                                top: 109 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 10 * fem,
                                    height: 82 * fem,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xffcaaaff),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // line76SR2 (353:197)
                                left: 280.5 * fem,
                                top: 150 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 10 * fem,
                                    height: 41 * fem,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xffcaaaff),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // line52ZkY (353:198)
                                left: 306.5001872442 * fem,
                                top: 50 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 1 * fem,
                                    height: 10 * fem,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xffcaaaff),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // line775it (353:200)
                                left: 331.5001872079 * fem,
                                top: 80 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 1.01 * fem,
                                    height: 10 * fem,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xffcaaaff),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          // autogroupx3gaQWG (TqGn9MynYYYwKnhbUXX3gA)
                          width: 370 * fem,
                          height: 332 * fem,
                          child: Stack(
                            children: [
                              Positioned(
                                // rectangle135iG4 (283:92)
                                left: 212 * fem,
                                top: 202 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 155 * fem,
                                    height: 130 * fem,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xff000000)),
                                        gradient: const LinearGradient(
                                          begin: Alignment(0, -1),
                                          end: Alignment(0, 1),
                                          colors: <Color>[
                                            Color(0xffffe9e9),
                                            Color(0xffd5f5ff)
                                          ],
                                          stops: <double>[0, 1],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // rectangle136Z1n (283:93)
                                left: 25 * fem,
                                top: 202 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 162 * fem,
                                    height: 130 * fem,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xff000000)),
                                        gradient: const LinearGradient(
                                          begin: Alignment(0, -1),
                                          end: Alignment(0, 1),
                                          colors: <Color>[
                                            Color(0xffffe9e9),
                                            Color(0xffd6f5ff)
                                          ],
                                          stops: <double>[0, 1],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // steps2AG (297:63)
                                left: 53.5 * fem,
                                top: 210 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 31 * fem,
                                    height: 16 * fem,
                                    child: Text(
                                      'steps',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Exo',
                                        fontSize: 12 * ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.33 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // rectangle1347Sc (283:91)
                                left: 212 * fem,
                                top: 1 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 155 * fem,
                                    height: 189 * fem,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xff000000)),
                                        gradient: const LinearGradient(
                                          begin: Alignment(0, -1),
                                          end: Alignment(0, 1),
                                          colors: <Color>[
                                            Color(0xffffe9e9),
                                            Color(0xffd5f5ff)
                                          ],
                                          stops: <double>[0, 1],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // rectangle138nYk (295:58)
                                left: 239 * fem,
                                top: 229 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 102 * fem,
                                    height: 80 * fem,
                                    child: Image.asset(
                                      'assets/page-1/images/rectangle-138.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // group12WDr (343:31)
                                left: 0 * fem,
                                top: 0 * fem,
                                child: SizedBox(
                                  width: 258 * fem,
                                  height: 332 * fem,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        // autogroupkpx4Efe (TqGntRaNFncs5EQmkqKPX4)
                                        margin: EdgeInsets.fromLTRB(
                                            0 * fem, 0 * fem, 9 * fem, 0 * fem),
                                        width: 215 * fem,
                                        height: double.infinity,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              // rectangle133YRS (283:89)
                                              left: 24 * fem,
                                              top: 0 * fem,
                                              child: Align(
                                                child: SizedBox(
                                                  width: 162 * fem,
                                                  height: 189 * fem,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xff000000)),
                                                      gradient:
                                                          const LinearGradient(
                                                        begin: Alignment(0, -1),
                                                        end: Alignment(0, 1),
                                                        colors: <Color>[
                                                          Color(0xffffe9e9),
                                                          Color(0xffd5f5ff)
                                                        ],
                                                        stops: <double>[0, 1],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              // caloriesCkt (292:48)
                                              left: 49.5 * fem,
                                              top: 8 * fem,
                                              child: Align(
                                                child: SizedBox(
                                                  width: 46 * fem,
                                                  height: 16 * fem,
                                                  child: Text(
                                                    ' Calories',
                                                    textAlign: TextAlign.center,
                                                    style: SafeGoogleFont(
                                                      'Exo',
                                                      fontSize: 12 * ffem,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      height: 1.33 * ffem / fem,
                                                      color: const Color(
                                                          0xff000000),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              // fireUiQ (292:50)
                                              left: 31 * fem,
                                              top: 6 * fem,
                                              child: Align(
                                                child: SizedBox(
                                                  width: 24 * fem,
                                                  height: 19 * fem,
                                                  child: Text(
                                                    'fire',
                                                    textAlign: TextAlign.center,
                                                    style: SafeGoogleFont(
                                                      'Font Awesome 5 Free',
                                                      fontSize: 15 * ffem,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      height:
                                                          1.2575 * ffem / fem,
                                                      color: const Color(
                                                          0xfffd6100),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              // frame2mxQ (292:10)
                                              left: 36.2374773305 * fem,
                                              top: 31.000018239 * fem,
                                              child: SizedBox(
                                                width: 134.38 * fem,
                                                height: 155.51 * fem,
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                      // ellipse36h5N (292:12)
                                                      left: 8.7624777723 * fem,
                                                      top: 4.999981761 * fem,
                                                      child: Align(
                                                        child: SizedBox(
                                                          width: 121.15 * fem,
                                                          height: 121.15 * fem,
                                                          child: Image.asset(
                                                            'assets/page-1/images/ellipse-36-HpQ.png',
                                                            width: 121.15 * fem,
                                                            height:
                                                                121.15 * fem,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      // ellipse37QEg (292:47)
                                                      left: 2.7627238948 * fem,
                                                      top: 0 * fem,
                                                      child: Align(
                                                        child: SizedBox(
                                                          width: 131.62 * fem,
                                                          height: 131.62 * fem,
                                                          child: Image.asset(
                                                            'assets/page-1/images/ellipse-37.png',
                                                            width: 131.62 * fem,
                                                            height:
                                                                131.62 * fem,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      // kcalhzU (292:49)
                                                      left: 0 * fem,
                                                      top: 128.5138302259 * fem,
                                                      child: Align(
                                                        child: SizedBox(
                                                          width: 59 * fem,
                                                          height: 18 * fem,
                                                          child: Text(
                                                            '1280 Kcal',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                SafeGoogleFont(
                                                              'Exo',
                                                              fontSize:
                                                                  13 * ffem,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              height: 1.33 *
                                                                  ffem /
                                                                  fem,
                                                              color: const Color(
                                                                  0xff000000),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      // kcalQP6 (292:51)
                                                      left: 30.0428105704 * fem,
                                                      top: 55.4455628917 * fem,
                                                      child: Align(
                                                        child: SizedBox(
                                                          width: 78 * fem,
                                                          height: 27 * fem,
                                                          child: Text(
                                                            '410 Kcal',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                SafeGoogleFont(
                                                              'Exo',
                                                              fontSize:
                                                                  20 * ffem,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              height: 1.33 *
                                                                  ffem /
                                                                  fem,
                                                              color: const Color(
                                                                  0xff000000),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      // dailyratesVQY (292:52)
                                                      left: 0.9285382945 * fem,
                                                      top: 141.5138367414 * fem,
                                                      child: Align(
                                                        child: SizedBox(
                                                          width: 53 * fem,
                                                          height: 14 * fem,
                                                          child: Text(
                                                            'Daily rates',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                SafeGoogleFont(
                                                              'Outfit',
                                                              fontSize:
                                                                  11 * ffem,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              height: 1.26 *
                                                                  ffem /
                                                                  fem,
                                                              color: const Color(
                                                                  0xffcaaaff),
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
                                              // rectangle139Ama (297:59)
                                              left: 0 * fem,
                                              top: 175 * fem,
                                              child: Align(
                                                child: SizedBox(
                                                  width: 215 * fem,
                                                  height: 157 * fem,
                                                  child: Image.asset(
                                                    'assets/page-1/images/rectangle-139.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              // shoeprints69S (297:62)
                                              left: 36.4999688528 * fem,
                                              top: 208.8755423796 * fem,
                                              child: Align(
                                                child: SizedBox(
                                                  width: 17 * fem,
                                                  height: 91 * fem,
                                                  child: Text(
                                                    'shoe-prints____',
                                                    textAlign: TextAlign.center,
                                                    style: SafeGoogleFont(
                                                      'Font Awesome 6 Free',
                                                      fontSize: 12 * ffem,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      height:
                                                          1.2575 * ffem / fem,
                                                      color: const Color(
                                                          0xff000000),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              // stepsN6x (329:2)
                                              left: 32 * fem,
                                              top: 315 * fem,
                                              child: Align(
                                                child: SizedBox(
                                                  width: 63 * fem,
                                                  height: 16 * fem,
                                                  child: Text(
                                                    '8792 Steps',
                                                    style: SafeGoogleFont(
                                                      'Exo',
                                                      fontSize: 12 * ffem,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      height: 1.33 * ffem / fem,
                                                      color: const Color(
                                                          0xff000000),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        // autogroupybd83yn (TqGoCR4PYuWKEQbFAMybd8)
                                        margin: EdgeInsets.fromLTRB(0 * fem,
                                            33 * fem, 0 * fem, 0 * fem),
                                        width: 34 * fem,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              // autogroupzociBKJ (TqGoqPzmYefQfiJ73wzoci)
                                              padding: EdgeInsets.fromLTRB(
                                                  5 * fem,
                                                  0 * fem,
                                                  0 * fem,
                                                  1.68 * fem),
                                              width: double.infinity,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    // autogrouplj1kVqn (TqGoNAH9kbVBeiBvB2LJ1k)
                                                    margin: EdgeInsets.fromLTRB(
                                                        3 * fem,
                                                        0 * fem,
                                                        2 * fem,
                                                        0 * fem),
                                                    width: double.infinity,
                                                    height: 70 * fem,
                                                    child: SizedBox(
                                                      // autogroupacye2Kv (TqGoVjtraMUJeHD7BYAcYE)
                                                      width: 19 * fem,
                                                      height: double.infinity,
                                                    ),
                                                  ),
                                                  Container(
                                                    // line60xjN (343:7)
                                                    margin: EdgeInsets.fromLTRB(
                                                        0 * fem,
                                                        0 * fem,
                                                        7 * fem,
                                                        45 * fem),
                                                    width: 0 * fem,
                                                    height: 5 * fem,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color(0xffa27dde),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    // autogroupzldlFyN (TqGodQLkga57EGB87bZLDL)
                                                    width: double.infinity,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          // monojz (343:22)
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  0 * fem,
                                                                  0 * fem,
                                                                  9 * fem,
                                                                  0 * fem),
                                                          child: Text(
                                                            'Mon',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                SafeGoogleFont(
                                                              'Inter',
                                                              fontSize:
                                                                  5 * ffem,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              height: 1.2125 *
                                                                  ffem /
                                                                  fem,
                                                              color: const Color(
                                                                  0xff000000),
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          // tueirx (343:23)
                                                          'Tue',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: SafeGoogleFont(
                                                            'Inter',
                                                            fontSize: 5 * ffem,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            height: 1.2125 *
                                                                ffem /
                                                                fem,
                                                            color: const Color(
                                                                0xff000000),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              // autogroupsgsgTpY (TqGoipMQ8Q4Uo6cq7xsGsg)
                                              width: double.infinity,
                                              height: 28.32 * fem,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    // hoursDHv (343:32)
                                                    left: 0 * fem,
                                                    top: 12.3155094832 * fem,
                                                    child: Align(
                                                      child: SizedBox(
                                                        width: 34 * fem,
                                                        height: 16 * fem,
                                                        child: Text(
                                                          'Hours',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: SafeGoogleFont(
                                                            'Exo',
                                                            fontSize: 12 * ffem,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            height: 1.33 *
                                                                ffem /
                                                                fem,
                                                            color: const Color(
                                                                0xffcaaaff),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    // 6cc (343:30)
                                                    left: 0.2376992088 * fem,
                                                    top: 0 * fem,
                                                    child: Align(
                                                      child: SizedBox(
                                                        width: 20 * fem,
                                                        height: 18 * fem,
                                                        child: Text(
                                                          '8.5',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: SafeGoogleFont(
                                                            'Exo',
                                                            fontSize: 13 * ffem,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            height: 1.33 *
                                                                ffem /
                                                                fem,
                                                            color: const Color(
                                                                0xff000000),
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
                              ),
                              Positioned(
                                // heartrateoG8 (297:60)
                                left: 233 * fem,
                                top: 209 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 56 * fem,
                                    height: 16 * fem,
                                    child: Text(
                                      'heart rate',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Exo',
                                        fontSize: 12 * ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.33 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // heart5zL (297:66)
                                left: 210 * fem,
                                top: 210 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 30 * fem,
                                    height: 16 * fem,
                                    child: Text(
                                      'heart',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Font Awesome 6 Free',
                                        fontSize: 12 * ffem,
                                        fontWeight: FontWeight.w900,
                                        height: 1.2575 * ffem / fem,
                                        color: const Color(0xffde1919),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // bpmBnU (329:3)
                                left: 222 * fem,
                                top: 311 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 48 * fem,
                                    height: 18 * fem,
                                    child: Text(
                                      '60 Bpm',
                                      style: SafeGoogleFont(
                                        'Exo',
                                        fontSize: 13 * ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.33 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // line62svC (343:9)
                                left: 265.9999999558 * fem,
                                top: 44 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 0 * fem,
                                    height: 5 * fem,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xffa27dde),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // line63o3A (343:10)
                                left: 266 * fem,
                                top: 33 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 5 * fem,
                                    height: 11 * fem,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xb5caaaff),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // line66ifv (343:13)
                                left: 284.9999999538 * fem,
                                top: 134 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 0 * fem,
                                    height: 5 * fem,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xffa27dde),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // line67FA4 (343:14)
                                left: 302.9999999538 * fem,
                                top: 93 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 0 * fem,
                                    height: 5 * fem,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xffa27dde),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // line68A28 (343:15)
                                left: 321 * fem,
                                top: 33 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 1 * fem,
                                    height: 5 * fem,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xff8749ec),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // line70V4Q (343:18)
                                left: 285 * fem,
                                top: 64 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 5 * fem,
                                    height: 70 * fem,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xb5caaaff),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // line71QBN (343:19)
                                left: 303 * fem,
                                top: 33 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 5 * fem,
                                    height: 60 * fem,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xb5caaaff),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // line728dA (343:20)
                                left: 342 * fem,
                                top: 33 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 5 * fem,
                                    height: 68 * fem,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xb5caaaff),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // line73rJG (343:21)
                                left: 342 * fem,
                                top: 101 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 5 * fem,
                                    height: 51 * fem,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xffa27dde),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // wedNXW (343:24)
                                left: 263 * fem,
                                top: 154 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 11 * fem,
                                    height: 7 * fem,
                                    child: Text(
                                      'Wed',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Inter',
                                        fontSize: 5 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.2125 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // thru5B2 (343:25)
                                left: 282 * fem,
                                top: 154 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 11 * fem,
                                    height: 7 * fem,
                                    child: Text(
                                      'Thru',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Inter',
                                        fontSize: 5 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.2125 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // friaNg (343:26)
                                left: 303 * fem,
                                top: 154 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 6 * fem,
                                    height: 7 * fem,
                                    child: Text(
                                      'Fri',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Inter',
                                        fontSize: 5 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.2125 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // sunssa (343:27)
                                left: 340 * fem,
                                top: 154 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 10 * fem,
                                    height: 7 * fem,
                                    child: Text(
                                      'Sun',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Inter',
                                        fontSize: 5 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.2125 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // satB7a (343:28)
                                left: 321 * fem,
                                top: 154 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 8 * fem,
                                    height: 7 * fem,
                                    child: Text(
                                      'Sat',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Inter',
                                        fontSize: 5 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.2125 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // sleepUkt (343:29)
                                left: 236 * fem,
                                top: 8 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 31 * fem,
                                    height: 16 * fem,
                                    child: Text(
                                      'Sleep',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Exo',
                                        fontSize: 12 * ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.33 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // moonxg4 (343:33)
                                left: 208 * fem,
                                top: 8 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 39 * fem,
                                    height: 19 * fem,
                                    child: Text(
                                      'moon',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
