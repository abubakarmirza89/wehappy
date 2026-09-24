import 'package:flutter/material.dart';
import 'package:myapp/utils.dart';

class Scene extends StatelessWidget {
  const Scene({super.key});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 28;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return SizedBox(
      width: double.infinity,
      child: SizedBox(
        // homeR32 (279:60)
        width: double.infinity,
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
    );
  }
}
