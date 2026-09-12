import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class SectionLeadDetailsWidget extends StatefulWidget {
  const SectionLeadDetailsWidget({super.key});

  @override
  State<SectionLeadDetailsWidget> createState() =>
      _SectionLeadDetailsWidgetState();
}

class _SectionLeadDetailsWidgetState extends State<SectionLeadDetailsWidget>
    with SingleTickerProviderStateMixin {
  String _selectedStatus = 'New';
  String _selectedPriority = 'Medium';
  double _leadScore = 50;
  String _selectedTier = 'Standard';
  bool _isVip = false;
  String _selectedSource = '';
  String _selectedAction = '';
  double _dealValue = 0;
  final _dealValueCtrl = TextEditingController();
  final _campaignCtrl = TextEditingController();
  final _utmCtrl = TextEditingController();
  final _referralCtrl = TextEditingController();
  DateTime? _expectedCloseDate;
  String _selectedOwner = 'Rahul Singh';

  static const _statuses = [
    'New',
    'Contacted',
    'Qualified',
    'Proposal',
    'Negotiation',
    'Won',
    'Lost',
    'Junk',
  ];
  static const _priorities = ['High', 'Medium', 'Low'];
  static const _tiers = ['Standard', 'Silver', 'Gold', 'Platinum'];
  static const _sources = [
    'Website',
    'Referral',
    'Cold Call',
    'LinkedIn',
    'Trade Show',
    'Email Campaign',
    'Walk-in',
    'Partner',
    'Social Media',
  ];
  static const _actions = [
    'Appointment',
    'Follow-up',
    'Video Call',
    'Call Back',
    'Result',
    'Not Interested',
  ];
  static const _tags = [
    'VIP',
    'Urgent',
    'Follow-up',
    'Hot Lead',
    'Cold Lead',
    'Nurture',
  ];
  final List<String> _selectedTags = [];

  static const _owners = [
    {'name': 'Rahul Singh', 'initials': 'RS', 'role': 'Senior Rep'},
    {'name': 'Ananya Patel', 'initials': 'AP', 'role': 'Manager'},
    {'name': 'Kavya Menon', 'initials': 'KM', 'role': 'Sales Rep'},
    {'name': 'Arjun Das', 'initials': 'AD', 'role': 'Sales Rep'},
  ];

  static const _quickAmounts = [
    {'label': '₹1L', 'value': 100000.0},
    {'label': '₹5L', 'value': 500000.0},
    {'label': '₹10L', 'value': 1000000.0},
    {'label': '₹50L', 'value': 5000000.0},
    {'label': '₹1Cr', 'value': 10000000.0},
  ];

  String _formatAmount(double v) {
    if (v >= 10000000) return '₹${(v / 10000000).toStringAsFixed(2)} Crore';
    if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(2)} Lakh';
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(1)} Thousand';
    return '₹${v.toStringAsFixed(0)}';
  }

  @override
  void dispose() {
    _dealValueCtrl.dispose();
    _campaignCtrl.dispose();
    _utmCtrl.dispose();
    _referralCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pipeline status bar
        _buildPipelineBar(),
        const SizedBox(height: 20),
        // Priority
        _buildPrioritySection(),
        const SizedBox(height: 16),
        // Lead score
        _buildLeadScoreSection(),
        const SizedBox(height: 16),
        // Tier + VIP
        Row(
          children: [
            Expanded(child: _buildTierDropdown()),
            const SizedBox(width: 12),
            _buildVipToggle(),
          ],
        ),
        const SizedBox(height: 16),
        // Deal value + close date
        _buildDealValueSection(),
        const SizedBox(height: 16),
        // Source attribution
        _buildSourceSection(),
        const SizedBox(height: 16),
        // Action schedule
        _buildActionSection(),
        const SizedBox(height: 16),
        // Lead owner
        _buildOwnerSection(),
        const SizedBox(height: 16),
        // Tags
        _buildTagsSection(),
      ],
    );
  }

  Widget _buildPipelineBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pipeline Stage',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(_statuses.length, (i) {
              final status = _statuses[i];
              final isActive = _selectedStatus == status;
              final color = AppTheme.leadStatusColor(status);
              final isPast = _statuses.indexOf(_selectedStatus) > i;

              return Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _selectedStatus = status),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: isActive ? 14 : 10,
                          height: isActive ? 14 : 10,
                          decoration: BoxDecoration(
                            color: isPast || isActive
                                ? color
                                : AppTheme.surface200,
                            shape: BoxShape.circle,
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: color.withAlpha(128),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          status,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9,
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: isActive ? color : AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (i < _statuses.length - 1)
                    Container(
                      width: 24,
                      height: 2,
                      margin: const EdgeInsets.only(bottom: 14),
                      color: isPast ? color : AppTheme.surface200,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildPrioritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: _priorities.map((p) {
            final isSelected = _selectedPriority == p;
            final color = AppTheme.priorityColor(p);
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedPriority = p),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? color : AppTheme.surface100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? color : AppTheme.surface200,
                    ),
                  ),
                  child: Text(
                    p,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppTheme.textSecondary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLeadScoreSection() {
    final scoreColor = _leadScore >= 70
        ? AppTheme.success
        : _leadScore >= 40
        ? AppTheme.warning
        : AppTheme.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Lead Score',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const Spacer(),
            Text(
              _leadScore.round().toString(),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: scoreColor,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            Text(
              '/100',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: scoreColor,
            inactiveTrackColor: AppTheme.surface200,
            thumbColor: scoreColor,
            overlayColor: scoreColor.withAlpha(38),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: _leadScore,
            min: 0,
            max: 100,
            onChanged: (v) => setState(() => _leadScore = v),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Cold',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                color: AppTheme.error,
              ),
            ),
            Text(
              'Warm',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                color: AppTheme.warning,
              ),
            ),
            Text(
              'Hot',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                color: AppTheme.success,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTierDropdown() {
    return InputDecorator(
      decoration: const InputDecoration(
        labelText: 'Customer Tier',
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedTier,
          isExpanded: true,
          isDense: true,
          items: _tiers
              .map(
                (t) => DropdownMenuItem(
                  value: t,
                  child: Text(
                    t,
                    style: GoogleFonts.plusJakartaSans(fontSize: 13),
                  ),
                ),
              )
              .toList(),
          onChanged: (v) => setState(() => _selectedTier = v!),
          icon: const Icon(Icons.expand_more_rounded, size: 16),
        ),
      ),
    );
  }

  Widget _buildVipToggle() {
    return GestureDetector(
      onTap: () => setState(() => _isVip = !_isVip),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _isVip ? const Color(0xFFFEF3C7) : AppTheme.surface100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isVip ? const Color(0xFFB45309) : AppTheme.surface200,
          ),
        ),
        child: Row(
          children: [
            Text('⭐', style: TextStyle(fontSize: _isVip ? 18 : 16)),
            const SizedBox(width: 6),
            Text(
              'VIP',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _isVip
                    ? const Color(0xFFB45309)
                    : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDealValueSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deal Value',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _dealValueCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount (₹)',
                  prefixText: '₹ ',
                  prefixIcon: Icon(Icons.currency_rupee_rounded, size: 18),
                ),
                onChanged: (v) {
                  setState(() => _dealValue = double.tryParse(v) ?? 0);
                },
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 30)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) setState(() => _expectedCloseDate = picked);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariantLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.surface200),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _expectedCloseDate != null
                          ? '${_expectedCloseDate!.day}/${_expectedCloseDate!.month}'
                          : 'Close Date',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (_dealValue > 0) ...[
          const SizedBox(height: 6),
          Text(
            _formatAmount(_dealValue),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppTheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        const SizedBox(height: 10),
        // Quick amount chips
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: _quickAmounts.map((qa) {
            return GestureDetector(
              onTap: () {
                final val = qa['value'] as double;
                setState(() {
                  _dealValue = val;
                  _dealValueCtrl.text = val.toStringAsFixed(0);
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surface100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.surface200),
                ),
                child: Text(
                  qa['label'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSourceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Source Attribution',
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
          children: _sources.map((s) {
            final isSelected = _selectedSource == s;
            return GestureDetector(
              onTap: () => setState(() => _selectedSource = s),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryContainer
                      : AppTheme.surface100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : AppTheme.surface200,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  s,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppTheme.primary
                        : AppTheme.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _campaignCtrl,
                decoration: const InputDecoration(labelText: 'Campaign'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _utmCtrl,
                decoration: const InputDecoration(labelText: 'UTM Source'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _referralCtrl,
          decoration: const InputDecoration(
            labelText: 'Referral Name',
            prefixIcon: Icon(Icons.person_add_outlined, size: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildActionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Schedule Action',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _actions.map((a) {
              final isSelected = _selectedAction == a;
              return GestureDetector(
                onTap: () => setState(() {
                  _selectedAction = isSelected ? '' : a;
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primary : AppTheme.surface100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.surface200,
                    ),
                  ),
                  child: Text(
                    a,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppTheme.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: _selectedAction.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer.withAlpha(77),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.primary.withAlpha(51)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$_selectedAction Details',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: 'Date & Time',
                                prefixIcon: Icon(
                                  Icons.calendar_today_outlined,
                                  size: 16,
                                ),
                              ),
                              onTap: () async {
                                await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now().add(
                                    const Duration(days: 1),
                                  ),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 365),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Notes',
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
    );
  }

  Widget _buildOwnerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lead Owner',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showOwnerPicker(),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariantLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.surface200),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppTheme.primaryContainer,
                  child: Text(
                    _owners.firstWhere(
                          (o) => o['name'] == _selectedOwner,
                        )['initials']
                        as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
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
                      _selectedOwner,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _owners.firstWhere(
                            (o) => o['name'] == _selectedOwner,
                          )['role']
                          as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(
                  Icons.swap_horiz_rounded,
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
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
          children: [
            ..._tags.map((tag) {
              final isSelected = _selectedTags.contains(tag);
              Color tagColor;
              switch (tag) {
                case 'VIP':
                  tagColor = const Color(0xFFB45309);
                  break;
                case 'Urgent':
                  tagColor = AppTheme.error;
                  break;
                case 'Follow-up':
                  tagColor = AppTheme.warning;
                  break;
                default:
                  tagColor = AppTheme.primary;
              }
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedTags.remove(tag);
                    } else {
                      _selectedTags.add(tag);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? tagColor.withAlpha(31)
                        : AppTheme.surface100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? tagColor : AppTheme.surface200,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tag,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? tagColor : AppTheme.textSecondary,
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.close_rounded, size: 12, color: tagColor),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  void _showOwnerPicker() {
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
              'Assign Lead Owner',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ..._owners.map(
              (owner) => InkWell(
                onTap: () {
                  setState(() => _selectedOwner = owner['name'] as String);
                  Navigator.pop(ctx);
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppTheme.primaryContainer,
                        child: Text(
                          owner['initials'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
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
                            owner['name'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            owner['role'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      if (_selectedOwner == owner['name'])
                        const Icon(
                          Icons.check_rounded,
                          color: AppTheme.primary,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
