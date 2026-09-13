import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

// ─── Lead Owner Data ──────────────────────────────────────────────────────────

class LeadOwner {
  final String name;
  final String initials;
  final String role;
  final String id;

  const LeadOwner({
    required this.name,
    required this.initials,
    required this.role,
    required this.id,
  });
}

// Unique IDs: ADM-XXXX for admin, EMP-XXXX for employee, CONT-XXXX for contractor
const List<LeadOwner> kLeadOwners = [
  LeadOwner(
    name: 'Priya Sharma',
    initials: 'PS',
    role: 'Admin',
    id: 'ADM-1042',
  ),
  LeadOwner(
    name: 'Rahul Singh',
    initials: 'RS',
    role: 'Senior Rep',
    id: 'EMP-2391',
  ),
  LeadOwner(
    name: 'Ananya Patel',
    initials: 'AP',
    role: 'Manager',
    id: 'EMP-1874',
  ),
  LeadOwner(
    name: 'Kavya Menon',
    initials: 'KM',
    role: 'Sales Rep',
    id: 'EMP-3012',
  ),
  LeadOwner(
    name: 'Arjun Das',
    initials: 'AD',
    role: 'Sales Rep',
    id: 'EMP-2756',
  ),
  LeadOwner(
    name: 'Vikram Nair',
    initials: 'VN',
    role: 'Contractor',
    id: 'CONT-8391',
  ),
  LeadOwner(
    name: 'Meera Iyer',
    initials: 'MI',
    role: 'Contractor',
    id: 'CONT-5204',
  ),
];

// ─── Section Lead Details Widget ─────────────────────────────────────────────

class SectionLeadDetailsWidget extends StatefulWidget {
  final void Function(int filledCount)? onCompulsoryChanged;
  final void Function(Map<String, dynamic>)? onDataChanged;
  final Map<String, dynamic>? prefillData;
  const SectionLeadDetailsWidget({
    super.key,
    this.onCompulsoryChanged,
    this.onDataChanged,
    this.prefillData,
  });

  @override
  State<SectionLeadDetailsWidget> createState() =>
      _SectionLeadDetailsWidgetState();
}

