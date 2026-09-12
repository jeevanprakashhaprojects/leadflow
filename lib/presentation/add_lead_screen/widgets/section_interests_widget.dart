import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/empty_state_widget.dart';

// ─── Interest Card Model ──────────────────────────────────────────────────────

class _InterestCard {
  final String industry;
  int activeTab = 0;
  _InterestCard({required this.industry});
}

// ─── Reusable Field Builders ──────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  final bool required;
  const _FieldLabel(this.text, {this.required = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          if (required)
            Text(
              ' *',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppTheme.error,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}

Widget _buildDropdownField(
  String label,
  List<String> options, {
  String? value,
  ValueChanged<String?>? onChanged,
  bool required = false,
}) {
  return Builder(
    builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel(label, required: required),
          InputDecorator(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppTheme.surface200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppTheme.surface200),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                isDense: true,
                hint: Text(
                  'Select',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppTheme.textMuted,
                  ),
                ),
                items: options
                    .map(
                      (o) => DropdownMenuItem(
                        value: o,
                        child: Text(
                          o,
                          style: GoogleFonts.plusJakartaSans(fontSize: 13),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
                icon: const Icon(Icons.expand_more_rounded, size: 16),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      );
    },
  );
}

Widget _buildTextField(
  String label, {
  int maxLines = 1,
  bool required = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _FieldLabel(label, required: required),
      TextFormField(
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: 'Enter $label',
          hintStyle: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: AppTheme.textMuted,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppTheme.surface200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppTheme.surface200),
          ),
        ),
        style: GoogleFonts.plusJakartaSans(fontSize: 13),
      ),
      const SizedBox(height: 12),
    ],
  );
}

// ─── Accordion Section ────────────────────────────────────────────────────────

class _AccordionSection extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget content;
  final bool initiallyExpanded;

  const _AccordionSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.content,
    this.initiallyExpanded = false,
  });

  @override
  State<_AccordionSection> createState() => _AccordionSectionState();
}

class _AccordionSectionState extends State<_AccordionSection> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: widget.color.withAlpha(30),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(widget.icon, size: 16, color: widget.color),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
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
            child: _expanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        widget.content,
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

// ─── Universal Fields ─────────────────────────────────────────────────────────

class _UniversalFieldsSection extends StatefulWidget {
  const _UniversalFieldsSection();

  @override
  State<_UniversalFieldsSection> createState() =>
      _UniversalFieldsSectionState();
}

class _UniversalFieldsSectionState extends State<_UniversalFieldsSection> {
  String? _priority;
  String? _readiness;
  String? _source;
  String? _timeline;
  String? _commPref;
  String? _crossSell;
  String? _upsell;
  String? _replacement;
  final List<String> _documents = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdownFieldStateful(
          'Interest Priority',
          ['High', 'Medium', 'Low'],
          _priority,
          (v) => setState(() => _priority = v),
        ),
        _buildDropdownFieldStateful(
          'Customer Readiness',
          [
            'Just Exploring',
            'Researching',
            'Ready to Buy',
            'Comparing Options',
            'Decision Made',
          ],
          _readiness,
          (v) => setState(() => _readiness = v),
        ),
        _buildDropdownFieldStateful(
          'Interest Source',
          [
            'Customer mentioned',
            'Agent suggested',
            'Referral',
            'Campaign',
            'Cross-sell from existing policy',
            'Website enquiry',
          ],
          _source,
          (v) => setState(() => _source = v),
        ),
        _buildDropdownFieldStateful(
          'Estimated Closing Timeline',
          [
            'This Week',
            'This Month',
            '1-3 Months',
            '3-6 Months',
            '6-12 Months',
            'No timeline',
          ],
          _timeline,
          (v) => setState(() => _timeline = v),
        ),
        _buildTextField('Agent Commission Preference'),
        _buildDropdownFieldStateful(
          'Preferred Communication for This Interest',
          ['Phone Call', 'WhatsApp', 'Email', 'SMS', 'In-Person Visit'],
          _commPref,
          (v) => setState(() => _commPref = v),
        ),
        _buildDropdownFieldStateful(
          'Documents Required',
          [
            'Aadhaar',
            'PAN',
            'Income Proof',
            'Address Proof',
            'Medical Reports',
            'Vehicle RC',
            'Property Papers',
            'None identified',
          ],
          null,
          null,
        ),
        _buildDropdownFieldStateful(
          'Cross-sell Opportunity',
          ['Yes', 'No'],
          _crossSell,
          (v) => setState(() => _crossSell = v),
        ),
        if (_crossSell == 'Yes')
          _buildTextField('Link Existing Policy/Lead (Cross-sell)'),
        _buildDropdownFieldStateful(
          'Upsell Opportunity',
          ['Yes', 'No'],
          _upsell,
          (v) => setState(() => _upsell = v),
        ),
        if (_upsell == 'Yes')
          _buildTextField('Link Existing Policy/Lead (Upsell)'),
        _buildDropdownFieldStateful(
          'Replacement Flag',
          ['Yes', 'No', 'Exploring'],
          _replacement,
          (v) => setState(() => _replacement = v),
        ),
        if (_replacement == 'Yes') ...[
          _buildTextField('Existing Insurer'),
          _buildTextField('Existing Policy Number'),
          _buildTextField('Reason for Switching'),
        ],
      ],
    );
  }

  Widget _buildTextField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Enter $label',
            hintStyle: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppTheme.textMuted,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.surface200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.surface200),
            ),
          ),
          style: GoogleFonts.plusJakartaSans(fontSize: 13),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildDropdownFieldStateful(
    String label,
    List<String> options,
    String? value,
    ValueChanged<String?>? onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        InputDecorator(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.surface200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.surface200),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              isDense: true,
              hint: Text(
                'Select',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppTheme.textMuted,
                ),
              ),
              items: options
                  .map(
                    (o) => DropdownMenuItem(
                      value: o,
                      child: Text(
                        o,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
              icon: const Icon(Icons.expand_more_rounded, size: 16),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

// ─── Agent Activity & Competitive Intelligence ────────────────────────────────

Widget _buildAgentActivitySection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Date of First Discussion'),
      _buildTextField('Number of Discussions Had'),
      _buildTextField('Next Scheduled Follow-up Date'),
      _buildDropdownField('Next Follow-up Mode', [
        'Call',
        'Visit',
        'WhatsApp',
        'Email',
      ]),
      _buildDropdownField('Customer Responsiveness', [
        'Very responsive',
        'Moderately responsive',
        'Slow',
        'Not responding',
      ]),
      _buildDropdownField('Interest Temperature', [
        'Hot',
        'Warm',
        'Cold',
        'Ice cold',
      ]),
    ],
  );
}

