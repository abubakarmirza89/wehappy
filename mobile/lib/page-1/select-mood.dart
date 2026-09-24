import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/globals/globals.dart' as globals;
import 'package:myapp/utils.dart';

import 'mood-suggestion.dart';

class SelectMood extends StatefulWidget {
  const SelectMood({Key? key}) : super(key: key);

  @override
  _SelectMoodState createState() => _SelectMoodState();
}

class _SelectMoodState extends State<SelectMood> {
  late List<Map<String, dynamic>> moods;

  @override
  void initState() {
    super.initState();
    fetchMoods();
  }

  Future<void> fetchMoods() async {
    final String baseUrl = globals.baseurl; // Replace with your actual base URL
    final String moodUrl = "$baseUrl/api/moods/";
    print("Access Token : ${globals.accessToken}");

    try {
      final response = await http.get(
        Uri.parse(moodUrl),
        headers: {
          'Authorization': 'Token ${globals.accessToken}',
          // Add other headers if needed
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print(response.body);

        setState(() {
          moods = List<Map<String, dynamic>>.from(data);
        });
      } else {
        // Handle errors here
        print('Failed to load moods');
        print(response.body);
      }
    } catch (e) {
      // Handle exceptions
      print("Exception during fetchMoods: $e");
      // Handle errors here
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 393;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Container(
          // selectmoodypG (45:4)
          padding: EdgeInsets.fromLTRB(6 * fem, 23 * fem, 0 * fem, 8 * fem),
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/page-1/images/select-mood-bg.png',
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // howareyoufeelingtodayJ9i (185:299)
                margin:
                    EdgeInsets.fromLTRB(0 * fem, 50 * fem, 11 * fem, 26 * fem),
                child: Text(
                  'HOW ARE YOU FEELING TODAY ?',
                  textAlign: TextAlign.center,
                  style: SafeGoogleFont(
                    'Inter',
                    fontSize: 20 * ffem,
                    fontWeight: FontWeight.w700,
                    height: 1.2125 * ffem / fem,
                    color: const Color(0xffcaaaff),
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.fromLTRB(10 * fem, 0 * fem, 10 * fem, 17 * fem),
                width: double.infinity,
                height: 300, // Adjust the height based on your requirements
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    // Number of items per row
                    crossAxisSpacing: 5.0,
                    // Adjust the spacing between items horizontally
                    mainAxisSpacing:
                        5.0, // Adjust the spacing between items vertically
                  ),
                  itemCount: moods.length,
                  // Assuming moods is a List of mood items
                  itemBuilder: (BuildContext context, int index) {
                    // Sort moods by 'id' before displaying
                    List<Map<String, dynamic>> sortedMoods =
                        List<Map<String, dynamic>>.from(moods)
                          ..sort((a, b) => a['id'].compareTo(b['id']));

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MoodSuggestion(),
                          ),
                        );
                      },
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 57 * fem,
                              height: 70 * fem,
                              child: Image.network(
                                sortedMoods[index]['img_emoji'],
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                sortedMoods[index]['name'],
                                textAlign: TextAlign.center,
                                style: SafeGoogleFont(
                                  'Outfit',
                                  fontSize: 14 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5 * ffem / fem,
                                  color: const Color(0xff000000),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                // autogroupzfkjDMn (TqHENrmbExjnbK8v6rZfkJ)
                margin: EdgeInsets.fromLTRB(
                    149 * fem, 0 * fem, 157 * fem, 10 * fem),
                width: double.infinity,
                height: 29 * fem,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      'assets/page-1/images/rectangle-8.png',
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    'SAVE',
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont(
                      'Outfit',
                      fontSize: 20 * ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.26 * ffem / fem,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
              ),
              Container(
                // autogroupxprqfzU (TqHEWXDVMBLbBJ6w2uxPRQ)
                margin:
                    EdgeInsets.fromLTRB(0 * fem, 0 * fem, 11 * fem, 12 * fem),
                width: 400 * fem,
                height: 163 * fem,
                child: Stack(
                  children: [
                    Positioned(
                      // rectangle12PvU (136:15)
                      left: 269.5 * fem,
                      top: 59 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 79 * fem,
                          height: 38 * fem,
                          child: Image.asset(
                            'assets/page-1/images/rectangle-12.png',
                            width: 79 * fem,
                            height: 38 * fem,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // rectangle1575n (136:20)
                      left: 0 * fem,
                      top: 0 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 380 * fem,
                          height: 163 * fem,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30 * fem),
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
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // rectangle13NGc (136:16)
                      left: 21 * fem,
                      top: 24 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 89 * fem,
                          height: 30 * fem,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60 * fem),
                              color: const Color(0xb5caaaff),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // todayTYx (136:3)
                      left: 42 * fem,
                      top: 31 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 44 * fem,
                          height: 17 * fem,
                          child: Text(
                            'TODAY',
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
                      // rectangle11xEp (136:14)
                      left: 138 * fem,
                      top: 24 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 89 * fem,
                          height: 30 * fem,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60 * fem),
                              color: const Color(0xb5caaaff),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // rectangle14UU4 (136:18)
                      left: 267 * fem,
                      top: 24 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 89 * fem,
                          height: 30 * fem,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60 * fem),
                              color: const Color(0xb5caaaff),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      // yesterdayzhJ (136:4)
                      left: 147 * fem,
                      top: 31 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 73 * fem,
                          height: 17 * fem,
                          child: Text(
                            'YESTERDAY',
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
                      // weeklysm6 (136:19)
                      left: 285 * fem,
                      top: 31 * fem,
                      child: Align(
                        child: SizedBox(
                          width: 52 * fem,
                          height: 17 * fem,
                          child: Text(
                            'WEEKLY',
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
              Container(
                // autogroupf3kryJL (TqHEjbg2uDvmL7WeyLf3kr)
                margin:
                    EdgeInsets.fromLTRB(43.5 * fem, 0 * fem, 80 * fem, 0 * fem),
                width: double.infinity,
                height: 42 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      // autogroupixvvtw6 (TqHEvLs8WRHpsNTF4XiXvv)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 13 * fem, 0 * fem),
                      width: 61 * fem,
                      height: 38 * fem,
                      child: Stack(
                        children: [
                          Positioned(
                            // homedNt (162:30)
                            left: 18.5 * fem,
                            top: 24 * fem,
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
                            // hometpc (162:26)
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
                        ],
                      ),
                    ),
                    SizedBox(
                      // autogroupmh9q8DA (TqHF1WPC6sS9ey4UJGMH9Q)
                      width: 193.5 * fem,
                      height: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            // smileU28 (162:27)
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
                                    color: const Color(0xffa27dde),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // stethoscopem1E (162:28)
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
                            // bellrYU (162:29)
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
                            // moodLTe (162:31)
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
                                    color: const Color(0xffa27dde),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // therapyRV6 (162:32)
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
                            // reminderiyz (162:33)
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
      ),
    );
  }
}
