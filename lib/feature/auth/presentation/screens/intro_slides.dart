part of 'auth_screen.dart';

class IntroSlide {
  final String title;
  final String description;
  final String image;

  const IntroSlide({
    required this.title,
    required this.description,
    required this.image,
  });
}

// Static data for the slides
const List<IntroSlide> _introSlides = [
  IntroSlide(
    title: 'Stay Organized, Achieve More',
    description: 'Unlock Your Full Potential with Ease',
    image: AppAssets.introSlide1,
  ),
  IntroSlide(
    title: 'Smart Task Management',
    description: 'Efficiently Organize and Prioritize Your Tasks',
    image: AppAssets.introSlide2,
  ),
  IntroSlide(
    title: 'Track Your Progress',
    description: 'Monitor Your Achievements and Stay Motivated',
    image: AppAssets.introSlide3,
  ),
  IntroSlide(
    title: 'Collaborate Seamlessly',
    description: 'Work Together with Your Team in Real-Time',
    image: AppAssets.introSlide4,
  ),
];