Widget _buildCompetitiveSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Competitor Products Customer is Comparing'),
      _buildDropdownField('Competitor Pricing Known?', ['Yes', 'No']),
      _buildTextField('Our Competitive Advantage Discussed'),
      _buildTextField('Customer Concern About Our Product'),
      _buildDropdownField('Competitor Being Preferred?', [
        'Yes',
        'No',
        'Equal',
      ]),
    ],
  );
}

Widget _buildFinancialQualificationSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Annual Income'),
      _buildDropdownField('Income Stability', [
        'Stable',
        'Fluctuating',
        'Seasonal',
      ]),
      _buildDropdownField('Credit Awareness', ['High', 'Medium', 'Low']),
      _buildTextField('Existing EMI Burden (₹/month)'),
      _buildDropdownField('Budget Flexibility', [
        'Fixed',
        'Somewhat flexible',
        'Very flexible',
      ]),
      _buildTextField('Down Payment Available (₹)'),
    ],
  );
}

Widget _buildDecisionProcessSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Number of Decision Makers Involved'),
      _buildTextField('Decision Maker Names and Roles'),
      _buildDropdownField('Decision Timeline Confirmed?', [
        'Yes',
        'Approximate',
        'No idea',
      ]),
      _buildTextField('Approval Hierarchy'),
      _buildDropdownField('Budget Approved?', ['Yes', 'Partially', 'Not yet']),
      _buildDropdownField('Final Decision Maker Confirmed?', [
        'Yes',
        'Not sure',
      ]),
    ],
  );
}

Widget _buildAfterSalesSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildDropdownField('Service Expectation Level', [
        'High',
        'Medium',
        'Low',
      ]),
      _buildDropdownField('Claim Expectation Awareness', [
        'Well informed',
        'Somewhat aware',
        'Not aware',
      ]),
      _buildDropdownField('Renewal Reminder Preference', [
        '30 days before',
        '15 days before',
        'SMS',
        'Call',
      ]),
      _buildDropdownField('Loyalty Program Interest', [
        'Yes',
        'No',
        'Not Sure',
      ]),
    ],
  );
}

// ─── Industry-Specific Field Sections ────────────────────────────────────────

Widget _buildLifeInsuranceFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Product Name'),
      _buildTextField('Sum Assured (₹)'),
      _buildTextField('Premium Amount (₹/year)'),
      _buildTextField('Policy Term (years)'),
      _buildTextField('Existing Life Cover Amount (₹)'),
      _buildTextField('Number of Dependent Family Members'),
      _buildDropdownField('Any Existing Critical Illness Cover?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildDropdownField('Any Existing Accidental Cover?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildDropdownField('Preferred Insurer Interaction Mode', [
        'Online only',
        'Agent-assisted',
        'Branch visit',
      ]),
      _buildDropdownField('Medical Test Preference', [
        'At home',
        'At hospital',
        'Already done',
        'Not required',
      ]),
      _buildDropdownField('Policy Document Delivery Preference', [
        'Digital',
        'Physical',
        'Both',
      ]),
      _buildTextField('Annual Premium as % of Income'),
      _buildTextField('Previous Policy Surrender Value (₹)'),
      _buildTextField('Previous Policy Loan Outstanding (₹)'),
      _buildTextField('Trustee Name (if for child)'),
      _buildTextField('Trustee Age'),
      _buildTextField('Trustee Relation'),
      _buildTextField('Nominee Name'),
      _buildTextField('Nominee Relation'),
      _buildTextField('Nominee Share (%)'),
    ],
  );
}