class _SectionLeadDetailsWidgetState extends State<SectionLeadDetailsWidget>
    with SingleTickerProviderStateMixin {
  // Pipeline stages renamed as requested
  static const _statuses = [
    'New',
    'Contacted',
    'Proposed',
    'Qualified',
    'Negotiations',
    'Result',
  ];

  String _selectedStatus = 'New';
  String _selectedPriority = 'Medium';
  String _selectedTier = 'Standard';
  bool _isVip = false;
  String _selectedSource = '';
  String _selectedAction = '';
  double _dealValue = 0;
  final _dealValueCtrl = TextEditingController();
  final _campaignCtrl = TextEditingController();
  final _utmCtrl = TextEditingController();
  final _referralCtrl = TextEditingController();
  final _actionNotesCtrl = TextEditingController();
  DateTime? _expectedCloseDate;
  DateTime? _scheduledActionDate;
  TimeOfDay? _scheduledActionTime;
  String _followUpFrequency = ''; // Daily/Weekly/Monthly/Yearly/Custom

  // Default to logged-in user (Priya Sharma - Admin)
  LeadOwner _selectedOwner = kLeadOwners.first;

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

  Color _ownerIdColor(String id) {
    if (id.startsWith('ADM')) return AppTheme.primary;
    if (id.startsWith('EMP')) return AppTheme.success;
    return const Color(0xFFD97706);
  }

  void _notifyParent() {
    int filled = 0;
    // Only scheduledAction is compulsory — deal value is NOT compulsory
    if (_selectedAction.isNotEmpty) filled++;
    widget.onCompulsoryChanged?.call(filled);
  }

  @override
  void initState() {
    super.initState();
    _dealValueCtrl.addListener(_notifyParent);
  }

  @override
  void dispose() {
    _dealValueCtrl.dispose();
    _campaignCtrl.dispose();
    _utmCtrl.dispose();
    _referralCtrl.dispose();
    _actionNotesCtrl.dispose();
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
        // Tier
        _buildTierDropdown(),
        const SizedBox(height: 12),
        // VIP toggle
        _buildVipToggle(),
        const SizedBox(height: 16),
        // Deal value
        _buildDealValueSection(),
        const SizedBox(height: 16),
        // Expected close date (stacked)
        _buildCloseDatePicker(),
        const SizedBox(height: 16),
        // Source attribution
        _buildSourceSection(),
        const SizedBox(height: 16),
        // Action schedule (compulsory)
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
        const SizedBox(height: 14),
        // Wrap in ClipRect to prevent glow from being cut off
        ClipRect(
          child: Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
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
                                width: isActive ? 16 : 10,
                                height: isActive ? 16 : 10,
                                decoration: BoxDecoration(
                                  color: isPast || isActive
                                      ? color
                                      : AppTheme.surface200,
                                  shape: BoxShape.circle,
                                  boxShadow: isActive
                                      ? [
                                          BoxShadow(
                                            color: color.withAlpha(128),
                                            blurRadius: 10,
                                            spreadRadius: 3,
                                          ),
                                        ]
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 6),
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
                            width: 28,
                            height: 2,
                            margin: const EdgeInsets.only(bottom: 16),
                            color: isPast ? color : AppTheme.surface200,
                          ),
                      ],
                    );
                  }),
                ),
              ),
            ),
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
            const SizedBox(width: 8),
            Text(
              'Mark as VIP',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _isVip
                    ? const Color(0xFFB45309)
                    : AppTheme.textSecondary,
              ),
            ),
            const Spacer(),
            Switch(
              value: _isVip,
              onChanged: (v) => setState(() => _isVip = v),
              activeThumbColor: const Color(0xFFB45309),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
          'Deal Value (Optional)',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
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

  Widget _buildCloseDatePicker() {
    return GestureDetector(
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariantLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.surface200),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(width: 10),
            Text(
              _expectedCloseDate != null
                  ? 'Close Date: ${_expectedCloseDate!.day}/${_expectedCloseDate!.month}/${_expectedCloseDate!.year}'
                  : 'Expected Close Date',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: _expectedCloseDate != null
                    ? AppTheme.textPrimary
                    : AppTheme.textSecondary,
              ),
            ),
            const Spacer(),
            if (_expectedCloseDate != null)
              GestureDetector(
                onTap: () => setState(() => _expectedCloseDate = null),
                child: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: AppTheme.textMuted,
                ),
              ),
          ],
        ),
      ),
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
        TextFormField(
          controller: _campaignCtrl,
          decoration: const InputDecoration(labelText: 'Campaign'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _utmCtrl,
          decoration: const InputDecoration(labelText: 'UTM Source'),
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
        Row(
          children: [
            Text(
              'Scheduled Action',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.error.withAlpha(20),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Required',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.error,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _actions.map((a) {
              final isSelected = _selectedAction == a;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAction = isSelected ? '' : a;
                    // Reset follow-up frequency when action changes
                    if (_selectedAction != 'Follow-up') {
                      _followUpFrequency = '';
                    }
                  });
                  _notifyParent();
                },
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
        if (_selectedAction.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              'Please select a scheduled action',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: AppTheme.error,
              ),
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
                      const SizedBox(height: 12),

                      // ── Follow-up Frequency (only for Follow-up action) ──
                      if (_selectedAction == 'Follow-up') ...[
                        Text(
                          'Follow-up Frequency',
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
                          children:
                              [
                                'Daily',
                                'Weekly',
                                'Monthly',
                                'Yearly',
                                'Custom',
                              ].map((freq) {
                                final isSelected = _followUpFrequency == freq;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _followUpFrequency = freq;
                                      // Auto-set date based on frequency
                                      final now = DateTime.now();
                                      switch (freq) {
                                        case 'Daily':
                                          _scheduledActionDate = now.add(
                                            const Duration(days: 1),
                                          );
                                          break;
                                        case 'Weekly':
                                          _scheduledActionDate = now.add(
                                            const Duration(days: 7),
                                          );
                                          break;
                                        case 'Monthly':
                                          _scheduledActionDate = DateTime(
                                            now.year,
                                            now.month + 1,
                                            now.day,
                                          );
                                          break;
                                        case 'Yearly':
                                          _scheduledActionDate = DateTime(
                                            now.year + 1,
                                            now.month,
                                            now.day,
                                          );
                                          break;
                                        case 'Custom':
                                          // Don't auto-set — user picks manually
                                          _scheduledActionDate = null;
                                          break;
                                      }
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppTheme.primary
                                          : AppTheme.surfaceLight,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppTheme.primary
                                            : AppTheme.surface200,
                                      ),
                                    ),
                                    child: Text(
                                      freq,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? Colors.white
                                            : AppTheme.textSecondary,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // ── Date (separate from time) ──
                      GestureDetector(
                        onTap:
                            (_selectedAction == 'Follow-up' &&
                                _followUpFrequency.isNotEmpty &&
                                _followUpFrequency != 'Custom')
                            ? null // locked for non-custom frequencies
                            : () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      _scheduledActionDate ??
                                      DateTime.now().add(
                                        const Duration(days: 1),
                                      ),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 365 * 2),
                                  ),
                                );
                                if (picked != null) {
                                  setState(() => _scheduledActionDate = picked);
                                }
                              },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color:
                                (_selectedAction == 'Follow-up' &&
                                    _followUpFrequency.isNotEmpty &&
                                    _followUpFrequency != 'Custom')
                                ? AppTheme.surface100
                                : AppTheme.surfaceLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.surface200),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 18,
                                color: AppTheme.textSecondary,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Date',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        color: AppTheme.textMuted,
                                      ),
                                    ),
                                    Text(
                                      _scheduledActionDate != null
                                          ? '${_scheduledActionDate!.day}/${_scheduledActionDate!.month}/${_scheduledActionDate!.year}'
                                          : 'Select date',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        color: _scheduledActionDate != null
                                            ? AppTheme.textPrimary
                                            : AppTheme.textMuted,
                                        fontWeight: _scheduledActionDate != null
                                            ? FontWeight.w500
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (_selectedAction == 'Follow-up' &&
                                  _followUpFrequency.isNotEmpty &&
                                  _followUpFrequency != 'Custom')
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Auto-set',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      color: AppTheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              else
                                const Icon(
                                  Icons.edit_calendar_outlined,
                                  size: 16,
                                  color: AppTheme.textMuted,
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // ── Time (separate from date) ──
                      GestureDetector(
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime:
                                _scheduledActionTime ?? TimeOfDay.now(),
                          );
                          if (picked != null) {
                            setState(() => _scheduledActionTime = picked);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.surface200),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                size: 18,
                                color: AppTheme.textSecondary,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Time',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        color: AppTheme.textMuted,
                                      ),
                                    ),
                                    Text(
                                      _scheduledActionTime != null
                                          ? _scheduledActionTime!.format(
                                              context,
                                            )
                                          : 'Select time',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        color: _scheduledActionTime != null
                                            ? AppTheme.textPrimary
                                            : AppTheme.textMuted,
                                        fontWeight: _scheduledActionTime != null
                                            ? FontWeight.w500
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.edit_outlined,
                                size: 16,
                                color: AppTheme.textMuted,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // ── Notes ──
                      TextFormField(
                        controller: _actionNotesCtrl,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Notes',
                          alignLabelWithHint: true,
                        ),
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
                  radius: 20,
                  backgroundColor: _ownerIdColor(
                    _selectedOwner.id,
                  ).withAlpha(30),
                  child: Text(
                    _selectedOwner.initials,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _ownerIdColor(_selectedOwner.id),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedOwner.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            _selectedOwner.role,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _ownerIdColor(
                                _selectedOwner.id,
                              ).withAlpha(20),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _selectedOwner.id,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: _ownerIdColor(_selectedOwner.id),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
          children: _tags.map((tag) {
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
          }).toList(),
        ),
      ],
    );
  }

  void _showOwnerPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _OwnerPickerSheet(
        owners: kLeadOwners,
        selectedOwner: _selectedOwner,
        onSelect: (owner) {
          setState(() => _selectedOwner = owner);
          Navigator.pop(ctx);
        },
      ),
    );
  }
}

