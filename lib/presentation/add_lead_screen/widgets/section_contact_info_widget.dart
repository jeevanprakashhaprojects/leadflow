import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

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
        // Salutation + Name row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Salutation dropdown
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariantLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.surface200),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _salutation,
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
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _firstNameCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _lastNameCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SectionLabel('Phone Numbers'),
        const SizedBox(height: 8),
        _PhoneField(
          label: 'Primary Mobile *',
          controller: _mobileCtrl,
          onChanged: (v) {
            if (_whatsappSameAsMobile) {
              setState(() => _whatsappCtrl.text = v);
            }
          },
        ),
        const SizedBox(height: 12),
        _PhoneField(label: 'Alternate Phone', controller: _altPhoneCtrl),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _PhoneField(
                label: 'WhatsApp',
                controller: _whatsappCtrl,
                prefixIcon: Icons.whatshot_rounded,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                Text(
                  'Same as\nMobile',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
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
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
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
        // 3-column row: DOB, Gender, Marital Status
        Row(
          children: [
            Expanded(
              child: TextFormField(
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  prefixIcon: Icon(Icons.calendar_today_outlined, size: 16),
                ),
                onTap: () async {
                  await showDatePicker(
                    context: context,
                    initialDate: DateTime(1990),
                    firstDate: DateTime(1940),
                    lastDate: DateTime.now(),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _DropdownField(
                label: 'Gender',
                value: _selectedGender,
                items: _genders,
                onChanged: (v) => setState(() => _selectedGender = v),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _DropdownField(
                label: 'Marital Status',
                value: _selectedMaritalStatus,
                items: _maritalStatuses,
                onChanged: (v) => setState(() => _selectedMaritalStatus = v),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Age'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Occupation'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Annual Income',
                  prefixText: '₹ ',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'PAN Number'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Aadhaar'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Children'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PhoneField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData prefixIcon;
  final ValueChanged<String>? onChanged;

  const _PhoneField({
    required this.label,
    required this.controller,
    this.prefixIcon = Icons.phone_outlined,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 12),
            Text('🇮🇳', style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 4),
            Text(
              '+91',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Container(width: 1, height: 16, color: AppTheme.surface200),
            const SizedBox(width: 4),
          ],
        ),
      ),
      onChanged: onChanged,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppTheme.textSecondary,
        letterSpacing: 0.3,
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value.isEmpty ? null : value,
          hint: const SizedBox.shrink(),
          isExpanded: true,
          isDense: true,
          items: items
              .map(
                (i) => DropdownMenuItem(
                  value: i,
                  child: Text(
                    i,
                    style: GoogleFonts.plusJakartaSans(fontSize: 12),
                  ),
                ),
              )
              .toList(),
          onChanged: (v) => onChanged(v ?? ''),
          icon: const Icon(Icons.expand_more_rounded, size: 16),
        ),
      ),
    );
  }
}
