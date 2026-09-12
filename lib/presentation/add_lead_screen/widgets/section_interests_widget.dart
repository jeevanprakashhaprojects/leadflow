import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/empty_state_widget.dart';

class SectionInterestsWidget extends StatefulWidget {
  const SectionInterestsWidget({super.key});

  @override
  State<SectionInterestsWidget> createState() => _SectionInterestsWidgetState();
}

class _SectionInterestsWidgetState extends State<SectionInterestsWidget>
    with SingleTickerProviderStateMixin {
  final List<_InterestCard> _interests = [];
  int _activeInterestIndex = 0;

  static const _quickAddIndustries = [
    'Insurance',
    'Mutual Funds',
    'Real Estate',
    'Equity',
    'Fixed Deposits',
    'Health Plans',
    'Life Insurance',
  ];

  static const _insuranceTabs = [
    'Product',
    'Coverage',
    'Health',
    'Nominee',
    'Riders',
    'Renewal',
    'Remarks',
  ];

  void _addInterest(String industry) {
    setState(() {
      _interests.add(_InterestCard(industry: industry, activeTab: 0));
      _activeInterestIndex = _interests.length - 1;
    });
  }

  void _removeInterest(int index) {
    setState(() {
      _interests.removeAt(index);
      if (_activeInterestIndex >= _interests.length) {
        _activeInterestIndex = _interests.length - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_interests.isEmpty) {
      return Column(
        children: [
          EmptyStateWidget(
            icon: Icons.star_outline_rounded,
            title: 'No interests added',
            subtitle:
                'Add the lead\'s financial interests to personalise your pitch',
          ),
          const SizedBox(height: 16),
          Text(
            'Quick Add',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickAddIndustries.map((industry) {
              return GestureDetector(
                onTap: () => _addInterest(industry),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer.withAlpha(128),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.primary.withAlpha(77)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.add_rounded,
                        size: 14,
                        color: AppTheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        industry,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Interest tabs (one per added interest)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(_interests.length, (i) {
                final isActive = i == _activeInterestIndex;
                return GestureDetector(
                  onTap: () => setState(() => _activeInterestIndex = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isActive ? AppTheme.primary : AppTheme.surface100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive
                            ? AppTheme.primary
                            : AppTheme.surface200,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _interests[i].industry,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isActive
                                ? Colors.white
                                : AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => _removeInterest(i),
                          child: Icon(
                            Icons.close_rounded,
                            size: 14,
                            color: isActive
                                ? Colors.white70
                                : AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              // Add button
              GestureDetector(
                onTap: () => _showAddInterestSheet(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surface100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.surface200,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.add_rounded,
                        size: 14,
                        color: AppTheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Add',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Active interest content
        if (_interests.isNotEmpty)
          _buildInterestContent(_interests[_activeInterestIndex]),
      ],
    );
  }

  Widget _buildInterestContent(_InterestCard interest) {
    return DefaultTabController(
      length: _insuranceTabs.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            isScrollable: true,
            labelColor: AppTheme.primary,
            unselectedLabelColor: AppTheme.textSecondary,
            indicatorColor: AppTheme.primary,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 12),
            tabs: _insuranceTabs.map((t) => Tab(text: t)).toList(),
          ),
          const Divider(height: 1),
          const SizedBox(height: 12),
          SizedBox(
            height: 280,
            child: TabBarView(
              children: _insuranceTabs.map((tab) {
                return _buildTabContent(tab, interest.industry);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(String tab, String industry) {
    switch (tab) {
      case 'Product':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: '$industry Product Name'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Premium Amount',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Policy Term'),
                  ),
                ),
              ],
            ),
          ],
        );
      case 'Nominee':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NomineeCard(
              name: 'Add Nominee',
              relation: '',
              share: 0,
              isPlaceholder: true,
            ),
          ],
        );
      default:
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: TextFormField(
            maxLines: 5,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: '$tab Details',
              alignLabelWithHint: true,
            ),
          ),
        );
    }
  }

  void _showAddInterestSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppTheme.surface200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Add Interest',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickAddIndustries.map((industry) {
                return GestureDetector(
                  onTap: () {
                    _addInterest(industry);
                    Navigator.pop(ctx);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryContainer.withAlpha(128),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.primary.withAlpha(77)),
                    ),
                    child: Text(
                      industry,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _InterestCard {
  final String industry;
  int activeTab;
  _InterestCard({required this.industry, required this.activeTab});
}

class _NomineeCard extends StatelessWidget {
  final String name;
  final String relation;
  final int share;
  final bool isPlaceholder;

  const _NomineeCard({
    required this.name,
    required this.relation,
    required this.share,
    this.isPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isPlaceholder) {
      return GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.surface200,
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: AppTheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Add Nominee',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariantLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.primaryContainer,
            child: Text(
              name.isNotEmpty ? name[0] : 'N',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (relation.isNotEmpty)
                Text(
                  relation,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
            ],
          ),
          const Spacer(),
          if (share > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$share%',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
