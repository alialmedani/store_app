import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../constant/app_icons/app_icons.dart';

class LogoWidget extends StatelessWidget {
  final double? height;
  final double? width;
  const LogoWidget({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SvgPicture.asset(
      logoSVG,
      width: width,
      height: height,
      fit: BoxFit.fill,
    ));
  }
}