Widget _buildHealthInsuranceFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Product Name'),
      _buildTextField('Sum Insured (₹)'),
      _buildTextField('Premium Amount (₹/year)'),
      _buildTextField('Existing Health Cover Amount (₹)'),
      _buildTextField('Family Members to be Covered (count + names)'),
      _buildDropdownField('Any Pre-existing Diseases Declared?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildDropdownField('Waiting Period Acceptable?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildDropdownField('Maternity Cover Needed For?', [
        'Self',
        'Spouse',
        'Daughter',
        'Not needed',
      ]),
      _buildDropdownField('Day Care Treatments Covered Previously?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildDropdownField('Ambulance Cover Required?', ['Yes', 'No']),
      _buildDropdownField('Ayush Treatment Required?', ['Yes', 'No']),
      _buildDropdownField('Organ Donor Expenses Covered?', ['Yes', 'No']),
      _buildDropdownField('Restore Benefit Required?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildDropdownField('No Claim Bonus Expected?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildTextField('Preferred Network Hospitals'),
      _buildDropdownField('Co-pay Acceptable Percentage', [
        '0%',
        '10%',
        '20%',
        '30%',
        'Not acceptable',
      ]),
      _buildDropdownField('Top-up Plan Required?', ['Yes', 'No']),
      _buildDropdownField('Parental Health Cover Needed?', [
        'Yes',
        'No',
        'Only one',
        'Both',
      ]),
    ],
  );
}

Widget _buildMotorInsuranceFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Vehicle Make & Model'),
      _buildTextField('Vehicle Year'),
      _buildTextField('Registration Number'),
      _buildDropdownField('Vehicle Type', [
        'Two Wheeler',
        'Four Wheeler',
        'Commercial',
      ]),
      _buildDropdownField('Insurance Type', [
        'Comprehensive',
        'Third Party',
        'Own Damage',
      ]),
      _buildTextField('IDV Value (₹)'),
      _buildTextField('Previous Claim Amount (₹)'),
      _buildTextField('Previous Claim Details'),
      _buildDropdownField('Vehicle Modification Done?', ['Yes', 'No']),
      _buildTextField('Modification Description (if any)'),
      _buildDropdownField('Hypothecation / Loan on Vehicle?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildTextField('Financier Name'),
      _buildTextField('Previous Insurer Claim Settlement Rating'),
      _buildDropdownField('Roadside Assistance Required?', [
        'Yes',
        'No',
        'Already have',
      ]),
      _buildDropdownField('Garage Preference', [
        'Authorized',
        'Any networked',
        'Specific garage',
      ]),
      _buildTextField('Previous Policy Discount %'),
      _buildDropdownField('Transfer of NCB from Previous Vehicle?', [
        'Yes',
        'No',
        'Not Applicable',
      ]),
    ],
  );
}

Widget _buildHomeInsuranceFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Property Address'),
      _buildDropdownField('Property Type', [
        'Apartment',
        'Independent House',
        'Villa',
        'Commercial',
      ]),
      _buildTextField('Property Value (₹)'),
      _buildTextField('Built-up Area (sq ft)'),
      _buildTextField('Previous Home Insurance Claim History'),
      _buildTextField('Claim Amount (₹)'),
      _buildDropdownField('Security System Installed?', ['Yes', 'No']),
      _buildDropdownField('Smoke Detectors Installed?', ['Yes', 'No']),
      _buildDropdownField('Fire Extinguishers Available?', ['Yes', 'No']),
      _buildDropdownField('CCTV Installed?', ['Yes', 'No']),
      _buildTextField('Nearby Fire Station Distance (km)'),
      _buildTextField('Nearby Hospital Distance (km)'),
      _buildDropdownField('Building Approval from Local Authority?', [
        'Yes',
        'No',
        'Pending',
      ]),
      _buildDropdownField('Property Tax Up to Date?', ['Yes', 'No']),
      _buildDropdownField('Flood Zone Area?', ['Yes', 'No', 'Not Sure']),
      _buildDropdownField('Earthquake Zone Area?', ['Yes', 'No', 'Not Sure']),
    ],
  );
}

Widget _buildTravelInsuranceFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Destination Country/Countries'),
      _buildTextField('Travel Start Date'),
      _buildTextField('Travel End Date'),
      _buildTextField('Number of Travellers'),
      _buildDropdownField('Travel Purpose', [
        'Leisure',
        'Business',
        'Education',
        'Medical',
        'Other',
      ]),
      _buildTextField('Pre-existing Medical Conditions'),
      _buildTextField('Medical Condition Stability Period'),
      _buildTextField('Luggage Value Estimate (₹)'),
      _buildDropdownField('Flight Booking Status', [
        'Booked',
        'Planning',
        'Not booked',
      ]),
      _buildDropdownField('Hotel Booking Status', [
        'Booked',
        'Planning',
        'Not booked',
      ]),
      _buildDropdownField('Traveller Occupation', [
        'Student',
        'Professional',
        'Business',
        'Retired',
        'Others',
      ]),
      _buildDropdownField('Travel Agent Used?', ['Yes', 'No']),
      _buildTextField('Travel Agent Name (if any)'),
      _buildTextField('Trip Cost Estimate (₹)'),
    ],
  );
}

