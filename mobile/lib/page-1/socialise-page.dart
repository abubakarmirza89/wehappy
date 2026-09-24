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
        // socialisepageJeQ (343:34)
        width: double.infinity,
        height: 852 * fem,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/page-1/images/socialise-page-bg.png',
            ),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              // autogroupzsvzBCQ (TqJqovb4rMSFuj2KkSzSvz)
              left: 59.5 * fem,
              top: 803 * fem,
              child: SizedBox(
                width: 264.5 * fem,
                height: 42 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      // autogrouprvlnHFS (TqJr1vF5iS2ZMB9JgoRvLN)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 10 * fem, 0 * fem),
                      width: 61 * fem,
                      height: 40 * fem,
                      child: Stack(
                        children: [
                          Positioned(
                            // homeCtC (359:240)
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
                            // hometW8 (359:244)
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
                      // autogroupwgqemZv (TqJr6zvx2RZCYMohzzWGQE)
                      width: 193.5 * fem,
                      height: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            // smileJJx (359:241)
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
                            // stethoscopezSg (359:242)
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
                            // bellHAt (359:243)
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
                            // moodn7e (359:245)
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
                            // therepyset (359:246)
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
                            // reminderNbe (359:247)
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
              // group11gMS (359:287)
              left: 25 * fem,
              top: 26 * fem,
              child: SizedBox(
                width: 383.5 * fem,
                height: 20 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // pmPWk (359:288)
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
                      // autogroupymew6RA (TqJrbV7V5MxfTZ6Hj5YmEW)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 1 * fem, 0 * fem, 0 * fem),
                      width: 131 * fem,
                      height: 19 * fem,
                      child: Stack(
                        children: [
                          Positioned(
                            // signal1o2 (359:289)
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
                            // wifiWjn (359:290)
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
                            // batteryfullpVa (359:291)
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
            ),
            Positioned(
              // autogroupnpjiKBS (TqJmKZ4umtGKBA5RuYnpJi)
              left: 12 * fem,
              top: 63 * fem,
              child: SizedBox(
                width: 338 * fem,
                height: 31 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // barsSG4 (403:212)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 2 * fem, 2 * fem, 0 * fem),
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
                    Container(
                      // searchZ5n (403:208)
                      padding: EdgeInsets.fromLTRB(
                          12 * fem, 5 * fem, 11 * fem, 6 * fem),
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20 * fem),
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            'assets/page-1/images/rectangle-75-Y68.png',
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            // searchfriendsrqa (403:210)
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 139 * fem, 1 * fem),
                            child: Text(
                              'Search Friends',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Outfit',
                                fontSize: 15 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.26 * ffem / fem,
                                color: const Color(0xffaaa4a4),
                              ),
                            ),
                          ),
                          Container(
                            // searchNov (403:211)
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 1 * fem, 0 * fem, 0 * fem),
                            child: Text(
                              'search',
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Font Awesome 5 Free',
                                fontSize: 15 * ffem,
                                fontWeight: FontWeight.w900,
                                height: 1.2575 * ffem / fem,
                                color: const Color(0xffaaa4a4),
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
              // autogroupyqdp5TS (TqJmcsuNoLEJb2hHviyqDp)
              left: 25 * fem,
              top: 109 * fem,
              child: SizedBox(
                width: 324 * fem,
                height: 41 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      // autogroupwwarMQx (TqJmpHk2gCWpsbCVQGWWar)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 203 * fem, 0 * fem),
                      width: 85 * fem,
                      height: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            // friendsSxC (403:213)
                            left: 0 * fem,
                            top: 0 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 67 * fem,
                                height: 26 * fem,
                                child: Text(
                                  'Friends',
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
                            // friendrequests61A (403:214)
                            left: 0 * fem,
                            top: 25 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 85 * fem,
                                height: 16 * fem,
                                child: Text(
                                  'Friend Requests',
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
                        ],
                      ),
                    ),
                    Text(
                      // seeallm7J (403:217)
                      'See All',
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont(
                        'Outfit',
                        fontSize: 12 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.26 * ffem / fem,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              // nonewrequestVZ6 (403:215)
              left: 152 * fem,
              top: 174 * fem,
              child: Align(
                child: SizedBox(
                  width: 87 * fem,
                  height: 16 * fem,
                  child: Text(
                    'No New Request',
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont(
                      'Outfit',
                      fontSize: 12 * ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.26 * ffem / fem,
                      color: const Color(0xffa27dde),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              // line83yUG (403:218)
              left: 28 * fem,
              top: 209 * fem,
              child: Align(
                child: SizedBox(
                  width: 349 * fem,
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
              // peopleyoumayknow636 (403:219)
              left: 27.5 * fem,
              top: 217 * fem,
              child: Align(
                child: SizedBox(
                  width: 156 * fem,
                  height: 21 * fem,
                  child: Text(
                    'People You May Know',
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
              // autogroup5ebgz8U (TqJmvnZCozW59nvwQi5eBG)
              left: 16 * fem,
              top: 252 * fem,
              child: SizedBox(
                width: 287 * fem,
                height: 68 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      // ellipse587it (403:220)
                      width: 76 * fem,
                      height: 68 * fem,
                      child: Image.asset(
                        'assets/page-1/images/ellipse-58.png',
                        width: 76 * fem,
                        height: 68 * fem,
                      ),
                    ),
                    Container(
                      // autogroupcv2jFaC (TqJnTXAzXKWy68jq4VCv2J)
                      padding: EdgeInsets.fromLTRB(
                          7 * fem, 3 * fem, 0 * fem, 3 * fem),
                      height: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            // autogroupvh9ynKE (TqJnAn9tV5rkq9jkW7vh9Y)
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 15 * fem, 0 * fem),
                            width: 97 * fem,
                            height: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  // sarahedwardJoN (403:221)
                                  margin: EdgeInsets.fromLTRB(
                                      0 * fem, 0 * fem, 0 * fem, 12 * fem),
                                  child: Text(
                                    'Sarah Edward',
                                    textAlign: TextAlign.center,
                                    style: SafeGoogleFont(
                                      'Outfit',
                                      fontSize: 15 * ffem,
                                      fontWeight: FontWeight.w600,
                                      height: 1.26 * ffem / fem,
                                      color: const Color(0xff000000),
                                    ),
                                  ),
                                ),
                                Container(
                                  // autogroupzsn2cJG (TqJnFwfx5Y15ckLyjrZSN2)
                                  margin: EdgeInsets.fromLTRB(
                                      3 * fem, 0 * fem, 2 * fem, 0 * fem),
                                  width: double.infinity,
                                  height: 31 * fem,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff000000)),
                                    borderRadius:
                                        BorderRadius.circular(10 * fem),
                                    gradient: const LinearGradient(
                                      begin: Alignment(0, -1),
                                      end: Alignment(0, 1),
                                      colors: <Color>[
                                        Color(0xffd5f5ff),
                                        Color(0xffffe9e9)
                                      ],
                                      stops: <double>[0, 1],
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Add Friend',
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
                              ],
                            ),
                          ),
                          Container(
                            // autogroup8zxsp9S (TqJnNSV8DKzKtx5RkJ8ZxS)
                            width: 92 * fem,
                            height: 31 * fem,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xff000000)),
                              borderRadius: BorderRadius.circular(10 * fem),
                              gradient: const LinearGradient(
                                begin: Alignment(0, -1),
                                end: Alignment(0, 1),
                                colors: <Color>[
                                  Color(0xffd5f5ff),
                                  Color(0xffffe9e9)
                                ],
                                stops: <double>[0, 1],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Remove',
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              // autogroupbwcjFEk (TqJnkRrV8UQYXwdZTwbwCJ)
              left: 16 * fem,
              top: 348 * fem,
              child: SizedBox(
                width: 287 * fem,
                height: 68 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      // ellipse59ZmE (407:292)
                      width: 76 * fem,
                      height: 68 * fem,
                      child: Image.asset(
                        'assets/page-1/images/ellipse-59.png',
                        width: 76 * fem,
                        height: 68 * fem,
                      ),
                    ),
                    Container(
                      // autogroupkdushsS (TqJoFAXc2nf4ENkcxfKdUS)
                      padding: EdgeInsets.fromLTRB(
                          7 * fem, 3 * fem, 0 * fem, 3 * fem),
                      height: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            // autogroupjbxkqik (TqJnyWK2gWzigm3HQNJbXk)
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 15 * fem, 0 * fem),
                            width: 97 * fem,
                            height: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  // sarahedwardNCt (407:293)
                                  margin: EdgeInsets.fromLTRB(
                                      0 * fem, 0 * fem, 0 * fem, 12 * fem),
                                  child: Text(
                                    'Sarah Edward',
                                    textAlign: TextAlign.center,
                                    style: SafeGoogleFont(
                                      'Outfit',
                                      fontSize: 15 * ffem,
                                      fontWeight: FontWeight.w600,
                                      height: 1.26 * ffem / fem,
                                      color: const Color(0xff000000),
                                    ),
                                  ),
                                ),
                                Container(
                                  // autogrouppyszUWp (TqJo4WAhi3ugHXkro1pYSz)
                                  margin: EdgeInsets.fromLTRB(
                                      3 * fem, 0 * fem, 2 * fem, 0 * fem),
                                  width: double.infinity,
                                  height: 31 * fem,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff000000)),
                                    borderRadius:
                                        BorderRadius.circular(10 * fem),
                                    gradient: const LinearGradient(
                                      begin: Alignment(0, -1),
                                      end: Alignment(0, 1),
                                      colors: <Color>[
                                        Color(0xffd5f5ff),
                                        Color(0xffffe9e9)
                                      ],
                                      stops: <double>[0, 1],
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Add Friend',
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
                              ],
                            ),
                          ),
                          Container(
                            // autogroupttwr62Q (TqJo9ara23SKUiRG7CttWr)
                            width: 92 * fem,
                            height: 31 * fem,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xff000000)),
                              borderRadius: BorderRadius.circular(10 * fem),
                              gradient: const LinearGradient(
                                begin: Alignment(0, -1),
                                end: Alignment(0, 1),
                                colors: <Color>[
                                  Color(0xffd5f5ff),
                                  Color(0xffffe9e9)
                                ],
                                stops: <double>[0, 1],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Remove',
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              // autogroupzgxq2aG (TqJoWKm1gJdJDWnzygzGXQ)
              left: 20 * fem,
              top: 447 * fem,
              child: SizedBox(
                width: 287 * fem,
                height: 68 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      // ellipse60LL4 (407:298)
                      width: 76 * fem,
                      height: 68 * fem,
                      child: Image.asset(
                        'assets/page-1/images/ellipse-60.png',
                        width: 76 * fem,
                        height: 68 * fem,
                      ),
                    ),
                    Container(
                      // autogroupjz62USG (TqJoxyfGV9Vk5dHQPojz62)
                      padding: EdgeInsets.fromLTRB(
                          7 * fem, 3 * fem, 0 * fem, 3 * fem),
                      height: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            // autogroupkyuv1h6 (TqJoi4vSh1NYsj5W9QkYUv)
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 15 * fem, 0 * fem),
                            width: 97 * fem,
                            height: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  // sarahedwardYS8 (407:299)
                                  margin: EdgeInsets.fromLTRB(
                                      0 * fem, 0 * fem, 0 * fem, 12 * fem),
                                  child: Text(
                                    'Sarah Edward',
                                    textAlign: TextAlign.center,
                                    style: SafeGoogleFont(
                                      'Outfit',
                                      fontSize: 15 * ffem,
                                      fontWeight: FontWeight.w600,
                                      height: 1.26 * ffem / fem,
                                      color: const Color(0xff000000),
                                    ),
                                  ),
                                ),
                                Container(
                                  // autogroupmhmpfFr (TqJonUxkjKyjKcBJ5FMhMp)
                                  margin: EdgeInsets.fromLTRB(
                                      3 * fem, 0 * fem, 2 * fem, 0 * fem),
                                  width: double.infinity,
                                  height: 31 * fem,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff000000)),
                                    borderRadius:
                                        BorderRadius.circular(10 * fem),
                                    gradient: const LinearGradient(
                                      begin: Alignment(0, -1),
                                      end: Alignment(0, 1),
                                      colors: <Color>[
                                        Color(0xffd5f5ff),
                                        Color(0xffffe9e9)
                                      ],
                                      stops: <double>[0, 1],
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Add Friend',
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
                              ],
                            ),
                          ),
                          Container(
                            // autogroup7esyUyz (TqJosp9CthMRJ2gBA57EsY)
                            width: 92 * fem,
                            height: 31 * fem,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xff000000)),
                              borderRadius: BorderRadius.circular(10 * fem),
                              gradient: const LinearGradient(
                                begin: Alignment(0, -1),
                                end: Alignment(0, 1),
                                colors: <Color>[
                                  Color(0xffd5f5ff),
                                  Color(0xffffe9e9)
                                ],
                                stops: <double>[0, 1],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Remove',
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              // autogroupqcc66Va (TqJpGy9HnGPCEoTsoLQCC6)
              left: 20 * fem,
              top: 549 * fem,
              child: SizedBox(
                width: 287 * fem,
                height: 68 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      // ellipse611cY (407:304)
                      width: 76 * fem,
                      height: 68 * fem,
                      child: Image.asset(
                        'assets/page-1/images/ellipse-61.png',
                        width: 76 * fem,
                        height: 68 * fem,
                      ),
                    ),
                    Container(
                      // autogrouppwj6xGt (TqJph87i5LoAJXbVX8PwJ6)
                      padding: EdgeInsets.fromLTRB(
                          7 * fem, 3 * fem, 0 * fem, 3 * fem),
                      height: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            // autogroup25wnsue (TqJpToAafvMwNUMHp525Wn)
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 15 * fem, 0 * fem),
                            width: 97 * fem,
                            height: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  // sarahedwardooJ (407:305)
                                  margin: EdgeInsets.fromLTRB(
                                      0 * fem, 0 * fem, 0 * fem, 12 * fem),
                                  child: Text(
                                    'Sarah Edward',
                                    textAlign: TextAlign.center,
                                    style: SafeGoogleFont(
                                      'Outfit',
                                      fontSize: 15 * ffem,
                                      fontWeight: FontWeight.w600,
                                      height: 1.26 * ffem / fem,
                                      color: const Color(0xff000000),
                                    ),
                                  ),
                                ),
                                Container(
                                  // autogroupk2gv7oz (TqJpYNsHHACV1BLjazk2gv)
                                  margin: EdgeInsets.fromLTRB(
                                      3 * fem, 0 * fem, 2 * fem, 0 * fem),
                                  width: double.infinity,
                                  height: 31 * fem,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff000000)),
                                    borderRadius:
                                        BorderRadius.circular(10 * fem),
                                    gradient: const LinearGradient(
                                      begin: Alignment(0, -1),
                                      end: Alignment(0, 1),
                                      colors: <Color>[
                                        Color(0xffd5f5ff),
                                        Color(0xffffe9e9)
                                      ],
                                      stops: <double>[0, 1],
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Add Friend',
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
                              ],
                            ),
                          ),
                          Container(
                            // autogrouptys4jaU (TqJpcxZytQ32dtLBMvTys4)
                            width: 92 * fem,
                            height: 31 * fem,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xff000000)),
                              borderRadius: BorderRadius.circular(10 * fem),
                              gradient: const LinearGradient(
                                begin: Alignment(0, -1),
                                end: Alignment(0, 1),
                                colors: <Color>[
                                  Color(0xffd5f5ff),
                                  Color(0xffffe9e9)
                                ],
                                stops: <double>[0, 1],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Remove',
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              // autogroupezqgMrk (TqJpy7f4ZSvEDo68mbeZqG)
              left: 20 * fem,
              top: 639 * fem,
              child: SizedBox(
                width: 287 * fem,
                height: 68 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      // ellipse62UgU (407:310)
                      width: 76 * fem,
                      height: 68 * fem,
                      child: Image.asset(
                        'assets/page-1/images/ellipse-62.png',
                        width: 76 * fem,
                        height: 68 * fem,
                      ),
                    ),
                    Container(
                      // autogroupqtfg1wJ (TqJqRgj85qAzVVdiGAqtFG)
                      padding: EdgeInsets.fromLTRB(
                          7 * fem, 3 * fem, 0 * fem, 3 * fem),
                      height: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            // autogroupkdq8X8x (TqJqBSdrZMyG2tzRQ8Kdq8)
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 15 * fem, 0 * fem),
                            width: 97 * fem,
                            height: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  // sarahedwardEJG (407:311)
                                  margin: EdgeInsets.fromLTRB(
                                      0 * fem, 0 * fem, 0 * fem, 12 * fem),
                                  child: Text(
                                    'Sarah Edward',
                                    textAlign: TextAlign.center,
                                    style: SafeGoogleFont(
                                      'Outfit',
                                      fontSize: 15 * ffem,
                                      fontWeight: FontWeight.w600,
                                      height: 1.26 * ffem / fem,
                                      color: const Color(0xff000000),
                                    ),
                                  ),
                                ),
                                Container(
                                  // autogroupnpzqYJx (TqJqFmqyKDxktN9PQRNPZQ)
                                  margin: EdgeInsets.fromLTRB(
                                      3 * fem, 0 * fem, 2 * fem, 0 * fem),
                                  width: double.infinity,
                                  height: 31 * fem,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff000000)),
                                    borderRadius:
                                        BorderRadius.circular(10 * fem),
                                    gradient: const LinearGradient(
                                      begin: Alignment(0, -1),
                                      end: Alignment(0, 1),
                                      colors: <Color>[
                                        Color(0xffd5f5ff),
                                        Color(0xffffe9e9)
                                      ],
                                      stops: <double>[0, 1],
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Add Friend',
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
                              ],
                            ),
                          ),
                          Container(
                            // autogroup7w58mhW (TqJqM72RUbLSrneGVF7w58)
                            width: 92 * fem,
                            height: 31 * fem,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xff000000)),
                              borderRadius: BorderRadius.circular(10 * fem),
                              gradient: const LinearGradient(
                                begin: Alignment(0, -1),
                                end: Alignment(0, 1),
                                colors: <Color>[
                                  Color(0xffd5f5ff),
                                  Color(0xffffe9e9)
                                ],
                                stops: <double>[0, 1],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Remove',
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              // autogroup8y4vCXv (TqJqfbVcUTuzaSVhS38Y4v)
              left: 162 * fem,
              top: 741 * fem,
              child: Container(
                width: 89 * fem,
                height: 33 * fem,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff000000)),
                  borderRadius: BorderRadius.circular(5 * fem),
                  gradient: const LinearGradient(
                    begin: Alignment(0, -1),
                    end: Alignment(0, 1),
                    colors: <Color>[Color(0xffa27dde), Color(0xffffe9e9)],
                    stops: <double>[0, 1],
                  ),
                ),
                child: Center(
                  child: Text(
                    'See All',
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont(
                      'Outfit',
                      fontSize: 15 * ffem,
                      fontWeight: FontWeight.w600,
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
    );
  }
}
