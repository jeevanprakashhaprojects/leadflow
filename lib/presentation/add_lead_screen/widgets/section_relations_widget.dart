import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class SectionRelationsWidget extends StatefulWidget {
  const SectionRelationsWidget({super.key});

  @override
  State<SectionRelationsWidget> createState() => _SectionRelationsWidgetState();
}

class _SectionRelationsWidgetState extends State<SectionRelationsWidget> {
  final List<Map<String, dynamic>> _relations = [
    {
      'name': 'Sneha Sharma',
      'relation': 'Spouse',
      'phone': '+91 98765 12345',
      'age': 35,
      'occupation': 'Teacher',
      'company': 'DPS School',
      'isExpanded': false,
    },
  ];

  static const _relationTypes = [
    'Spouse',
    'Son',
    'Daughter',
    'Father',
    'Mother',
    'Brother',
    'Sister',
    'Friend',
    'Colleague',
    'Partner',
  ];

  static const _relationColors = {
    'Spouse': Color(0xFFE91E63),
    'Son': Color(0xFF2196F3),
    'Daughter': Color(0xFF9C27B0),
    'Father': Color(0xFF4CAF50),
    'Mother': Color(0xFFFF9800),
    'Brother': Color(0xFF00BCD4),
    'Sister': Color(0xFFFF5722),
    'Friend': Color(0xFF8BC34A),
    'Colleague': Color(0xFF607D8B),
    'Partner': Color(0xFF795548),
  };

  Color _getRelationColor(String relation) {
    return _relationColors[relation] ?? AppTheme.primary;
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'R';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._relations.asMap().entries.map((entry) {
          final index = entry.key;
          final rel = entry.value;
          return _RelationCard(
            relation: rel,
            onToggleExpand: () {
              setState(
                () => _relations[index]['isExpanded'] = !rel['isExpanded'],
              );
            },
            onRemove: () => setState(() => _relations.removeAt(index)),
            getRelationColor: _getRelationColor,
            getInitials: _getInitials,
            relationTypes: _relationTypes,
          );
        }),
        const SizedBox(height: 12),
        // Dashed add card
        GestureDetector(
          onTap: _addRelation,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surface100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primary.withAlpha(102),
                style: BorderStyle.solid,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    size: 18,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Add Relation',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _addRelation() {
    setState(() {
      _relations.add({
        'name': '',
        'relation': 'Friend',
        'phone': '',
        'age': 0,
        'occupation': '',
        'company': '',
        'isExpanded': true,
      });
    });
  }
}

class _RelationCard extends StatelessWidget {
  final Map<String, dynamic> relation;
  final VoidCallback onToggleExpand;
  final VoidCallback onRemove;
  final Color Function(String) getRelationColor;
  final String Function(String) getInitials;
  final List<String> relationTypes;

  const _RelationCard({
    required this.relation,
    required this.onToggleExpand,
    required this.onRemove,
    required this.getRelationColor,
    required this.getInitials,
    required this.relationTypes,
  });

  @override
  Widget build(BuildContext context) {
    final name = relation['name'] as String;
    final rel = relation['relation'] as String;
    final phone = relation['phone'] as String;
    final age = relation['age'] as int;
    final occupation = relation['occupation'] as String;
    final company = relation['company'] as String;
    final isExpanded = relation['isExpanded'] as bool;
    final color = getRelationColor(rel);
    final initials = name.isNotEmpty ? getInitials(name) : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surface200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Summary row
          InkWell(
            onTap: onToggleExpand,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: color.withAlpha(38),
                    child: Text(
                      initials,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              name.isNotEmpty ? name : 'New Relation',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: color.withAlpha(31),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                rel,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: color,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (phone.isNotEmpty || occupation.isNotEmpty)
                          Text(
                            [
                              if (phone.isNotEmpty) phone,
                              if (age > 0) '$age yrs',
                              if (occupation.isNotEmpty) occupation,
                            ].join(' · '),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Expanded edit form
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: isExpanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                initialValue: name,
                                textCapitalization: TextCapitalization.words,
                                decoration: const InputDecoration(
                                  labelText: 'Full Name',
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Relation',
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: rel,
                                    isDense: true,
                                    isExpanded: true,
                                    items: relationTypes
                                        .map(
                                          (r) => DropdownMenuItem(
                                            value: r,
                                            child: Text(
                                              r,
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    fontSize: 12,
                                                  ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (_) {},
                                    icon: const Icon(
                                      Icons.expand_more_rounded,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: phone,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  labelText: 'Phone',
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                initialValue: age > 0 ? '$age' : '',
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Age',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: occupation,
                                textCapitalization: TextCapitalization.words,
                                decoration: const InputDecoration(
                                  labelText: 'Occupation',
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                initialValue: company,
                                textCapitalization: TextCapitalization.words,
                                decoration: const InputDecoration(
                                  labelText: 'Company',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: onRemove,
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                size: 16,
                                color: AppTheme.error,
                              ),
                              label: Text(
                                'Remove',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: AppTheme.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