Widget _buildRealEstateFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildDropdownField('Property Type', [
        'Residential',
        'Commercial',
        'Plot',
        'Agricultural',
      ]),
      _buildDropdownField('Transaction Type', ['Buy', 'Sell', 'Rent', 'Lease']),
      _buildTextField('Budget Range (₹)'),
      _buildTextField('Preferred Location'),
      _buildTextField('Required Area (sq ft)'),
      _buildDropdownField('BHK Requirement', [
        '1 BHK',
        '2 BHK',
        '3 BHK',
        '4 BHK',
        '4+ BHK',
        'Studio',
        'Villa',
      ]),
      _buildDropdownField('Property Visit Done?', ['Yes', 'No']),
      _buildTextField('Property Visited Locations'),
      _buildTextField('Builder Reputation Rating'),
      _buildTextField('Construction Quality Feedback'),
      _buildDropdownField('Legal Verification Status', [
        'Verified',
        'Pending',
        'Not checked',
      ]),
      _buildDropdownField('Encumbrance Certificate Checked?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildTextField('Approved Plan Number'),
      _buildDropdownField('Occupancy Certificate Status', [
        'Received',
        'Pending',
        'Not applicable',
      ]),
      _buildTextField('Brokerage Expectation'),
      _buildTextField('Agent Commission Preference'),
      _buildDropdownField('Price Negotiation Flexibility', [
        'Firm',
        '5% negotiable',
        '10% negotiable',
        'More than 10%',
      ]),
      _buildTextField('Registration Cost Expectation'),
      _buildDropdownField('Stamp Duty Awareness', [
        'Aware',
        'Needs explanation',
      ]),
      _buildTextField('Current Rent Amount (₹)'),
      _buildTextField('Notice Period in Current Place (months)'),
      _buildDropdownField('School/College Proximity Required?', ['Yes', 'No']),
      _buildDropdownField('Hospital Proximity Required?', ['Yes', 'No']),
      _buildDropdownField('Public Transport Access Required?', ['Yes', 'No']),
      _buildDropdownField('Vastu Preference', ['Yes', 'No', 'Not important']),
      _buildDropdownField('Pet-friendly Required?', ['Yes', 'No']),
      _buildDropdownField('Gated Community Preference', [
        'Yes',
        'No',
        'Preferred',
      ]),
      _buildTextField('Floor Preference Specific'),
      _buildDropdownField('Parking Type Preference', [
        'Covered',
        'Open',
        'Both',
        'Not needed',
      ]),
      _buildDropdownField('Visitor Parking Available?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
    ],
  );
}

Widget _buildEducationFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Course/Program of Interest'),
      _buildTextField('Institution Name'),
      _buildDropdownField('Education Level', [
        'School',
        'Undergraduate',
        'Postgraduate',
        'Diploma',
        'Certificate',
        'PhD',
      ]),
      _buildTextField('Student Name'),
      _buildTextField('Student Age'),
      _buildTextField('Previous Academic Performance'),
      _buildDropdownField('Learning Difficulty or Special Needs?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildTextField('Special Needs Description (if any)'),
      _buildDropdownField('Preferred Learning Mode', [
        'In-person',
        'Online',
        'Hybrid',
        'Not sure',
      ]),
      _buildTextField('Board Preference'),
      _buildDropdownField('Distance from Home Preferred?', [
        'Same city',
        'Within state',
        'Out of state',
        'Abroad',
      ]),
      _buildTextField('Coaching Center Preference'),
      _buildDropdownField('Previous Coaching Attended?', ['Yes', 'No']),
      _buildTextField('Previous Coaching Name and Rating'),
      _buildDropdownField('Scholarship or Financial Aid Needed?', [
        'Yes',
        'No',
        'Already applied',
      ]),
      _buildTextField('Career Aspiration After Course'),
      _buildTextField('Parent/Guardian Income Range'),
      _buildDropdownField('Sibling Studying?', ['Yes', 'No']),
      _buildTextField('Sibling Institution (if any)'),
      _buildTextField('Reservation Category (SC/ST/OBC/EWS/General)'),
      _buildDropdownField('Sports Quota Applicable?', ['Yes', 'No']),
      _buildTextField('Hostel Food Preference'),
      _buildDropdownField('Transport Required?', ['Yes', 'No']),
      _buildDropdownField('Hostel Mess Food Preference', [
        'Veg',
        'Non-veg',
        'Both',
      ]),
      _buildDropdownField('Local Guardian Available?', ['Yes', 'No']),
      _buildTextField('Transport from Hostel to College'),
      _buildDropdownField('Attendance Requirement Awareness', [
        'Yes',
        'No',
        'Not sure',
      ]),
      _buildTextField('Previous Coaching Institute Attended'),
      _buildDropdownField('Study Material Preference', [
        'Hard copy',
        'Digital',
        'Both',
      ]),
      _buildDropdownField('Doubt-clearing Session Required?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildTextField('Parent Occupation'),
      _buildTextField('Family Annual Income'),
      _buildTextField('Community or Caste Certificate'),
      _buildDropdownField('Migration Certificate Needed?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildDropdownField('Transfer Certificate Needed?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
    ],
  );
}

