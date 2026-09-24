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
        // reminderpLt (166:105)
        padding: EdgeInsets.fromLTRB(0 * fem, 22 * fem, 0 * fem, 6 * fem),
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/page-1/images/reminder-bg.png',
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // group11HEU (228:150)
              margin: EdgeInsets.fromLTRB(15 * fem, 0 * fem, 0 * fem, 19 * fem),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // pmCsE (228:151)
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
                    // autogroup2gsihZ6 (TqHjtgFwMvhUcCYFBV2GSi)
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 1 * fem, 0 * fem, 0 * fem),
                    width: 131 * fem,
                    height: 19 * fem,
                    child: Stack(
                      children: [
                        Positioned(
                          // signal1pg (228:152)
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
                          // wifi5pY (228:153)
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
                          // batteryfullMn4 (228:154)
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
              // autogroupmkv4396 (TqHhVAS53JD3ngCFs6MkV4)
              margin:
                  EdgeInsets.fromLTRB(0 * fem, 0 * fem, 147 * fem, 0.56 * fem),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // chevrondownxWx (344:76)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 3.44 * fem, 12 * fem, 0 * fem),
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
                  Container(
                    // reminderrMS (166:106)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 0 * fem, 3.44 * fem),
                    child: Text(
                      'REMINDER',
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont(
                        'Outfit',
                        fontSize: 24 * ffem,
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
              // autogroupamjkAN8 (TqHhoEkHcsiBYGKZCAaMjk)
              margin:
                  EdgeInsets.fromLTRB(112 * fem, 0 * fem, 128 * fem, 12 * fem),
              width: double.infinity,
              height: 50 * fem,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff000000)),
                color: const Color(0xffcaaaff),
                borderRadius: BorderRadius.circular(30 * fem),
              ),
              child: Center(
                child: Text(
                  'TODAY’S TASK',
                  textAlign: TextAlign.center,
                  style: SafeGoogleFont(
                    'Outfit',
                    fontSize: 16 * ffem,
                    fontWeight: FontWeight.w700,
                    height: 1.26 * ffem / fem,
                    color: const Color(0xffffffff),
                  ),
                ),
              ),
            ),
            Container(
              // autogroup7lbg29S (TqHi9tpXzgHUgekU977Lbg)
              margin: EdgeInsets.fromLTRB(15 * fem, 0 * fem, 7 * fem, 0 * fem),
              width: double.infinity,
              height: 688 * fem,
              child: Stack(
                children: [
                  Positioned(
                    // rectangle141uU8 (344:52)
                    left: 0 * fem,
                    top: 0 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 370 * fem,
                        height: 642 * fem,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10 * fem),
                            border: Border.all(color: const Color(0xff000000)),
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
                    // calendarYmz (344:74)
                    left: 311 * fem,
                    top: 42 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 60 * fem,
                        height: 19 * fem,
                        child: Text(
                          'calendar',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Font Awesome 6 Free',
                            fontSize: 15 * ffem,
                            fontWeight: FontWeight.w900,
                            height: 1.2575 * ffem / fem,
                            color: const Color(0xffcaaaff),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // giftScU (344:72)
                    left: 270 * fem,
                    top: 366.9994506836 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 20 * fem,
                        height: 16 * fem,
                        child: Text(
                          'Gift',
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
                    // rectangle140YQc (344:50)
                    left: 164 * fem,
                    top: 53 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 42 * fem,
                        height: 90 * fem,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10 * fem),
                            border: Border.all(color: const Color(0x47e62a9b)),
                            color: const Color(0xffd6f5ff),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // FK2 (344:51)
                    left: 179 * fem,
                    top: 98 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 11 * fem,
                        height: 46 * fem,
                        child: Text(
                          '.',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 36 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xffe62a9b),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // homewxY (196:15)
                    left: 42.5 * fem,
                    top: 648 * fem,
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
                    // smileFCY (196:16)
                    left: 113.5 * fem,
                    top: 648 * fem,
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
                    // stethoscopeMWU (196:17)
                    left: 132.5 * fem,
                    top: 650 * fem,
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
                    // bellTZW (196:18)
                    left: 261.2363019958 * fem,
                    top: 646 * fem,
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
                            color: const Color(0xffa27dde),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // home9x8 (196:19)
                    left: 58 * fem,
                    top: 674 * fem,
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
                    // moodTC8 (196:20)
                    left: 130 * fem,
                    top: 674 * fem,
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
                    // therepyN4C (196:21)
                    left: 193.5 * fem,
                    top: 674 * fem,
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
                    // reminderTrL (196:22)
                    left: 258 * fem,
                    top: 673 * fem,
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
                            color: const Color(0xffa27dde),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // november15m6L (344:37)
                    left: 17 * fem,
                    top: 8 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 139 * fem,
                        height: 31 * fem,
                        child: Text(
                          'November 15',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 24 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // taskstodaySyA (344:39)
                    left: 17.5 * fem,
                    top: 38 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 92 * fem,
                        height: 19 * fem,
                        child: Text(
                          '5 Tasks Today',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 15 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xffcaaaff),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // monkU4 (344:40)
                    left: 28 * fem,
                    top: 71 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 30 * fem,
                        height: 38 * fem,
                        child: Text(
                          '12\nMon',
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
                    // tueT7a (344:41)
                    left: 78 * fem,
                    top: 72 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 24 * fem,
                        height: 38 * fem,
                        child: Text(
                          '13\nTue',
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
                    // wedwoS (344:42)
                    left: 120 * fem,
                    top: 72 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 31 * fem,
                        height: 38 * fem,
                        child: Text(
                          '14\nWed',
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
                    // thru35n (344:43)
                    left: 167 * fem,
                    top: 72 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 32 * fem,
                        height: 38 * fem,
                        child: Text(
                          '15\nThru',
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
                    // friXme (344:44)
                    left: 219 * fem,
                    top: 72 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 18 * fem,
                        height: 38 * fem,
                        child: Text(
                          '16\nFri',
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
                    // satq1e (344:45)
                    left: 263 * fem,
                    top: 71 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 23 * fem,
                        height: 38 * fem,
                        child: Text(
                          '17\nSat',
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
                    // am830am900am930am1000am1030am1 (344:54)
                    left: 10 * fem,
                    top: 199 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 62 * fem,
                        height: 454 * fem,
                        child: Text(
                          '8:00AM\n \n8:30AM\n\n9:00AM\n\n9:30AM\n\n10:00AM\n\n10:30AM\n\n11:OOAM\n\n12:00PM\n\n12:30PM\n\n1:00PM\n\n1:30PM\n\n2:00PM\n\n',
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
                    // sunmJc (344:46)
                    left: 306 * fem,
                    top: 71 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 25 * fem,
                        height: 38 * fem,
                        child: Text(
                          '18\nSun',
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
                    // line74GFN (344:48)
                    left: 96 * fem,
                    top: 184.9999911186 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 270 * fem,
                        height: 1.04 * fem,
                        child: Image.asset(
                          'assets/page-1/images/line-74.png',
                          width: 270 * fem,
                          height: 1.04 * fem,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // rectangle142yQg (344:55)
                    left: 97 * fem,
                    top: 228 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 268 * fem,
                        height: 34 * fem,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10 * fem),
                            border: Border.all(color: const Color(0xff000000)),
                            color: const Color(0xb5caaaff),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // rectangle1435yW (344:56)
                    left: 143 * fem,
                    top: 412 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 222 * fem,
                        height: 36 * fem,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10 * fem),
                            border: Border.all(color: const Color(0xff000000)),
                            color: const Color(0xb591d5ea),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // rectangle144bS4 (344:57)
                    left: 90 * fem,
                    top: 337 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 245 * fem,
                        height: 49 * fem,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10 * fem),
                            border: Border.all(color: const Color(0xff000000)),
                            color: const Color(0x47e62a9b),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // rectangle1456tc (344:58)
                    left: 104 * fem,
                    top: 605 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 241 * fem,
                        height: 34 * fem,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10 * fem),
                            border: Border.all(color: const Color(0xff000000)),
                            color: const Color(0xffcaaaff),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // smilepJp (347:79)
                    left: 257 * fem,
                    top: 616 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 45 * fem,
                        height: 16 * fem,
                        child: Text(
                          '“SMILE”',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 12 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // rectangle146hdW (344:59)
                    left: 79 * fem,
                    top: 495 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 196 * fem,
                        height: 32 * fem,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10 * fem),
                            border: Border.all(color: const Color(0xff000000)),
                            color: const Color(0xffa27dde),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // appointmentwithdrellaedwardQH2 (344:62)
                    left: 127 * fem,
                    top: 235 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 227 * fem,
                        height: 19 * fem,
                        child: Text(
                          'Appointment with DR.Ella Edward',
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
                    // ellipse406Qk (344:63)
                    left: 100 * fem,
                    top: 233 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 26 * fem,
                        height: 24 * fem,
                        child: Image.asset(
                          'assets/page-1/images/ellipse-40.png',
                          width: 26 * fem,
                          height: 24 * fem,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // dontmakeanyplaneswithhaniabeca (344:64)
                    left: 84.0000052059 * fem,
                    top: 336.9999592767 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 257 * fem,
                        height: 46 * fem,
                        child: Text(
                          'Don’t make any planes with HANIA  Because She’s sad\nSEND HER FLOWERS',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 12 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // unlockpracticeyogasession04UAQ (344:70)
                    left: 167 * fem,
                    top: 422 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 178 * fem,
                        height: 16 * fem,
                        child: Text(
                          'Unlock & PracticeYoga session 04',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 12 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // checkyourheartrateYvx (344:71)
                    left: 107 * fem,
                    top: 504 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 121 * fem,
                        height: 16 * fem,
                        child: Text(
                          'Check your Heart Rate',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 12 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // listenyourfavouritesong3cp (347:78)
                    left: 116 * fem,
                    top: 614 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 137 * fem,
                        height: 16 * fem,
                        child: Text(
                          'Listen your favourite song',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 12 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // heartwCQ (344:73)
                    left: 224 * fem,
                    top: 506 * fem,
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
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // musicqHn (347:80)
                    left: 294 * fem,
                    top: 617 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 36 * fem,
                        height: 16 * fem,
                        child: Text(
                          'mUSIC',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
