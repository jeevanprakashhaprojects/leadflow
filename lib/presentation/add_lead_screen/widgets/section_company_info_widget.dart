import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class SectionCompanyInfoWidget extends StatefulWidget {
  final void Function(int filledCount)? onCompulsoryChanged;
  const SectionCompanyInfoWidget({super.key, this.onCompulsoryChanged});

  @override
  State<SectionCompanyInfoWidget> createState() =>
      _SectionCompanyInfoWidgetState();
}

class _SectionCompanyInfoWidgetState extends State<SectionCompanyInfoWidget> {
  String _selectedIndustry = '';
  String _selectedCompanySize = '';
  String _selectedDepartment = '';
  String _selectedDecisionLevel = '';

  // No compulsory fields — all optional
  void _notifyParent() {
    // Business Details is fully optional — always report 0 required
    widget.onCompulsoryChanged?.call(0);
  }

  static const _industries = [
    'Technology',
    'Finance',
    'Healthcare',
    'Manufacturing',
    'Retail',
    'Education',
    'Real Estate',
    'Automotive',
    'FMCG',
    'Telecom',
    'Insurance',
    'Consulting',
  ];

  static const _companySizes = [
    '1–10',
    '11–50',
    '51–200',
    '201–500',
    '501–1000',
    '1000+',
  ];

  static const _departments = [
    'Sales',
    'Marketing',
    'Operations',
    'Finance',
    'HR',
    'IT',
    'Legal',
    'Product',
    'Customer Success',
  ];

  static const _decisionLevels = [
    'C-Suite',
    'VP / Director',
    'Manager',
    'Individual Contributor',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Optional badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.surface100,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.surface200),
          ),
          child: Text(
            'All fields optional — fill only if applicable',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: AppTheme.textMuted,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Company Name (optional)
        TextFormField(
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Company Name',
            prefixIcon: Icon(Icons.business_outlined, size: 18),
          ),
        ),
        const SizedBox(height: 12),
        // Industry
        _DropdownFormField(
          label: 'Industry',
          value: _selectedIndustry,
          items: _industries,
          onChanged: (v) => setState(() => _selectedIndustry = v),
        ),
        const SizedBox(height: 12),
        // Job Title
        TextFormField(
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Job Title',
            prefixIcon: Icon(Icons.work_outline_rounded, size: 18),
          ),
        ),
        const SizedBox(height: 12),
        // Department
        _DropdownFormField(
          label: 'Department',
          value: _selectedDepartment,
          items: _departments,
          onChanged: (v) => setState(() => _selectedDepartment = v),
        ),
        const SizedBox(height: 12),
        // Company Size
        _DropdownFormField(
          label: 'Company Size',
          value: _selectedCompanySize,
          items: _companySizes,
          onChanged: (v) => setState(() => _selectedCompanySize = v),
        ),
        const SizedBox(height: 12),
        // Annual Revenue
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Annual Revenue',
            prefixText: '₹ ',
            prefixIcon: Icon(Icons.currency_rupee_rounded, size: 18),
          ),
        ),
        const SizedBox(height: 12),
        // Company Phone
        TextFormField(
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Company Phone',
            prefixIcon: Icon(Icons.phone_outlined, size: 18),
          ),
        ),
        const SizedBox(height: 12),
        // Company Email
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Company Email',
            prefixIcon: Icon(Icons.email_outlined, size: 18),
          ),
        ),
        const SizedBox(height: 16),
        // Decision Maker
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.primaryContainer.withAlpha(77),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primary.withAlpha(51)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    size: 16,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Decision Maker',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Role / Title'),
              ),
              const SizedBox(height: 12),
              _DropdownFormField(
                label: 'Decision Level',
                value: _selectedDecisionLevel,
                items: _decisionLevels,
                onChanged: (v) => setState(() => _selectedDecisionLevel = v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Company Address
        TextFormField(
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Company Address',
            alignLabelWithHint: true,
            prefixIcon: Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Icon(Icons.location_on_outlined, size: 18),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Website URL
        TextFormField(
          keyboardType: TextInputType.url,
          decoration: const InputDecoration(
            labelText: 'Website URL',
            prefixIcon: Icon(Icons.language_rounded, size: 18),
            hintText: 'https://example.com',
          ),
        ),
      ],
    );
  }
}

// ─── Reusable Dropdown ────────────────────────────────────────────────────────

class _DropdownFormField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _DropdownFormField({
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value.isEmpty ? null : value,
          isExpanded: true,
          isDense: true,
          hint: Text(
            'Select $label',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppTheme.textMuted,
            ),
          ),
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: GoogleFonts.plusJakartaSans(fontSize: 13),
                  ),
                ),
              )
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
          icon: const Icon(Icons.expand_more_rounded, size: 16),
        ),
      ),
    );
  }
}
