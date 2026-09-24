import 'package:flutter/material.dart';

class Scene extends StatelessWidget {
  const Scene({super.key});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 100;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return SizedBox(
      width: double.infinity,
      child: SizedBox(
        // rectangle257KyE (473:10)
        width: double.infinity,
        height: 100 * fem,
        child: Image.asset(
          'assets/page-1/images/rectangle-257.png',
          width: 100 * fem,
          height: 100 * fem,
        ),
      ),
    );
  }
}