Widget _buildSoftwareITFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Product/Service of Interest'),
      _buildTextField('Company Size (employees)'),
      _buildTextField('Current System or Process Being Replaced'),
      _buildTextField('Current System Pain Points'),
      _buildDropdownField('Data Migration Required?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildTextField('Number of Existing Users'),
      _buildDropdownField('Training Required for Team?', ['Yes', 'No']),
      _buildTextField('Training Count (if required)'),
      _buildDropdownField('Training Mode Preference', [
        'On-site',
        'Online',
        'Recorded videos',
      ]),
      _buildDropdownField('Support Hours Required', [
        'Business hours',
        '24x7',
        'On-call only',
      ]),
      _buildTextField('SLA Required for Support'),
      _buildTextField('Data Security Requirements'),
      _buildTextField('Third-party Vendor Integrations Needed'),
      _buildDropdownField('API Integration Required?', ['Yes', 'No']),
      _buildDropdownField('Mobile App Required?', ['Yes', 'No', 'Maybe']),
      _buildDropdownField('Offline Functionality Required?', ['Yes', 'No']),
      _buildDropdownField('Multi-language Support Required?', ['Yes', 'No']),
      _buildTextField('Languages Required (if any)'),
      _buildDropdownField('Accessibility Compliance Needed?', ['Yes', 'No']),
      _buildTextField('Current Hosting Environment'),
      _buildDropdownField('License Preference', [
        'Open source',
        'Commercial',
        'SaaS',
        'Not sure',
      ]),
      _buildDropdownField('Implementation Timeline Urgency', [
        'ASAP',
        'This quarter',
        'Next quarter',
        'Flexible',
      ]),
    ],
  );
}

Widget _buildHealthcareFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Healthcare Service of Interest'),
      _buildDropdownField('Health Insurance Currently Held?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildTextField('Current Insurer Name'),
      _buildTextField('Current Sum Insured (₹)'),
      _buildDropdownField('Employer Health Cover Available?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildTextField('Employer Cover Amount (₹)'),
      _buildTextField('Regular Medications'),
      _buildDropdownField('Recent Medical Reports Available?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildTextField('Preferred Hospital Network'),
      _buildDropdownField('Cashless Preferred?', ['Yes', 'No', 'Both']),
      _buildDropdownField('Reimbursement Preferred?', ['Yes', 'No', 'Both']),
      _buildDropdownField('Second Opinion Needed?', ['Yes', 'No']),
      _buildDropdownField('Telemedicine Acceptable?', [
        'Yes',
        'No',
        'Sometimes',
      ]),
      _buildTextField('Mental Health History'),
      _buildDropdownField('Disability or Physical Limitation?', ['Yes', 'No']),
      _buildTextField('Disability Description (if any)'),
      _buildDropdownField('Pregnancy Planning?', ['Yes', 'No', 'Not Sure']),
      _buildDropdownField('Recent Surgery in Last 2 Years?', ['Yes', 'No']),
      _buildTextField('Family Doctor Reference'),
      _buildTextField('Blood Group'),
      _buildTextField('Known Allergies'),
      _buildTextField('Vaccination Status'),
    ],
  );
}

Widget _buildAutomotiveFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildDropdownField('Vehicle Category', [
        'Two Wheeler',
        'Hatchback',
        'Sedan',
        'SUV',
        'MUV',
        'Luxury',
        'Commercial',
        'EV',
      ]),
      _buildTextField('Preferred Brand'),
      _buildTextField('Budget Range (₹)'),
      _buildDropdownField('Fuel Type', [
        'Petrol',
        'Diesel',
        'CNG',
        'Electric',
        'Hybrid',
      ]),
      _buildDropdownField('Usage Purpose', [
        'Personal',
        'Commercial',
        'Family',
        'Off-road',
      ]),
      _buildDropdownField('Test Drive Already Done?', ['Yes', 'No']),
      _buildTextField('Test Drive Vehicles (if done)'),
      _buildDropdownField('Color Variant Availability Confirmed?', [
        'Yes',
        'No',
        'Not checked',
      ]),
      _buildDropdownField('Insurance from Dealer Preferred?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildDropdownField('Extended Warranty Required?', [
        'Yes',
        'No',
        'Not Sure',
      ]),
      _buildDropdownField('Service Package Preference', [
        'Standard',
        'Extended',
        'Not Sure',
      ]),
      _buildDropdownField('Exchange Vehicle Valuation Done?', ['Yes', 'No']),
      _buildDropdownField('RC Transfer Assistance Needed?', ['Yes', 'No']),
      _buildDropdownField('Financing Pre-approval Status', [
        'Approved',
        'Applied',
        'Not started',
        'Self-funded',
      ]),
      _buildTextField('Fuel Type Switching Reason'),
      _buildTextField('Driving Experience (years)'),
      _buildTextField('Previous Vehicle Brand Loyalty'),
      _buildTextField('Accessories Budget (₹)'),
      _buildTextField('Number Plate Preference'),
    ],
  );
}

