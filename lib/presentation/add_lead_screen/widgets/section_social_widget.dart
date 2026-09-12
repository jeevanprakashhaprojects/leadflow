import 'package:flutter/material.dart';

class SectionSocialWidget extends StatelessWidget {
  const SectionSocialWidget({super.key});

  static const _platforms = [
    {
      'label': 'LinkedIn',
      'icon': Icons.work_outline_rounded,
      'color': 0xFF0077B5,
      'hint': 'linkedin.com/in/username',
    },
    {
      'label': 'Facebook',
      'icon': Icons.facebook_rounded,
      'color': 0xFF1877F2,
      'hint': 'facebook.com/username',
    },
    {
      'label': 'Twitter / X',
      'icon': Icons.alternate_email_rounded,
      'color': 0xFF1DA1F2,
      'hint': 'twitter.com/username',
    },
    {
      'label': 'Instagram',
      'icon': Icons.camera_alt_outlined,
      'color': 0xFFE1306C,
      'hint': 'instagram.com/username',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.8,
      children: _platforms.map((p) {
        final color = Color(p['color'] as int);
        return TextFormField(
          keyboardType: TextInputType.url,
          decoration: InputDecoration(
            labelText: p['label'] as String,
            hintText: p['hint'] as String,
            hintStyle: const TextStyle(fontSize: 10),
            prefixIcon: Icon(p['icon'] as IconData, size: 18, color: color),
          ),
        );
      }).toList(),
    );
  }
}
