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

  @override
  void initState() {
    super.initState();
    _lead = widget.lead;
    _tabController = TabController(length: 3, vsync: this);
    // Pre-populate notes from lead if any
    _notes.addAll([
      {
        'author': _lead.ownerName,
        'initials': _lead.ownerInitials,
        'note': 'Lead added to pipeline.',
        'time': _lead.lastContact,
        'isVoice': false,
      },
    ]);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _noteController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Column(
        children: [
          // Fixed header — no NestedScrollView to prevent overlap
          _buildHeader(context),
          // Tab bar — separate from header, no overlap
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
          // Tab content
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
            // App bar row
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
                  tooltip: 'Edit Lead',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => _showMoreOptions(),
                  tooltip: 'More options',
                ),
              ],
            ),
            // Lead info
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white.withAlpha(50),
                    child: Text(
                      _lead.name.isNotEmpty ? _lead.name[0] : 'L',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _lead.name.isNotEmpty ? _lead.name : 'New Lead',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        if (_lead.phone.isNotEmpty)
                          Text(
                            _lead.phone,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: Colors.white.withAlpha(200),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Badges row — separate from tab bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: Row(
                children: [
                  _HeaderBadge(label: _lead.status, color: _statusColor),
                  const SizedBox(width: 8),
                  _HeaderBadge(label: _lead.priority, color: _priorityColor),
                  const SizedBox(width: 8),
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
          // Contact info — only show filled fields
          _buildContactInfoCard(),
          const SizedBox(height: 16),
          // Deal info
          _InfoCard(
            title: 'Deal Information',
            icon: Icons.trending_up_rounded,
            children: [
              if (_lead.dealValue > 0)
                _InfoRow(
                  label: 'Deal Value',
                  value: _formatValue(_lead.dealValue),
                  icon: Icons.currency_rupee_rounded,
                ),
              _InfoRow(
                label: 'Status',
                value: _lead.status,
                icon: Icons.flag_outlined,
              ),
              _InfoRow(
                label: 'Priority',
                value: _lead.priority,
                icon: Icons.priority_high_rounded,
              ),
              _InfoRow(
                label: 'Last Contact',
                value: _lead.lastContact,
                icon: Icons.access_time_rounded,
              ),
              if (_lead.ownerName.isNotEmpty)
                _InfoRow(
                  label: 'Owner',
                  value: _lead.ownerName,
                  icon: Icons.person_pin_outlined,
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Tags
          if (_lead.tags.isNotEmpty) ...[
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
            const SizedBox(height: 16),
          ],
          // Pipeline stage
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
    if (_lead.industry.isNotEmpty && _lead.industry != 'General') {
      rows.add(
        _InfoRow(
          label: 'Industry',
          value: _lead.industry,
          icon: Icons.business_outlined,
        ),
      );
    }
    if (_lead.company.isNotEmpty && _lead.company != 'New Company') {
      rows.add(
        _InfoRow(
          label: 'Company',
          value: _lead.company,
          icon: Icons.corporate_fare_rounded,
        ),
      );
    }
    if (rows.isEmpty) {
      rows.add(
        Text(
          'No contact details filled yet. Tap Edit to add.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: AppTheme.textMuted,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }
    return _InfoCard(
      title: 'Contact Information',
      icon: Icons.person_outline_rounded,
      children: rows,
    );
  }

  Widget _buildTimelineTab() {
    final events = [
      _TimelineEvent(
        title: 'Lead Created',
        description: 'Lead added to the system',
        time: _lead.lastContact,
        icon: Icons.add_circle_outline_rounded,
        color: AppTheme.primary,
      ),
      _TimelineEvent(
        title: 'Status: ${_lead.status}',
        description: 'Current pipeline stage',
        time: _lead.lastContact,
        icon: Icons.update_rounded,
        color: _statusColor,
      ),
      _TimelineEvent(
        title: 'Priority: ${_lead.priority}',
        description: 'Lead priority level set',
        time: _lead.lastContact,
        icon: Icons.flag_rounded,
        color: _priorityColor,
      ),
    ];

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
                    color: event.color.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(event.icon, size: 18, color: event.color),
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
                          Expanded(
                            child: Text(
                              event.title,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            event.time,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: AppTheme.textMuted,
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
        // Add note area — with proper gap between textarea and button
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
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add a note...',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    color: AppTheme.textMuted,
                  ),
                  border: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(
                height: 12,
              ), // proper gap between textarea and button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Voice recording button
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
        // Notes list
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
                    // Voice recordings section
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
                    // Text notes
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
        'isVoice': false,
      });
      _noteController.clear();
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
            onTap: () => _showSnackBar('Opening email to ${_lead.email}...'),
          ),
          const SizedBox(width: 8),
          _QuickActionButton(
            icon: Icons.chat_rounded,
            label: 'WhatsApp',
            color: const Color(0xFF25D366),
            onTap: () => _showSnackBar('Opening WhatsApp for ${_lead.name}...'),
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
    // Navigate to add lead screen with existing lead data for editing
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
              // Date picker button
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
              // Time picker button — compulsory
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
                  // Update global list
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
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
            const SizedBox(height: 16),
            ...employees.map(
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
                  style: GoogleFonts.plusJakartaSans(fontSize: 12),
                ),
                trailing: _lead.ownerName == e['name']
                    ? const Icon(Icons.check_rounded, color: AppTheme.primary)
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
                      globalLeadMaps[idx]['ownerName'] = e['name'];
                      globalLeadMaps[idx]['ownerInitials'] = e['initials'];
                    }
                  });
                  _showSnackBar('Lead reassigned to ${e['name']}');
                },
              ),
            ),
          ],
        ),
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
            width: 80,
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
  final String time;
  final IconData icon;
  final Color color;
  const _TimelineEvent({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
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
