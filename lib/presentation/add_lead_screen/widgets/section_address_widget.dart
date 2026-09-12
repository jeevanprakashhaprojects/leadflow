import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class SectionAddressWidget extends StatefulWidget {
  const SectionAddressWidget({super.key});

  @override
  State<SectionAddressWidget> createState() => _SectionAddressWidgetState();
}

class _SectionAddressWidgetState extends State<SectionAddressWidget> {
  String _addressType = 'Permanent';
  String _selectedState = '';
  String _selectedCountry = 'India';
  final _streetCtrl = TextEditingController();
  final _landmarkCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _districtCtrl = TextEditingController();
  final _pincodeCtrl = TextEditingController();

  static const _addressTypes = ['Permanent', 'Current', 'Both'];
  static const _states = [
    'Andhra Pradesh',
    'Delhi',
    'Gujarat',
    'Karnataka',
    'Kerala',
    'Maharashtra',
    'Rajasthan',
    'Tamil Nadu',
    'Telangana',
    'Uttar Pradesh',
    'West Bengal',
  ];
  static const _countries = [
    'India',
    'USA',
    'UK',
    'UAE',
    'Singapore',
    'Australia',
    'Canada',
  ];

  // Pincode → state mapping (sample)
  static const Map<String, String> _pincodeStateMap = {
    '400': 'Maharashtra',
    '110': 'Delhi',
    '560': 'Karnataka',
    '600': 'Tamil Nadu',
    '500': 'Telangana',
    '380': 'Gujarat',
    '302': 'Rajasthan',
  };

  void _onPincodeChanged(String value) {
    if (value.length >= 3) {
      final prefix = value.substring(0, 3);
      final state = _pincodeStateMap[prefix];
      if (state != null) {
        setState(() => _selectedState = state);
      }
    }
  }

  @override
  void dispose() {
    _streetCtrl.dispose();
    _landmarkCtrl.dispose();
    _cityCtrl.dispose();
    _districtCtrl.dispose();
    _pincodeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Address type segmented
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surface100,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(3),
          child: Row(
            children: _addressTypes.map((type) {
              final isSelected = _addressType == type;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _addressType = type),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.surfaceLight
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.black.withAlpha(15),
                                blurRadius: 4,
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      type,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected
                            ? AppTheme.primary
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _streetCtrl,
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Street Address',
            alignLabelWithHint: true,
            prefixIcon: Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Icon(Icons.location_on_outlined, size: 18),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Landmark, City, District
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _landmarkCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Landmark'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _cityCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'City *'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _districtCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'District'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // State, Pincode, Country
        Row(
          children: [
            Expanded(
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'State',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedState.isEmpty ? null : _selectedState,
                    hint: const SizedBox.shrink(),
                    isExpanded: true,
                    isDense: true,
                    items: _states
                        .map(
                          (s) => DropdownMenuItem(
                            value: s,
                            child: Text(
                              s,
                              style: GoogleFonts.plusJakartaSans(fontSize: 12),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _selectedState = v ?? ''),
                    icon: const Icon(Icons.expand_more_rounded, size: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _pincodeCtrl,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: 'Pincode',
                  counterText: '',
                ),
                onChanged: _onPincodeChanged,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Country',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCountry,
                    isExpanded: true,
                    isDense: true,
                    items: _countries
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(
                              c,
                              style: GoogleFonts.plusJakartaSans(fontSize: 12),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _selectedCountry = v!),
                    icon: const Icon(Icons.expand_more_rounded, size: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Action buttons
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.copy_outlined, size: 16),
              label: const Text('Copy Address'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.textSecondary,
                side: BorderSide(color: AppTheme.surface200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: GoogleFonts.plusJakartaSans(fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.map_outlined, size: 16),
              label: const Text('Open in Maps'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primary,
                side: BorderSide(color: AppTheme.primary.withAlpha(128)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: GoogleFonts.plusJakartaSans(fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
