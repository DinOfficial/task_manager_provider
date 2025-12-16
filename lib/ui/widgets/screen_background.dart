import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/asset_path.dart';

class ScreenBackground extends StatelessWidget {
  const ScreenBackground({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(AssetPath.backgroundSVG, fit: BoxFit.cover,width: double.maxFinite,height: double.maxFinite,),
        SafeArea(child: child),
      ],
    );
  }
}