Widget _buildFinancialServicesFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildDropdownField('Service Type', [
        'Loan',
        'Investment',
        'Insurance',
        'Mutual Fund',
        'Fixed Deposit',
        'Credit Card',
        'Wealth Management',
      ]),
      _buildTextField('Amount Required (₹)'),
      _buildTextField('Current Bank Relationship'),
      _buildTextField('Existing Credit Card Usage Pattern'),
      _buildTextField('Previous Loan Repayment History'),
      _buildDropdownField('Guarantor Available?', ['Yes', 'No', 'Not sure']),
      _buildDropdownField('Collateral Available?', [
        'Yes',
        'No',
        'Not applicable',
      ]),
      _buildDropdownField('Tax Filing Status', [
        'Regular filer',
        'First time',
        'Non-filer',
      ]),
      _buildDropdownField('ITR Available?', ['Yes', 'No', 'Not Sure']),
      _buildDropdownField('Bank Statements Available?', [
        'Last 3 months',
        'Last 6 months',
        'Not ready',
      ]),
      _buildDropdownField('Previous Investment Experience', [
        'Beginner',
        'Some experience',
        'Experienced',
        'First time',
      ]),
      _buildTextField('Investment Objective'),
      _buildDropdownField('Liquidity Need', [
        'Immediate',
        '1-3 months',
        '6 months',
        'No urgency',
      ]),
      _buildDropdownField('Emergency Fund Already Created?', [
        'Yes',
        'No',
        'In progress',
      ]),
      _buildDropdownField('Insurance Coverage Existing?', [
        'Yes',
        'No',
        'Partial',
      ]),
      _buildDropdownField('Will or Estate Planning Done?', [
        'Yes',
        'No',
        'Considering',
      ]),
    ],
  );
}

Widget _buildRetailFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Product Category of Interest'),
      _buildTextField('Specific Product Name'),
      _buildTextField('Budget (₹)'),
      _buildDropdownField('Preferred Store or Marketplace', [
        'Brand store',
        'Amazon',
        'Flipkart',
        'Myntra',
        'Local store',
        'Any',
      ]),
      _buildTextField('Membership or Loyalty Program'),
      _buildDropdownField('Exchange or Trade-in Available?', ['Yes', 'No']),
      _buildDropdownField('Gift Purchase?', ['Yes', 'No', 'Not Sure']),
      _buildDropdownField('Delivery Address Type', [
        'Home',
        'Office',
        'Gift address',
      ]),
      _buildDropdownField('Delivery Time Preference', [
        'Morning',
        'Afternoon',
        'Evening',
        'Anytime',
      ]),
      _buildDropdownField('Installation Required?', ['Yes', 'No', 'Not Sure']),
      _buildDropdownField('Warranty Preference', [
        'Standard',
        'Extended',
        'Not important',
      ]),
      _buildTextField('Return Reason (if replacing)'),
      _buildTextField('Previous Purchase Experience with Brand'),
      _buildDropdownField('EMI Card Available?', ['Yes', 'No', 'Not Sure']),
      _buildDropdownField('Discount Coupon Available?', ['Yes', 'No']),
    ],
  );
}

Widget _buildHospitalityFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildDropdownField('Service Type', [
        'Hotel Stay',
        'Restaurant',
        'Event Venue',
        'Catering',
        'Travel Package',
      ]),
      _buildTextField('Check-in Date'),
      _buildTextField('Check-out Date'),
      _buildTextField('Number of Guests'),
      _buildDropdownField('Room Type', [
        'Standard',
        'Deluxe',
        'Suite',
        'Presidential Suite',
      ]),
      _buildDropdownField('Meal Preference', [
        'Veg',
        'Non-veg',
        'Vegan',
        'Jain',
        'Others',
      ]),
      _buildDropdownField('Accessibility Requirement', [
        'None',
        'Wheelchair',
        'Ground floor only',
        'Others',
      ]),
      _buildDropdownField('Special Occasion Celebration', [
        'Birthday',
        'Anniversary',
        'Honeymoon',
        'Corporate',
        'Others',
      ]),
      _buildDropdownField('Early Check-in Required?', ['Yes', 'No']),
      _buildDropdownField('Late Check-out Required?', ['Yes', 'No']),
      _buildDropdownField('Extra Bed Required?', ['Yes', 'No']),
      _buildTextField('Extra Bed Count'),
      _buildDropdownField('Smoking Preference', [
        'Smoking',
        'Non-smoking',
        'Either',
      ]),
      _buildTextField('Floor Preference'),
      _buildDropdownField('Connecting Rooms Needed?', ['Yes', 'No']),
      _buildTextField('Event Decoration Preference'),
      _buildDropdownField('Photographer Required?', ['Yes', 'No']),
      _buildDropdownField('Transportation from Airport Required?', [
        'Yes',
        'No',
        'Own arrangement',
      ]),
      _buildDropdownField('Previous Stay with Same Hotel Chain?', [
        'Yes',
        'No',
      ]),
    ],
  );
}

Widget _buildConsultingB2BFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Service of Interest'),
      _buildTextField('Company Name'),
      _buildTextField('Industry Sector'),
      _buildTextField('Annual Revenue Range'),
      _buildTextField('Current Vendor Contract Expiry Date'),
      _buildDropdownField('Budget Approved by Management?', [
        'Yes',
        'Pending approval',
        'Not yet presented',
      ]),
      _buildDropdownField('Board or Committee Approval Needed?', ['Yes', 'No']),
      _buildDropdownField('RFQ or RFP Process?', ['Yes', 'No', 'Not sure']),
      _buildDropdownField('NDA Required Before Discussion?', ['Yes', 'No']),
      _buildDropdownField('Site Visit Required?', ['Yes', 'No']),
      _buildDropdownField('Pilot Project Acceptable?', ['Yes', 'No']),
      _buildDropdownField('Reference Client Request?', [
        'Yes',
        'No',
        'Not expected',
      ]),
      _buildTextField('Case Study or White Label Interest'),
      _buildDropdownField('IP Rights Concern?', [
        'Yes',
        'No',
        'To be discussed',
      ]),
      _buildTextField('Data Residency Requirement'),
      _buildTextField('Compliance or Audit Requirement'),
      _buildDropdownField('On-site Resource Required?', ['Yes', 'No']),
      _buildDropdownField('Knowledge Transfer Required?', ['Yes', 'No']),
      _buildTextField('Post-project Support Expectation'),
    ],
  );
}

