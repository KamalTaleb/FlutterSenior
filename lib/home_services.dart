import 'package:beauty_center/vertical_image_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SHomeServices extends StatelessWidget {
  const SHomeServices({super.key});

  final List<Map<String, dynamic>> services = const [
    {
      'icon': FontAwesomeIcons.magic,
      'title': 'Makeup',
    },
    {
      'icon': FontAwesomeIcons.cut,
      'title': 'Hair',
    },
    {
      'icon': FontAwesomeIcons.handPaper,
      'title': 'Nails',
    },
    {
      'icon': FontAwesomeIcons.eye,
      'title': 'Eyebrows',
    },
    {
      'icon': FontAwesomeIcons.handSparkles,
      'title': 'Body Waxing',
    },
    {
      'icon': FontAwesomeIcons.heart,
      'title': 'Permanent Treatments',
    },
    {
      'icon': FontAwesomeIcons.smile,
      'title': 'Facials',
    },
    {
      'icon': FontAwesomeIcons.spa,
      'title': 'Spa',
    },
    {
      'icon': FontAwesomeIcons.lightbulb,
      'title': 'Laser Hair Removal',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: services.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          return SVerticalImageText(
            image: "images/onboarding1.PNG",
            title: services[index]['title'] as String,
            onTap: () {},
          );
        },
      ),
    );
  }
}
