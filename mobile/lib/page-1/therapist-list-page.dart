import 'package:flutter/material.dart';
import 'package:myapp/utils.dart';

class Therapist_list_page extends StatelessWidget {
  const Therapist_list_page({super.key});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 393;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Container(
          // therapistlistpagedrc (359:58)
          width: double.infinity,
          height: 852 * fem,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/page-1/images/therapist-list-page-bg.png',
              ),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                // ellipse25716 (359:8)
                left: 137 * fem,
                top: 108 * fem,
                child: Align(
                  child: SizedBox(
                    width: 114 * fem,
                    height: 103 * fem,
                    child: Image.asset(
                      'assets/page-1/images/ellipse-25-HKr.png',
                      width: 114 * fem,
                      height: 103 * fem,
                    ),
                  ),
                ),
              ),
              Positioned(
                // autogroupwnuccCk (TqJu9FCcVRMg1x25SLWnuc)
                left: 11 * fem,
                top: 65 * fem,
                child: SizedBox(
                  width: 345.5 * fem,
                  height: 28 * fem,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        // autogroupmirtCKN (TqJubKHWK3vLjAthPeMiRt)
                        width: 310.5 * fem,
                        height: double.infinity,
                        child: Stack(
                          children: [
                            Positioned(
                              // rectangle147vmA (359:5)
                              left: 0 * fem,
                              top: 0 * fem,
                              child: Align(
                                child: SizedBox(
                                  width: 307 * fem,
                                  height: 28 * fem,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(10 * fem),
                                      color: const Color(0xffebe0ff),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              // searchxxk (359:7)
                              left: 260.5 * fem,
                              top: 5 * fem,
                              child: Align(
                                child: SizedBox(
                                  width: 50 * fem,
                                  height: 19 * fem,
                                  child: Text(
                                    'Search ',
                                    textAlign: TextAlign.center,
                                    style: SafeGoogleFont(
                                      'Font Awesome 5 Free',
                                      fontSize: 15 * ffem,
                                      fontWeight: FontWeight.w900,
                                      height: 1.2575 * ffem / fem,
                                      color: const Color(0xffa27dde),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              // searchatheripstdZ6 (359:4)
                              left: 10 * fem,
                              top: 4 * fem,
                              child: Align(
                                child: SizedBox(
                                  width: 120 * fem,
                                  height: 19 * fem,
                                  child: Text(
                                    'Search a Theripst',
                                    textAlign: TextAlign.center,
                                    style: SafeGoogleFont(
                                      'Outfit',
                                      fontSize: 15 * ffem,
                                      fontWeight: FontWeight.w400,
                                      height: 1.26 * ffem / fem,
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
              ),
              Positioned(
                // autogroupseqeuFi (TqJuj9PnzBkWVykNAnsEQE)
                left: 87 * fem,
                top: 211 * fem,
                child: SizedBox(
                  width: 213 * fem,
                  height: 56 * fem,
                  child: Stack(
                    children: [
                      Positioned(
                        // seekprofessionalhelpdirectRjr (359:10)
                        left: 2 * fem,
                        top: 0 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 209 * fem,
                            height: 21 * fem,
                            child: Text(
                              'Seek Professional Help Direct',
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
                        // meetwithalicensedtherapistviap (359:9)
                        left: 0 * fem,
                        top: 20 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 213 * fem,
                            height: 36 * fem,
                            child: Text(
                              'Meet with a Licensed Therapist via Phone, Chat or Vedio',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 14 * ffem,
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
              ),
              Positioned(
                // autogroupyax6dDe (TqJv9Yro8e1XLwiTfDYAx6)
                left: 17 * fem,
                top: 278 * fem,
                child: SizedBox(
                  width: 397 * fem,
                  height: 116 * fem,
                  child: Stack(
                    children: [
                      Positioned(
                        // rectangle1484pk (359:57)
                        left: 0 * fem,
                        top: 0 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 361 * fem,
                            height: 116 * fem,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10 * fem),
                                border:
                                    Border.all(color: const Color(0xff000000)),
                                gradient: const LinearGradient(
                                  begin: Alignment(0, -1),
                                  end: Alignment(0, 1),
                                  colors: <Color>[
                                    Color(0xffd6f5ff),
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
                        // ivebeenworkingintheindustryfor (359:68)
                        left: 68 * fem,
                        top: 56 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 146 * fem,
                            height: 7 * fem,
                            child: Text(
                              'I’ve been working in the industry for 10 years.Cu....',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Epilogue',
                                fontSize: 6 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.025 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // ellipse44VHn (359:14)
                        left: 8 * fem,
                        top: 7 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 60 * fem,
                            height: 53 * fem,
                            child: Image.asset(
                              'assets/page-1/images/ellipse-44-owa.png',
                              width: 60 * fem,
                              height: 53 * fem,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // sessionsBRW (359:25)
                        left: 12 * fem,
                        top: 64 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 53 * fem,
                            height: 13 * fem,
                            child: Text(
                              '177 Sessions',
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
                        // videoeK6 (359:11)
                        left: 13 * fem,
                        top: 79 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 25 * fem,
                            height: 13 * fem,
                            child: Stack(
                              children: [
                                Icon(
                                  Icons.video_call,
                                  size: 15 * fem,
                                  color: const Color(0xff000000),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // messagev1i (359:19)
                        left: 30 * fem,
                        top: 82 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 39 * fem,
                            height: 13 * fem,
                            child: Stack(
                              children: [
                                Icon(
                                  Icons.message,
                                  size: 11 * fem,
                                  color: const Color(0xff000000),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // callv1i (359:19)
                        left: 43 * fem,
                        top: 81 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 39 * fem,
                            height: 13 * fem,
                            child: Stack(
                              children: [
                                Icon(
                                  Icons.call,
                                  size: 11 * fem,
                                  color: const Color(0xff000000),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // elwoodvicmo2 (359:29)
                        left: 12 * fem,
                        top: 94 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 51 * fem,
                            height: 13 * fem,
                            child: Text(
                              'Elwood,VIC',
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
                        // benjaminjamesUSY (359:13)
                        left: 66.5 * fem,
                        top: 2 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 117 * fem,
                            height: 21 * fem,
                            child: Text(
                              ' Benjamin James',
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
                        // counsellorakU (359:12)
                        left: 72 * fem,
                        top: 22 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 71 * fem,
                            height: 14 * fem,
                            child: Text(
                              'COUNSELLOR',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 11 * ffem,
                                fontWeight: FontWeight.w300,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // fX2 (359:56)
                        left: 307 * fem,
                        top: 4 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 41 * fem,
                            height: 19 * fem,
                            child: Text(
                              '\$5.00',
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
                        // calendarcheckATn (359:18)
                        left: 310 * fem,
                        top: 25 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 138 * fem,
                            height: 26 * fem,
                            child: Stack(
                              children: [
                                // You can use any other widget instead of Icon if needed
                                Icon(
                                  Icons.edit_calendar_outlined,
                                  size: 23 * fem,
                                  color: const Color(0xff000000),
                                ),
                                Positioned(
                                  left: 20 * fem,
                                  // Adjust the left position as needed
                                  child: GestureDetector(
                                    // GestureDetector for handling left movement
                                    onHorizontalDragUpdate: (details) {
                                      // Handle left movement
                                      print('Moving left');
                                      // You can update the left position here
                                    },
                                  ),
                                ),
                                Positioned(
                                  right: 10 * fem,
                                  // Adjust the right position as needed
                                  child: GestureDetector(
                                    // GestureDetector for handling right movement
                                    onHorizontalDragUpdate: (details) {
                                      // Handle right movement
                                      print('Moving right');
                                      // You can update the left position here
                                    },
                                    child: Icon(
                                      Icons.arrow_right,
                                      size: 20 * fem,
                                      color: Colors
                                          .blue, // Change the color as needed
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // tommorow200am4ZA (359:26)
                        left: 284 * fem,
                        top: 62 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 72 * fem,
                            height: 11 * fem,
                            child: Text(
                              'Tommorow 2:00AM',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 8 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle149a1i (359:60)
                        left: 75 * fem,
                        top: 81 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 60 * fem,
                            height: 19 * fem,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5 * fem),
                                border:
                                    Border.all(color: const Color(0xff000000)),
                                color: const Color(0xcecaaaff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle150fYx (359:61)
                        left: 208 * fem,
                        top: 81 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 60 * fem,
                            height: 19 * fem,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5 * fem),
                                border:
                                    Border.all(color: const Color(0xff000000)),
                                color: const Color(0xcecaaaff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle151mM6 (359:62)
                        left: 142 * fem,
                        top: 81 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 60 * fem,
                            height: 19 * fem,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5 * fem),
                                border:
                                    Border.all(color: const Color(0xff000000)),
                                color: const Color(0xcecaaaff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle15256t (359:63)
                        left: 281 * fem,
                        top: 80 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 75 * fem,
                            height: 26 * fem,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5 * fem),
                                border:
                                    Border.all(color: const Color(0xff000000)),
                                color: const Color(0x47e62a9b),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // nX6 (359:28)
                        left: 266 * fem,
                        top: 5 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 15 * fem,
                            height: 13 * fem,
                            child: Text(
                              '5.0',
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
                        // booknow6Gt (359:24)
                        left: 290 * fem,
                        top: 85 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 59 * fem,
                            height: 17 * fem,
                            child: Text(
                              'Book Now',
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
                      Positioned(
                        // traumaptsdbDe (359:21)
                        left: 210 * fem,
                        top: 86 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 56 * fem,
                            height: 11 * fem,
                            child: Text(
                              'Trauma & PTSD',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 8 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // selfesteemtiY (359:22)
                        left: 83 * fem,
                        top: 86 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 42 * fem,
                            height: 11 * fem,
                            child: Text(
                              'Self Esteem',
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
                        // spirtualityBSk (359:23)
                        left: 154 * fem,
                        top: 86 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 36 * fem,
                            height: 11 * fem,
                            child: Text(
                              'Spirtuality',
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
                        // viewprofilegPW (359:15)
                        left: 215 * fem,
                        top: 54 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 51 * fem,
                            height: 11 * fem,
                            child: Text(
                              'View Profile....',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 8 * ffem,
                                fontWeight: FontWeight.w200,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xffa27dde),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // thrivesonhelpingpeopleliveamor (359:66)
                        left: 68 * fem,
                        top: 48 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 196 * fem,
                            height: 7 * fem,
                            child: Text(
                              'thrives on helping people live a more peaceful and meaningful life.',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Epilogue',
                                fontSize: 6 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.025 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // group133NU (359:205)
                        left: 190 * fem,
                        top: 5 * fem,
                        child: SizedBox(
                          width: 79 * fem,
                          height: 16 * fem,
                          child: Stack(
                            children: [
                              Positioned(
                                // starN9r (359:199)
                                left: 18 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 28 * fem,
                                    height: 16 * fem,
                                    child: Stack(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 12 * fem,
                                          color: const Color(0xfff39200),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // starN9r (359:199)
                                left: 28 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 28 * fem,
                                    height: 16 * fem,
                                    child: Stack(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 12 * fem,
                                          color: const Color(0xfff39200),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // starN9r (359:199)
                                left: 38 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 28 * fem,
                                    height: 16 * fem,
                                    child: Stack(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 12 * fem,
                                          color: const Color(0xfff39200),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // starN9r (359:199)
                                left: 48 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 28 * fem,
                                    height: 16 * fem,
                                    child: Stack(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 12 * fem,
                                          color: const Color(0xfff39200),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // starN9r (359:199)
                                left: 58 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 28 * fem,
                                    height: 16 * fem,
                                    child: Stack(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 12 * fem,
                                          color: const Color(0xfff39200),
                                        ),
                                      ],
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
              ),
              Positioned(
                // nextavaliablefRn (359:59)
                left: 306 * fem,
                top: 328 * fem,
                child: SizedBox(
                  width: 63 * fem,
                  height: 15 * fem,
                  child: Text(
                    'Next Avaliable',
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont(
                      'Outfit',
                      fontSize: 10 * ffem,
                      fontWeight: FontWeight.w200,
                      height: 1.26 * ffem / fem,
                      color: const Color(0xffa27dde),
                    ),
                  ),
                ),
              ),
              Positioned(
                // autogroupcrf4wu6 (TqJw2wYqDmbiRfxGFwCRf4)
                left: 16 * fem,
                top: 406 * fem,
                child: SizedBox(
                  width: 394 * fem,
                  height: 116 * fem,
                  child: Stack(
                    children: [
                      Positioned(
                        // rectangle1532vY (359:104)
                        left: 0 * fem,
                        top: 0 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 361 * fem,
                            height: 116 * fem,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10 * fem),
                                border:
                                    Border.all(color: const Color(0xff000000)),
                                gradient: const LinearGradient(
                                  begin: Alignment(0, -1),
                                  end: Alignment(0, 1),
                                  colors: <Color>[
                                    Color(0xffd6f5ff),
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
                        // ivebeenworkingintheindustryfor (359:105)
                        left: 65 * fem,
                        top: 58 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 146 * fem,
                            height: 7 * fem,
                            child: Text(
                              'I’ve been working in the industry for 10 years.Cu....',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Epilogue',
                                fontSize: 6 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.025 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // ellipse45ZJC (359:106)
                        left: 5 * fem,
                        top: 9 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 60 * fem,
                            height: 53 * fem,
                            child: Image.asset(
                              'assets/page-1/images/ellipse-45-pDr.png',
                              width: 60 * fem,
                              height: 53 * fem,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // sessions5GY (359:107)
                        left: 9 * fem,
                        top: 66 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 53 * fem,
                            height: 13 * fem,
                            child: Text(
                              '177 Sessions',
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
                        // videoeK6 (359:11)
                        left: 13 * fem,
                        top: 79 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 25 * fem,
                            height: 13 * fem,
                            child: Stack(
                              children: [
                                Icon(
                                  Icons.video_call,
                                  size: 15 * fem,
                                  color: const Color(0xff000000),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // messagev1i (359:19)
                        left: 30 * fem,
                        top: 82 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 39 * fem,
                            height: 13 * fem,
                            child: Stack(
                              children: [
                                Icon(
                                  Icons.message,
                                  size: 11 * fem,
                                  color: const Color(0xff000000),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // callv1i (359:19)
                        left: 43 * fem,
                        top: 81 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 39 * fem,
                            height: 13 * fem,
                            child: Stack(
                              children: [
                                Icon(
                                  Icons.call,
                                  size: 11 * fem,
                                  color: const Color(0xff000000),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // elwoodvicBD6 (359:110)
                        left: 9 * fem,
                        top: 96 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 51 * fem,
                            height: 13 * fem,
                            child: Text(
                              'Elwood,VIC',
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
                        // benjaminjamesvK6 (359:111)
                        left: 63.5 * fem,
                        top: 4 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 117 * fem,
                            height: 21 * fem,
                            child: Text(
                              ' Benjamin James',
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
                        // hjA (359:113)
                        left: 304 * fem,
                        top: 6 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 41 * fem,
                            height: 19 * fem,
                            child: Text(
                              '\$8.00',
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
                        // calendarcheckATn (359:18)
                        left: 310 * fem,
                        top: 25 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 138 * fem,
                            height: 26 * fem,
                            child: Stack(
                              children: [
                                // You can use any other widget instead of Icon if needed
                                Icon(
                                  Icons.edit_calendar_outlined,
                                  size: 23 * fem,
                                  color: const Color(0xff000000),
                                ),
                                Positioned(
                                  left: 20 * fem,
                                  // Adjust the left position as needed
                                  child: GestureDetector(
                                    // GestureDetector for handling left movement
                                    onHorizontalDragUpdate: (details) {
                                      // Handle left movement
                                      print('Moving left');
                                      // You can update the left position here
                                    },
                                  ),
                                ),
                                Positioned(
                                  right: 10 * fem,
                                  // Adjust the right position as needed
                                  child: GestureDetector(
                                    // GestureDetector for handling right movement
                                    onHorizontalDragUpdate: (details) {
                                      // Handle right movement
                                      print('Moving right');
                                      // You can update the left position here
                                    },
                                    child: Icon(
                                      Icons.arrow_right,
                                      size: 20 * fem,
                                      color: Colors
                                          .blue, // Change the color as needed
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // nextavaliablefpQ (I359:115;359:16)
                        left: 286 * fem,
                        top: 52 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 63 * fem,
                            height: 13 * fem,
                            child: Text(
                              'Next Avaliable',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 10 * ffem,
                                fontWeight: FontWeight.w200,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xffa27dde),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // tommorow200amkqr (359:116)
                        left: 281 * fem,
                        top: 64 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 72 * fem,
                            height: 11 * fem,
                            child: Text(
                              'Tommorow 2:00AM',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 8 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle154TEU (359:117)
                        left: 72 * fem,
                        top: 83 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 60 * fem,
                            height: 19 * fem,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5 * fem),
                                border:
                                    Border.all(color: const Color(0xff000000)),
                                color: const Color(0xcecaaaff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle155kzG (359:118)
                        left: 205 * fem,
                        top: 83 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 60 * fem,
                            height: 19 * fem,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5 * fem),
                                border:
                                    Border.all(color: const Color(0xff000000)),
                                color: const Color(0xcecaaaff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle156sJC (359:119)
                        left: 139 * fem,
                        top: 83 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 60 * fem,
                            height: 19 * fem,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5 * fem),
                                border:
                                    Border.all(color: const Color(0xff000000)),
                                color: const Color(0xcecaaaff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle157muN (359:120)
                        left: 278 * fem,
                        top: 82 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 75 * fem,
                            height: 26 * fem,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5 * fem),
                                border:
                                    Border.all(color: const Color(0xff000000)),
                                color: const Color(0x47e62a9b),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // HMv (359:121)
                        left: 263 * fem,
                        top: 7 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 15 * fem,
                            height: 13 * fem,
                            child: Text(
                              '5.0',
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
                        // booknowz1S (359:122)
                        left: 287 * fem,
                        top: 87 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 59 * fem,
                            height: 17 * fem,
                            child: Text(
                              'Book Now',
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
                      Positioned(
                        // traumaptsd5Hn (359:123)
                        left: 207 * fem,
                        top: 88 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 56 * fem,
                            height: 11 * fem,
                            child: Text(
                              'Trauma & PTSD',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 8 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // selfesteemakL (359:124)
                        left: 80 * fem,
                        top: 88 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 42 * fem,
                            height: 11 * fem,
                            child: Text(
                              'Self Esteem',
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
                        // spirtualityUap (359:125)
                        left: 151 * fem,
                        top: 88 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 36 * fem,
                            height: 11 * fem,
                            child: Text(
                              'Spirtuality',
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
                        // viewprofileaNx (359:126)
                        left: 212 * fem,
                        top: 56 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 51 * fem,
                            height: 11 * fem,
                            child: Text(
                              'View Profile....',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 8 * ffem,
                                fontWeight: FontWeight.w200,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xffa27dde),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // thrivesonhelpingpeopleliveamor (359:127)
                        left: 65 * fem,
                        top: 50 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 196 * fem,
                            height: 7 * fem,
                            child: Text(
                              'thrives on helping people live a more peaceful and meaningful life.',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Epilogue',
                                fontSize: 6 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.025 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // phychologistYyz (359:198)
                        left: 67 * fem,
                        top: 23 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 83 * fem,
                            height: 14 * fem,
                            child: Text(
                              'PHYCHOLOGIST',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 11 * ffem,
                                fontWeight: FontWeight.w300,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // group14FdW (359:207)
                        left: 188 * fem,
                        top: 6 * fem,
                        child: SizedBox(
                          width: 79 * fem,
                          height: 16 * fem,
                          child: Stack(
                            children: [
                              Positioned(
                                // starN9r (359:199)
                                left: 18 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 28 * fem,
                                    height: 16 * fem,
                                    child: Stack(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 12 * fem,
                                          color: const Color(0xfff39200),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // starN9r (359:199)
                                left: 28 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 28 * fem,
                                    height: 16 * fem,
                                    child: Stack(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 12 * fem,
                                          color: const Color(0xfff39200),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // starN9r (359:199)
                                left: 38 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 28 * fem,
                                    height: 16 * fem,
                                    child: Stack(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 12 * fem,
                                          color: const Color(0xfff39200),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // starN9r (359:199)
                                left: 48 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 28 * fem,
                                    height: 16 * fem,
                                    child: Stack(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 12 * fem,
                                          color: const Color(0xfff39200),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // starN9r (359:199)
                                left: 58 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 28 * fem,
                                    height: 16 * fem,
                                    child: Stack(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 12 * fem,
                                          color: const Color(0xfff39200),
                                        ),
                                      ],
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
              ),
              Positioned(
                // autogroupwtkg5Pa (TqJwukRWKgt8MWaHPqwtKg)
                left: 16 * fem,
                top: 542 * fem,
                child: SizedBox(
                  width: 398 * fem,
                  height: 116 * fem,
                  child: Stack(
                    children: [
                      Positioned(
                        // rectangle158wwa (359:131)
                        left: 0 * fem,
                        top: 0 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 361 * fem,
                            height: 116 * fem,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10 * fem),
                                border:
                                    Border.all(color: const Color(0xff000000)),
                                gradient: const LinearGradient(
                                  begin: Alignment(0, -1),
                                  end: Alignment(0, 1),
                                  colors: <Color>[
                                    Color(0xffd6f5ff),
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
                        // ivebeenworkingintheindustryfor (359:132)
                        left: 69 * fem,
                        top: 60 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 146 * fem,
                            height: 7 * fem,
                            child: Text(
                              'I’ve been working in the industry for 10 years.Cu....',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Epilogue',
                                fontSize: 6 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.025 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // ellipse46tVS (359:133)
                        left: 9 * fem,
                        top: 11 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 60 * fem,
                            height: 53 * fem,
                            child: Image.asset(
                              'assets/page-1/images/ellipse-46-gyJ.png',
                              width: 60 * fem,
                              height: 53 * fem,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // sessionszoN (359:134)
                        left: 13 * fem,
                        top: 68 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 53 * fem,
                            height: 13 * fem,
                            child: Text(
                              '177 Sessions',
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
                        // videoeK6 (359:11)
                        left: 13 * fem,
                        top: 79 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 25 * fem,
                            height: 13 * fem,
                            child: Stack(
                              children: [
                                Icon(
                                  Icons.video_call,
                                  size: 15 * fem,
                                  color: const Color(0xff000000),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // messagev1i (359:19)
                        left: 30 * fem,
                        top: 82 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 39 * fem,
                            height: 13 * fem,
                            child: Stack(
                              children: [
                                Icon(
                                  Icons.message,
                                  size: 11 * fem,
                                  color: const Color(0xff000000),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // callv1i (359:19)
                        left: 43 * fem,
                        top: 81 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 39 * fem,
                            height: 13 * fem,
                            child: Stack(
                              children: [
                                Icon(
                                  Icons.call,
                                  size: 11 * fem,
                                  color: const Color(0xff000000),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // elwoodvic7Fi (359:137)
                        left: 13 * fem,
                        top: 98 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 51 * fem,
                            height: 13 * fem,
                            child: Text(
                              'Elwood,VIC',
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
                        // benjaminjamesouE (359:138)
                        left: 67.5 * fem,
                        top: 6 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 117 * fem,
                            height: 21 * fem,
                            child: Text(
                              ' Benjamin James',
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
                        // counsellorJqz (359:139)
                        left: 73 * fem,
                        top: 26 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 71 * fem,
                            height: 14 * fem,
                            child: Text(
                              'COUNSELLOR',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 11 * ffem,
                                fontWeight: FontWeight.w300,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // Qe8 (359:140)
                        left: 305 * fem,
                        top: 8 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 46 * fem,
                            height: 19 * fem,
                            child: Text(
                              '\$15.00',
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
                        // calendarcheckATn (359:18)
                        left: 310 * fem,
                        top: 25 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 138 * fem,
                            height: 26 * fem,
                            child: Stack(
                              children: [
                                // You can use any other widget instead of Icon if needed
                                Icon(
                                  Icons.edit_calendar_outlined,
                                  size: 23 * fem,
                                  color: const Color(0xff000000),
                                ),
                                Positioned(
                                  left: 20 * fem,
                                  // Adjust the left position as needed
                                  child: GestureDetector(
                                    // GestureDetector for handling left movement
                                    onHorizontalDragUpdate: (details) {
                                      // Handle left movement
                                      print('Moving left');
                                      // You can update the left position here
                                    },
                                  ),
                                ),
                                Positioned(
                                  right: 10 * fem,
                                  // Adjust the right position as needed
                                  child: GestureDetector(
                                    // GestureDetector for handling right movement
                                    onHorizontalDragUpdate: (details) {
                                      // Handle right movement
                                      print('Moving right');
                                      // You can update the left position here
                                    },
                                    child: Icon(
                                      Icons.arrow_right,
                                      size: 20 * fem,
                                      color: Colors
                                          .blue, // Change the color as needed
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // nextavaliable1tp (I359:142;359:16)
                        left: 290 * fem,
                        top: 54 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 63 * fem,
                            height: 13 * fem,
                            child: Text(
                              'Next Avaliable',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 10 * ffem,
                                fontWeight: FontWeight.w200,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xffa27dde),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // tommorow200amiYL (359:143)
                        left: 285 * fem,
                        top: 66 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 72 * fem,
                            height: 11 * fem,
                            child: Text(
                              'Tommorow 2:00AM',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 8 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle159b6L (359:144)
                        left: 76 * fem,
                        top: 85 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 60 * fem,
                            height: 19 * fem,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5 * fem),
                                border:
                                    Border.all(color: const Color(0xff000000)),
                                color: const Color(0xcecaaaff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle160JWY (359:145)
                        left: 209 * fem,
                        top: 85 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 60 * fem,
                            height: 19 * fem,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5 * fem),
                                border:
                                    Border.all(color: const Color(0xff000000)),
                                color: const Color(0xcecaaaff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle161nwW (359:146)
                        left: 143 * fem,
                        top: 85 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 60 * fem,
                            height: 19 * fem,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5 * fem),
                                border:
                                    Border.all(color: const Color(0xff000000)),
                                color: const Color(0xcecaaaff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle162W6p (359:147)
                        left: 282 * fem,
                        top: 84 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 75 * fem,
                            height: 26 * fem,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5 * fem),
                                border:
                                    Border.all(color: const Color(0xff000000)),
                                color: const Color(0x47e62a9b),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // p7W (359:148)
                        left: 267 * fem,
                        top: 9 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 15 * fem,
                            height: 13 * fem,
                            child: Text(
                              '5.0',
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
                        // booknowvAY (359:149)
                        left: 291 * fem,
                        top: 89 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 59 * fem,
                            height: 17 * fem,
                            child: Text(
                              'Book Now',
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
                      Positioned(
                        // traumaptsdpmi (359:150)
                        left: 211 * fem,
                        top: 90 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 56 * fem,
                            height: 11 * fem,
                            child: Text(
                              'Trauma & PTSD',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 8 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // selfesteemLEG (359:151)
                        left: 84 * fem,
                        top: 90 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 42 * fem,
                            height: 11 * fem,
                            child: Text(
                              'Self Esteem',
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
                        // spirtualitydUG (359:152)
                        left: 155 * fem,
                        top: 90 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 36 * fem,
                            height: 11 * fem,
                            child: Text(
                              'Spirtuality',
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
                        // viewprofileXZe (359:153)
                        left: 216 * fem,
                        top: 58 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 51 * fem,
                            height: 11 * fem,
                            child: Text(
                              'View Profile....',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 8 * ffem,
                                fontWeight: FontWeight.w200,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xffa27dde),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // thrivesonhelpingpeopleliveamor (359:154)
                        left: 69 * fem,
                        top: 52 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 196 * fem,
                            height: 7 * fem,
                            child: Text(
                              'thrives on helping people live a more peaceful and meaningful life.',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Epilogue',
                                fontSize: 6 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.025 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // group15u4Q (359:213)
                        left: 193 * fem,
                        top: 9 * fem,
                        child: SizedBox(
                          width: 79 * fem,
                          height: 16 * fem,
                          child: Stack(
                            children: [
                              Positioned(
                                // starN9r (359:199)
                                left: 18 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 28 * fem,
                                    height: 16 * fem,
                                    child: Stack(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 12 * fem,
                                          color: const Color(0xfff39200),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // starN9r (359:199)
                                left: 28 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 28 * fem,
                                    height: 16 * fem,
                                    child: Stack(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 12 * fem,
                                          color: const Color(0xfff39200),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // starN9r (359:199)
                                left: 38 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 28 * fem,
                                    height: 16 * fem,
                                    child: Stack(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 12 * fem,
                                          color: const Color(0xfff39200),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // starN9r (359:199)
                                left: 48 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 28 * fem,
                                    height: 16 * fem,
                                    child: Stack(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 12 * fem,
                                          color: const Color(0xfff39200),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // starN9r (359:199)
                                left: 58 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 28 * fem,
                                    height: 16 * fem,
                                    child: Stack(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 12 * fem,
                                          color: const Color(0xfff39200),
                                        ),
                                      ],
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
              ),
              Positioned(
                // autogroupxxsguVe (TqJxkor6TyFCpgLx9KxxsG)
                left: 16 * fem,
                top: 675 * fem,
                child: SizedBox(
                  width: 398 * fem,
                  height: 116 * fem,
                  child: Stack(
                    children: [
                      Positioned(
                        // rectangle163Bi4 (359:158)
                        left: 0 * fem,
                        top: 0 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 361 * fem,
                            height: 116 * fem,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10 * fem),
                                border:
                                    Border.all(color: const Color(0xff000000)),
                                gradient: const LinearGradient(
                                  begin: Alignment(0, -1),
                                  end: Alignment(0, 1),
                                  colors: <Color>[
                                    Color(0xffd6f5ff),
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
                        // ivebeenworkingintheindustryfor (359:159)
                        left: 69 * fem,
                        top: 60 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 146 * fem,
                            height: 7 * fem,
                            child: Text(
                              'I’ve been working in the industry for 10 years.Cu....',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Epilogue',
                                fontSize: 6 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.025 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // ellipse476yS (359:160)
                        left: 9 * fem,
                        top: 11 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 60 * fem,
                            height: 53 * fem,
                            child: Image.asset(
                              'assets/page-1/images/ellipse-47-pqi.png',
                              width: 60 * fem,
                              height: 53 * fem,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // sessionsRF2 (359:161)
                        left: 13 * fem,
                        top: 68 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 53 * fem,
                            height: 13 * fem,
                            child: Text(
                              '177 Sessions',
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
                        // videoeK6 (359:11)
                        left: 13 * fem,
                        top: 79 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 25 * fem,
                            height: 13 * fem,
                            child: Stack(
                              children: [
                                Icon(
                                  Icons.video_call,
                                  size: 15 * fem,
                                  color: const Color(0xff000000),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // messagev1i (359:19)
                        left: 30 * fem,
                        top: 82 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 39 * fem,
                            height: 13 * fem,
                            child: Stack(
                              children: [
                                Icon(
                                  Icons.message,
                                  size: 11 * fem,
                                  color: const Color(0xff000000),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // callv1i (359:19)
                        left: 43 * fem,
                        top: 81 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 39 * fem,
                            height: 13 * fem,
                            child: Stack(
                              children: [
                                Icon(
                                  Icons.call,
                                  size: 11 * fem,
                                  color: const Color(0xff000000),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // elwoodvicvb6 (359:164)
                        left: 13 * fem,
                        top: 98 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 51 * fem,
                            height: 13 * fem,
                            child: Text(
                              'Elwood,VIC',
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
                        // benjaminjamesdEc (359:165)
                        left: 67.5 * fem,
                        top: 6 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 117 * fem,
                            height: 21 * fem,
                            child: Text(
                              ' Benjamin James',
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
                        // counsellorKdE (359:166)
                        left: 73 * fem,
                        top: 26 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 71 * fem,
                            height: 14 * fem,
                            child: Text(
                              'COUNSELLOR',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 11 * ffem,
                                fontWeight: FontWeight.w300,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // DCp (359:167)
                        left: 308 * fem,
                        top: 8 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 41 * fem,
                            height: 19 * fem,
                            child: Text(
                              '\$5.00',
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
                        // calendarcheckATn (359:18)
                        left: 310 * fem,
                        top: 25 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 138 * fem,
                            height: 26 * fem,
                            child: Stack(
                              children: [
                                // You can use any other widget instead of Icon if needed
                                Icon(
                                  Icons.edit_calendar_outlined,
                                  size: 23 * fem,
                                  color: const Color(0xff000000),
                                ),
                                Positioned(
                                  left: 20 * fem,
                                  // Adjust the left position as needed
                                  child: GestureDetector(
                                    // GestureDetector for handling left movement
                                    onHorizontalDragUpdate: (details) {
                                      // Handle left movement
                                      print('Moving left');
                                      // You can update the left position here
                                    },
                                  ),
                                ),
                                Positioned(
                                  right: 10 * fem,
                                  // Adjust the right position as needed
                                  child: GestureDetector(
                                    // GestureDetector for handling right movement
                                    onHorizontalDragUpdate: (details) {
                                      // Handle right movement
                                      print('Moving right');
                                      // You can update the left position here
                                    },
                                    child: Icon(
                                      Icons.arrow_right,
                                      size: 20 * fem,
                                      color: Colors
                                          .blue, // Change the color as needed
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // nextavaliableR3z (I359:169;359:16)
                        left: 290 * fem,
                        top: 54 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 63 * fem,
                            height: 13 * fem,
                            child: Text(
                              'Next Avaliable',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 10 * ffem,
                                fontWeight: FontWeight.w200,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xffa27dde),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // tommorow200amW5S (359:170)
                        left: 285 * fem,
                        top: 66 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 72 * fem,
                            height: 11 * fem,
                            child: Text(
                              'Tommorow 2:00AM',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 8 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle164Pf2 (359:171)
                        left: 76 * fem,
                        top: 85 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 60 * fem,
                            height: 19 * fem,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5 * fem),
                                border:
                                    Border.all(color: const Color(0xff000000)),
                                color: const Color(0xcecaaaff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle165hfi (359:172)
                        left: 209 * fem,
                        top: 85 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 60 * fem,
                            height: 19 * fem,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5 * fem),
                                border:
                                    Border.all(color: const Color(0xff000000)),
                                color: const Color(0xcecaaaff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle166cng (359:173)
                        left: 143 * fem,
                        top: 85 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 60 * fem,
                            height: 19 * fem,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5 * fem),
                                border:
                                    Border.all(color: const Color(0xff000000)),
                                color: const Color(0xcecaaaff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // rectangle167LTn (359:174)
                        left: 282 * fem,
                        top: 84 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 75 * fem,
                            height: 26 * fem,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5 * fem),
                                border:
                                    Border.all(color: const Color(0xff000000)),
                                color: const Color(0x47e62a9b),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // SWp (359:175)
                        left: 267 * fem,
                        top: 9 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 15 * fem,
                            height: 13 * fem,
                            child: Text(
                              '5.0',
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
                        // booknow8uS (359:176)
                        left: 291 * fem,
                        top: 89 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 59 * fem,
                            height: 17 * fem,
                            child: Text(
                              'Book Now',
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
                      Positioned(
                        // traumaptsdr4k (359:177)
                        left: 211 * fem,
                        top: 90 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 56 * fem,
                            height: 11 * fem,
                            child: Text(
                              'Trauma & PTSD',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 8 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // selfesteemMXJ (359:178)
                        left: 84 * fem,
                        top: 90 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 42 * fem,
                            height: 11 * fem,
                            child: Text(
                              'Self Esteem',
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
                        // spirtuality39E (359:179)
                        left: 155 * fem,
                        top: 90 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 36 * fem,
                            height: 11 * fem,
                            child: Text(
                              'Spirtuality',
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
                        // viewprofile8wN (359:180)
                        left: 216 * fem,
                        top: 58 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 51 * fem,
                            height: 11 * fem,
                            child: Text(
                              'View Profile....',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 8 * ffem,
                                fontWeight: FontWeight.w200,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xffa27dde),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // thrivesonhelpingpeopleliveamor (359:181)
                        left: 69 * fem,
                        top: 52 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 196 * fem,
                            height: 7 * fem,
                            child: Text(
                              'thrives on helping people live a more peaceful and meaningful life.',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Epilogue',
                                fontSize: 6 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.025 * ffem / fem,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // group16qjJ (359:225)
                        left: 193 * fem,
                        top: 8 * fem,
                        child: SizedBox(
                          width: 79 * fem,
                          height: 16 * fem,
                          child: Stack(
                            children: [
                              Positioned(
                                // starN9r (359:199)
                                left: 18 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 28 * fem,
                                    height: 16 * fem,
                                    child: Stack(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 12 * fem,
                                          color: const Color(0xfff39200),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // starN9r (359:199)
                                left: 28 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 28 * fem,
                                    height: 16 * fem,
                                    child: Stack(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 12 * fem,
                                          color: const Color(0xfff39200),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // starN9r (359:199)
                                left: 38 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 28 * fem,
                                    height: 16 * fem,
                                    child: Stack(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 12 * fem,
                                          color: const Color(0xfff39200),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // starN9r (359:199)
                                left: 48 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 28 * fem,
                                    height: 16 * fem,
                                    child: Stack(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 12 * fem,
                                          color: const Color(0xfff39200),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // starN9r (359:199)
                                left: 58 * fem,
                                top: 0 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 28 * fem,
                                    height: 16 * fem,
                                    child: Stack(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 12 * fem,
                                          color: const Color(0xfff39200),
                                        ),
                                      ],
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
              ),
              Positioned(
                // autogroupvpljgWx (TqJyNNfAduwhAxymLfVPLJ)
                left: 59.5 * fem,
                top: 806 * fem,
                child: SizedBox(
                  width: 264.5 * fem,
                  height: 42 * fem,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        // autogroups5d8b88 (TqJyYxBsgC5PXQ2hamS5D8)
                        margin: EdgeInsets.fromLTRB(
                            0 * fem, 0 * fem, 10 * fem, 0 * fem),
                        width: 61 * fem,
                        height: 40 * fem,
                        child: Stack(
                          children: [
                            Positioned(
                              // homeWVz (359:184)
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
                              // homeQ5a (359:188)
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
                        // autogroupx28nHv4 (TqJydx3YhizM8AkGyQx28N)
                        width: 193.5 * fem,
                        height: double.infinity,
                        child: Stack(
                          children: [
                            Positioned(
                              // smileEKW (359:185)
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
                              // stethoscope89z (359:186)
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
                              // bellDhE (359:187)
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
                              // mood7Xi (359:189)
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
                              // therepycjN (359:190)
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
                              // remindervEG (359:191)
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
              ),
              Positioned(
                // group11Qv8 (359:192)
                left: 21 * fem,
                top: 20 * fem,
                child: SizedBox(
                  width: 383.5 * fem,
                  height: 20 * fem,
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [],
                  ),
                ),
              ),
              Positioned(
                // welcomemynameisbanjaminjamesia (359:64)
                left: 86 * fem,
                top: 319 * fem,
                child: Align(
                  child: SizedBox(
                    width: 198 * fem,
                    height: 7 * fem,
                    child: Text(
                      'welcome! My name is Banjamin James. I am passionate person that',
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont(
                        'Epilogue',
                        fontSize: 6 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.025 * ffem / fem,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                // welcomemynameisbanjaminjamesia (359:128)
                left: 82 * fem,
                top: 448 * fem,
                child: Align(
                  child: SizedBox(
                    width: 198 * fem,
                    height: 7 * fem,
                    child: Text(
                      'welcome! My name is Banjamin James. I am passionate person that',
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont(
                        'Epilogue',
                        fontSize: 6 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.025 * ffem / fem,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                // welcomemynameisbanjaminjamesia (359:155)
                left: 86 * fem,
                top: 586 * fem,
                child: Align(
                  child: SizedBox(
                    width: 198 * fem,
                    height: 7 * fem,
                    child: Text(
                      'welcome! My name is Banjamin James. I am passionate person that',
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont(
                        'Epilogue',
                        fontSize: 6 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.025 * ffem / fem,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                // welcomemynameisbanjaminjamesia (359:182)
                left: 86 * fem,
                top: 719 * fem,
                child: Align(
                  child: SizedBox(
                    width: 198 * fem,
                    height: 7 * fem,
                    child: Text(
                      'welcome! My name is Banjamin James. I am passionate person that',
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont(
                        'Epilogue',
                        fontSize: 6 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.025 * ffem / fem,
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
    );
  }
}
