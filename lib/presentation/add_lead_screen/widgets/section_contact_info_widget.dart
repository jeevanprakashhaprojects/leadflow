import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

// ─── Country Code Data ────────────────────────────────────────────────────────

class _Country {
  final String name;
  final String code;
  final String flag;
  const _Country(this.name, this.code, this.flag);
}

const List<_Country> _allCountries = [
  _Country('India', '+91', '🇮🇳'),
  _Country('United States', '+1', '🇺🇸'),
  _Country('United Kingdom', '+44', '🇬🇧'),
  _Country('United Arab Emirates', '+971', '🇦🇪'),
  _Country('Australia', '+61', '🇦🇺'),
  _Country('Canada', '+1', '🇨🇦'),
  _Country('Singapore', '+65', '🇸🇬'),
  _Country('Germany', '+49', '🇩🇪'),
  _Country('France', '+33', '🇫🇷'),
  _Country('Japan', '+81', '🇯🇵'),
  _Country('China', '+86', '🇨🇳'),
  _Country('South Korea', '+82', '🇰🇷'),
  _Country('Brazil', '+55', '🇧🇷'),
  _Country('Mexico', '+52', '🇲🇽'),
  _Country('South Africa', '+27', '🇿🇦'),
  _Country('Nigeria', '+234', '🇳🇬'),
  _Country('Kenya', '+254', '🇰🇪'),
  _Country('Egypt', '+20', '🇪🇬'),
  _Country('Saudi Arabia', '+966', '🇸🇦'),
  _Country('Qatar', '+974', '🇶🇦'),
  _Country('Kuwait', '+965', '🇰🇼'),
  _Country('Bahrain', '+973', '🇧🇭'),
  _Country('Oman', '+968', '🇴🇲'),
  _Country('Pakistan', '+92', '🇵🇰'),
  _Country('Bangladesh', '+880', '🇧🇩'),
  _Country('Sri Lanka', '+94', '🇱🇰'),
  _Country('Nepal', '+977', '🇳🇵'),
  _Country('Myanmar', '+95', '🇲🇲'),
  _Country('Thailand', '+66', '🇹🇭'),
  _Country('Vietnam', '+84', '🇻🇳'),
  _Country('Indonesia', '+62', '🇮🇩'),
  _Country('Malaysia', '+60', '🇲🇾'),
  _Country('Philippines', '+63', '🇵🇭'),
  _Country('New Zealand', '+64', '🇳🇿'),
  _Country('Italy', '+39', '🇮🇹'),
  _Country('Spain', '+34', '🇪🇸'),
  _Country('Portugal', '+351', '🇵🇹'),
  _Country('Netherlands', '+31', '🇳🇱'),
  _Country('Belgium', '+32', '🇧🇪'),
  _Country('Switzerland', '+41', '🇨🇭'),
  _Country('Sweden', '+46', '🇸🇪'),
  _Country('Norway', '+47', '🇳🇴'),
  _Country('Denmark', '+45', '🇩🇰'),
  _Country('Finland', '+358', '🇫🇮'),
  _Country('Poland', '+48', '🇵🇱'),
  _Country('Russia', '+7', '🇷🇺'),
  _Country('Turkey', '+90', '🇹🇷'),
  _Country('Israel', '+972', '🇮🇱'),
  _Country('Iran', '+98', '🇮🇷'),
  _Country('Iraq', '+964', '🇮🇶'),
  _Country('Jordan', '+962', '🇯🇴'),
  _Country('Lebanon', '+961', '🇱🇧'),
  _Country('Argentina', '+54', '🇦🇷'),
  _Country('Chile', '+56', '🇨🇱'),
  _Country('Colombia', '+57', '🇨🇴'),
  _Country('Peru', '+51', '🇵🇪'),
  _Country('Venezuela', '+58', '🇻🇪'),
  _Country('Ghana', '+233', '🇬🇭'),
  _Country('Tanzania', '+255', '🇹🇿'),
  _Country('Uganda', '+256', '🇺🇬'),
  _Country('Ethiopia', '+251', '🇪🇹'),
  _Country('Morocco', '+212', '🇲🇦'),
  _Country('Tunisia', '+216', '🇹🇳'),
  _Country('Algeria', '+213', '🇩🇿'),
  _Country('Zimbabwe', '+263', '🇿🇼'),
  _Country('Zambia', '+260', '🇿🇲'),
  _Country('Mozambique', '+258', '🇲🇿'),
  _Country('Afghanistan', '+93', '🇦🇫'),
  _Country('Kazakhstan', '+7', '🇰🇿'),
  _Country('Uzbekistan', '+998', '🇺🇿'),
  _Country('Ukraine', '+380', '🇺🇦'),
  _Country('Romania', '+40', '🇷🇴'),
  _Country('Czech Republic', '+420', '🇨🇿'),
  _Country('Hungary', '+36', '🇭🇺'),
  _Country('Greece', '+30', '🇬🇷'),
  _Country('Austria', '+43', '🇦🇹'),
  _Country('Ireland', '+353', '🇮🇪'),
  _Country('Hong Kong', '+852', '🇭🇰'),
  _Country('Taiwan', '+886', '🇹🇼'),
  _Country('Maldives', '+960', '🇲🇻'),
  _Country('Bhutan', '+975', '🇧🇹'),
  _Country('Cambodia', '+855', '🇰🇭'),
  _Country('Laos', '+856', '🇱🇦'),
  _Country('Mongolia', '+976', '🇲🇳'),
  _Country('Papua New Guinea', '+675', '🇵🇬'),
  _Country('Fiji', '+679', '🇫🇯'),
  _Country('Jamaica', '+1876', '🇯🇲'),
  _Country('Trinidad and Tobago', '+1868', '🇹🇹'),
  _Country('Cuba', '+53', '🇨🇺'),
  _Country('Dominican Republic', '+1809', '🇩🇴'),
  _Country('Guatemala', '+502', '🇬🇹'),
  _Country('Honduras', '+504', '🇭🇳'),
  _Country('El Salvador', '+503', '🇸🇻'),
  _Country('Costa Rica', '+506', '🇨🇷'),
  _Country('Panama', '+507', '🇵🇦'),
  _Country('Bolivia', '+591', '🇧🇴'),
  _Country('Paraguay', '+595', '🇵🇾'),
  _Country('Uruguay', '+598', '🇺🇾'),
  _Country('Ecuador', '+593', '🇪🇨'),
];

