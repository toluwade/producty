import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CarouselView extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final Brightness brightness;

  const CarouselView({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
    required this.brightness,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          image,
          height: size.height * 0.25,
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: GoogleFonts.dmSans(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: brightness == Brightness.dark
                ? const Color(0xFFFFFFFF)
                : const Color(0xFF3D3D3D),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            description,
            style: GoogleFonts.dmSans(
              fontSize: 16,
              color: brightness == Brightness.dark
                  ? const Color(0xFF7B7B80)
                  : const Color(0xFF616161),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
