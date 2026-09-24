import 'package:flutter/material.dart';

class Scene extends StatelessWidget {
  const Scene({super.key});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return SizedBox(
      width: double.infinity,
      child: Container(
        // iphone141cn8 (503:5)
        padding: EdgeInsets.fromLTRB(72 * fem, 381 * fem, 56 * fem, 255 * fem),
        width: double.infinity,
        height: 844 * fem,
        decoration: const BoxDecoration(
          color: Color(0xff24967d),
        ),
        child: Center(
          // rectangle2758kU (503:6)
          child: SizedBox(
            width: 262 * fem,
            height: 208 * fem,
            child: Image.asset(
              'assets/page-1/images/rectangle-275.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
