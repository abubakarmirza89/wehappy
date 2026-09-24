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
        // musicpage02XjS (228:180)
        width: double.infinity,
        height: 852 * fem,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10 * fem),
          image: const DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/page-1/images/music-page-02-bg.png',
            ),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              // rectangle129Etk (738:6)
              left: 0 * fem,
              top: 306 * fem,
              child: Container(
                padding:
                    EdgeInsets.fromLTRB(20 * fem, 20 * fem, 20 * fem, 20 * fem),
                width: 401 * fem,
                height: 608 * fem,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff9747ff)),
                  borderRadius: BorderRadius.circular(5 * fem),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // property1defaultWbN (738:5)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 20 * fem),
                      width: double.infinity,
                      child: Center(
                        // rectangle129eSg (228:184)
                        child: SizedBox(
                          width: double.infinity,
                          height: 274 * fem,
                          child: Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xff000000)),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30 * fem),
                                topRight: Radius.circular(30 * fem),
                              ),
                              gradient: const LinearGradient(
                                begin: Alignment(0, -1),
                                end: Alignment(0, 1),
                                colors: <Color>[
                                  Color(0xffd6f5ff),
                                  Color(0x00d6f5ff)
                                ],
                                stops: <double>[0.089, 0.844],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x3f000000),
                                  offset: Offset(0 * fem, 4 * fem),
                                  blurRadius: 2 * fem,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // property1variant2Gix (738:7)
                      padding: EdgeInsets.fromLTRB(
                          1 * fem, 0 * fem, 0 * fem, 0 * fem),
                      width: double.infinity,
                      height: 274 * fem,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff000000)),
                        gradient: const LinearGradient(
                          begin: Alignment(0, -1),
                          end: Alignment(0, 1),
                          colors: <Color>[Color(0xffd6f5ff), Color(0x00d6f5ff)],
                          stops: <double>[0.089, 0.844],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30 * fem),
                          topRight: Radius.circular(30 * fem),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x3f000000),
                            offset: Offset(0 * fem, 4 * fem),
                            blurRadius: 2 * fem,
                          ),
                        ],
                      ),
                      child: Align(
                        // rectangle130hJU (241:4)
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          width: 360.55 * fem,
                          height: 201.12 * fem,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10 * fem),
                              border:
                                  Border.all(color: const Color(0xff000000)),
                              gradient: const LinearGradient(
                                begin: Alignment(0, -1),
                                end: Alignment(0, 1),
                                colors: <Color>[
                                  Color(0xffffe9e9),
                                  Color(0x00ffe9e9)
                                ],
                                stops: <double>[0, 1],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x3f000000),
                                  offset: Offset(0 * fem, 4 * fem),
                                  blurRadius: 2 * fem,
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
            Positioned(
              // autogroupermt9gG (TqJ8HHT8gNZa8wQVPmErmt)
              left: 0 * fem,
              top: 0 * fem,
              child: Container(
                padding:
                    EdgeInsets.fromLTRB(0 * fem, 48 * fem, 0 * fem, 9 * fem),
                width: 425.5 * fem,
                height: 401 * fem,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      'assets/page-1/images/rectangle-128-bg.png',
                    ),
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20 * fem),
                    topRight: Radius.circular(20 * fem),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // autogroup2j4znUL (TqJ8Vn6KFCqy8sCRsP2j4z)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 5.5 * fem, 74 * fem),
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // arrowleftJha (228:186)
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 202 * fem, 0 * fem),
                            child: Text(
                              'arrow-left',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Font Awesome 5 Free',
                                fontSize: 32 * ffem,
                                fontWeight: FontWeight.w900,
                                height: 1.2575 * ffem / fem,
                                color: const Color(0xffd6f5ff),
                              ),
                            ),
                          ),
                          Text(
                            // heartbgg (228:185)
                            'heart',
                            textAlign: TextAlign.center,
                            style: SafeGoogleFont(
                              'Font Awesome 5 Free',
                              fontSize: 32 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.2575 * ffem / fem,
                              color: const Color(0xffd5f5ff),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // relaxationofanxity8wW (228:182)
                      margin: EdgeInsets.fromLTRB(
                          32.5 * fem, 0 * fem, 0 * fem, 15 * fem),
                      child: Text(
                        'Relaxation of Anxity ',
                        textAlign: TextAlign.center,
                        style: SafeGoogleFont(
                          'Outfit',
                          fontSize: 32 * ffem,
                          fontWeight: FontWeight.w900,
                          height: 1.26 * ffem / fem,
                          color: const Color(0xffd6f5ff),
                        ),
                      ),
                    ),
                    Container(
                      // relax3tracksbyarinagrandeShJ (228:183)
                      margin: EdgeInsets.fromLTRB(
                          32.5 * fem, 0 * fem, 0 * fem, 137 * fem),
                      child: Text(
                        'Relax / 3 tracks/ by Arina Grande',
                        textAlign: TextAlign.center,
                        style: SafeGoogleFont(
                          'Outfit',
                          fontSize: 24 * ffem,
                          fontWeight: FontWeight.w700,
                          height: 1.26 * ffem / fem,
                          color: const Color(0xffd5f5ff),
                        ),
                      ),
                    ),
                    Container(
                      // line309Lp (243:26)
                      margin: EdgeInsets.fromLTRB(
                          209.5 * fem, 0 * fem, 192 * fem, 0 * fem),
                      width: double.infinity,
                      height: 5 * fem,
                      decoration: const BoxDecoration(
                        color: Color(0xffcaaaff),
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
