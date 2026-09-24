import 'package:flutter/material.dart';
import 'package:myapp/utils.dart';

class MoodSuggestion extends StatelessWidget {
  const MoodSuggestion({super.key});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 393;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return SizedBox(
      width: double.infinity,
      child: Container(
        // moodsuggestionWax (54:27)
        padding: EdgeInsets.fromLTRB(18 * fem, 25 * fem, 0 * fem, 10 * fem),
        width: double.infinity,
        decoration: const BoxDecoration(
          border: Border(),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/page-1/images/mood-suggestion-bg.png',
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // autogroupxpsqZZE (TqHGiYNWWUvp7qztxDXpsQ)
              margin: EdgeInsets.fromLTRB(4 * fem, 0 * fem, 0 * fem, 8 * fem),
              width: double.infinity,
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [],
              ),
            ),
            Container(
              // autogroupdcsx5C8 (TqHH5HGxAk7nreNdphdCsx)
              margin:
                  EdgeInsets.fromLTRB(19 * fem, 0 * fem, 38 * fem, 11 * fem),
              width: double.infinity,
              height: 220 * fem,
              child: Stack(
                children: [
                  Positioned(
                    // ellipse17o88 (67:19)
                    left: 77 * fem,
                    top: 0 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 167 * fem,
                        height: 146 * fem,
                        child: Image.asset(
                          'assets/page-1/images/ellipse-17-AMJ.png',
                          width: 167 * fem,
                          height: 146 * fem,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // ellipse18ghi (75:2)
                    left: 23 * fem,
                    top: 86 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 80 * fem,
                        height: 79 * fem,
                        child: Image.asset(
                          'assets/page-1/images/ellipse-18-17i.png',
                          width: 80 * fem,
                          height: 79 * fem,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // feelingstressedoutzyJ (110:5)
                    left: 55.5 * fem,
                    top: 128 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 212 * fem,
                        height: 26 * fem,
                        child: Text(
                          'Feeling Stressed Out ?',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Mulish',
                            fontSize: 20 * ffem,
                            fontWeight: FontWeight.w700,
                            height: 1.255 * ffem / fem,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // rectangle103tYt (211:22)
                    left: 0 * fem,
                    top: 163 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 318 * fem,
                        height: 57 * fem,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30 * fem),
                            border: Border.all(color: const Color(0xff000000)),
                            color: const Color(0xffcaaaff),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // start2minutesmeditationBXz (211:23)
                    left: 38 * fem,
                    top: 179 * fem,
                    child: Align(
                      child: SizedBox(
                        width: 240 * fem,
                        height: 26 * fem,
                        child: Text(
                          'Start 2 Minutes Meditation ',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont(
                            'Outfit',
                            fontSize: 20 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.26 * ffem / fem,
                            color: const Color(0xffffffff),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // orFnk (211:24)
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 22 * fem, 7 * fem),
              child: Text(
                'OR',
                textAlign: TextAlign.center,
                style: SafeGoogleFont(
                  'Mulish',
                  fontSize: 20 * ffem,
                  fontWeight: FontWeight.w700,
                  height: 1.255 * ffem / fem,
                  color: const Color(0xff000000),
                ),
              ),
            ),
            Container(
              // tryouttheseactivitiesmm6 (211:21)
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 18 * fem, 10 * fem),
              child: Text(
                'Try Out These Activities !',
                textAlign: TextAlign.center,
                style: SafeGoogleFont(
                  'Mulish',
                  fontSize: 20 * ffem,
                  fontWeight: FontWeight.w700,
                  height: 1.255 * ffem / fem,
                  color: const Color(0xff000000),
                ),
              ),
            ),
            Container(
              // autogroup35wk5Wt (TqHHGXTDUhAwxNzBTA35wk)
              margin: EdgeInsets.fromLTRB(22 * fem, 0 * fem, 45 * fem, 9 * fem),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // ellipse24c12 (76:8)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 25 * fem, 0 * fem),
                    width: 82 * fem,
                    height: 79 * fem,
                    child: Image.asset(
                      'assets/page-1/images/ellipse-24.png',
                      width: 82 * fem,
                      height: 79 * fem,
                    ),
                  ),
                  Container(
                    // ellipse197yN (75:3)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 36 * fem, 0 * fem),
                    width: 83 * fem,
                    height: 79 * fem,
                    child: Image.asset(
                      'assets/page-1/images/ellipse-19.png',
                      width: 83 * fem,
                      height: 79 * fem,
                    ),
                  ),
                  SizedBox(
                    // ellipse20Eo6 (75:4)
                    width: 82 * fem,
                    height: 79 * fem,
                    child: Image.asset(
                      'assets/page-1/images/ellipse-20.png',
                      width: 82 * fem,
                      height: 79 * fem,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // autogroupgz38aMA (TqHHS71b7TvTBrhCcjGz38)
              margin:
                  EdgeInsets.fromLTRB(29 * fem, 0 * fem, 59.5 * fem, 6 * fem),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // readingVyv (67:20)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 58.5 * fem, 0 * fem),
                    child: Text(
                      'READING',
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
                  Container(
                    // music1Ba (67:21)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 73 * fem, 0 * fem),
                    child: Text(
                      'MUSIC',
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
                    // yogaWe8 (67:23)
                    'YOGA',
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont(
                      'Outfit',
                      fontSize: 15 * ffem,
                      fontWeight: FontWeight.w500,
                      height: 1.26 * ffem / fem,
                      color: const Color(0xff000000),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // autogroupn54aF5v (TqHHcmNVSCfq8hgxnNn54a)
              margin: EdgeInsets.fromLTRB(28 * fem, 0 * fem, 42 * fem, 0 * fem),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    // ellipse21yGp (75:5)
                    width: 82 * fem,
                    height: 87 * fem,
                    child: Image.asset(
                      'assets/page-1/images/ellipse-21.png',
                      width: 82 * fem,
                      height: 87 * fem,
                    ),
                  ),
                  SizedBox(
                    width: 29 * fem,
                  ),
                  Container(
                    // ellipse22t8t (75:6)
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 2 * fem, 0 * fem, 0 * fem),
                    width: 83 * fem,
                    height: 79 * fem,
                    child: Image.asset(
                      'assets/page-1/images/ellipse-22.png',
                      width: 83 * fem,
                      height: 79 * fem,
                    ),
                  ),
                  SizedBox(
                    width: 29 * fem,
                  ),
                  Container(
                    // ellipse23yg8 (75:7)
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 7 * fem),
                    width: 82 * fem,
                    height: 80 * fem,
                    child: Image.asset(
                      'assets/page-1/images/ellipse-23.png',
                      width: 82 * fem,
                      height: 80 * fem,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // autogroupfageJiQ (TqHHmqwhNDjEohj2QgfaGE)
              margin:
                  EdgeInsets.fromLTRB(33 * fem, 0 * fem, 43 * fem, 10 * fem),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    // runningSJp (67:24)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 52.5 * fem, 0 * fem),
                    child: Text(
                      'RUNNING',
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
                  Container(
                    // travelxHA (67:25)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 48.5 * fem, 0 * fem),
                    child: Text(
                      'TRAVEL',
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
                  Container(
                    // socialises9E (67:27)
                    margin:
                        EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 4 * fem),
                    child: Text(
                      'SOCIALISE',
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
                ],
              ),
            ),
            Container(
              // ellipse25Au2 (274:3)
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 237 * fem, 4 * fem),
              width: 82 * fem,
              height: 83 * fem,
              child: Image.asset(
                'assets/page-1/images/ellipse-25.png',
                width: 82 * fem,
                height: 83 * fem,
              ),
            ),
            Container(
              // laughVwJ (274:2)
              margin:
                  EdgeInsets.fromLTRB(0 * fem, 0 * fem, 238 * fem, 84 * fem),
              child: Text(
                'LAUGH',
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
            Container(
              // autogroupx4bqR4G (TqHHy1HmPiAiK2Pk7bX4BQ)
              margin:
                  EdgeInsets.fromLTRB(39.5 * fem, 0 * fem, 71 * fem, 0 * fem),
              width: double.infinity,
              height: 42 * fem,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    // autogroupivzjjak (TqHJAfd17xJHNpjRMmivzJ)
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 10 * fem, 0 * fem),
                    width: 61 * fem,
                    height: 40 * fem,
                    child: Stack(
                      children: [
                        Positioned(
                          // homefUQ (162:18)
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
                          // homepEp (162:22)
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
                    // autogroupbgogun4 (TqHJGATqrEuLY57xHgbGoG)
                    width: 193.5 * fem,
                    height: double.infinity,
                    child: Stack(
                      children: [
                        Positioned(
                          // smileFL8 (162:19)
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
                          // stethoscopeYa8 (162:20)
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
                          // bellS9i (162:21)
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
                          // moodisv (162:23)
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
                          // therapyRGY (162:24)
                          left: 79.5 * fem,
                          top: 28 * fem,
                          child: Align(
                            child: SizedBox(
                              width: 44 * fem,
                              height: 14 * fem,
                              child: Text(
                                'THERAPY',
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
                          // reminderKsi (162:25)
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
