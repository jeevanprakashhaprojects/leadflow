import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class SectionSocialWidget extends StatefulWidget {
  final Map<String, dynamic>? prefillData;
  final void Function(Map<String, dynamic>)? onDataChanged;

  const SectionSocialWidget({super.key, this.prefillData, this.onDataChanged});

  @override
  State<SectionSocialWidget> createState() => _SectionSocialWidgetState();
}

class _SectionSocialWidgetState extends State<SectionSocialWidget> {
  late final TextEditingController _linkedinCtrl;
  late final TextEditingController _facebookCtrl;
  late final TextEditingController _twitterCtrl;
  late final TextEditingController _instagramCtrl;
  late final TextEditingController _websiteCtrl;

  static const _platforms = [
    {
      'label': 'LinkedIn',
      'key': 'linkedin',
      'icon': Icons.work_outline_rounded,
      'color': 0xFF0077B5,
      'hint': 'linkedin.com/in/username',
    },
    {
      'label': 'Facebook',
      'key': 'facebook',
      'icon': Icons.facebook_rounded,
      'color': 0xFF1877F2,
      'hint': 'facebook.com/username',
    },
    {
      'label': 'Twitter / X',
      'key': 'twitter',
      'icon': Icons.alternate_email_rounded,
      'color': 0xFF1DA1F2,
      'hint': 'twitter.com/username',
    },
    {
      'label': 'Instagram',
      'key': 'instagram',
      'icon': Icons.camera_alt_outlined,
      'color': 0xFFE1306C,
      'hint': 'instagram.com/username',
    },
    {
      'label': 'Website',
      'key': 'website',
      'icon': Icons.language_rounded,
      'color': 0xFF10B981,
      'hint': 'https://yourwebsite.com',
    },
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.prefillData;
    _linkedinCtrl = TextEditingController(
      text: p?['linkedin'] as String? ?? '',
    );
    _facebookCtrl = TextEditingController(
      text: p?['facebook'] as String? ?? '',
    );
    _twitterCtrl = TextEditingController(text: p?['twitter'] as String? ?? '');
    _instagramCtrl = TextEditingController(
      text: p?['instagram'] as String? ?? '',
    );
    _websiteCtrl = TextEditingController(text: p?['website'] as String? ?? '');

    for (final ctrl in [
      _linkedinCtrl,
      _facebookCtrl,
      _twitterCtrl,
      _instagramCtrl,
      _websiteCtrl,
    ]) {
      ctrl.addListener(_notifyParent);
    }
  }

  void _notifyParent() {
    widget.onDataChanged?.call({
      'linkedin': _linkedinCtrl.text,
      'facebook': _facebookCtrl.text,
      'twitter': _twitterCtrl.text,
      'instagram': _instagramCtrl.text,
      'website': _websiteCtrl.text,
    });
  }

  TextEditingController _ctrlFor(String key) {
    switch (key) {
      case 'linkedin':
        return _linkedinCtrl;
      case 'facebook':
        return _facebookCtrl;
      case 'twitter':
        return _twitterCtrl;
      case 'instagram':
        return _instagramCtrl;
      case 'website':
        return _websiteCtrl;
      default:
        return _linkedinCtrl;
    }
  }

  @override
  void dispose() {
    _linkedinCtrl.dispose();
    _facebookCtrl.dispose();
    _twitterCtrl.dispose();
    _instagramCtrl.dispose();
    _websiteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Social Profiles & Website',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        ..._platforms.map((p) {
          final color = Color(p['color'] as int);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextFormField(
              controller: _ctrlFor(p['key'] as String),
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                labelText: p['label'] as String,
                hintText: p['hint'] as String,
                prefixIcon: Icon(p['icon'] as IconData, size: 18, color: color),
              ),
            ),
          );
        }),
      ],
    );
  }
}
