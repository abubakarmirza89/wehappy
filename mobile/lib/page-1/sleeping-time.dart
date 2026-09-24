import 'package:flutter/material.dart';
import 'package:myapp/utils.dart';

class SleepingTime extends StatefulWidget {
  const SleepingTime({super.key});

  @override
  _SleepingTimeState createState() => _SleepingTimeState();
}

class _SleepingTimeState extends State<SleepingTime> {
  TextEditingController inBedController = TextEditingController();
  TextEditingController outBedController = TextEditingController();
  TextEditingController moodEffectController = TextEditingController();
  String selectedMood = '';

  @override
  Widget build(BuildContext context) {
    double baseWidth = 393;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Container(
          // sleepingtimem64 (115:2)
          padding: EdgeInsets.fromLTRB(10.09 * fem, 27 * fem, 0 * fem, 8 * fem),
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/page-1/images/sleeping-time-bg.png',
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // group11dPA (228:129)
                margin:
                    EdgeInsets.fromLTRB(12.91 * fem, 0 * fem, 0 * fem, 5 * fem),
                width: double.infinity,
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [],
                ),
              ),
              Container(
                // ellipse25k8L (127:3)
                margin: EdgeInsets.fromLTRB(
                    0 * fem, 0 * fem, 13.09 * fem, 11 * fem),
                width: 114 * fem,
                height: 103 * fem,
                child: Image.asset(
                  'assets/page-1/images/ellipse-25-eMA.png',
                  width: 114 * fem,
                  height: 103 * fem,
                ),
              ),
              Container(
                // sleepdxp (142:21)
                margin: EdgeInsets.fromLTRB(
                    0 * fem, 0 * fem, 12.09 * fem, 10 * fem),
                child: Text(
                  'Sleep',
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
                // enterwhenyoubeginandendyoursle (142:22)
                margin: EdgeInsets.fromLTRB(
                    0 * fem, 0 * fem, 14.09 * fem, 20 * fem),
                constraints: BoxConstraints(
                  maxWidth: 297 * fem,
                ),
                child: Text(
                  'Enter when you begin and end your sleep and the duration of the actual sleep.',
                  textAlign: TextAlign.center,
                  style: SafeGoogleFont(
                    'Mulish',
                    fontSize: 13 * ffem,
                    fontWeight: FontWeight.w400,
                    height: 1.255 * ffem / fem,
                    color: const Color(0xff000000),
                  ),
                ),
              ),
// In Bed

              _buildFormField(
                label: 'In Bed',
                icon: Icons.hotel,
                controller: inBedController,
              ),

              // Out Bed
              _buildFormField(
                label: 'Out Bed',
                icon: Icons.hotel,
                controller: outBedController,
              ),

              // Duration
              _buildReadOnlyField(
                label: 'Duration',
                value: _calculateDuration(
                    inBedController.text, outBedController.text),
                icon: Icons.access_time,
              ),

              // Mood Effect
              _buildMoodSelectionField(),

              // Save Button
              Positioned(
                left: 150.9059628717 * fem,
                top: 220 * fem,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your save logic here
                    print('Save Button Pressed');
                  },
                  child: const Text('Save'),
                ),
              ),
              Container(
                // autogroup9hxaq8Q (TqHLpkrv6tTB2bW1EP9Hxa)
                margin: EdgeInsets.fromLTRB(
                    150.91 * fem, 0 * fem, 154 * fem, 17 * fem),
                width: double.infinity,
                height: 33 * fem,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff000000)),
                  color: const Color(0xb5caaaff),
                  borderRadius: BorderRadius.circular(40 * fem),
                ),
                child: Center(
                  child: Text(
                    'SAVE',
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
              Container(
                // autogrouprpbp5oS (TqHLxApEMjCvqLdYPorpBp)
                margin: EdgeInsets.fromLTRB(
                    16.91 * fem, 0 * fem, 0 * fem, 134 * fem),
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      // autogroupmudgQqi (TqHM8qB8gTxJnBdJZTMuDG)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 62 * fem, 3 * fem),
                      width: 338 * fem,
                      height: 46 * fem,
                      child: Stack(
                        children: [
                          Positioned(
                            // rectangle188Wp (146:59)
                            left: 3 * fem,
                            top: 17 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 2 * fem,
                                height: 1 * fem,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xffd9d9d9),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // rectangle1937z (148:64)
                            left: 5 * fem,
                            top: 0 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 333 * fem,
                                height: 46 * fem,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(70 * fem),
                                    border: Border.all(
                                        color: const Color(0xff000000)),
                                    gradient: const LinearGradient(
                                      begin: Alignment(0, -1),
                                      end: Alignment(0, 1),
                                      colors: <Color>[
                                        Color(0xffc4eefb),
                                        Color(0x00c4eefb)
                                      ],
                                      stops: <double>[0, 1],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // commentshTS (147:63)
                            left: 47 * fem,
                            top: 7 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 70 * fem,
                                height: 19 * fem,
                                child: Text(
                                  'comments',
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
                            // commentsoFa (147:60)
                            left: 0 * fem,
                            top: 9 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 67 * fem,
                                height: 19 * fem,
                                child: Text(
                                  'comments',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Font Awesome 5 Free',
                                    fontSize: 15 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2575 * ffem / fem,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // entercommentsJi8 (148:66)
                            left: 47 * fem,
                            top: 26 * fem,
                            child: Align(
                              child: SizedBox(
                                width: 80 * fem,
                                height: 14 * fem,
                                child: Text(
                                  'Enter comments',
                                  textAlign: TextAlign.center,
                                  style: SafeGoogleFont(
                                    'Outfit',
                                    fontSize: 11 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 1.26 * ffem / fem,
                                    color: const Color(0xff976f39),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      // ellipse31ntC (152:11)
                      width: 43 * fem,
                      height: 39 * fem,
                      child: Image.asset(
                        'assets/page-1/images/ellipse-31.png',
                        width: 43 * fem,
                        height: 39 * fem,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // autogroupjkzavzQ (TqHMNA8G5tPXiEsWGWjkza)
                margin: EdgeInsets.fromLTRB(
                    51.41 * fem, 0 * fem, 67 * fem, 0 * fem),
                width: double.infinity,
                height: 42 * fem,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      // autogroupofaes8x (TqHMYuKMh5kbFVp6MhoFAe)
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 10 * fem, 0 * fem),
                      width: 61 * fem,
                      height: 40 * fem,
                      child: Stack(
                        children: [
                          Positioned(
                            // homenmi (148:86)
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
                            // homeHTa (148:91)
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
                      // autogroupdze2n9S (TqHMdegSsEpW52hByidze2)
                      width: 193.5 * fem,
                      height: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            // smileKQG (148:87)
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
                            // stethoscope1H6 (148:89)
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
                            // bellg8L (148:90)
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
                            // moodxbe (148:92)
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
                            // therapyrwv (148:94)
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
                            // reminderMtg (148:95)
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

  Widget _buildFormField(
      {required String label,
      required IconData icon,
      required TextEditingController controller}) {
    double fem = 1.0; // You can replace this with your actual factor

    return Positioned(
      left: 59.9059628717 * fem,
      top: 29 * fem,
      child: Align(
        child: SizedBox(
          width: 36 * fem,
          height: 17 * fem,
          child: Column(
            children: [
              Icon(
                icon,
                size: 20 * fem,
                color: const Color(0xff000000),
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13 * fem,
                  fontWeight: FontWeight.w500,
                  height: 1.26,
                  color: const Color(0xff000000),
                ),
              ),
              SizedBox(
                height: 10 * fem,
                width: 70 * fem,
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'hh:mm',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(
      {required String label, required String value, required IconData icon}) {
    double fem = 1.0; // You can replace this with your actual factor

    return Positioned(
      left: 201.9059628717 * fem,
      top: 131 * fem,
      child: Align(
        child: SizedBox(
          width: 63 * fem,
          height: 17 * fem,
          child: Column(
            children: [
              Icon(
                icon,
                size: 20 * fem,
                color: const Color(0xff000000),
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13 * fem,
                  fontWeight: FontWeight.w400,
                  height: 1.26,
                  color: const Color(0xff000000),
                ),
              ),
              SizedBox(
                height: 10 * fem,
                width: 70 * fem,
                child: TextFormField(
                  initialValue: value,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'hh:mm',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodSelectionField() {
    double fem = 1.0; // You can replace this with your actual factor

    return Positioned(
      left: 115.9059628717 * fem,
      top: 163 * fem,
      child: Align(
        child: SizedBox(
          width: 151 * fem,
          height: 14 * fem,
          child: Column(
            children: [
              Icon(
                Icons.mood,
                size: 20 * fem,
                color: const Color(0xff976f39),
              ),
              Text(
                'Mood Effect',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11 * fem,
                  fontWeight: FontWeight.w400,
                  height: 1.26,
                  color: const Color(0xff976f39),
                ),
              ),
              SizedBox(
                height: 10 * fem,
                width: 150 * fem,
                child: ElevatedButton(
                  onPressed: () {
                    // Open a dialog or navigate to another screen for mood selection
                    print('Mood Effect Button Pressed');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xff976f39),
                    backgroundColor: Colors.white,
                  ),
                  child:
                      Text(selectedMood.isEmpty ? 'Select Mood' : selectedMood),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _calculateDuration(String inBedTime, String outBedTime) {
    // Implement your duration calculation logic here
    return '4 hr 30 min';
  }
}