// ─── Owner Picker Sheet ───────────────────────────────────────────────────────

class _OwnerPickerSheet extends StatefulWidget {
  final List<LeadOwner> owners;
  final LeadOwner selectedOwner;
  final ValueChanged<LeadOwner> onSelect;

  const _OwnerPickerSheet({
    required this.owners,
    required this.selectedOwner,
    required this.onSelect,
  });

  @override
  State<_OwnerPickerSheet> createState() => _OwnerPickerSheetState();
}

class _OwnerPickerSheetState extends State<_OwnerPickerSheet> {
  String _query = '';
  final _searchCtrl = TextEditingController();

  List<LeadOwner> get _filtered {
    if (_query.isEmpty) return widget.owners;
    final q = _query.toLowerCase();
    return widget.owners
        .where(
          (o) =>
              o.name.toLowerCase().contains(q) ||
              o.role.toLowerCase().contains(q) ||
              o.id.toLowerCase().contains(q),
        )
        .toList();
  }

  Color _idColor(String id) {
    if (id.startsWith('ADM')) return AppTheme.primary;
    if (id.startsWith('EMP')) return AppTheme.success;
    return const Color(0xFFD97706);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.surface200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Assign Lead Owner',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search by name, role, or ID...',
                prefixIcon: const Icon(Icons.search_rounded, size: 18),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.surface200),
                ),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 320),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filtered.length,
              itemBuilder: (_, i) {
                final owner = _filtered[i];
                final isSelected = owner.id == widget.selectedOwner.id;
                return InkWell(
                  onTap: () => widget.onSelect(owner),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: _idColor(owner.id).withAlpha(30),
                          child: Text(
                            owner.initials,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _idColor(owner.id),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                owner.name,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    owner.role,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _idColor(owner.id).withAlpha(20),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      owner.id,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: _idColor(owner.id),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_rounded,
                            color: AppTheme.primary,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
