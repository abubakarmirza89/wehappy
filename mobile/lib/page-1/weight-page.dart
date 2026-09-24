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
        // weightpageFCQ (341:2)
        padding: EdgeInsets.fromLTRB(13 * fem, 32 * fem, 0 * fem, 8 * fem),
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/page-1/images/weight-page-bg.png',
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // group11uXr (359:302)
              margin: EdgeInsets.fromLTRB(12 * fem, 0 * fem, 0 * fem, 18 * fem),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // pmcx4 (359:303)
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
                    // autogroup6ulaikC (TqJP8MiNLJgjvyiPAp6uLa)
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 1 * fem, 0 * fem, 0 * fem),
                    width: 131 * fem,
                    height: 19 * fem,
                    child: Stack(
                      children: [
                        Positioned(
                          // signal3Gg (359:304)
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
                          // wifivrG (359:305)
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
                          // batteryfullqCY (359:306)
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
              // autogroupqvbkKdW (TqJJca4uS34C7PhSdfQVBk)
              margin:
                  EdgeInsets.fromLTRB(0 * fem, 0 * fem, 151 * fem, 15 * fem),
              width: 223 * fem,
              height: 101 * fem,
              child: Stack(
                children: [
                  Positioned(
                    // weightpqA (376:49)
                    left: 121 * fem,
                    top: 0 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 102 * fem,
                        height: 41 * fem,
                        child: Text(
                          'Weight',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 32 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // currentweightvNQ (376:51)
                    left: 33 * fem,
                    top: 40 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 109 * fem,
                        height: 21 * fem,
                        child: Text(
                          'Current Weight',
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
                    // pya (376:52)
                    left: 61 * fem,
                    top: 60 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 81 * fem,
                        height: 41 * fem,
                        child: Text(
                          '70.33',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 32 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // kgLBE (376:53)
                    left: 145 * fem,
                    top: 74 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 20 * fem,
                        height: 21 * fem,
                        child: Text(
                          'Kg',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 16 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xffcaaaff),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // weightEGc (376:60)
                    left: 4 * fem,
                    top: 69 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 76 * fem,
                        height: 31 * fem,
                        child: Text(
                          'weight',
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
                    // barsKYx (388:334)
                    left: 0 * fem,
                    top: 6 * fem,
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
            Container(
              // autogroupd5vecnx (TqJJwUh4rCi9o7H1CBD5ve)
              margin:
                  EdgeInsets.fromLTRB(16 * fem, 0 * fem, 46.5 * fem, 23 * fem),
              width: double.infinity,
              height: 30 * fem,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // autogrouprgeswKS (TqJKJPFu5P8VijYPukRGES)
                    padding: EdgeInsets.fromLTRB(
                        0 * fem, 4 * fem, 5.5 * fem, 5 * fem),
                    height: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // weeksD6 (376:54)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 6.5 * fem, 0 * fem),
                          child: Text(
                            '1 week       ',
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
                        Text(
                          // weekBUg (376:55)
                          '2 week       ',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 16 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // autogroupyvruvSG (TqJKCtR4M6XSZV9ryqYvRU)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 4.5 * fem, 0 * fem),
                    width: 79 * fem,
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
                        '3week       ',
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
                    // monthLF6 (376:57)
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 3 * fem),
                    child: Text(
                      '1 month       ',
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
                ],
              ),
            ),
            Container(
              // line78SZ2 (376:40)
              margin:
                  EdgeInsets.fromLTRB(0 * fem, 0 * fem, 278 * fem, 28 * fem),
              width: 0 * fem,
              height: 3 * fem,
              decoration: const BoxDecoration(
                color: Color(0xffa27dde),
              ),
            ),
            Container(
              // autogroup5aqcy3A (TqJKT8WKsZjB25o9qt5Aqc)
              margin:
                  EdgeInsets.fromLTRB(23 * fem, 0 * fem, 68 * fem, 28 * fem),
              width: double.infinity,
              height: 186 * fem,
              child: Stack(
                children: [
                  Positioned(
                    // line79VGQ (376:41)
                    left: 28 * fem,
                    top: 171 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 261 * fem,
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
                    // rectangle175b4Y (376:42)
                    left: 2 * fem,
                    top: 0 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 250 * fem,
                        height: 186 * fem,
                        child: Image.asset(
                          'assets/page-1/images/rectangle-175.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // Jje (376:43)
                    left: 0 * fem,
                    top: 58 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 16 * fem,
                        height: 17 * fem,
                        child: Text(
                          '60',
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
                    // owJ (376:44)
                    left: 0 * fem,
                    top: 82 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 16 * fem,
                        height: 17 * fem,
                        child: Text(
                          '50',
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
                    // K8x (376:45)
                    left: 1 * fem,
                    top: 107 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 17 * fem,
                        height: 17 * fem,
                        child: Text(
                          '40',
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
                    // Dk8 (376:47)
                    left: 2 * fem,
                    top: 130 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 16 * fem,
                        height: 17 * fem,
                        child: Text(
                          '30',
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
                    // 86Q (376:48)
                    left: 2 * fem,
                    top: 154 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 16 * fem,
                        height: 17 * fem,
                        child: Text(
                          '20',
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
                ],
              ),
            ),
            Container(
              // autogroupunrzEfE (TqJKjxMdCG14sUk4Knunrz)
              margin: EdgeInsets.fromLTRB(6 * fem, 0 * fem, 26 * fem, 5 * fem),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // goalsB4g (378:82)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 251 * fem, 0 * fem),
                    child: Text(
                      'Goals',
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
                  Container(
                    // seealltUt (378:80)
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 3 * fem, 0 * fem, 0 * fem),
                    child: Text(
                      'See All',
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont(
                        'Outfit',
                        fontSize: 15 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.26 * ffem / fem,
                        color: const Color(0xffa27dde),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // autogroupxr6aQi8 (TqJKyXoLT4HLampjoUxr6A)
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 16 * fem, 28 * fem),
              height: 85 * fem,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // autogroupxrhgjEc (TqJLLwMLNzPn4sm64KXRHg)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 10 * fem, 0 * fem),
                    padding:
                        EdgeInsets.fromLTRB(6 * fem, 7 * fem, 6 * fem, 6 * fem),
                    width: 114 * fem,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // weightZjS (378:69)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 8 * fem, 6 * fem),
                          child: Text(
                            'weight',
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
                        Container(
                          // autogroupolfyg3N (TqJLUS8qvHmDU2qT9HoLfY)
                          margin: EdgeInsets.fromLTRB(
                              22 * fem, 0 * fem, 10 * fem, 1 * fem),
                          width: double.infinity,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // zJx (378:71)
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 0 * fem, 2 * fem, 0 * fem),
                                child: Text(
                                  '70.33',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Outfit',
                                    fontSize: 20 * ffem,
                                    fontWeight: FontWeight.w700,
                                    height: 1.26 * ffem / fem,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                              Container(
                                // kg6sn (378:74)
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 1 * fem, 0 * fem, 0 * fem),
                                child: Text(
                                  'kg',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Outfit',
                                    fontSize: 15 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.26 * ffem / fem,
                                    color: const Color(0xffa27dde),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          // startweightDhW (378:77)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 25 * fem, 0 * fem),
                          child: Text(
                            'Start weight',
                            textAlign: TextAlign.center,
                            style: SafeGoogleFont(
                              'Outfit',
                              fontSize: 14 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.26 * ffem / fem,
                              color: const Color(0xffa27dde),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // autogroupiscnXiC (TqJLeGBoQSMmUkNx5ViSCn)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 12 * fem, 0 * fem),
                    padding:
                        EdgeInsets.fromLTRB(8 * fem, 7 * fem, 8 * fem, 6 * fem),
                    width: 114 * fem,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // dumbbellAmA (376:68)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 4 * fem, 8 * fem),
                          child: Text(
                            'dumbbell',
                            textAlign: TextAlign.center,
                            style: SafeGoogleFont(
                              'Font Awesome 6 Free',
                              fontSize: 16 * ffem,
                              fontWeight: FontWeight.w900,
                              height: 1.2575 * ffem / fem,
                              color: const Color(0xfff51818),
                            ),
                          ),
                        ),
                        Container(
                          // autogroupcmqyV2k (TqJLmLpLXSenuqjBYkCMqY)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 12 * fem, 0 * fem),
                          width: 86 * fem,
                          height: 43 * fem,
                          child: Stack(
                            children: [
                              Positioned(
                                // oJL (378:72)
                                left: 35 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 25 * fem,
                                    height: 26 * fem,
                                    child: Text(
                                      '60',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Outfit',
                                        fontSize: 20 * ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.26 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // kgh8p (378:75)
                                left: 61 * fem,
                                top: 4 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 16 * fem,
                                    height: 19 * fem,
                                    child: Text(
                                      'kg',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Outfit',
                                        fontSize: 15 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.26 * ffem / fem,
                                        color: const Color(0xffa27dde),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // targetweightCrG (378:78)
                                left: 0 * fem,
                                top: 25 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 86 * fem,
                                    height: 18 * fem,
                                    child: Text(
                                      'Target weight',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Outfit',
                                        fontSize: 14 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.26 * ffem / fem,
                                        color: const Color(0xffa27dde),
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
                    // autogroupm3yg7TS (TqJLwWC59Ri5JD3zB8M3yG)
                    padding:
                        EdgeInsets.fromLTRB(8 * fem, 7 * fem, 5 * fem, 6 * fem),
                    width: 114 * fem,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // firemH6 (378:70)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 3 * fem, 8 * fem),
                          child: Text(
                            'fire',
                            textAlign: TextAlign.center,
                            style: SafeGoogleFont(
                              'Font Awesome 5 Free',
                              fontSize: 16 * ffem,
                              fontWeight: FontWeight.w900,
                              height: 1.2575 * ffem / fem,
                              color: const Color(0xffa27dde),
                            ),
                          ),
                        ),
                        SizedBox(
                          // autogroupvbzg52t (TqJM411FHDhKaQnSBZvBZg)
                          width: double.infinity,
                          height: 43 * fem,
                          child: Stack(
                            children: [
                              Positioned(
                                // R6k (378:73)
                                left: 19 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 55 * fem,
                                    height: 26 * fem,
                                    child: Text(
                                      '3.600',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Outfit',
                                        fontSize: 20 * ffem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.26 * ffem / fem,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // calj7S (378:76)
                                left: 78 * fem,
                                top: 4 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 23 * fem,
                                    height: 19 * fem,
                                    child: Text(
                                      'Cal',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Outfit',
                                        fontSize: 15 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.26 * ffem / fem,
                                        color: const Color(0xffa27dde),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // dailycalories2MS (378:79)
                                left: 0 * fem,
                                top: 25 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 86 * fem,
                                    height: 18 * fem,
                                    child: Text(
                                      'Daily Calories',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Outfit',
                                        fontSize: 14 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.26 * ffem / fem,
                                        color: const Color(0xffa27dde),
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
            Container(
              // autogroupgkzq89a (TqJMUexqH3oPCcb1SdGKZQ)
              margin: EdgeInsets.fromLTRB(6 * fem, 0 * fem, 25 * fem, 7 * fem),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // yourentriesSg4 (378:83)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 197 * fem, 0 * fem),
                    child: Text(
                      'Your Entries',
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
                  Container(
                    // seeallZEt (378:81)
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 3 * fem),
                    child: Text(
                      'See All',
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont(
                        'Outfit',
                        fontSize: 15 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.26 * ffem / fem,
                        color: const Color(0xffa27dde),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // autogroupwpwaGQC (TqJMe9h1dMwCqgMCgewpWA)
              margin:
                  EdgeInsets.fromLTRB(15 * fem, 0 * fem, 32 * fem, 25 * fem),
              padding:
                  EdgeInsets.fromLTRB(13 * fem, 10 * fem, 10 * fem, 1 * fem),
              width: double.infinity,
              height: 49 * fem,
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // autogroupy7vgJbn (TqJMpEEYxtNoddjBPVY7VG)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 168 * fem, 0 * fem),
                    width: 73 * fem,
                    height: double.infinity,
                    child: Stack(
                      children: [
                        Positioned(
                          // mondayxgL (378:84)
                          left: 1 * fem,
                          top: 0 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 59 * fem,
                              height: 21 * fem,
                              child: Text(
                                'Monday',
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
                          // nov2022TNC (378:90)
                          left: 0 * fem,
                          top: 20 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 73 * fem,
                              height: 18 * fem,
                              child: Text(
                                '15 nov 2022',
                                textAlign: TextAlign.center,
                                style: SafeGoogleFont(
                                  'Outfit',
                                  fontSize: 14 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.26 * ffem / fem,
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
                    // kcC (378:86)
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 0 * fem, 2 * fem, 6 * fem),
                    child: Text(
                      '70.33',
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont(
                        'Outfit',
                        fontSize: 20 * ffem,
                        fontWeight: FontWeight.w500,
                        height: 1.26 * ffem / fem,
                        color: const Color(0xff7938e3),
                      ),
                    ),
                  ),
                  Container(
                    // kg5eU (378:88)
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 1 * fem),
                    child: Text(
                      'kg',
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont(
                        'Outfit',
                        fontSize: 15 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.26 * ffem / fem,
                        color: const Color(0xffa27dde),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // autogroupp2s8o4g (TqJMwj24WBkF2noYUTp2s8)
              margin:
                  EdgeInsets.fromLTRB(15 * fem, 0 * fem, 32 * fem, 18 * fem),
              padding:
                  EdgeInsets.fromLTRB(14 * fem, 10 * fem, 7 * fem, 2 * fem),
              width: double.infinity,
              height: 49 * fem,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff000000)),
                borderRadius: BorderRadius.circular(10 * fem),
                gradient: const LinearGradient(
                  begin: Alignment(0, -1),
                  end: Alignment(0, 1),
                  colors: <Color>[Color(0xffffe9e9), Color(0x00d6f5ff)],
                  stops: <double>[0, 1],
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // autogroupm9b43Dv (TqJN6Jc6jT7Z9KAeZWM9B4)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 172 * fem, 0 * fem),
                    width: 74 * fem,
                    height: double.infinity,
                    child: Stack(
                      children: [
                        Positioned(
                          // tuesdayAZS (378:85)
                          left: 0 * fem,
                          top: 0 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 59 * fem,
                              height: 21 * fem,
                              child: Text(
                                'Tuesday',
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
                          // nov2022sCx (378:91)
                          left: 1 * fem,
                          top: 19 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 73 * fem,
                              height: 18 * fem,
                              child: Text(
                                '16 nov 2022',
                                textAlign: TextAlign.center,
                                style: SafeGoogleFont(
                                  'Outfit',
                                  fontSize: 14 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.26 * ffem / fem,
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
                    // Mtp (378:87)
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 0 * fem, 1 * fem, 7 * fem),
                    child: Text(
                      '69.33',
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont(
                        'Outfit',
                        fontSize: 20 * ffem,
                        fontWeight: FontWeight.w500,
                        height: 1.26 * ffem / fem,
                        color: const Color(0xff7938e3),
                      ),
                    ),
                  ),
                  Container(
                    // kgssA (378:89)
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 2 * fem),
                    child: Text(
                      'kg',
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont(
                        'Outfit',
                        fontSize: 15 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.26 * ffem / fem,
                        color: const Color(0xffa27dde),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // autogroupd438okp (TqJNEdhZ7LdpUbhGsvD438)
              margin:
                  EdgeInsets.fromLTRB(47.5 * fem, 0 * fem, 68 * fem, 0 * fem),
              width: double.infinity,
              height: 42 * fem,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    // autogroupplws8HJ (TqJNRYZ3HTEFCgXWpCPLWS)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 10 * fem, 0 * fem),
                    width: 61 * fem,
                    height: 40 * fem,
                    child: Stack(
                      children: [
                        Positioned(
                          // home4Ax (359:264)
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
                          // homexn8 (359:268)
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
                    // autogroupvgut4qA (TqJNXNif9aJ2jahMSHVGut)
                    width: 193.5 * fem,
                    height: double.infinity,
                    child: Stack(
                      children: [
                        Positioned(
                          // smileDCG (359:265)
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
                          // stethoscope6mr (359:266)
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
                          // bellQ1r (359:267)
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
                          // mooduDW (359:269)
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
                          // therepy1XS (359:270)
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
                          // reminderucp (359:271)
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
