import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

// ─── Address Data Model ───────────────────────────────────────────────────────

class _AddressData {
  final TextEditingController street;
  final TextEditingController landmark;
  final TextEditingController city;
  final TextEditingController district;
  final TextEditingController pincode;
  String state;
  String country;

  _AddressData()
    : street = TextEditingController(),
      landmark = TextEditingController(),
      city = TextEditingController(),
      district = TextEditingController(),
      pincode = TextEditingController(),
      state = '',
      country = 'India';

  void dispose() {
    street.dispose();
    landmark.dispose();
    city.dispose();
    district.dispose();
    pincode.dispose();
  }

  void copyFrom(_AddressData other) {
    street.text = other.street.text;
    landmark.text = other.landmark.text;
    city.text = other.city.text;
    district.text = other.district.text;
    pincode.text = other.pincode.text;
    state = other.state;
    country = other.country;
  }
}

// ─── Section Address Widget ───────────────────────────────────────────────────

class SectionAddressWidget extends StatefulWidget {
  const SectionAddressWidget({super.key});

  @override
  State<SectionAddressWidget> createState() => _SectionAddressWidgetState();
}

class _SectionAddressWidgetState extends State<SectionAddressWidget> {
  String _addressType = 'Permanent';

  // Each address type has its own independent data
  final _permanentAddress = _AddressData();
  final _currentAddress = _AddressData();

  static const _addressTypes = ['Permanent', 'Current', 'Both'];
  static const _states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Delhi',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
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
    'Germany',
    'France',
    'Japan',
    'China',
    'South Korea',
    'Brazil',
    'Saudi Arabia',
    'Qatar',
    'Kuwait',
    'Bahrain',
    'Oman',
    'Pakistan',
    'Bangladesh',
    'Sri Lanka',
    'Nepal',
    'Malaysia',
  ];

  static const Map<String, String> _pincodeStateMap = {
    '400': 'Maharashtra',
    '110': 'Delhi',
    '560': 'Karnataka',
    '600': 'Tamil Nadu',
    '500': 'Telangana',
    '380': 'Gujarat',
    '302': 'Rajasthan',
    '700': 'West Bengal',
    '411': 'Maharashtra',
    '226': 'Uttar Pradesh',
    '160': 'Punjab',
    '641': 'Tamil Nadu',
    '682': 'Kerala',
  };

  @override
  void dispose() {
    _permanentAddress.dispose();
    _currentAddress.dispose();
    super.dispose();
  }

  void _onPincodeChanged(String value, _AddressData data) {
    if (value.length >= 3) {
      final prefix = value.substring(0, 3);
      final state = _pincodeStateMap[prefix];
      if (state != null) {
        setState(() => data.state = state);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Address type segmented control
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
        // Show address form(s) based on type
        if (_addressType == 'Permanent' || _addressType == 'Both') ...[
          if (_addressType == 'Both') ...[
            _AddressTypeHeader(
              label: 'Permanent Address',
              icon: Icons.home_outlined,
            ),
            const SizedBox(height: 12),
          ],
          _buildAddressForm(_permanentAddress),
        ],
        if (_addressType == 'Both') ...[
          const SizedBox(height: 20),
          _AddressTypeHeader(
            label: 'Current Address',
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 8),
          // Copy from permanent option
          GestureDetector(
            onTap: () {
              setState(() => _currentAddress.copyFrom(_permanentAddress));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer.withAlpha(60),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primary.withAlpha(60)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.copy_outlined,
                    size: 14,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Copy from Permanent Address',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildAddressForm(_currentAddress),
        ],
        if (_addressType == 'Current') _buildAddressForm(_currentAddress),
        const SizedBox(height: 16),
        // Action buttons
        Row(
          children: [
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

  Widget _buildAddressForm(_AddressData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Optional notice
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppTheme.surface100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.surface200),
          ),
          child: Text(
            'Address is optional — fill only if available',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: AppTheme.textMuted,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        // Street Address
        TextFormField(
          controller: data.street,
          maxLines: 2,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Street Address',
            alignLabelWithHint: true,
            prefixIcon: Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: Icon(Icons.home_outlined, size: 18),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Landmark
        TextFormField(
          controller: data.landmark,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Landmark',
            prefixIcon: Icon(Icons.place_outlined, size: 18),
          ),
        ),
        const SizedBox(height: 12),
        // City
        TextFormField(
          controller: data.city,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'City',
            prefixIcon: Icon(Icons.location_city_outlined, size: 18),
          ),
        ),
        const SizedBox(height: 12),
        // District
        TextFormField(
          controller: data.district,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'District',
            prefixIcon: Icon(Icons.map_outlined, size: 18),
          ),
        ),
        const SizedBox(height: 12),
        // Pincode
        TextFormField(
          controller: data.pincode,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: const InputDecoration(
            labelText: 'Pincode',
            prefixIcon: Icon(Icons.pin_drop_outlined, size: 18),
            counterText: '',
          ),
          onChanged: (v) => _onPincodeChanged(v, data),
        ),
        const SizedBox(height: 12),
        // State dropdown
        StatefulBuilder(
          builder: (ctx, setInner) => InputDecorator(
            decoration: const InputDecoration(
              labelText: 'State',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: data.state.isEmpty ? null : data.state,
                isExpanded: true,
                isDense: true,
                hint: Text(
                  'Select State',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppTheme.textMuted,
                  ),
                ),
                items: _states
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
                onChanged: (v) {
                  if (v != null) {
                    setState(() => data.state = v);
                  }
                },
                icon: const Icon(Icons.expand_more_rounded, size: 16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Country dropdown
        StatefulBuilder(
          builder: (ctx, setInner) => InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Country',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: data.country.isEmpty ? null : data.country,
                isExpanded: true,
                isDense: true,
                items: _countries
                    .map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Text(
                          c,
                          style: GoogleFonts.plusJakartaSans(fontSize: 13),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() => data.country = v);
                  }
                },
                icon: const Icon(Icons.expand_more_rounded, size: 16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Open in Maps
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.map_outlined, size: 16),
          label: const Text('Open in Maps'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.primary,
            side: BorderSide(color: AppTheme.primary.withAlpha(100)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddressTypeHeader extends StatelessWidget {
  final String label;
  final IconData icon;

  const _AddressTypeHeader({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppTheme.primary,
          ),
        ),
      ],
    );
  }
}
