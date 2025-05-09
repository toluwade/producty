import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class BannerView extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final Brightness brightness;

  const BannerView({
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
        Text(
          title,
          style: GoogleFonts.dmSans(
            fontSize: 23,
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

class Dots extends StatelessWidget {
  const Dots({super.key, required this.length, required this.currentPage});

  final int currentPage;
  final int length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: currentPage == index ? 24 : 8,
          decoration: BoxDecoration(
            color: currentPage == index
                ? theme.brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF3D3D3D)
                : theme.brightness == Brightness.dark
                    ? const Color(0xFF3D3D3D)
                    : const Color(0xFFE5E5EA),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
