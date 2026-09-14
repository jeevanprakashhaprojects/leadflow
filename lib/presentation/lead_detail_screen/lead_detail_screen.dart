import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import '../leads_list_screen/leads_list_screen.dart';

class LeadDetailScreen extends StatefulWidget {
  final LeadModel lead;
  const LeadDetailScreen({super.key, required this.lead});

  @override
  State<LeadDetailScreen> createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends State<LeadDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late LeadModel _lead;
  final List<Map<String, dynamic>> _notes = [];
  final List<Map<String, dynamic>> _voiceRecordings = [];
  final _noteController = TextEditingController();
  // Focus node to control cursor visibility
  final _noteFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _lead = widget.lead;
    _tabController = TabController(length: 3, vsync: this);
    // Do NOT pre-populate "Lead added to pipeline" note
  }

  @override
  void dispose() {
    _tabController.dispose();
    _noteController.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  Color get _priorityColor => AppTheme.priorityColor(_lead.priority);
  Color get _statusColor => AppTheme.leadStatusColor(_lead.status);

  String _formatValue(double value) {
    if (value >= 10000000) return '₹${(value / 10000000).toStringAsFixed(1)}Cr';
    if (value >= 100000) return '₹${(value / 100000).toStringAsFixed(1)}L';
    if (value >= 1000) return '₹${(value / 1000).toStringAsFixed(0)}K';
    return '₹${value.toStringAsFixed(0)}';
  }

  /// Format a relative time label from a DateTime
  String _relativeLabel(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final dateStr = '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    if (diff.inMinutes < 1) return 'Just now · $dateStr';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago · $dateStr';
    if (diff.inHours < 24) return '${diff.inHours}h ago · $dateStr';
    if (diff.inDays == 1) return 'Yesterday · $dateStr';
    if (diff.inDays < 7) return '${diff.inDays} days ago · $dateStr';
    if (diff.inDays < 30) {
      return '${(diff.inDays / 7).floor()} weeks ago · $dateStr';
    }
    if (diff.inDays < 365) {
      return '${(diff.inDays / 30).floor()} months ago · $dateStr';
    }
    return '${(diff.inDays / 365).floor()} years ago · $dateStr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Column(
        children: [
          _buildHeader(context),
          Container(
            color: AppTheme.primary,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withAlpha(150),
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 3,
              labelStyle: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Timeline'),
                Tab(text: 'Notes'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildTimelineTab(),
                _buildNotesTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildQuickActions(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, AppTheme.primary.withAlpha(220)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => context.go(AppRoutes.leadsListScreen),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.white),
                  onPressed: () => _editLead(context),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => _showMoreOptions(),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white.withAlpha(50),
                    child: Text(
                      _lead.name.isNotEmpty ? _lead.name[0].toUpperCase() : 'L',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _lead.name.isNotEmpty ? _lead.name : 'New Lead',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (_lead.phone.isNotEmpty)
                          Text(
                            _lead.phone,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: Colors.white.withAlpha(200),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Badges row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _HeaderBadge(label: _lead.status, color: _statusColor),
                  _HeaderBadge(label: _lead.priority, color: _priorityColor),
                  if (_lead.dealValue > 0)
                    _HeaderBadge(
                      label: _formatValue(_lead.dealValue),
                      color: Colors.white.withAlpha(100),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contact Information — only show filled fields
          _buildContactInfoCard(),
          // Business Details — only if filled
          _buildBusinessDetailsCard(),
          // Lead / Deal Information
          _buildDealInfoCard(),
          // Address — only if filled
          _buildAddressCard(),
          // Social — only if filled
          _buildSocialCard(),
          // Interests — only if filled
          _buildInterestsCard(),
          // Notes — only if filled
          _buildNotesPreviewCard(),
          // Tags
          if (_lead.tags.isNotEmpty) ...[
            const SizedBox(height: 16),
            _InfoCard(
              title: 'Tags',
              icon: Icons.label_outline_rounded,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: _lead.tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            tag,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ],
          // Pipeline stage
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Pipeline Stage',
            icon: Icons.account_tree_outlined,
            children: [_PipelineProgress(currentStatus: _lead.status)],
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildContactInfoCard() {
    final rows = <Widget>[];
    if (_lead.phone.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Phone',
          value: _lead.phone,
          icon: Icons.phone_outlined,
        ),
      );
    }
    if (_lead.email.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Email',
          value: _lead.email,
          icon: Icons.email_outlined,
        ),
      );
    }
    if (_lead.whatsapp != null && _lead.whatsapp!.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'WhatsApp',
          value: _lead.whatsapp!,
          icon: Icons.chat_rounded,
        ),
      );
    }
    // Additional contact fields from map
    final map = _lead.toMap();
    final altPhone = map['alternatePhone'] as String?;
    final altEmail = map['alternateEmail'] as String?;
    final dob = map['dateOfBirth'] as String?;
    final gender = map['gender'] as String?;
    final marital = map['maritalStatus'] as String?;
    final nationality = map['nationality'] as String?;
    final language = map['preferredLanguage'] as String?;
    if (altPhone != null && altPhone.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Alt Phone',
          value: altPhone,
          icon: Icons.phone_callback_outlined,
        ),
      );
    }
    if (altEmail != null && altEmail.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Alt Email',
          value: altEmail,
          icon: Icons.alternate_email_rounded,
        ),
      );
    }
    if (dob != null && dob.isNotEmpty) {
      rows.add(
        _InfoRow(label: 'Date of Birth', value: dob, icon: Icons.cake_outlined),
      );
    }
    if (gender != null && gender.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Gender',
          value: gender,
          icon: Icons.person_outline_rounded,
        ),
      );
    }
    if (marital != null && marital.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Marital Status',
          value: marital,
          icon: Icons.favorite_outline_rounded,
        ),
      );
    }
    if (nationality != null && nationality.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Nationality',
          value: nationality,
          icon: Icons.flag_outlined,
        ),
      );
    }
    if (language != null && language.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Language',
          value: language,
          icon: Icons.language_rounded,
        ),
      );
    }
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        _InfoCard(
          title: 'Contact Information',
          icon: Icons.person_outline_rounded,
          children: rows,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBusinessDetailsCard() {
    final rows = <Widget>[];
    if (_lead.company.isNotEmpty && _lead.company != 'New Company') {
      rows.add(
        _InfoRow(
          label: 'Company',
          value: _lead.company,
          icon: Icons.corporate_fare_rounded,
        ),
      );
    }
    if (_lead.industry.isNotEmpty && _lead.industry != 'General') {
      rows.add(
        _InfoRow(
          label: 'Industry',
          value: _lead.industry,
          icon: Icons.business_outlined,
        ),
      );
    }
    final map = _lead.toMap();
    final designation = map['designation'] as String?;
    final website = map['website'] as String?;
    final gst = map['gstNumber'] as String?;
    final pan = map['panNumber'] as String?;
    final annualRevenue = map['annualRevenue'] as String?;
    final employees = map['numberOfEmployees'] as String?;
    final businessType = map['businessType'] as String?;
    if (designation != null && designation.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Designation',
          value: designation,
          icon: Icons.badge_outlined,
        ),
      );
    }
    if (website != null && website.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Website',
          value: website,
          icon: Icons.language_rounded,
        ),
      );
    }
    if (gst != null && gst.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'GST No.',
          value: gst,
          icon: Icons.receipt_long_outlined,
        ),
      );
    }
    if (pan != null && pan.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'PAN No.',
          value: pan,
          icon: Icons.credit_card_outlined,
        ),
      );
    }
    if (annualRevenue != null && annualRevenue.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Annual Revenue',
          value: annualRevenue,
          icon: Icons.trending_up_rounded,
        ),
      );
    }
    if (employees != null && employees.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Employees',
          value: employees,
          icon: Icons.group_outlined,
        ),
      );
    }
    if (businessType != null && businessType.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Business Type',
          value: businessType,
          icon: Icons.store_outlined,
        ),
      );
    }
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        _InfoCard(
          title: 'Business Details',
          icon: Icons.business_outlined,
          children: rows,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDealInfoCard() {
    final rows = <Widget>[];
    if (_lead.status.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Status',
          value: _lead.status,
          icon: Icons.flag_outlined,
        ),
      );
    }
    if (_lead.priority.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Priority',
          value: _lead.priority,
          icon: Icons.priority_high_rounded,
        ),
      );
    }
    if (_lead.dealValue > 0) {
      rows.add(
        _InfoRow(
          label: 'Deal Value',
          value: _formatValue(_lead.dealValue),
          icon: Icons.currency_rupee_rounded,
        ),
      );
    }
    if (_lead.ownerName.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Owner',
          value: _lead.ownerName,
          icon: Icons.person_pin_outlined,
        ),
      );
    }
    final map = _lead.toMap();
    final source = _lead.source ?? map['source'] as String?;
    final campaign = _lead.campaign ?? map['campaign'] as String?;
    final tier = map['tier'] as String?;
    final score = _lead.score > 0 ? '${_lead.score}' : null;
    final expectedClose = map['expectedCloseDate'] as String?;
    final scheduledAction = map['scheduledAction'] as String?;
    final scheduledDate = map['scheduledActionDate'] as String?;
    if (source != null && source.isNotEmpty) {
      rows.add(
        _InfoRow(label: 'Source', value: source, icon: Icons.input_rounded),
      );
    }
    if (campaign != null && campaign.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Campaign',
          value: campaign,
          icon: Icons.campaign_outlined,
        ),
      );
    }
    if (tier != null && tier.isNotEmpty) {
      rows.add(
        _InfoRow(label: 'Tier', value: tier, icon: Icons.star_outline_rounded),
      );
    }
    if (score != null) {
      rows.add(
        _InfoRow(label: 'Score', value: score, icon: Icons.analytics_outlined),
      );
    }
    if (expectedClose != null && expectedClose.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Expected Close',
          value: expectedClose,
          icon: Icons.event_rounded,
        ),
      );
    }
    if (scheduledAction != null && scheduledAction.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Next Action',
          value: scheduledAction,
          icon: Icons.schedule_rounded,
        ),
      );
    }
    if (scheduledDate != null && scheduledDate.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Action Date',
          value: scheduledDate,
          icon: Icons.calendar_today_rounded,
        ),
      );
    }
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        _InfoCard(
          title: 'Deal Information',
          icon: Icons.trending_up_rounded,
          children: rows,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAddressCard() {
    final rows = <Widget>[];
    if (_lead.address != null && _lead.address!.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Address',
          value: _lead.address!,
          icon: Icons.location_on_outlined,
        ),
      );
    }
    if (_lead.city != null && _lead.city!.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'City',
          value: _lead.city!,
          icon: Icons.location_city_rounded,
        ),
      );
    }
    if (_lead.state != null && _lead.state!.isNotEmpty) {
      rows.add(
        _InfoRow(label: 'State', value: _lead.state!, icon: Icons.map_outlined),
      );
    }
    if (_lead.country != null && _lead.country!.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Country',
          value: _lead.country!,
          icon: Icons.public_rounded,
        ),
      );
    }
    final map = _lead.toMap();
    final pincode = map['pincode'] as String?;
    final landmark = map['landmark'] as String?;
    if (pincode != null && pincode.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Pincode',
          value: pincode,
          icon: Icons.pin_drop_outlined,
        ),
      );
    }
    if (landmark != null && landmark.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Landmark',
          value: landmark,
          icon: Icons.place_outlined,
        ),
      );
    }
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        _InfoCard(
          title: 'Address',
          icon: Icons.location_on_outlined,
          children: rows,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSocialCard() {
    final map = _lead.toMap();
    final rows = <Widget>[];
    final linkedin = map['linkedin'] as String?;
    final facebook = map['facebook'] as String?;
    final twitter = map['twitter'] as String?;
    final instagram = map['instagram'] as String?;
    final website = map['socialWebsite'] as String?;
    if (linkedin != null && linkedin.isNotEmpty) {
      rows.add(
        _InfoRow(label: 'LinkedIn', value: linkedin, icon: Icons.link_rounded),
      );
    }
    if (facebook != null && facebook.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Facebook',
          value: facebook,
          icon: Icons.facebook_rounded,
        ),
      );
    }
    if (twitter != null && twitter.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Twitter/X',
          value: twitter,
          icon: Icons.alternate_email_rounded,
        ),
      );
    }
    if (instagram != null && instagram.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Instagram',
          value: instagram,
          icon: Icons.camera_alt_outlined,
        ),
      );
    }
    if (website != null && website.isNotEmpty) {
      rows.add(
        _InfoRow(
          label: 'Website',
          value: website,
          icon: Icons.language_rounded,
        ),
      );
    }
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        _InfoCard(
          title: 'Social Profiles',
          icon: Icons.share_outlined,
          children: rows,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildInterestsCard() {
    final map = _lead.toMap();
    final interests = map['interests'] as List?;
    if (interests == null || interests.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        _InfoCard(
          title: 'Interests',
          icon: Icons.star_outline_rounded,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: interests
                  .map<Widget>(
                    (i) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.warning.withAlpha(20),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.warning.withAlpha(60),
                        ),
                      ),
                      child: Text(
                        i.toString(),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.warning,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildNotesPreviewCard() {
    final notes = _lead.notes;
    if (notes == null || notes.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        _InfoCard(
          title: 'Notes',
          icon: Icons.notes_rounded,
          children: [
            Text(
              notes,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTimelineTab() {
    // Build timeline events from lead data with real dates
    final now = DateTime.now();
    final events = <_TimelineEvent>[];

    // Lead created event
    final createdAt =
        _lead.toMap()['createdAt'] as DateTime? ??
        now.subtract(const Duration(days: 3));
    events.add(
      _TimelineEvent(
        title: 'Lead Created',
        description: 'Lead "${_lead.name}" added to the CRM system',
        dateTime: createdAt,
        icon: Icons.person_add_rounded,
        color: AppTheme.primary,
        category: 'System',
      ),
    );

    // Status event
    events.add(
      _TimelineEvent(
        title: 'Status: ${_lead.status}',
        description: 'Lead status set to ${_lead.status}',
        dateTime: createdAt.add(const Duration(hours: 1)),
        icon: Icons.flag_rounded,
        color: _statusColor,
        category: 'Status',
      ),
    );

    // Priority event
    events.add(
      _TimelineEvent(
        title: 'Priority: ${_lead.priority}',
        description: 'Lead priority assigned as ${_lead.priority}',
        dateTime: createdAt.add(const Duration(hours: 2)),
        icon: Icons.priority_high_rounded,
        color: _priorityColor,
        category: 'Priority',
      ),
    );

    // Owner assigned
    if (_lead.ownerName.isNotEmpty) {
      events.add(
        _TimelineEvent(
          title: 'Assigned to ${_lead.ownerName}',
          description: 'Lead ownership assigned',
          dateTime: createdAt.add(const Duration(hours: 3)),
          icon: Icons.person_pin_rounded,
          color: AppTheme.success,
          category: 'Assignment',
        ),
      );
    }

    // Source event
    final source = _lead.source ?? _lead.toMap()['source'] as String?;
    if (source != null && source.isNotEmpty) {
      events.add(
        _TimelineEvent(
          title: 'Source: $source',
          description: 'Lead acquired via $source',
          dateTime: createdAt,
          icon: Icons.input_rounded,
          color: const Color(0xFF8B5CF6),
          category: 'Source',
        ),
      );
    }

    // Contact made
    if (_lead.phone.isNotEmpty) {
      events.add(
        _TimelineEvent(
          title: 'Contact Info Added',
          description:
              'Phone: ${_lead.phone}${_lead.email.isNotEmpty ? " · Email: ${_lead.email}" : ""}',
          dateTime: createdAt.add(const Duration(minutes: 30)),
          icon: Icons.contact_phone_rounded,
          color: AppTheme.primary,
          category: 'Contact',
        ),
      );
    }

    // Deal value
    if (_lead.dealValue > 0) {
      events.add(
        _TimelineEvent(
          title: 'Deal Value Set',
          description: 'Estimated deal value: ${_formatValue(_lead.dealValue)}',
          dateTime: createdAt.add(const Duration(hours: 4)),
          icon: Icons.currency_rupee_rounded,
          color: AppTheme.success,
          category: 'Deal',
        ),
      );
    }

    // Scheduled action
    final scheduledAction = _lead.toMap()['scheduledAction'] as String?;
    final scheduledDate = _lead.toMap()['scheduledActionDate'] as String?;
    if (scheduledAction != null && scheduledAction.isNotEmpty) {
      events.add(
        _TimelineEvent(
          title: 'Action Scheduled: $scheduledAction',
          description: scheduledDate != null
              ? 'Scheduled for $scheduledDate'
              : 'Action planned',
          dateTime: now.add(const Duration(days: 2)),
          icon: Icons.event_rounded,
          color: AppTheme.warning,
          category: 'Scheduled',
          isFuture: true,
        ),
      );
    }

    // Tags
    if (_lead.tags.isNotEmpty) {
      events.add(
        _TimelineEvent(
          title: 'Tags Added',
          description: _lead.tags.join(', '),
          dateTime: createdAt.add(const Duration(hours: 5)),
          icon: Icons.label_rounded,
          color: const Color(0xFF06B6D4),
          category: 'Tags',
        ),
      );
    }

    // Company
    if (_lead.company.isNotEmpty && _lead.company != 'New Company') {
      events.add(
        _TimelineEvent(
          title: 'Company: ${_lead.company}',
          description:
              'Associated with ${_lead.company}${_lead.industry.isNotEmpty ? " (${_lead.industry})" : ""}',
          dateTime: createdAt.add(const Duration(minutes: 45)),
          icon: Icons.corporate_fare_rounded,
          color: const Color(0xFFEC4899),
          category: 'Business',
        ),
      );
    }

    // Notes added
    if (_lead.notes != null && _lead.notes!.isNotEmpty) {
      events.add(
        _TimelineEvent(
          title: 'Note Added',
          description: _lead.notes!.length > 60
              ? '${_lead.notes!.substring(0, 60)}...'
              : _lead.notes!,
          dateTime: createdAt.add(const Duration(days: 1)),
          icon: Icons.notes_rounded,
          color: AppTheme.textSecondary,
          category: 'Note',
        ),
      );
    }

    // User-added notes
    for (final n in _notes) {
      events.add(
        _TimelineEvent(
          title: 'Note by ${n['author']}',
          description: n['note'] as String,
          dateTime: n['dateTime'] as DateTime? ?? now,
          icon: Icons.note_rounded,
          color: AppTheme.primary,
          category: 'Note',
        ),
      );
    }

    // Sort by date descending (newest first)
    events.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    if (events.isEmpty) {
      return Center(
        child: Text(
          'No timeline events yet.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppTheme.textMuted,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: events.length,
      itemBuilder: (context, i) {
        final event = events[i];
        final isLast = i == events.length - 1;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: event.isFuture
                        ? event.color.withAlpha(15)
                        : event.color.withAlpha(30),
                    shape: BoxShape.circle,
                    border: event.isFuture
                        ? Border.all(
                            color: event.color.withAlpha(80),
                            style: BorderStyle.solid,
                          )
                        : null,
                  ),
                  child: Icon(
                    event.icon,
                    size: 18,
                    color: event.color.withAlpha(event.isFuture ? 150 : 255),
                  ),
                ),
                if (!isLast)
                  Container(width: 2, height: 50, color: AppTheme.surface200),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: event.isFuture
                        ? event.color.withAlpha(8)
                        : AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                    border: event.isFuture
                        ? Border.all(color: event.color.withAlpha(40))
                        : null,
                    boxShadow: event.isFuture
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.black.withAlpha(8),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: event.color.withAlpha(20),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              event.category,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: event.color,
                              ),
                            ),
                          ),
                          if (event.isFuture) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.warning.withAlpha(20),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Upcoming',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.warning,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              event.title,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event.description,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _relativeLabel(event.dateTime),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotesTab() {
    return Column(
      children: [
        // Add note area — no blinking cursor by default, proper gap
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.surface200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _noteController,
                focusNode: _noteFocusNode,
                maxLines: 3,
                showCursor: true,
                cursorColor: AppTheme.primary,
                decoration: InputDecoration(
                  hintText: 'Add a note...',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    color: AppTheme.textMuted,
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                ),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    onPressed: _addVoiceRecording,
                    icon: const Icon(Icons.mic_rounded, size: 16),
                    label: Text(
                      'Voice Note',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primary,
                      side: BorderSide(color: AppTheme.primary.withAlpha(100)),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _addNote,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Add Note',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: _notes.isEmpty && _voiceRecordings.isEmpty
              ? Center(
                  child: Text(
                    'No notes yet. Add your first note above.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppTheme.textMuted,
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                  children: [
                    if (_voiceRecordings.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Voice Recordings',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                      ..._voiceRecordings.map(
                        (r) => _VoiceRecordingCard(recording: r),
                      ),
                      const SizedBox(height: 8),
                    ],
                    ..._notes.map(
                      (n) => _NoteCard(
                        author: n['author'] as String,
                        initials: n['initials'] as String,
                        note: n['note'] as String,
                        time: n['time'] as String,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  void _addNote() {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _notes.insert(0, {
        'author': _lead.ownerName.isNotEmpty ? _lead.ownerName : 'Agent',
        'initials': _lead.ownerInitials.isNotEmpty ? _lead.ownerInitials : 'AG',
        'note': text,
        'time': 'Just now',
        'dateTime': DateTime.now(),
        'isVoice': false,
      });
      _noteController.clear();
      _noteFocusNode.unfocus();
    });
  }

  void _addVoiceRecording() {
    setState(() {
      _voiceRecordings.insert(0, {
        'duration': '0:05',
        'time': 'Just now',
        'label': 'Voice Recording ${_voiceRecordings.length + 1}',
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.mic_rounded, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              'Voice recording saved',
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
            ),
          ],
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          _QuickActionButton(
            icon: Icons.phone_rounded,
            label: 'Call',
            color: AppTheme.success,
            onTap: () => _showSnackBar('Calling ${_lead.name}...'),
          ),
          const SizedBox(width: 8),
          _QuickActionButton(
            icon: Icons.email_rounded,
            label: 'Email',
            color: AppTheme.primary,
            onTap: () => _showSnackBar('Opening email...'),
          ),
          const SizedBox(width: 8),
          _QuickActionButton(
            icon: Icons.chat_rounded,
            label: 'WhatsApp',
            color: const Color(0xFF25D366),
            onTap: () => _showSnackBar('Opening WhatsApp...'),
          ),
          const SizedBox(width: 8),
          _QuickActionButton(
            icon: Icons.event_rounded,
            label: 'Schedule',
            color: AppTheme.warning,
            onTap: () => _showScheduleDialog(),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.plusJakartaSans(fontSize: 13),
        ),
        backgroundColor: AppTheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _editLead(BuildContext context) {
    context.go(AppRoutes.addLeadScreen, extra: {'editLead': _lead.toMap()});
  }

  void _showScheduleDialog() {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 0);
    String selectedType = 'Follow-up';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Schedule Follow-up',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Type',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: ['Follow-up', 'Appointment', 'Video Call', 'Callback']
                    .map(
                      (t) => ChoiceChip(
                        label: Text(
                          t,
                          style: GoogleFonts.plusJakartaSans(fontSize: 12),
                        ),
                        selected: selectedType == t,
                        onSelected: (_) =>
                            setDialogState(() => selectedType = t),
                        selectedColor: AppTheme.primaryContainer,
                        checkmarkColor: AppTheme.primary,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final d = await showDatePicker(
                      context: ctx,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (d != null) setDialogState(() => selectedDate = d);
                  },
                  icon: const Icon(Icons.calendar_today_rounded, size: 16),
                  label: Text(
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                    style: GoogleFonts.plusJakartaSans(fontSize: 13),
                  ),
                  style: OutlinedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final t = await showTimePicker(
                      context: ctx,
                      initialTime: selectedTime,
                    );
                    if (t != null) setDialogState(() => selectedTime = t);
                  },
                  icon: const Icon(Icons.access_time_rounded, size: 16),
                  label: Text(
                    selectedTime.format(ctx),
                    style: GoogleFonts.plusJakartaSans(fontSize: 13),
                  ),
                  style: OutlinedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: GoogleFonts.plusJakartaSans()),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                _showSnackBar(
                  '$selectedType scheduled for ${selectedDate.day}/${selectedDate.month}/${selectedDate.year} at ${selectedTime.format(context)}',
                );
              },
              style: FilledButton.styleFrom(backgroundColor: AppTheme.primary),
              child: Text('Schedule', style: GoogleFonts.plusJakartaSans()),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangeStatusDialog() {
    const statuses = [
      'New',
      'Contacted',
      'Proposed',
      'Qualified',
      'Negotiations',
      'Result',
      'Won',
      'Lost',
    ];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Change Status',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: statuses.map((s) {
            final color = AppTheme.leadStatusColor(s);
            final isCurrent = s == _lead.status;
            return ListTile(
              dense: true,
              leading: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              title: Text(
                s,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
                  color: isCurrent ? color : AppTheme.textPrimary,
                ),
              ),
              trailing: isCurrent
                  ? Icon(Icons.check_rounded, color: color, size: 18)
                  : null,
              onTap: () {
                Navigator.pop(ctx);
                setState(() {
                  final updatedMap = _lead.toMap();
                  updatedMap['status'] = s;
                  _lead = LeadModel.fromMap(updatedMap);
                  final idx = globalLeadMaps.indexWhere(
                    (m) => m['id'] == _lead.id,
                  );
                  if (idx >= 0) globalLeadMaps[idx]['status'] = s;
                });
                _showSnackBar('Status changed to $s');
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _OptionTile(
              icon: Icons.edit_rounded,
              label: 'Edit Lead',
              onTap: () {
                Navigator.pop(context);
                _editLead(context);
              },
            ),
            _OptionTile(
              icon: Icons.swap_horiz_rounded,
              label: 'Change Status',
              onTap: () {
                Navigator.pop(context);
                _showChangeStatusDialog();
              },
            ),
            _OptionTile(
              icon: Icons.person_add_rounded,
              label: 'Reassign Lead',
              onTap: () {
                Navigator.pop(context);
                _showReassignDialog();
              },
            ),
            _OptionTile(
              icon: Icons.delete_outline_rounded,
              label: 'Delete Lead',
              color: AppTheme.error,
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showReassignDialog() {
    final employees = [
      {
        'name': 'Priya Sharma',
        'role': 'Admin',
        'id': 'ADM-1042',
        'initials': 'PS',
      },
      {
        'name': 'Rahul Singh',
        'role': 'Senior Rep',
        'id': 'EMP-2031',
        'initials': 'RS',
      },
      {
        'name': 'Ananya Patel',
        'role': 'Manager',
        'id': 'EMP-1187',
        'initials': 'AP',
      },
      {
        'name': 'Kavya Menon',
        'role': 'Sales Rep',
        'id': 'EMP-3045',
        'initials': 'KM',
      },
      {
        'name': 'Arjun Das',
        'role': 'Sales Rep',
        'id': 'EMP-3046',
        'initials': 'AD',
      },
      {
        'name': 'Vikram Nair',
        'role': 'Contractor',
        'id': 'CONT-8391',
        'initials': 'VN',
      },
      {
        'name': 'Meera Iyer',
        'role': 'Contractor',
        'id': 'CONT-5204',
        'initials': 'MI',
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) {
          String searchQuery = '';
          return StatefulBuilder(
            builder: (ctx, setSearch) {
              final filtered = employees.where((e) {
                final q = searchQuery.toLowerCase();
                return q.isEmpty ||
                    (e['name'] ?? '').toLowerCase().contains(q) ||
                    (e['role'] ?? '').toLowerCase().contains(q) ||
                    (e['id'] ?? '').toLowerCase().contains(q);
              }).toList();

              return Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppTheme.surfaceLight,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reassign Lead',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Search field
                    TextField(
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Search employees...',
                        prefixIcon: const Icon(Icons.search_rounded, size: 18),
                        filled: true,
                        fillColor: AppTheme.surfaceVariantLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        isDense: true,
                      ),
                      onChanged: (v) => setSearch(() => searchQuery = v),
                    ),
                    const SizedBox(height: 8),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        children: filtered
                            .map(
                              (e) => ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppTheme.primaryContainer,
                                  child: Text(
                                    e['initials']!,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.primary,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  e['name']!,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  '${e['role']} · ${e['id']}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                  ),
                                ),
                                trailing: _lead.ownerName == e['name']
                                    ? const Icon(
                                        Icons.check_rounded,
                                        color: AppTheme.primary,
                                      )
                                    : null,
                                onTap: () {
                                  Navigator.pop(ctx);
                                  setState(() {
                                    final updatedMap = _lead.toMap();
                                    updatedMap['ownerName'] = e['name'];
                                    updatedMap['ownerInitials'] = e['initials'];
                                    _lead = LeadModel.fromMap(updatedMap);
                                    final idx = globalLeadMaps.indexWhere(
                                      (m) => m['id'] == _lead.id,
                                    );
                                    if (idx >= 0) {
                                      globalLeadMaps[idx]['ownerName'] =
                                          e['name'];
                                      globalLeadMaps[idx]['ownerInitials'] =
                                          e['initials'];
                                    }
                                  });
                                  _showSnackBar(
                                    'Lead reassigned to ${e['name']}',
                                  );
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Lead',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to delete ${_lead.name}? This action cannot be undone.',
          style: GoogleFonts.plusJakartaSans(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              globalLeadMaps.removeWhere((m) => m['id'] == _lead.id);
              context.go(AppRoutes.leadsListScreen);
            },
            style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ─── Helper Widgets ───────────────────────────────────────────────────────────

class _HeaderBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _HeaderBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(60),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  const _InfoCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppTheme.primary),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppTheme.textMuted),
          const SizedBox(width: 8),
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _PipelineProgress extends StatelessWidget {
  final String currentStatus;
  const _PipelineProgress({required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    const stages = [
      'New',
      'Contacted',
      'Proposed',
      'Qualified',
      'Negotiations',
      'Result',
    ];
    final currentIndex = stages.indexOf(currentStatus);
    return Row(
      children: stages.asMap().entries.map((entry) {
        final i = entry.key;
        final stage = entry.value;
        final isPast = i < currentIndex;
        final isCurrent = i == currentIndex;
        final color = AppTheme.leadStatusColor(stage);
        return Expanded(
          child: Column(
            children: [
              Container(
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: isPast || isCurrent ? color : AppTheme.surface200,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stage,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 8,
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
                  color: isCurrent ? color : AppTheme.textMuted,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _TimelineEvent {
  final String title;
  final String description;
  final DateTime dateTime;
  final IconData icon;
  final Color color;
  final String category;
  final bool isFuture;
  const _TimelineEvent({
    required this.title,
    required this.description,
    required this.dateTime,
    required this.icon,
    required this.color,
    required this.category,
    this.isFuture = false,
  });
}

class _NoteCard extends StatelessWidget {
  final String author;
  final String initials;
  final String note;
  final String time;
  const _NoteCard({
    required this.author,
    required this.initials,
    required this.note,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppTheme.primaryContainer,
                child: Text(
                  initials,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  author,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                time,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            note,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _VoiceRecordingCard extends StatelessWidget {
  final Map<String, dynamic> recording;
  const _VoiceRecordingCard({required this.recording});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primary.withAlpha(10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary.withAlpha(40)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primary.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mic_rounded,
              size: 18,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recording['label'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  '${recording['duration']} · ${recording['time']}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.play_circle_rounded, color: AppTheme.primary, size: 28),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: color.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withAlpha(60)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;
  const _OptionTile({
    required this.icon,
    required this.label,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.textPrimary;
    return ListTile(
      leading: Icon(icon, color: c),
      title: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          color: c,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