// ─── Country Code Picker Widget ───────────────────────────────────────────────

class _CountryCodePicker extends StatefulWidget {
  final _Country selected;
  final ValueChanged<_Country> onChanged;

  const _CountryCodePicker({required this.selected, required this.onChanged});

  @override
  State<_CountryCodePicker> createState() => _CountryCodePickerState();
}

class _CountryCodePickerState extends State<_CountryCodePicker> {
  void _openPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _CountryPickerSheet(
        selected: widget.selected,
        onSelect: (c) {
          widget.onChanged(c);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openPicker,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariantLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.surface200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.selected.flag, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 4),
            Text(
              widget.selected.code,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(
              Icons.arrow_drop_down_rounded,
              size: 18,
              color: AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _CountryPickerSheet extends StatefulWidget {
  final _Country selected;
  final ValueChanged<_Country> onSelect;

  const _CountryPickerSheet({required this.selected, required this.onSelect});

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  String _query = '';
  final _searchCtrl = TextEditingController();

  List<_Country> get _filtered {
    if (_query.isEmpty) return _allCountries;
    final q = _query.toLowerCase();
    return _allCountries
        .where((c) => c.name.toLowerCase().contains(q) || c.code.contains(q))
        .toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.4,
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
            child: Text(
              'Select Country Code',
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
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search country...',
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
          Expanded(
            child: ListView.builder(
              controller: scrollCtrl,
              itemCount: _filtered.length,
              itemBuilder: (_, i) {
                final c = _filtered[i];
                final isSelected =
                    c.code == widget.selected.code &&
                    c.name == widget.selected.name;
                return ListTile(
                  leading: Text(c.flag, style: const TextStyle(fontSize: 22)),
                  title: Text(
                    c.name,
                    style: GoogleFonts.plusJakartaSans(fontSize: 14),
                  ),
                  trailing: Text(
                    c.code,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.textSecondary,
                    ),
                  ),
                  selected: isSelected,
                  selectedTileColor: AppTheme.primaryContainer.withAlpha(60),
                  onTap: () => widget.onSelect(c),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Phone Field with Country Code ───────────────────────────────────────────

class _PhoneFieldWithCode extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isRequired;
  final IconData? prefixIcon;
  final ValueChanged<String>? onChanged;

  const _PhoneFieldWithCode({
    required this.label,
    required this.controller,
    this.isRequired = false,
    this.prefixIcon,
    this.onChanged,
  });

  @override
  State<_PhoneFieldWithCode> createState() => _PhoneFieldWithCodeState();
}

class _PhoneFieldWithCodeState extends State<_PhoneFieldWithCode> {
  _Country _selectedCountry = _allCountries.first; // India default

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CountryCodePicker(
          selected: _selectedCountry,
          onChanged: (c) => setState(() => _selectedCountry = c),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            controller: widget.controller,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: widget.label,
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, size: 18)
                  : null,
            ),
            validator: widget.isRequired
                ? (v) => (v == null || v.isEmpty) ? 'Required' : null
                : null,
            onChanged: widget.onChanged,
          ),
        ),
      ],
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppTheme.textSecondary,
        letterSpacing: 0.3,
      ),
    );
  }
}

// ─── Main Widget ──────────────────────────────────────────────────────────────

class SectionContactInfoWidget extends StatefulWidget {
  const SectionContactInfoWidget({super.key});

  @override
  State<SectionContactInfoWidget> createState() =>
      _SectionContactInfoWidgetState();
}

class _SectionContactInfoWidgetState extends State<SectionContactInfoWidget> {
  String _salutation = 'Mr.';
  bool _whatsappSameAsMobile = false;
  bool _showDemographics = false;
  String _selectedGender = '';
  String _selectedMaritalStatus = '';

  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _altPhoneCtrl = TextEditingController();
  final _whatsappCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _email2Ctrl = TextEditingController();

  static const _salutations = ['Mr.', 'Ms.', 'Mrs.', 'Dr.', 'Prof.'];
  static const _genders = ['Male', 'Female', 'Other', 'Prefer not to say'];
  static const _maritalStatuses = ['Single', 'Married', 'Divorced', 'Widowed'];

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _mobileCtrl.dispose();
    _altPhoneCtrl.dispose();
    _whatsappCtrl.dispose();
    _emailCtrl.dispose();
    _email2Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Salutation
        _SectionLabel('Salutation'),
        const SizedBox(height: 8),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariantLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.surface200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _salutation,
              isExpanded: true,
              items: _salutations
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text(
                        s,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _salutation = v!),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
              icon: const Icon(Icons.expand_more_rounded, size: 18),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // First Name
        TextFormField(
          controller: _firstNameCtrl,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'First Name *'),
          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        // Last Name
        TextFormField(
          controller: _lastNameCtrl,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'Last Name'),
        ),
        const SizedBox(height: 20),
        _SectionLabel('Phone Numbers'),
        const SizedBox(height: 8),
        // Primary Mobile
        _PhoneFieldWithCode(
          label: 'Primary Mobile *',
          controller: _mobileCtrl,
          isRequired: true,
          onChanged: (v) {
            if (_whatsappSameAsMobile) {
              setState(() => _whatsappCtrl.text = v);
            }
          },
        ),
        const SizedBox(height: 12),
        // Alternate Phone
        _PhoneFieldWithCode(
          label: 'Alternate Phone',
          controller: _altPhoneCtrl,
        ),
        const SizedBox(height: 12),
        // WhatsApp
        _PhoneFieldWithCode(label: 'WhatsApp', controller: _whatsappCtrl),
        const SizedBox(height: 8),
        // Same as mobile toggle
        Row(
          children: [
            Switch(
              value: _whatsappSameAsMobile,
              onChanged: (v) {
                setState(() {
                  _whatsappSameAsMobile = v;
                  if (v) _whatsappCtrl.text = _mobileCtrl.text;
                });
              },
              activeThumbColor: AppTheme.success,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const SizedBox(width: 8),
            Text(
              'WhatsApp same as Primary Mobile',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _SectionLabel('Email Addresses'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Primary Email *',
            prefixIcon: const Icon(Icons.email_outlined, size: 18),
            suffixIcon: _emailCtrl.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 18),
                    onPressed: () => setState(() => _emailCtrl.clear()),
                  )
                : null,
          ),
          onChanged: (_) => setState(() {}),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Email required';
            if (!v.contains('@')) return 'Invalid email';
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _email2Ctrl,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Secondary Email',
            prefixIcon: Icon(Icons.email_outlined, size: 18),
          ),
        ),
        const SizedBox(height: 16),
        // Demographics toggle
        GestureDetector(
          onTap: () => setState(() => _showDemographics = !_showDemographics),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.surface100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.surface200),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.person_pin_outlined,
                  size: 18,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Additional Demographics',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                AnimatedRotation(
                  turns: _showDemographics ? 0.5 : 0,
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
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: _showDemographics
              ? Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: _buildDemographics(),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildDemographics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // DOB
        TextFormField(
          readOnly: true,
          decoration: const InputDecoration(
            labelText: 'Date of Birth',
            prefixIcon: Icon(Icons.cake_outlined, size: 18),
          ),
          onTap: () async {
            await showDatePicker(
              context: context,
              initialDate: DateTime(1990),
              firstDate: DateTime(1920),
              lastDate: DateTime.now(),
            );
          },
        ),
        const SizedBox(height: 12),
        // Gender
        InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Gender',
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedGender.isEmpty ? null : _selectedGender,
              hint: Text(
                'Select',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppTheme.textMuted,
                ),
              ),
              isExpanded: true,
              isDense: true,
              items: _genders
                  .map(
                    (g) => DropdownMenuItem(
                      value: g,
                      child: Text(
                        g,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedGender = v ?? ''),
              icon: const Icon(Icons.expand_more_rounded, size: 16),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Marital Status
        InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Marital Status',
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedMaritalStatus.isEmpty
                  ? null
                  : _selectedMaritalStatus,
              hint: Text(
                'Select',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppTheme.textMuted,
                ),
              ),
              isExpanded: true,
              isDense: true,
              items: _maritalStatuses
                  .map(
                    (m) => DropdownMenuItem(
                      value: m,
                      child: Text(
                        m,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) =>
                  setState(() => _selectedMaritalStatus = v ?? ''),
              icon: const Icon(Icons.expand_more_rounded, size: 16),
            ),
          ),
        ),
      ],
    );
  }
}