Widget _buildAgricultureFields() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField('Land Area (acres/hectares)'),
      _buildDropdownField('Land Type', ['Owned', 'Leased', 'Shared']),
      _buildTextField('Soil Type'),
      _buildDropdownField('Irrigation Method', [
        'Canal',
        'Borewell',
        'Rain-fed',
        'Drip',
        'Sprinkler',
      ]),
      _buildTextField('Current Crop'),
      _buildTextField('Previous Yield'),
      _buildDropdownField('Crop Insurance Currently Held?', ['Yes', 'No']),
      _buildTextField('Equipment Owned'),
      _buildTextField('Livestock Count'),
      _buildDropdownField('Organic Farming?', ['Yes', 'No', 'Converting']),
      _buildTextField('Market Access (nearest mandi distance)'),
      _buildDropdownField('Storage Facility Available?', ['Yes', 'No']),
      _buildDropdownField('Loan for Agriculture Needed?', ['Yes', 'No']),
      _buildDropdownField('Kisan Credit Card?', ['Yes', 'No']),
    ],
  );
}

// ─── Interest Content Builder ─────────────────────────────────────────────────

Widget _buildInterestContent(String industry) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Universal fields always at top
        _AccordionSection(
          title: 'Universal Fields',
          icon: Icons.tune_rounded,
          color: AppTheme.primary,
          content: const _UniversalFieldsSection(),
          initiallyExpanded: true,
        ),
        // Industry-specific fields
        _AccordionSection(
          title: _getIndustryTitle(industry),
          icon: _getIndustryIcon(industry),
          color: _getIndustryColor(industry),
          content: _getIndustryFields(industry),
          initiallyExpanded: true,
        ),
        // Agent Activity Tracking
        _AccordionSection(
          title: 'Agent Activity Tracking',
          icon: Icons.track_changes_rounded,
          color: const Color(0xFF0891B2),
          content: _buildAgentActivitySection(),
        ),
        // Competitive Intelligence
        _AccordionSection(
          title: 'Competitive Intelligence',
          icon: Icons.compare_arrows_rounded,
          color: const Color(0xFFD97706),
          content: _buildCompetitiveSection(),
        ),
        // Financial Qualification
        _AccordionSection(
          title: 'Financial Qualification',
          icon: Icons.account_balance_rounded,
          color: AppTheme.success,
          content: _buildFinancialQualificationSection(),
        ),
        // Decision Process
        _AccordionSection(
          title: 'Decision Process',
          icon: Icons.how_to_vote_rounded,
          color: const Color(0xFF7C3AED),
          content: _buildDecisionProcessSection(),
        ),
        // After-Sales Expectations
        _AccordionSection(
          title: 'After-Sales Expectations',
          icon: Icons.support_agent_rounded,
          color: const Color(0xFFE91E63),
          content: _buildAfterSalesSection(),
        ),
      ],
    ),
  );
}

String _getIndustryTitle(String industry) {
  switch (industry) {
    case 'Life Insurance':
      return 'Life Insurance Details';
    case 'Health Insurance':
      return 'Health Insurance Details';
    case 'Motor Insurance':
      return 'Motor Insurance Details';
    case 'Home Insurance':
      return 'Home Insurance Details';
    case 'Travel Insurance':
      return 'Travel Insurance Details';
    case 'Real Estate':
      return 'Real Estate Details';
    case 'Education':
      return 'Education Details';
    case 'Software / IT':
      return 'Software / IT Details';
    case 'Healthcare':
      return 'Healthcare Details';
    case 'Automotive':
      return 'Automotive Details';
    case 'Financial Services':
      return 'Financial Services Details';
    case 'Retail':
      return 'Retail / E-commerce Details';
    case 'Hospitality':
      return 'Hospitality Details';
    case 'Consulting / B2B':
      return 'Consulting / B2B Details';
    case 'Agriculture':
      return 'Agriculture Details';
    default:
      return '$industry Details';
  }
}

IconData _getIndustryIcon(String industry) {
  switch (industry) {
    case 'Life Insurance':
      return Icons.favorite_rounded;
    case 'Health Insurance':
      return Icons.health_and_safety_rounded;
    case 'Motor Insurance':
      return Icons.directions_car_rounded;
    case 'Home Insurance':
      return Icons.home_rounded;
    case 'Travel Insurance':
      return Icons.flight_rounded;
    case 'Real Estate':
      return Icons.apartment_rounded;
    case 'Education':
      return Icons.school_rounded;
    case 'Software / IT':
      return Icons.computer_rounded;
    case 'Healthcare':
      return Icons.local_hospital_rounded;
    case 'Automotive':
      return Icons.car_repair_rounded;
    case 'Financial Services':
      return Icons.account_balance_wallet_rounded;
    case 'Retail':
      return Icons.shopping_bag_rounded;
    case 'Hospitality':
      return Icons.hotel_rounded;
    case 'Consulting / B2B':
      return Icons.business_center_rounded;
    case 'Agriculture':
      return Icons.grass_rounded;
    default:
      return Icons.category_rounded;
  }
}

