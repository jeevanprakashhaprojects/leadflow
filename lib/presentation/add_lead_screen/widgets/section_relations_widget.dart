import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

// ─── Country Code Data ────────────────────────────────────────────────────────
class _CountryCode {
  final String flag;
  final String name;
  final String code;
  const _CountryCode(this.flag, this.name, this.code);
}

const List<_CountryCode> _countryCodes = [
  _CountryCode('🇮🇳', 'India', '+91'),
  _CountryCode('🇺🇸', 'United States', '+1'),
  _CountryCode('🇬🇧', 'United Kingdom', '+44'),
  _CountryCode('🇦🇺', 'Australia', '+61'),
  _CountryCode('🇨🇦', 'Canada', '+1'),
  _CountryCode('🇦🇪', 'UAE', '+971'),
  _CountryCode('🇸🇬', 'Singapore', '+65'),
  _CountryCode('🇲🇾', 'Malaysia', '+60'),
  _CountryCode('🇳🇿', 'New Zealand', '+64'),
  _CountryCode('🇿🇦', 'South Africa', '+27'),
  _CountryCode('🇩🇪', 'Germany', '+49'),
  _CountryCode('🇫🇷', 'France', '+33'),
  _CountryCode('🇮🇹', 'Italy', '+39'),
  _CountryCode('🇪🇸', 'Spain', '+34'),
  _CountryCode('🇳🇱', 'Netherlands', '+31'),
  _CountryCode('🇸🇪', 'Sweden', '+46'),
  _CountryCode('🇳🇴', 'Norway', '+47'),
  _CountryCode('🇩🇰', 'Denmark', '+45'),
  _CountryCode('🇨🇭', 'Switzerland', '+41'),
  _CountryCode('🇧🇪', 'Belgium', '+32'),
  _CountryCode('🇯🇵', 'Japan', '+81'),
  _CountryCode('🇨🇳', 'China', '+86'),
  _CountryCode('🇰🇷', 'South Korea', '+82'),
  _CountryCode('🇧🇷', 'Brazil', '+55'),
  _CountryCode('🇲🇽', 'Mexico', '+52'),
  _CountryCode('🇦🇷', 'Argentina', '+54'),
  _CountryCode('🇵🇰', 'Pakistan', '+92'),
  _CountryCode('🇧🇩', 'Bangladesh', '+880'),
  _CountryCode('🇱🇰', 'Sri Lanka', '+94'),
  _CountryCode('🇳🇵', 'Nepal', '+977'),
  _CountryCode('🇲🇻', 'Maldives', '+960'),
  _CountryCode('🇧🇹', 'Bhutan', '+975'),
  _CountryCode('🇮🇩', 'Indonesia', '+62'),
  _CountryCode('🇵🇭', 'Philippines', '+63'),
  _CountryCode('🇹🇭', 'Thailand', '+66'),
  _CountryCode('🇻🇳', 'Vietnam', '+84'),
  _CountryCode('🇸🇦', 'Saudi Arabia', '+966'),
  _CountryCode('🇶🇦', 'Qatar', '+974'),
  _CountryCode('🇰🇼', 'Kuwait', '+965'),
  _CountryCode('🇧🇭', 'Bahrain', '+973'),
  _CountryCode('🇴🇲', 'Oman', '+968'),
  _CountryCode('🇮🇱', 'Israel', '+972'),
  _CountryCode('🇹🇷', 'Turkey', '+90'),
  _CountryCode('🇷🇺', 'Russia', '+7'),
  _CountryCode('🇺🇦', 'Ukraine', '+380'),
  _CountryCode('🇵🇱', 'Poland', '+48'),
  _CountryCode('🇷🇴', 'Romania', '+40'),
  _CountryCode('🇨🇿', 'Czech Republic', '+420'),
  _CountryCode('🇭🇺', 'Hungary', '+36'),
  _CountryCode('🇬🇷', 'Greece', '+30'),
  _CountryCode('🇵🇹', 'Portugal', '+351'),
  _CountryCode('🇫🇮', 'Finland', '+358'),
  _CountryCode('🇦🇹', 'Austria', '+43'),
  _CountryCode('🇮🇪', 'Ireland', '+353'),
  _CountryCode('🇳🇬', 'Nigeria', '+234'),
  _CountryCode('🇰🇪', 'Kenya', '+254'),
  _CountryCode('🇬🇭', 'Ghana', '+233'),
  _CountryCode('🇪🇹', 'Ethiopia', '+251'),
  _CountryCode('🇹🇿', 'Tanzania', '+255'),
  _CountryCode('🇺🇬', 'Uganda', '+256'),
  _CountryCode('🇿🇼', 'Zimbabwe', '+263'),
  _CountryCode('🇲🇦', 'Morocco', '+212'),
  _CountryCode('🇪🇬', 'Egypt', '+20'),
  _CountryCode('🇹🇳', 'Tunisia', '+216'),
  _CountryCode('🇩🇿', 'Algeria', '+213'),
  _CountryCode('🇨🇴', 'Colombia', '+57'),
  _CountryCode('🇵🇪', 'Peru', '+51'),
  _CountryCode('🇨🇱', 'Chile', '+56'),
  _CountryCode('🇻🇪', 'Venezuela', '+58'),
  _CountryCode('🇪🇨', 'Ecuador', '+593'),
  _CountryCode('🇧🇴', 'Bolivia', '+591'),
  _CountryCode('🇵🇾', 'Paraguay', '+595'),
  _CountryCode('🇺🇾', 'Uruguay', '+598'),
  _CountryCode('🇨🇷', 'Costa Rica', '+506'),
  _CountryCode('🇵🇦', 'Panama', '+507'),
  _CountryCode('🇨🇺', 'Cuba', '+53'),
  _CountryCode('🇩🇴', 'Dominican Republic', '+1'),
  _CountryCode('🇯🇲', 'Jamaica', '+1'),
  _CountryCode('🇹🇹', 'Trinidad & Tobago', '+1'),
  _CountryCode('🇭🇰', 'Hong Kong', '+852'),
  _CountryCode('🇹🇼', 'Taiwan', '+886'),
  _CountryCode('🇲🇴', 'Macau', '+853'),
  _CountryCode('🇲🇲', 'Myanmar', '+95'),
  _CountryCode('🇰🇭', 'Cambodia', '+855'),
  _CountryCode('🇱🇦', 'Laos', '+856'),
  _CountryCode('🇧🇳', 'Brunei', '+673'),
  _CountryCode('🇹🇱', 'Timor-Leste', '+670'),
  _CountryCode('🇵🇬', 'Papua New Guinea', '+675'),
  _CountryCode('🇫🇯', 'Fiji', '+679'),
  _CountryCode('🇼🇸', 'Samoa', '+685'),
  _CountryCode('🇹🇴', 'Tonga', '+676'),
];

