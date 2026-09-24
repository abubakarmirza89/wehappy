import 'package:flutter/material.dart';
import 'package:myapp/utils.dart';

class Scene extends StatelessWidget {
  const Scene({super.key});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 88;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return SizedBox(
      width: double.infinity,
      child: SizedBox(
        // ashtangayogaY7v (206:146)
        width: double.infinity,
        height: 17 * fem,
        child: Text(
          'Ashtanga yoga',
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
    );
  }
}