Color _getIndustryColor(String industry) {
  switch (industry) {
    case 'Life Insurance':
      return const Color(0xFFE91E63);
    case 'Health Insurance':
      return const Color(0xFF4CAF50);
    case 'Motor Insurance':
      return const Color(0xFF2196F3);
    case 'Home Insurance':
      return const Color(0xFFFF9800);
    case 'Travel Insurance':
      return const Color(0xFF00BCD4);
    case 'Real Estate':
      return const Color(0xFF795548);
    case 'Education':
      return const Color(0xFF9C27B0);
    case 'Software / IT':
      return const Color(0xFF607D8B);
    case 'Healthcare':
      return const Color(0xFF009688);
    case 'Automotive':
      return const Color(0xFF3F51B5);
    case 'Financial Services':
      return const Color(0xFFFF5722);
    case 'Retail':
      return const Color(0xFFFF9800);
    case 'Hospitality':
      return const Color(0xFF8BC34A);
    case 'Consulting / B2B':
      return const Color(0xFF673AB7);
    case 'Agriculture':
      return const Color(0xFF4CAF50);
    default:
      return AppTheme.primary;
  }
}

Widget _getIndustryFields(String industry) {
  switch (industry) {
    case 'Life Insurance':
      return _buildLifeInsuranceFields();
    case 'Health Insurance':
      return _buildHealthInsuranceFields();
    case 'Motor Insurance':
      return _buildMotorInsuranceFields();
    case 'Home Insurance':
      return _buildHomeInsuranceFields();
    case 'Travel Insurance':
      return _buildTravelInsuranceFields();
    case 'Real Estate':
      return _buildRealEstateFields();
    case 'Education':
      return _buildEducationFields();
    case 'Software / IT':
      return _buildSoftwareITFields();
    case 'Healthcare':
      return _buildHealthcareFields();
    case 'Automotive':
      return _buildAutomotiveFields();
    case 'Financial Services':
      return _buildFinancialServicesFields();
    case 'Retail':
      return _buildRetailFields();
    case 'Hospitality':
      return _buildHospitalityFields();
    case 'Consulting / B2B':
      return _buildConsultingB2BFields();
    case 'Agriculture':
      return _buildAgricultureFields();
    default:
      return _buildTextField('Details');
  }
}

// ─── Main Section Interests Widget ───────────────────────────────────────────

class SectionInterestsWidget extends StatefulWidget {
  const SectionInterestsWidget({super.key});

  @override
  State<SectionInterestsWidget> createState() => _SectionInterestsWidgetState();
}

class _SectionInterestsWidgetState extends State<SectionInterestsWidget> {
  final List<_InterestCard> _interests = [];
  int _activeInterestIndex = 0;

  static const _allIndustries = [
    'Life Insurance',
    'Health Insurance',
    'Motor Insurance',
    'Home Insurance',
    'Travel Insurance',
    'Real Estate',
    'Education',
    'Software / IT',
    'Healthcare',
    'Automotive',
    'Financial Services',
    'Retail',
    'Hospitality',
    'Consulting / B2B',
    'Agriculture',
    'Mutual Funds',
    'Equity',
    'Fixed Deposits',
  ];

  static const _quickAddIndustries = [
    'Life Insurance',
    'Health Insurance',
    'Motor Insurance',
    'Real Estate',
    'Education',
    'Financial Services',
    'Automotive',
  ];

  void _addInterest(String industry) {
    setState(() {
      _interests.add(_InterestCard(industry: industry));
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

  void _showAddInterestSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
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
                'Select Industry',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                controller: scrollCtrl,
                itemCount: _allIndustries.length,
                itemBuilder: (_, i) {
                  final industry = _allIndustries[i];
                  return ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _getIndustryColor(industry).withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getIndustryIcon(industry),
                        size: 18,
                        color: _getIndustryColor(industry),
                      ),
                    ),
                    title: Text(
                      industry,
                      style: GoogleFonts.plusJakartaSans(fontSize: 14),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _addInterest(industry);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_interests.isEmpty) {
      return Column(
        children: [
          EmptyStateWidget(
            icon: Icons.star_outline_rounded,
            title: 'No interests added',
            subtitle: 'Add the lead\'s interests to personalise your pitch',
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
                    color: _getIndustryColor(industry).withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getIndustryColor(industry).withAlpha(77),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getIndustryIcon(industry),
                        size: 14,
                        color: _getIndustryColor(industry),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        industry,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getIndustryColor(industry),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _showAddInterestSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.surface100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.surface200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.add_rounded,
                    size: 16,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Browse All Industries',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Interest tabs
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(_interests.length, (i) {
                final isActive = i == _activeInterestIndex;
                final color = _getIndustryColor(_interests[i].industry);
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
                      color: isActive ? color : AppTheme.surface100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive ? color : AppTheme.surface200,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getIndustryIcon(_interests[i].industry),
                          size: 12,
                          color: isActive ? Colors.white : color,
                        ),
                        const SizedBox(width: 6),
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
              GestureDetector(
                onTap: _showAddInterestSheet,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surface100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.surface200),
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
        // Active interest content with accordion sections
        if (_interests.isNotEmpty)
          _buildInterestContent(_interests[_activeInterestIndex].industry),
      ],
    );
  }
}