// ─── Country Code Picker Widget ───────────────────────────────────────────────
class _CountryCodePicker extends StatefulWidget {
  final _CountryCode initialCountry;
  final ValueChanged<_CountryCode> onChanged;

  const _CountryCodePicker({
    required this.initialCountry,
    required this.onChanged,
  });

  @override
  State<_CountryCodePicker> createState() => _CountryCodePickerState();
}

class _CountryCodePickerState extends State<_CountryCodePicker> {
  late _CountryCode _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialCountry;
  }

  void _showPicker() {
    final searchCtrl = TextEditingController();
    List<_CountryCode> filtered = List.from(_countryCodes);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (_, scrollCtrl) => Column(
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'Search country...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 18),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (q) {
                    setModalState(() {
                      filtered = _countryCodes
                          .where(
                            (c) =>
                                c.name.toLowerCase().contains(
                                  q.toLowerCase(),
                                ) ||
                                c.code.contains(q),
                          )
                          .toList();
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  controller: scrollCtrl,
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final c = filtered[i];
                    final isSelected =
                        c.code == _selected.code && c.name == _selected.name;
                    return ListTile(
                      leading: Text(
                        c.flag,
                        style: const TextStyle(fontSize: 22),
                      ),
                      title: Text(
                        c.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                      trailing: Text(
                        c.code,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      selected: isSelected,
                      selectedTileColor: AppTheme.primaryContainer,
                      onTap: () {
                        setState(() => _selected = c);
                        widget.onChanged(c);
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showPicker,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: AppTheme.surface200)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_selected.flag, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 4),
            Text(
              _selected.code,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
            ),
            const Icon(
              Icons.arrow_drop_down_rounded,
              size: 16,
              color: AppTheme.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Main Widget ──────────────────────────────────────────────────────────────

class SectionRelationsWidget extends StatefulWidget {
  const SectionRelationsWidget({super.key});

  @override
  State<SectionRelationsWidget> createState() => _SectionRelationsWidgetState();
}

class _SectionRelationsWidgetState extends State<SectionRelationsWidget> {
  // Start with empty list — no default
  final List<_RelationData> _relations = [];

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
    'Guardian',
    'Nominee',
    'Business Partner',
    'Referral',
    'Other',
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
    'Guardian': Color(0xFF3F51B5),
    'Nominee': Color(0xFF009688),
    'Business Partner': Color(0xFF673AB7),
    'Referral': Color(0xFFFF5722),
    'Other': Color(0xFF9E9E9E),
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

  void _addRelation() {
    setState(() {
      _relations.add(
        _RelationData(
          name: '',
          relation: 'Friend',
          phone: '',
          countryCode: _countryCodes.first,
          age: '',
          occupation: '',
          company: '',
          isExpanded: true,
          isSaved: false,
        ),
      );
    });
  }

  void _removeRelation(int index) {
    setState(() => _relations.removeAt(index));
  }

  void _toggleExpand(int index) {
    setState(
      () => _relations[index].isExpanded = !_relations[index].isExpanded,
    );
  }

  void _updateRelation(int index, _RelationData updated) {
    setState(() => _relations[index] = updated);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_relations.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.surface200),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.group_outlined,
                    size: 20,
                    color: AppTheme.textMuted,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'No relations added yet',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ..._relations.asMap().entries.map((entry) {
          final index = entry.key;
          final rel = entry.value;
          return _RelationCard(
            key: ValueKey('relation_$index'),
            relation: rel,
            relationTypes: _relationTypes,
            getRelationColor: _getRelationColor,
            getInitials: _getInitials,
            onToggleExpand: () => _toggleExpand(index),
            onRemove: () => _removeRelation(index),
            onUpdate: (updated) => _updateRelation(index, updated),
          );
        }),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _addRelation,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surface100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primary.withAlpha(102)),
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
}

// ─── Mutable Relation Data ────────────────────────────────────────────────────

class _RelationData {
  String name;
  String relation;
  String phone;
  _CountryCode countryCode;
  String age;
  String occupation;
  String company;
  bool isExpanded;
  bool isSaved;

  _RelationData({
    required this.name,
    required this.relation,
    required this.phone,
    required this.countryCode,
    required this.age,
    required this.occupation,
    required this.company,
    required this.isExpanded,
    this.isSaved = false,
  });

  _RelationData copyWith({
    String? name,
    String? relation,
    String? phone,
    _CountryCode? countryCode,
    String? age,
    String? occupation,
    String? company,
    bool? isExpanded,
    bool? isSaved,
  }) {
    return _RelationData(
      name: name ?? this.name,
      relation: relation ?? this.relation,
      phone: phone ?? this.phone,
      countryCode: countryCode ?? this.countryCode,
      age: age ?? this.age,
      occupation: occupation ?? this.occupation,
      company: company ?? this.company,
      isExpanded: isExpanded ?? this.isExpanded,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

// ─── Relation Card ────────────────────────────────────────────────────────────

class _RelationCard extends StatefulWidget {
  final _RelationData relation;
  final List<String> relationTypes;
  final Color Function(String) getRelationColor;
  final String Function(String) getInitials;
  final VoidCallback onToggleExpand;
  final VoidCallback onRemove;
  final ValueChanged<_RelationData> onUpdate;

  const _RelationCard({
    super.key,
    required this.relation,
    required this.relationTypes,
    required this.getRelationColor,
    required this.getInitials,
    required this.onToggleExpand,
    required this.onRemove,
    required this.onUpdate,
  });

  @override
  State<_RelationCard> createState() => _RelationCardState();
}

class _RelationCardState extends State<_RelationCard> {
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _ageCtrl;
  late TextEditingController _occupationCtrl;
  late TextEditingController _companyCtrl;
  late String _selectedRelation;
  late _CountryCode _selectedCountry;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.relation.name);
    _phoneCtrl = TextEditingController(text: widget.relation.phone);
    _ageCtrl = TextEditingController(text: widget.relation.age);
    _occupationCtrl = TextEditingController(text: widget.relation.occupation);
    _companyCtrl = TextEditingController(text: widget.relation.company);
    _selectedRelation = widget.relation.relation;
    _selectedCountry = widget.relation.countryCode;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _ageCtrl.dispose();
    _occupationCtrl.dispose();
    _companyCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter the relation\'s name',
            style: GoogleFonts.plusJakartaSans(fontSize: 13),
          ),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }
    // After saving: COLLAPSE the card (isExpanded = false)
    widget.onUpdate(
      widget.relation.copyWith(
        name: _nameCtrl.text,
        relation: _selectedRelation,
        phone: _phoneCtrl.text,
        countryCode: _selectedCountry,
        age: _ageCtrl.text,
        occupation: _occupationCtrl.text,
        company: _companyCtrl.text,
        isExpanded: false, // Collapse after save
        isSaved: true,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              _nameCtrl.text.isNotEmpty
                  ? '${_nameCtrl.text.split(' ').first} saved'
                  : 'Relation saved',
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
            ),
          ],
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.relation.name;
    final rel = _selectedRelation;
    final color = widget.getRelationColor(rel);
    final initials = name.isNotEmpty ? widget.getInitials(name) : '?';
    final firstName = name.isNotEmpty
        ? name.trim().split(' ').first
        : 'New Relation';
    final isSaved = widget.relation.isSaved;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSaved ? color.withAlpha(80) : AppTheme.surface200,
          width: isSaved ? 1.5 : 1,
        ),
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
          // Profile header row (always visible)
          InkWell(
            onTap: widget.onToggleExpand,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // Profile avatar
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withAlpha(38),
                      shape: BoxShape.circle,
                      border: isSaved
                          ? Border.all(color: color.withAlpha(100), width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
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
                            Expanded(
                              child: Text(
                                firstName,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
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
                            if (isSaved) ...[
                              const SizedBox(width: 6),
                              Icon(
                                Icons.check_circle_rounded,
                                size: 14,
                                color: AppTheme.success,
                              ),
                            ],
                          ],
                        ),
                        if (widget.relation.phone.isNotEmpty ||
                            widget.relation.occupation.isNotEmpty)
                          Text(
                            [
                              if (widget.relation.phone.isNotEmpty)
                                '${widget.relation.countryCode.code} ${widget.relation.phone}',
                              if (widget.relation.age.isNotEmpty)
                                '${widget.relation.age} yrs',
                              if (widget.relation.occupation.isNotEmpty)
                                widget.relation.occupation,
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
                    turns: widget.relation.isExpanded ? 0.5 : 0,
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
            child: widget.relation.isExpanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        // Full Name (stacked)
                        TextFormField(
                          controller: _nameCtrl,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 10),
                        // Relation dropdown (stacked, fully functional)
                        InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Relation Type',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedRelation,
                              isDense: true,
                              isExpanded: true,
                              items: widget.relationTypes
                                  .map(
                                    (r) => DropdownMenuItem(
                                      value: r,
                                      child: Text(
                                        r,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) {
                                  setState(() => _selectedRelation = v);
                                }
                              },
                              icon: const Icon(
                                Icons.expand_more_rounded,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Phone with country code dropdown (stacked)
                        TextFormField(
                          controller: _phoneCtrl,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            prefixIcon: _CountryCodePicker(
                              initialCountry: _selectedCountry,
                              onChanged: (c) =>
                                  setState(() => _selectedCountry = c),
                            ),
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 0,
                              minHeight: 0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Age (stacked)
                        TextFormField(
                          controller: _ageCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Age'),
                        ),
                        const SizedBox(height: 10),
                        // Occupation (stacked)
                        TextFormField(
                          controller: _occupationCtrl,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Occupation',
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Company (stacked)
                        TextFormField(
                          controller: _companyCtrl,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Company',
                          ),
                        ),
                        const SizedBox(height: 14),
                        // Action buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              onPressed: widget.onRemove,
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
                            ElevatedButton.icon(
                              onPressed: _save,
                              icon: const Icon(Icons.save_rounded, size: 16),
                              label: Text(
                                'Save',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
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
