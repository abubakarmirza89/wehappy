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
        // therapistsessionreportsRyN (477:14)
        padding: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 51 * fem),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xffeaffe5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // autogroupmupkM6L (TqKejzZ5s7NjN4jP1dmuPk)
              padding:
                  EdgeInsets.fromLTRB(12.5 * fem, 17 * fem, 0 * fem, 19 * fem),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // group114Fe (484:154)
                    margin: EdgeInsets.fromLTRB(
                        10.5 * fem, 0 * fem, 0 * fem, 56 * fem),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // pmC6x (484:155)
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
                          // autogroupuptaVbr (TqKgDT6h1vb87eb8BtuPta)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 1 * fem, 0 * fem, 0 * fem),
                          width: 131 * fem,
                          height: 19 * fem,
                          child: Stack(
                            children: [
                              Positioned(
                                // signalcgU (484:156)
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
                                // wifi7NL (484:157)
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
                                // batteryfullcZz (484:158)
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
                    // autogroupaxfg6zx (TqKXrMheKPZQbDGycyaxFg)
                    margin: EdgeInsets.fromLTRB(
                        7.5 * fem, 0 * fem, 19 * fem, 21 * fem),
                    padding: EdgeInsets.fromLTRB(
                        10 * fem, 5 * fem, 47 * fem, 7 * fem),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff000000)),
                      borderRadius: BorderRadius.circular(10 * fem),
                      gradient: const LinearGradient(
                        begin: Alignment(0, -1),
                        end: Alignment(0, 1),
                        colors: <Color>[Color(0xffd6f5ff), Color(0xffffffff)],
                        stops: <double>[0, 1],
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          // autogroupc2ogL8c (TqKYhR8ETfvV4P3eNTc2oG)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 0 * fem, 2 * fem),
                          width: 128 * fem,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                // onlinesession3Yp (481:73)
                                'Online Session',
                                textAlign: TextAlign.center,
                                style: SafeGoogleFont(
                                  'Outfit',
                                  fontSize: 20 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.26 * ffem / fem,
                                  color: const Color(0xff279238),
                                ),
                              ),
                              Container(
                                // autogroupaebgyxG (TqKZeDtFBcjfU33KpVAebg)
                                padding: EdgeInsets.fromLTRB(
                                    1 * fem, 17 * fem, 1 * fem, 0 * fem),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      // autogroupjs3cuqv (TqKYyF1CNrpBnpedmqjs3C)
                                      margin: EdgeInsets.fromLTRB(
                                          0 * fem, 0 * fem, 0 * fem, 7 * fem),
                                      padding: EdgeInsets.fromLTRB(
                                          0 * fem, 3 * fem, 0 * fem, 0 * fem),
                                      width: 42 * fem,
                                      child: Text(
                                        '60mins',
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
                                    Container(
                                      // autogroupgyrvNUc (TqKZ6zHHmY2fyDZUdSgyrv)
                                      margin: EdgeInsets.fromLTRB(
                                          0 * fem, 0 * fem, 32 * fem, 3 * fem),
                                      width: double.infinity,
                                      height: 100 * fem,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            // autogroupbetgtxk (TqKZKearuHYS9yF4x9beTG)
                                            padding: EdgeInsets.fromLTRB(
                                                0 * fem,
                                                45 * fem,
                                                0 * fem,
                                                0 * fem),
                                            width: 84 * fem,
                                            height: double.infinity,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  // mins8s6 (481:71)
                                                  margin: EdgeInsets.fromLTRB(
                                                      0 * fem,
                                                      0 * fem,
                                                      48 * fem,
                                                      6 * fem),
                                                  child: Text(
                                                    '30mins',
                                                    textAlign: TextAlign.center,
                                                    style: SafeGoogleFont(
                                                      'Exo',
                                                      fontSize: 10 * ffem,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 1.33 * ffem / fem,
                                                      color: const Color(
                                                          0xff000000),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  // line38Fgp (481:45)
                                                  margin: EdgeInsets.fromLTRB(
                                                      42 * fem,
                                                      0 * fem,
                                                      32 * fem,
                                                      0 * fem),
                                                  width: double.infinity,
                                                  height: 35 * fem,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(0x6d279238),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            // autogrouppwbxzeQ (TqKZDZvfBndbqqEkZRpWbx)
                                            padding: EdgeInsets.fromLTRB(
                                                5 * fem,
                                                0 * fem,
                                                5 * fem,
                                                0 * fem),
                                            height: double.infinity,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      // autogrouph9q2XuE (TqKZV9K3FbgFo31GCBH9Q2)
                                      margin: EdgeInsets.fromLTRB(
                                          1 * fem, 0 * fem, 0 * fem, 0 * fem),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            // minseyr (481:70)
                                            margin: EdgeInsets.fromLTRB(0 * fem,
                                                0 * fem, 10 * fem, 0 * fem),
                                            child: Text(
                                              '0mins',
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
                                          Container(
                                            // Nex (481:62)
                                            margin: EdgeInsets.fromLTRB(0 * fem,
                                                0 * fem, 31 * fem, 0 * fem),
                                            child: Text(
                                              '01',
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
                                          Text(
                                            // JYc (481:63)
                                            '02',
                                            textAlign: TextAlign.center,
                                            style: SafeGoogleFont(
                                              'Exo',
                                              fontSize: 10 * ffem,
                                              fontWeight: FontWeight.w400,
                                              height: 1.33 * ffem / fem,
                                              color: const Color(0xff000000),
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
                          // autogroupw6c6FCx (TqKaDHmUqnyg1wKMKVw6c6)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 25 * fem, 2 * fem),
                          padding: EdgeInsets.fromLTRB(
                              0 * fem, 127 * fem, 0 * fem, 0 * fem),
                          child: Text(
                            '03',
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
                        Container(
                          // autogroupmqcnKyW (TqKaMhh8W97cwdnoZTMQcn)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 33 * fem, 1 * fem),
                          width: 13 * fem,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // line74TZv (481:51)
                                margin: EdgeInsets.fromLTRB(
                                    2.83 * fem, 0 * fem, 0 * fem, 73.99 * fem),
                                width: 0.02 * fem,
                                height: 10 * fem,
                                decoration: const BoxDecoration(
                                  color: Color(0xff279238),
                                ),
                              ),
                              Container(
                                // line41Az8 (481:52)
                                margin: EdgeInsets.fromLTRB(
                                    1.31 * fem, 0 * fem, 0 * fem, 52.27 * fem),
                                width: 1.52 * fem,
                                height: 10 * fem,
                                decoration: const BoxDecoration(
                                  color: Color(0x60279238),
                                ),
                              ),
                              SizedBox(
                                // Hor (481:65)
                                width: double.infinity,
                                child: Text(
                                  '04',
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
                            ],
                          ),
                        ),
                        Container(
                          // autogroupv7gj2Fe (TqKaX2kvHY25PsfLxPv7GJ)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 21.2 * fem, 1 * fem),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // line439r4 (481:54)
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 0 * fem, 1 * fem, 3 * fem),
                                width: 0 * fem,
                                height: 17 * fem,
                                child: Image.asset(
                                  'assets/page-1/images/line-43-YNx.png',
                                  width: 0 * fem,
                                  height: 17 * fem,
                                ),
                              ),
                              Text(
                                // U7e (481:66)
                                '05',
                                textAlign: TextAlign.center,
                                style: SafeGoogleFont(
                                  'Exo',
                                  fontSize: 10 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.33 * ffem / fem,
                                  color: const Color(0xff000000),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          // line46cje (481:55)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 0.07 * fem, 82.37 * fem),
                          width: 0.73 * fem,
                          height: 10 * fem,
                          decoration: const BoxDecoration(
                            color: Color(0x60279238),
                          ),
                        ),
                        Container(
                          // autogroupkrnnMBS (TqKaecNd7J1CPSgXxukRnn)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 25 * fem, 1 * fem),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                // 5t8 (481:67)
                                '06',
                                textAlign: TextAlign.center,
                                style: SafeGoogleFont(
                                  'Exo',
                                  fontSize: 10 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.33 * ffem / fem,
                                  color: const Color(0xff000000),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          // autogrouprnceSCt (TqKakSYEyR4yvLrNazrNCE)
                          width: 12 * fem,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // autogrouph79pBgG (TqKar2DGzAHig1BjSTH79p)
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 0 * fem, 0 * fem, 4 * fem),
                                width: 10 * fem,
                                height: 121 * fem,
                                child: Image.asset(
                                  'assets/page-1/images/auto-group-h79p.png',
                                  width: 10 * fem,
                                  height: 121 * fem,
                                ),
                              ),
                              SizedBox(
                                // HzC (481:68)
                                width: double.infinity,
                                child: Text(
                                  '07',
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // todaysessionsdYG (481:74)
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 8 * fem),
                    width: double.infinity,
                    child: Text(
                      'Today Sessions',
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont(
                        'Outfit',
                        fontSize: 20 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.26 * ffem / fem,
                        color: const Color(0xff279238),
                      ),
                    ),
                  ),
                  Container(
                    // autogroupj46zLSg (TqKbaapgzefYryDxBVj46z)
                    margin: EdgeInsets.fromLTRB(
                        13.5 * fem, 0 * fem, 31 * fem, 16 * fem),
                    width: double.infinity,
                    height: 133 * fem,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // autogroupfcxpFZe (TqKbyEqcBU1EFGLhHVfcXp)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 11 * fem, 0 * fem),
                          padding: EdgeInsets.fromLTRB(
                              17 * fem, 21 * fem, 18 * fem, 9 * fem),
                          width: 104 * fem,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xff000000)),
                            borderRadius: BorderRadius.circular(10 * fem),
                            gradient: const LinearGradient(
                              begin: Alignment(0, -1),
                              end: Alignment(0, 1),
                              colors: <Color>[
                                Color(0xffd6f5ff),
                                Color(0xfffffded)
                              ],
                              stops: <double>[0, 1],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // ellipse336KN (482:81)
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 0 * fem, 7 * fem, 0 * fem),
                                width: 44 * fem,
                                height: 39 * fem,
                                child: Image.asset(
                                  'assets/page-1/images/ellipse-33-r84.png',
                                  width: 44 * fem,
                                  height: 39 * fem,
                                ),
                              ),
                              Container(
                                // jessicarobertDPz (482:78)
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 0 * fem, 5 * fem, 7 * fem),
                                constraints: BoxConstraints(
                                  maxWidth: 48 * fem,
                                ),
                                child: Text(
                                  'Jessica Robert',
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
                              Text(
                                // followupiLk (482:84)
                                'Follow-Up',
                                textAlign: TextAlign.center,
                                style: SafeGoogleFont(
                                  'Outfit',
                                  fontSize: 15 * ffem,
                                  fontWeight: FontWeight.w300,
                                  height: 1.26 * ffem / fem,
                                  color: const Color(0xff279238),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          // autogrouptumpFLg (TqKc8uEB6hNR59zYNcTump)
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 13 * fem, 0 * fem),
                          padding: EdgeInsets.fromLTRB(
                              13 * fem, 20 * fem, 10 * fem, 9 * fem),
                          width: 104 * fem,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xff000000)),
                            borderRadius: BorderRadius.circular(10 * fem),
                            gradient: const LinearGradient(
                              begin: Alignment(0, -1),
                              end: Alignment(0, 1),
                              colors: <Color>[
                                Color(0xffd6f5ff),
                                Color(0xfffffded)
                              ],
                              stops: <double>[0, 1],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // ellipse34t8k (482:82)
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 0 * fem, 5 * fem, 2 * fem),
                                width: 44 * fem,
                                height: 39 * fem,
                                child: Image.asset(
                                  'assets/page-1/images/ellipse-34-FEL.png',
                                  width: 44 * fem,
                                  height: 39 * fem,
                                ),
                              ),
                              Container(
                                // jessicarobertbor (482:79)
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 0 * fem, 1 * fem, 6 * fem),
                                constraints: BoxConstraints(
                                  maxWidth: 48 * fem,
                                ),
                                child: Text(
                                  'Jessica Robert',
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
                              Text(
                                // newpatientJyA (482:86)
                                'New Patient',
                                textAlign: TextAlign.center,
                                style: SafeGoogleFont(
                                  'Outfit',
                                  fontSize: 15 * ffem,
                                  fontWeight: FontWeight.w300,
                                  height: 1.26 * ffem / fem,
                                  color: const Color(0xff279238),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          // autogroupr2byen8 (TqKcGeWGVNauFYuPEDR2bY)
                          padding: EdgeInsets.fromLTRB(
                              21 * fem, 18 * fem, 14 * fem, 9 * fem),
                          width: 104 * fem,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xff000000)),
                            borderRadius: BorderRadius.circular(10 * fem),
                            gradient: const LinearGradient(
                              begin: Alignment(0, -1),
                              end: Alignment(0, 1),
                              colors: <Color>[
                                Color(0xffd6f5ff),
                                Color(0xfffffded)
                              ],
                              stops: <double>[0, 1],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // ellipse357Qp (482:83)
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 0 * fem, 7 * fem, 3 * fem),
                                width: 44 * fem,
                                height: 39 * fem,
                                child: Image.asset(
                                  'assets/page-1/images/ellipse-35-goW.png',
                                  width: 44 * fem,
                                  height: 39 * fem,
                                ),
                              ),
                              Container(
                                // jessicarobertq5v (482:80)
                                margin: EdgeInsets.fromLTRB(
                                    0 * fem, 0 * fem, 1 * fem, 7 * fem),
                                constraints: BoxConstraints(
                                  maxWidth: 48 * fem,
                                ),
                                child: Text(
                                  'Jessica Robert',
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
                              Text(
                                // followup7ZE (482:85)
                                'Follow-Up',
                                textAlign: TextAlign.center,
                                style: SafeGoogleFont(
                                  'Outfit',
                                  fontSize: 15 * ffem,
                                  fontWeight: FontWeight.w300,
                                  height: 1.26 * ffem / fem,
                                  color: const Color(0xff279238),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // report3hn (483:87)
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 8 * fem),
                    width: double.infinity,
                    child: Text(
                      'Report',
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont(
                        'Outfit',
                        fontSize: 20 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.26 * ffem / fem,
                        color: const Color(0xff279238),
                      ),
                    ),
                  ),
                  SizedBox(
                    // autogrouprcesMyN (TqKcdyE58r5f9EtuZWRCeS)
                    height: 80 * fem,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          // autogroupt8wqJtc (TqKd4nr3hbR5xGb8fet8wQ)
                          width: 165.5 * fem,
                          height: double.infinity,
                          child: Stack(
                            children: [
                              Positioned(
                                // rectangle262eBn (484:88)
                                left: 16.5 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 63 * fem,
                                    height: 79 * fem,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10 * fem),
                                        border: Border.all(
                                            color: const Color(0xff000000)),
                                        gradient: const LinearGradient(
                                          begin: Alignment(0, -1),
                                          end: Alignment(0, 1),
                                          colors: <Color>[
                                            Color(0xffffffff),
                                            Color(0x00d6f5ff)
                                          ],
                                          stops: <double>[0, 1],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // rectangle263tbv (484:89)
                                left: 102.5 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 63 * fem,
                                    height: 79 * fem,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10 * fem),
                                        border: Border.all(
                                            color: const Color(0xff000000)),
                                        gradient: const LinearGradient(
                                          begin: Alignment(0, -1),
                                          end: Alignment(0, 1),
                                          colors: <Color>[
                                            Color(0xffffffff),
                                            Color(0x00d6f5ff)
                                          ],
                                          stops: <double>[0, 1],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // patientkPE (484:92)
                                left: 30 * fem,
                                top: 46 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 32 * fem,
                                    height: 13 * fem,
                                    child: Text(
                                      'patient',
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
                                // consultationFat (484:93)
                                left: 106.5 * fem,
                                top: 46 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 54 * fem,
                                    height: 13 * fem,
                                    child: Text(
                                      'consultation',
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
                                // userplusZ5n (484:99)
                                left: 0 * fem,
                                top: 16 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 101 * fem,
                                    height: 31 * fem,
                                    child: Text(
                                      'user-plus',
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
                                // phoneFjJ (484:101)
                                left: 97.5 * fem,
                                top: 13 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 68 * fem,
                                    height: 31 * fem,
                                    child: Text(
                                      'phone',
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
                                // x7v (484:104)
                                left: 28.5 * fem,
                                top: 59 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 34 * fem,
                                    height: 21 * fem,
                                    child: Text(
                                      '1056',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Outfit',
                                        fontSize: 16 * ffem,
                                        fontWeight: FontWeight.w500,
                                        height: 1.26 * ffem / fem,
                                        color: const Color(0xff279238),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // rj6 (484:105)
                                left: 118.5 * fem,
                                top: 58 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 30 * fem,
                                    height: 21 * fem,
                                    child: Text(
                                      '500',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Outfit',
                                        fontSize: 16 * ffem,
                                        fontWeight: FontWeight.w500,
                                        height: 1.26 * ffem / fem,
                                        color: const Color(0xff279238),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20.5 * fem,
                        ),
                        SizedBox(
                          // autogroupcpzlx1S (TqKdFnXjAAdCGmNCXUcpZL)
                          width: 81 * fem,
                          height: double.infinity,
                          child: Stack(
                            children: [
                              Positioned(
                                // rectangle26467e (484:90)
                                left: 10.5 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 63 * fem,
                                    height: 79 * fem,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10 * fem),
                                        border: Border.all(
                                            color: const Color(0xff000000)),
                                        gradient: const LinearGradient(
                                          begin: Alignment(0, -1),
                                          end: Alignment(0, 1),
                                          colors: <Color>[
                                            Color(0xffffffff),
                                            Color(0x00d6f5ff)
                                          ],
                                          stops: <double>[0, 1],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // injectANQ (484:97)
                                left: 30.5 * fem,
                                top: 43 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 24 * fem,
                                    height: 13 * fem,
                                    child: Text(
                                      'inject',
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
                                // syringefa4 (484:102)
                                left: 0 * fem,
                                top: 13 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 81 * fem,
                                    height: 31 * fem,
                                    child: Text(
                                      'syringe',
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
                                // ZvL (484:106)
                                left: 31.5 * fem,
                                top: 54 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 23 * fem,
                                    height: 26 * fem,
                                    child: Text(
                                      '56',
                                      style: SafeGoogleFont(
                                        'Outfit',
                                        fontSize: 20 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.26 * ffem / fem,
                                        color: const Color(0xff279238),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20.5 * fem,
                        ),
                        SizedBox(
                          // autogroup6kc6ewn (TqKdNsAGHAvDhriRzj6kC6)
                          width: 63 * fem,
                          height: double.infinity,
                          child: Stack(
                            children: [
                              Positioned(
                                // rectangle26511e (484:91)
                                left: 0 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 63 * fem,
                                    height: 79 * fem,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10 * fem),
                                        border: Border.all(
                                            color: const Color(0xff000000)),
                                        gradient: const LinearGradient(
                                          begin: Alignment(0, -1),
                                          end: Alignment(0, 1),
                                          colors: <Color>[
                                            Color(0xffffffff),
                                            Color(0x00d6f5ff)
                                          ],
                                          stops: <double>[0, 1],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // surgeryfM6 (484:94)
                                left: 16 * fem,
                                top: 46 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 34 * fem,
                                    height: 13 * fem,
                                    child: Text(
                                      'surgery',
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
                                // bedA2x (484:103)
                                left: 11.5 * fem,
                                top: 13 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 41 * fem,
                                    height: 31 * fem,
                                    child: Text(
                                      'bed',
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
                                // Tnk (484:107)
                                left: 20 * fem,
                                top: 54 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 25 * fem,
                                    height: 26 * fem,
                                    child: Text(
                                      '06',
                                      style: SafeGoogleFont(
                                        'Outfit',
                                        fontSize: 20 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 1.26 * ffem / fem,
                                        color: const Color(0xff279238),
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
            SizedBox(
              // autogroupu3awxzQ (TqKds6rDUjUdqpAXxBU3aW)
              width: double.infinity,
              height: 173 * fem,
              child: Stack(
                children: [
                  Positioned(
                    // rectangle2661xg (484:121)
                    left: 18 * fem,
                    top: 5.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 356 * fem,
                        height: 168 * fem,
                        child: Image.asset(
                          'assets/page-1/images/rectangle-266.png',
                          width: 356 * fem,
                          height: 168 * fem,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // wed6UL (484:148)
                    left: 129 * fem,
                    top: 32.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 23 * fem,
                        height: 28 * fem,
                        child: Text(
                          '27\nWed',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 11 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // friCGU (484:149)
                    left: 230 * fem,
                    top: 29.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 14 * fem,
                        height: 28 * fem,
                        child: Text(
                          '29\nFri',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 11 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // rectangle266stroketf6 (484:120)
                    left: 18 * fem,
                    top: 5.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 356 * fem,
                        height: 168 * fem,
                        child: Image.asset(
                          'assets/page-1/images/rectangle-266-stroke.png',
                          width: 356 * fem,
                          height: 168 * fem,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // line105oGG (484:109)
                    left: 18 * fem,
                    top: 25.0000193198 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 356 * fem,
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
                    // line106i8L (484:110)
                    left: 48 * fem,
                    top: 63.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 1 * fem,
                        height: 100 * fem,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xffd9d9d9),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // line107E6g (484:112)
                    left: 95 * fem,
                    top: 64.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 1 * fem,
                        height: 100 * fem,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xffd9d9d9),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // line108kap (484:113)
                    left: 141 * fem,
                    top: 63.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 1 * fem,
                        height: 100 * fem,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // line1095NC (484:114)
                    left: 186 * fem,
                    top: 63.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 1 * fem,
                        height: 100 * fem,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xff279238),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // thruszzx (484:118)
                    left: 173 * fem,
                    top: 31.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 28 * fem,
                        height: 28 * fem,
                        child: Text(
                          '28\n Thrus',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 11 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xff279238),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // line110Vgp (484:115)
                    left: 236 * fem,
                    top: 62.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 1 * fem,
                        height: 100 * fem,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // line111oxQ (484:116)
                    left: 287 * fem,
                    top: 61.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 1 * fem,
                        height: 100 * fem,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xffd9d9d9),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // line1128jn (484:117)
                    left: 337 * fem,
                    top: 60.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 1 * fem,
                        height: 100 * fem,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xffd9d9d9),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // rectangle267Tn4 (484:119)
                    left: 37 * fem,
                    top: 81.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 133 * fem,
                        height: 26 * fem,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5 * fem),
                            border: Border.all(color: const Color(0xff000000)),
                            gradient: const LinearGradient(
                              begin: Alignment(0, -1),
                              end: Alignment(0, 1),
                              colors: <Color>[
                                Color(0xffd6f5ff),
                                Color(0xffebe0ff)
                              ],
                              stops: <double>[0, 1],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // rectangle268KZN (484:122)
                    left: 50 * fem,
                    top: 127.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 132 * fem,
                        height: 24 * fem,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5 * fem),
                            border: Border.all(color: const Color(0xff000000)),
                            gradient: const LinearGradient(
                              begin: Alignment(0, -1),
                              end: Alignment(0, 1),
                              colors: <Color>[
                                Color(0xffd6f5ff),
                                Color(0xffebe0ff)
                              ],
                              stops: <double>[0, 1],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // rectangle269akC (484:123)
                    left: 214 * fem,
                    top: 78.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 142 * fem,
                        height: 27 * fem,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5 * fem),
                            border: Border.all(color: const Color(0xff000000)),
                            gradient: const LinearGradient(
                              begin: Alignment(0, -1),
                              end: Alignment(0, 1),
                              colors: <Color>[
                                Color(0xffd6f5ff),
                                Color(0xffebe0ff)
                              ],
                              stops: <double>[0, 1],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // rectangle2703Nt (484:124)
                    left: 210 * fem,
                    top: 122.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 115 * fem,
                        height: 25 * fem,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5 * fem),
                            border: Border.all(color: const Color(0xff000000)),
                            gradient: const LinearGradient(
                              begin: Alignment(0, -1),
                              end: Alignment(0, 1),
                              colors: <Color>[
                                Color(0xffd6f5ff),
                                Color(0xffebe0ff)
                              ],
                              stops: <double>[0, 1],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // checkuphyE (484:126)
                    left: 39 * fem,
                    top: 84.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 47 * fem,
                        height: 14 * fem,
                        child: Text(
                          'Check-up',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 11 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // surgeryomN (484:128)
                    left: 214 * fem,
                    top: 123.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 39 * fem,
                        height: 14 * fem,
                        child: Text(
                          'Surgery',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 11 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // consultantonlineKDv (484:127)
                    left: 216 * fem,
                    top: 79.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 88 * fem,
                        height: 14 * fem,
                        child: Text(
                          'Consultant Online',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 11 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // vaccineinjection1Me (484:129)
                    left: 54 * fem,
                    top: 129.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 75 * fem,
                        height: 13 * fem,
                        child: Text(
                          'Vaccine Injection',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 10 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // routinehealthcheckup15patients (484:130)
                    left: 39 * fem,
                    top: 95.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 128 * fem,
                        height: 11 * fem,
                        child: Text(
                          'Routine health check-up -15 patients',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 8 * ffem,
                            fontWeight: FontWeight.w300,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // consultationroutine1patientsnW (484:131)
                    left: 217 * fem,
                    top: 92.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 110 * fem,
                        height: 11 * fem,
                        child: Text(
                          'Consultation Routine-1 patients',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 8 * ffem,
                            fontWeight: FontWeight.w300,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // intensialsurgery1patient5kp (484:132)
                    left: 213.5 * fem,
                    top: 135.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 96 * fem,
                        height: 11 * fem,
                        child: Text(
                          'Intensial Surgery- 1 patient ',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 8 * ffem,
                            fontWeight: FontWeight.w300,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // ellipse36ybJ (484:134)
                    left: 129 * fem,
                    top: 85.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 13 * fem,
                        height: 12 * fem,
                        child: Image.asset(
                          'assets/page-1/images/ellipse-36-kUk.png',
                          width: 13 * fem,
                          height: 12 * fem,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // ellipse656vp (484:135)
                    left: 138 * fem,
                    top: 85.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 13 * fem,
                        height: 13 * fem,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.5 * fem),
                            border: Border.all(color: const Color(0xff000000)),
                            image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                'assets/page-1/images/ellipse-65-bg.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // ellipse66Puv (484:137)
                    left: 156 * fem,
                    top: 129.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 13 * fem,
                        height: 12 * fem,
                        child: Image.asset(
                          'assets/page-1/images/ellipse-66-yD6.png',
                          width: 13 * fem,
                          height: 12 * fem,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // ellipse677b2 (484:138)
                    left: 327 * fem,
                    top: 81.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 13 * fem,
                        height: 12 * fem,
                        child: Image.asset(
                          'assets/page-1/images/ellipse-67-gVA.png',
                          width: 13 * fem,
                          height: 12 * fem,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // ellipse682hz (484:139)
                    left: 336 * fem,
                    top: 81.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 13 * fem,
                        height: 13 * fem,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.5 * fem),
                            border: Border.all(color: const Color(0xff000000)),
                            image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                'assets/page-1/images/ellipse-68-bg.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // ellipse69uFz (484:140)
                    left: 148 * fem,
                    top: 85.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 13 * fem,
                        height: 12 * fem,
                        child: Image.asset(
                          'assets/page-1/images/ellipse-69.png',
                          width: 13 * fem,
                          height: 12 * fem,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // ellipse70QiY (484:141)
                    left: 298 * fem,
                    top: 124.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 13 * fem,
                        height: 12 * fem,
                        child: Image.asset(
                          'assets/page-1/images/ellipse-70-NBE.png',
                          width: 13 * fem,
                          height: 12 * fem,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // ellipse717sr (484:142)
                    left: 307 * fem,
                    top: 124.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 13 * fem,
                        height: 12 * fem,
                        child: Image.asset(
                          'assets/page-1/images/ellipse-71-8Ut.png',
                          width: 13 * fem,
                          height: 12 * fem,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // monq3A (484:144)
                    left: 39 * fem,
                    top: 31.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 22 * fem,
                        height: 28 * fem,
                        child: Text(
                          '25\nMon',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 11 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xffaaa4a4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // tuevqJ (484:145)
                    left: 87 * fem,
                    top: 31.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 18 * fem,
                        height: 28 * fem,
                        child: Text(
                          '26\nTue',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 11 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xffaaa4a4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // sat2dS (484:146)
                    left: 279 * fem,
                    top: 28.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 17 * fem,
                        height: 28 * fem,
                        child: Text(
                          '30\nSat',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 11 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xffaaa4a4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // sunXaC (484:147)
                    left: 329 * fem,
                    top: 28.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 18 * fem,
                        height: 28 * fem,
                        child: Text(
                          '01\nSun',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 11 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xffaaa4a4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // injectthecoronavaccine1patient (484:150)
                    left: 53 * fem,
                    top: 140.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 125 * fem,
                        height: 11 * fem,
                        child: Text(
                          'Inject the corona vaccine - 1 patient',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 8 * ffem,
                            fontWeight: FontWeight.w300,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // chevrondownL1r (484:151)
                    left: 313.0825092082 * fem,
                    top: 0 * fem,
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
                            color: const Color(0xff279238),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // chevrondownqDW (484:152)
                    left: 0 * fem,
                    top: 2.0000192229 * fem,
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
                            color: const Color(0xff279238),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // december20228Cc (484:153)
                    left: 132 * fem,
                    top: 9.0000192229 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 102 * fem,
                        height: 18 * fem,
                        child: Text(
                          'DECEMBER 2022',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Font Awesome 6 Free',
                            fontSize: 14 * ffem,
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
    );
  }
}
