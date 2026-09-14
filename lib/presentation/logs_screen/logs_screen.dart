import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

// ─── Call Log Data Models ─────────────────────────────────────────────────────

class CallLogEntry {
  final String id;
  final DateTime callDateTime;
  final int durationSeconds;
  final String direction; // incoming/outgoing/missed
  final String phoneNumber;
  final String countryCode;
  final String simUsed;
  final String callType;
  final String callStatus;
  final String callOutcome;
  final String? linkedLeadName;
  final String? linkedLeadId;
  final String notes;
  final List<String> tags;
  final String agentName;
  final String agentInitials;
  final String agentRole;
  final String? followUpType;
  final DateTime? followUpDate;
  final String? followUpNotes;
  final String followUpPriority;
  final String followUpStatus; // pending/completed/missed

  const CallLogEntry({
    required this.id,
    required this.callDateTime,
    required this.durationSeconds,
    required this.direction,
    required this.phoneNumber,
    required this.countryCode,
    required this.simUsed,
    required this.callType,
    required this.callStatus,
    required this.callOutcome,
    this.linkedLeadName,
    this.linkedLeadId,
    required this.notes,
    required this.tags,
    required this.agentName,
    required this.agentInitials,
    required this.agentRole,
    this.followUpType,
    this.followUpDate,
    this.followUpNotes,
    required this.followUpPriority,
    required this.followUpStatus,
  });

  String get formattedDuration {
    if (durationSeconds == 0) return '0 sec';
    final m = durationSeconds ~/ 60;
    final s = durationSeconds % 60;
    if (m == 0) return '${s}s';
    if (s == 0) return '${m}m';
    return '${m}m ${s}s';
  }

  String get relativeTime {
    final now = DateTime.now();
    final diff = now.difference(callDateTime);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} weeks ago';
    return '${callDateTime.day}/${callDateTime.month}/${callDateTime.year}';
  }

  String get formattedDate {
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
    return '${callDateTime.day} ${months[callDateTime.month - 1]} ${callDateTime.year}';
  }

  String get formattedTime {
    final h = callDateTime.hour;
    final m = callDateTime.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final hour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '$hour:$m $period';
  }
}

// ─── Sample Call Log Data ─────────────────────────────────────────────────────

final List<CallLogEntry> globalCallLogs = [
  CallLogEntry(
    id: 'call-1',
    callDateTime: DateTime.now().subtract(const Duration(hours: 2)),
    durationSeconds: 154,
    direction: 'Outgoing',
    phoneNumber: '+91 98765 43210',
    countryCode: '+91',
    simUsed: 'SIM 1',
    callType: 'Appointment Call',
    callStatus: 'Connected',
    callOutcome: 'Appointment Set',
    linkedLeadName: 'Rahul Mehta',
    linkedLeadId: 'default-1',
    notes:
        'Confirmed interest in enterprise plan. Scheduled demo for next week.',
    tags: ['Hot Lead', 'Interested'],
    agentName: 'Priya Sharma',
    agentInitials: 'PS',
    agentRole: 'Admin',
    followUpType: 'Appointment',
    followUpDate: DateTime.now().add(const Duration(days: 7)),
    followUpNotes: 'Product demo scheduled',
    followUpPriority: 'High',
    followUpStatus: 'pending',
  ),
  CallLogEntry(
    id: 'call-2',
    callDateTime: DateTime.now().subtract(const Duration(hours: 5)),
    durationSeconds: 0,
    direction: 'Missed',
    phoneNumber: '+91 87654 32109',
    countryCode: '+91',
    simUsed: 'SIM 1',
    callType: 'Follow-up Call',
    callStatus: 'No Answer',
    callOutcome: 'Pending',
    linkedLeadName: 'Sneha Kapoor',
    linkedLeadId: 'default-2',
    notes: 'No answer. Will try again tomorrow.',
    tags: ['Follow-up Required'],
    agentName: 'Amit Kumar',
    agentInitials: 'AK',
    agentRole: 'Employee',
    followUpType: 'Call Back',
    followUpDate: DateTime.now().add(const Duration(days: 1)),
    followUpNotes: 'Try calling in morning',
    followUpPriority: 'Medium',
    followUpStatus: 'pending',
  ),
  CallLogEntry(
    id: 'call-3',
    callDateTime: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    durationSeconds: 320,
    direction: 'Incoming',
    phoneNumber: '+91 76543 21098',
    countryCode: '+91',
    simUsed: 'SIM 2',
    callType: 'Warm Call',
    callStatus: 'Connected',
    callOutcome: 'Interested',
    linkedLeadName: 'Vikram Singh',
    linkedLeadId: 'default-3',
    notes: 'Customer called to inquire about premium upgrade. Very interested.',
    tags: ['Warm Lead', 'Upsell Opportunity'],
    agentName: 'Priya Sharma',
    agentInitials: 'PS',
    agentRole: 'Admin',
    followUpType: 'Schedule Appointment',
    followUpDate: DateTime.now().add(const Duration(days: 3)),
    followUpNotes: 'Send proposal first',
    followUpPriority: 'High',
    followUpStatus: 'pending',
  ),
  CallLogEntry(
    id: 'call-4',
    callDateTime: DateTime.now().subtract(const Duration(days: 2)),
    durationSeconds: 45,
    direction: 'Outgoing',
    phoneNumber: '+91 65432 10987',
    countryCode: '+91',
    simUsed: 'SIM 1',
    callType: 'Cold Call',
    callStatus: 'Connected — Voicemail left',
    callOutcome: 'Neutral',
    linkedLeadName: 'Anita Desai',
    linkedLeadId: 'default-4',
    notes: 'Left voicemail about renewal offer.',
    tags: ['Existing Customer'],
    agentName: 'Ravi Verma',
    agentInitials: 'RV',
    agentRole: 'Employee',
    followUpType: 'Call Back',
    followUpDate: DateTime.now().add(const Duration(days: 2)),
    followUpNotes: 'Check if voicemail received',
    followUpPriority: 'Low',
    followUpStatus: 'pending',
  ),
  CallLogEntry(
    id: 'call-5',
    callDateTime: DateTime.now().subtract(const Duration(days: 3, hours: 1)),
    durationSeconds: 0,
    direction: 'Missed',
    phoneNumber: '+91 54321 09876',
    countryCode: '+91',
    simUsed: 'SIM 1',
    callType: 'Reminder Call',
    callStatus: 'Switched Off',
    callOutcome: 'Pending',
    linkedLeadName: 'Karan Joshi',
    linkedLeadId: 'default-5',
    notes: 'Phone switched off. Try WhatsApp.',
    tags: ['Cold Lead'],
    agentName: 'Amit Kumar',
    agentInitials: 'AK',
    agentRole: 'Employee',
    followUpType: 'Send WhatsApp',
    followUpDate: DateTime.now().add(const Duration(hours: 4)),
    followUpNotes: 'Send product brochure via WhatsApp',
    followUpPriority: 'Medium',
    followUpStatus: 'pending',
  ),
  CallLogEntry(
    id: 'call-6',
    callDateTime: DateTime.now().subtract(const Duration(days: 5)),
    durationSeconds: 780,
    direction: 'Outgoing',
    phoneNumber: '+91 91234 56789',
    countryCode: '+91',
    simUsed: 'SIM 2',
    callType: 'Negotiation Call',
    callStatus: 'Connected',
    callOutcome: 'Price Discussion',
    linkedLeadName: 'Mohammed Al-Rashid',
    notes: 'Long negotiation on pricing. Customer wants 15% discount.',
    tags: ['VIP Customer', 'Hot Lead'],
    agentName: 'Priya Sharma',
    agentInitials: 'PS',
    agentRole: 'Admin',
    followUpType: 'Schedule Video Call',
    followUpDate: DateTime.now().add(const Duration(days: 5)),
    followUpNotes: 'Present final pricing with discount',
    followUpPriority: 'High',
    followUpStatus: 'pending',
  ),
  CallLogEntry(
    id: 'call-7',
    callDateTime: DateTime.now().subtract(const Duration(days: 7)),
    durationSeconds: 95,
    direction: 'Incoming',
    phoneNumber: '+91 99887 76655',
    countryCode: '+91',
    simUsed: 'SIM 1',
    callType: 'Support Call',
    callStatus: 'Connected',
    callOutcome: 'Success',
    linkedLeadName: 'Sunita Reddy',
    notes: 'Customer had query about policy terms. Resolved successfully.',
    tags: ['Existing Customer'],
    agentName: 'Kavya Menon',
    agentInitials: 'KM',
    agentRole: 'Employee',
    followUpPriority: 'Low',
    followUpStatus: 'completed',
  ),
  CallLogEntry(
    id: 'call-8',
    callDateTime: DateTime.now().subtract(const Duration(days: 10)),
    durationSeconds: 0,
    direction: 'Outgoing',
    phoneNumber: '+91 88776 65544',
    countryCode: '+91',
    simUsed: 'SIM 1',
    callType: 'Cold Call',
    callStatus: 'Wrong Number',
    callOutcome: 'Not Relevant',
    notes: 'Wrong number. Remove from list.',
    tags: [],
    agentName: 'Rahul Singh',
    agentInitials: 'RS',
    agentRole: 'Employee',
    followUpPriority: 'Low',
    followUpStatus: 'completed',
  ),
];

// ─── Logs Screen ──────────────────────────────────────────────────────────────

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  String _searchQuery = '';
  bool _isSearchActive = false;
  final _searchCtrl = TextEditingController();
  String _dateFilter = 'All';
  String _directionFilter = 'All';
  String _selectedEmployee = 'All';
  List<String> _selectedCallTypes = [];
  List<String> _selectedStatuses = [];
  final bool _showFilters = false;

  static const _dateFilters = [
    'All',
    'Today',
    'Yesterday',
    'This Week',
    'This Month',
    'Custom',
  ];
  static const _directions = ['All', 'Incoming', 'Outgoing', 'Missed'];
  static const _callTypes = [
    'Appointment Call',
    'Cold Call',
    'Callback',
    'Follow-up Call',
    'Video Call',
    'Warm Call',
    'Support Call',
    'Negotiation Call',
    'Closing Call',
    'Service Call',
    'Reminder Call',
    'Other',
  ];
  static const _callStatuses = [
    'Connected',
    'Connected — Voicemail left',
    'No Answer',
    'Busy',
    'Switched Off',
    'Wrong Number',
    'Not Interested',
    'Interested',
    'Appointment Set',
    'Deal Closed',
    'Call Dropped',
  ];
  static const _employees = [
    'All',
    'Priya Sharma',
    'Rahul Singh',
    'Ananya Patel',
    'Kavya Menon',
    'Arjun Das',
    'Amit Kumar',
    'Ravi Verma',
  ];

  List<CallLogEntry> get _filteredLogs {
    return globalCallLogs.where((log) {
      // Search
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!log.phoneNumber.toLowerCase().contains(q) &&
            !(log.linkedLeadName?.toLowerCase().contains(q) ?? false) &&
            !log.notes.toLowerCase().contains(q) &&
            !log.agentName.toLowerCase().contains(q)) {
          return false;
        }
      }
      // Direction
      if (_directionFilter != 'All' && log.direction != _directionFilter) {
        return false;
      }
      // Employee
      if (_selectedEmployee != 'All' && log.agentName != _selectedEmployee) {
        return false;
      }
      // Call types
      if (_selectedCallTypes.isNotEmpty &&
          !_selectedCallTypes.contains(log.callType)) {
        return false;
      }
      // Statuses
      if (_selectedStatuses.isNotEmpty &&
          !_selectedStatuses.contains(log.callStatus)) {
        return false;
      }
      // Date filter
      if (_dateFilter != 'All') {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final logDate = DateTime(
          log.callDateTime.year,
          log.callDateTime.month,
          log.callDateTime.day,
        );
        switch (_dateFilter) {
          case 'Today':
            if (logDate != today) return false;
            break;
          case 'Yesterday':
            if (logDate != today.subtract(const Duration(days: 1))) {
              return false;
            }
            break;
          case 'This Week':
            if (log.callDateTime.isBefore(
              today.subtract(Duration(days: today.weekday - 1)),
            )) {
              return false;
            }
            break;
          case 'This Month':
            if (log.callDateTime.month != now.month ||
                log.callDateTime.year != now.year) {
              return false;
            }
            break;
        }
      }
      return true;
    }).toList();
  }

  bool get _hasActiveFilters =>
      _dateFilter != 'All' ||
      _directionFilter != 'All' ||
      _selectedEmployee != 'All' ||
      _selectedCallTypes.isNotEmpty ||
      _selectedStatuses.isNotEmpty;

  void _clearAllFilters() {
    setState(() {
      _dateFilter = 'All';
      _directionFilter = 'All';
      _selectedEmployee = 'All';
      _selectedCallTypes = [];
      _selectedStatuses = [];
    });
  }

  int get _todayCount => globalCallLogs.where((l) {
    final now = DateTime.now();
    return l.callDateTime.day == now.day &&
        l.callDateTime.month == now.month &&
        l.callDateTime.year == now.year;
  }).length;

  int get _pendingFollowUps => globalCallLogs
      .where((l) => l.followUpStatus == 'pending' && l.followUpType != null)
      .length;
  int get _missedCount =>
      globalCallLogs.where((l) => l.direction == 'Missed').length;
  int get _connectedCount =>
      globalCallLogs.where((l) => l.callStatus.startsWith('Connected')).length;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredLogs;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: AppTheme.backgroundLight,
            elevation: 0,
            scrolledUnderElevation: 1,
            shadowColor: AppTheme.surface200,
            leading: Builder(
              builder: (ctx) => IconButton(
                icon: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariantLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.menu_rounded,
                    size: 20,
                    color: AppTheme.textPrimary,
                  ),
                ),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
            title: _isSearchActive
                ? TextField(
                    controller: _searchCtrl,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search calls, leads, notes...',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: AppTheme.textMuted,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      color: AppTheme.textPrimary,
                    ),
                    onChanged: (v) => setState(() => _searchQuery = v),
                  )
                : Text(
                    'Call Logs',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
            actions: [
              IconButton(
                icon: Icon(
                  _isSearchActive ? Icons.close_rounded : Icons.search_rounded,
                  color: AppTheme.textPrimary,
                ),
                onPressed: () => setState(() {
                  _isSearchActive = !_isSearchActive;
                  if (!_isSearchActive) {
                    _searchCtrl.clear();
                    _searchQuery = '';
                  }
                }),
              ),
              IconButton(
                icon: Stack(
                  children: [
                    Icon(
                      Icons.filter_list_rounded,
                      color: _hasActiveFilters
                          ? AppTheme.primary
                          : AppTheme.textPrimary,
                    ),
                    if (_hasActiveFilters)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppTheme.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: () => _showFilterSheet(),
              ),
            ],
          ),

          // Stats row
          SliverToBoxAdapter(child: _buildStatsRow()),

          // Active filter chips
          if (_hasActiveFilters)
            SliverToBoxAdapter(child: _buildActiveFilterChips()),

          // Upcoming reminders
          SliverToBoxAdapter(child: _buildUpcomingReminders()),

          // Date filter pills
          SliverToBoxAdapter(child: _buildDateFilterPills()),

          // Results count
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                children: [
                  Text(
                    '${filtered.length} call${filtered.length != 1 ? 's' : ''}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _showSortSheet,
                    icon: const Icon(Icons.sort_rounded, size: 16),
                    label: Text(
                      'Sort',
                      style: GoogleFonts.plusJakartaSans(fontSize: 13),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.textSecondary,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Call log list
          if (filtered.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.call_outlined,
                      size: 48,
                      color: AppTheme.textMuted,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No calls found',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Try adjusting your filters',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => _CallLogCard(
                    entry: filtered[i],
                    onTap: () => _showCallDetail(filtered[i]),
                  ),
                  childCount: filtered.length,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showLogCallSheet,
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add_call, color: Colors.white),
        label: Text(
          'Log Call',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      height: 90,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          _StatCard(
            label: 'Today',
            value: '$_todayCount',
            icon: Icons.today_rounded,
            color: AppTheme.primary,
          ),
          const SizedBox(width: 8),
          _StatCard(
            label: 'Connected',
            value: '$_connectedCount',
            icon: Icons.call_rounded,
            color: AppTheme.success,
          ),
          const SizedBox(width: 8),
          _StatCard(
            label: 'Follow-ups',
            value: '$_pendingFollowUps',
            icon: Icons.schedule_rounded,
            color: AppTheme.warning,
          ),
          const SizedBox(width: 8),
          _StatCard(
            label: 'Missed',
            value: '$_missedCount',
            icon: Icons.call_missed_rounded,
            color: AppTheme.error,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilterChips() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        children: [
          if (_dateFilter != 'All')
            _ActiveChip(
              label: _dateFilter,
              onRemove: () => setState(() => _dateFilter = 'All'),
            ),
          if (_directionFilter != 'All')
            _ActiveChip(
              label: _directionFilter,
              onRemove: () => setState(() => _directionFilter = 'All'),
            ),
          if (_selectedEmployee != 'All')
            _ActiveChip(
              label: _selectedEmployee,
              onRemove: () => setState(() => _selectedEmployee = 'All'),
            ),
          ..._selectedCallTypes.map(
            (t) => _ActiveChip(
              label: t,
              onRemove: () => setState(() => _selectedCallTypes.remove(t)),
            ),
          ),
          ..._selectedStatuses.map(
            (s) => _ActiveChip(
              label: s,
              onRemove: () => setState(() => _selectedStatuses.remove(s)),
            ),
          ),
          GestureDetector(
            onTap: _clearAllFilters,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.error.withAlpha(20),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.error.withAlpha(60)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.clear_all_rounded,
                    size: 14,
                    color: AppTheme.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Clear All',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: AppTheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingReminders() {
    final upcoming = globalCallLogs
        .where(
          (l) =>
              l.followUpStatus == 'pending' &&
              l.followUpType != null &&
              l.followUpDate != null,
        )
        .take(3)
        .toList();
    if (upcoming.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primary.withAlpha(10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primary.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.notifications_active_rounded,
                size: 16,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                'Upcoming Follow-ups',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...upcoming.map((l) {
            final fd = l.followUpDate!;
            final now = DateTime.now();
            final diff = fd.difference(now);
            String when;
            if (diff.inHours < 1) {
              when = 'In ${diff.inMinutes}m';
            } else if (diff.inHours < 24)
              when = 'In ${diff.inHours}h';
            else if (diff.inDays == 1)
              when = 'Tomorrow';
            else
              when = 'In ${diff.inDays} days';

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        l.agentInitials,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.linkedLeadName ?? l.phoneNumber,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          l.followUpType!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.warning.withAlpha(30),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      when,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.warning,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDateFilterPills() {
    return Container(
      height: 44,
      margin: const EdgeInsets.only(top: 12),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _dateFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final f = _dateFilters[i];
          final isSelected = _dateFilter == f;
          return GestureDetector(
            onTap: () => setState(() => _dateFilter = f),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppTheme.primary : AppTheme.surface200,
                ),
              ),
              child: Text(
                f,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) {
          String empSearch = '';
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.75,
            maxChildSize: 0.95,
            builder: (_, ctrl) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: ListView(
                controller: ctrl,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.surface200,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Filters',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      if (_hasActiveFilters)
                        TextButton(
                          onPressed: () {
                            _clearAllFilters();
                            Navigator.pop(ctx);
                          },
                          child: Text(
                            'Clear All',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppTheme.error,
                              fontSize: 13,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Direction
                  Text(
                    'Direction',
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
                    children: _directions
                        .map(
                          (d) => _SheetChip(
                            label: d,
                            isSelected: _directionFilter == d,
                            onTap: () {
                              setState(() => _directionFilter = d);
                              setSheet(() {});
                            },
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  // Employee with search
                  Text(
                    'Assigned Employee',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  StatefulBuilder(
                    builder: (_, setEmp) => Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Search employee...',
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              size: 18,
                            ),
                            filled: true,
                            fillColor: AppTheme.surfaceVariantLight,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            isDense: true,
                          ),
                          onChanged: (v) => setEmp(() => empSearch = v),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: _employees
                              .where(
                                (e) =>
                                    empSearch.isEmpty ||
                                    e.toLowerCase().contains(
                                      empSearch.toLowerCase(),
                                    ),
                              )
                              .map(
                                (e) => _SheetChip(
                                  label: e,
                                  isSelected: _selectedEmployee == e,
                                  onTap: () {
                                    setState(() => _selectedEmployee = e);
                                    setSheet(() {});
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Call types
                  Text(
                    'Call Type',
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
                    children: _callTypes
                        .map(
                          (t) => _SheetChip(
                            label: t,
                            isSelected: _selectedCallTypes.contains(t),
                            onTap: () {
                              setState(() {
                                if (_selectedCallTypes.contains(t)) {
                                  _selectedCallTypes.remove(t);
                                } else {
                                  _selectedCallTypes.add(t);
                                }
                              });
                              setSheet(() {});
                            },
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  // Status
                  Text(
                    'Call Status',
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
                    children: _callStatuses
                        .map(
                          (s) => _SheetChip(
                            label: s,
                            isSelected: _selectedStatuses.contains(s),
                            onTap: () {
                              setState(() {
                                if (_selectedStatuses.contains(s)) {
                                  _selectedStatuses.remove(s);
                                } else {
                                  _selectedStatuses.add(s);
                                }
                              });
                              setSheet(() {});
                            },
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Apply Filters',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppTheme.surface200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Sort By',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            ...[
              (Icons.access_time_rounded, 'Newest First'),
              (Icons.access_time_outlined, 'Oldest First'),
              (Icons.timer_rounded, 'Longest Duration'),
              (Icons.timer_outlined, 'Shortest Duration'),
              (Icons.sort_by_alpha_rounded, 'Lead Name A-Z'),
            ].map(
              (item) => ListTile(
                dense: true,
                leading: Icon(item.$1, size: 20, color: AppTheme.textSecondary),
                title: Text(
                  item.$2,
                  style: GoogleFonts.plusJakartaSans(fontSize: 14),
                ),
                onTap: () => Navigator.pop(ctx),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCallDetail(CallLogEntry entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CallDetailSheet(entry: entry),
    );
  }

  void _showLogCallSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _LogCallSheet(),
    );
  }
}

// ─── Call Log Card ────────────────────────────────────────────────────────────

class _CallLogCard extends StatelessWidget {
  final CallLogEntry entry;
  final VoidCallback onTap;
  const _CallLogCard({required this.entry, required this.onTap});

  Color get _directionColor {
    switch (entry.direction) {
      case 'Incoming':
        return AppTheme.success;
      case 'Outgoing':
        return AppTheme.primary;
      case 'Missed':
        return AppTheme.error;
      default:
        return AppTheme.textMuted;
    }
  }

  IconData get _directionIcon {
    switch (entry.direction) {
      case 'Incoming':
        return Icons.call_received_rounded;
      case 'Outgoing':
        return Icons.call_made_rounded;
      case 'Missed':
        return Icons.call_missed_rounded;
      default:
        return Icons.call_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border(left: BorderSide(color: _directionColor, width: 4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
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
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _directionColor.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_directionIcon, size: 18, color: _directionColor),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.linkedLeadName ?? entry.phoneNumber,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        entry.phoneNumber,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      entry.formattedTime,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    Text(
                      entry.relativeTime,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _InfoBadge(label: entry.direction, color: _directionColor),
                const SizedBox(width: 6),
                _InfoBadge(label: entry.callType, color: AppTheme.primary),
                const SizedBox(width: 6),
                _InfoBadge(
                  label: entry.formattedDuration,
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      entry.agentInitials,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 7,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  entry.agentName,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const Spacer(),
                _StatusBadge(status: entry.callStatus),
              ],
            ),
            if (entry.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                entry.notes,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (entry.followUpType != null &&
                entry.followUpStatus == 'pending') ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.warning.withAlpha(60)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      size: 12,
                      color: AppTheme.warning,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${entry.followUpType} · ${entry.followUpDate != null ? _formatFollowUp(entry.followUpDate!) : ""}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        color: AppTheme.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                _QuickBtn(
                  icon: Icons.call_rounded,
                  label: 'Call Back',
                  color: AppTheme.success,
                  onTap: () {},
                ),
                const SizedBox(width: 6),
                _QuickBtn(
                  icon: Icons.schedule_rounded,
                  label: 'Schedule',
                  color: AppTheme.primary,
                  onTap: () {},
                ),
                const SizedBox(width: 6),
                _QuickBtn(
                  icon: Icons.note_add_rounded,
                  label: 'Notes',
                  color: AppTheme.textSecondary,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatFollowUp(DateTime d) {
    final now = DateTime.now();
    final diff = d.difference(now);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Tomorrow';
    if (diff.inDays < 7) return 'In ${diff.inDays} days';
    return '${d.day}/${d.month}/${d.year}';
  }
}

// ─── Call Detail Sheet ────────────────────────────────────────────────────────

class _CallDetailSheet extends StatelessWidget {
  final CallLogEntry entry;
  const _CallDetailSheet({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        builder: (_, ctrl) => ListView(
          controller: ctrl,
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppTheme.surface200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  'Call Details',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _DetailSection(
              title: 'Call Info',
              icon: Icons.call_rounded,
              children: [
                _DetailRow(label: 'Type', value: entry.callType),
                _DetailRow(label: 'Status', value: entry.callStatus),
                _DetailRow(label: 'Outcome', value: entry.callOutcome),
                _DetailRow(label: 'Direction', value: entry.direction),
                _DetailRow(label: 'Duration', value: entry.formattedDuration),
                _DetailRow(label: 'SIM', value: entry.simUsed),
                _DetailRow(label: 'Date', value: entry.formattedDate),
                _DetailRow(label: 'Time', value: entry.formattedTime),
              ],
            ),
            const SizedBox(height: 12),
            _DetailSection(
              title: 'Contact',
              icon: Icons.person_outline_rounded,
              children: [
                _DetailRow(label: 'Phone', value: entry.phoneNumber),
                if (entry.linkedLeadName != null)
                  _DetailRow(label: 'Lead', value: entry.linkedLeadName!),
                _DetailRow(
                  label: 'Agent',
                  value: '${entry.agentName} · ${entry.agentRole}',
                ),
              ],
            ),
            if (entry.notes.isNotEmpty) ...[
              const SizedBox(height: 12),
              _DetailSection(
                title: 'Notes',
                icon: Icons.notes_rounded,
                children: [
                  Text(
                    entry.notes,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
            if (entry.tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              _DetailSection(
                title: 'Tags',
                icon: Icons.label_outline_rounded,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: entry.tags
                        .map(
                          (t) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              t,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
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
            if (entry.followUpType != null) ...[
              const SizedBox(height: 12),
              _DetailSection(
                title: 'Follow-up',
                icon: Icons.schedule_rounded,
                children: [
                  _DetailRow(label: 'Type', value: entry.followUpType!),
                  if (entry.followUpDate != null)
                    _DetailRow(
                      label: 'Date',
                      value:
                          '${entry.followUpDate!.day}/${entry.followUpDate!.month}/${entry.followUpDate!.year}',
                    ),
                  if (entry.followUpNotes != null)
                    _DetailRow(label: 'Notes', value: entry.followUpNotes!),
                  _DetailRow(label: 'Priority', value: entry.followUpPriority),
                  _DetailRow(
                    label: 'Status',
                    value: entry.followUpStatus.toUpperCase(),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Log Call Sheet ───────────────────────────────────────────────────────────

class _LogCallSheet extends StatefulWidget {
  const _LogCallSheet();

  @override
  State<_LogCallSheet> createState() => _LogCallSheetState();
}

class _LogCallSheetState extends State<_LogCallSheet> {
  String _callType = 'Follow-up Call';
  String _callStatus = 'Connected';
  String _callOutcome = 'Pending';
  String _direction = 'Outgoing';
  String _sim = 'SIM 1';
  final _phoneCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String? _followUpType;
  DateTime? _followUpDate;
  String _followUpPriority = 'Medium';
  bool _showFollowUp = false;

  static const _callTypes = [
    'Appointment Call',
    'Cold Call',
    'Callback',
    'Follow-up Call',
    'Video Call',
    'Warm Call',
    'Support Call',
    'Negotiation Call',
    'Closing Call',
    'Service Call',
    'Reminder Call',
    'Other',
  ];
  static const _statuses = [
    'Connected',
    'Connected — Voicemail left',
    'No Answer',
    'Busy',
    'Switched Off',
    'Wrong Number',
    'Not Interested',
    'Interested',
    'Appointment Set',
    'Deal Closed',
  ];
  static const _outcomes = [
    'Success',
    'Partial',
    'Neutral',
    'Negative',
    'Pending',
    'Callback Requested',
    'Appointment Booked',
    'Referral Given',
    'Objection Raised',
    'Price Discussion',
    'Demo Requested',
  ];
  static const _followUpTypes = [
    'Call Back',
    'Schedule Appointment',
    'Schedule Video Call',
    'Send Email',
    'Send WhatsApp',
    'Send SMS',
    'Send Quote/Proposal',
    'Escalate to Manager',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        builder: (_, ctrl) => ListView(
          controller: ctrl,
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppTheme.surface200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Log a Call',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            _FormLabel('Phone Number'),
            TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: _inputDeco('Enter phone number'),
            ),
            const SizedBox(height: 12),
            _FormLabel('Direction'),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: ['Incoming', 'Outgoing', 'Missed']
                  .map(
                    (d) => _SheetChip(
                      label: d,
                      isSelected: _direction == d,
                      onTap: () => setState(() => _direction = d),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            _FormLabel('Call Type'),
            _DropdownField(
              value: _callType,
              items: _callTypes,
              onChanged: (v) => setState(() => _callType = v!),
            ),
            const SizedBox(height: 12),
            _FormLabel('Call Status'),
            _DropdownField(
              value: _callStatus,
              items: _statuses,
              onChanged: (v) => setState(() => _callStatus = v!),
            ),
            const SizedBox(height: 12),
            _FormLabel('Call Outcome'),
            _DropdownField(
              value: _callOutcome,
              items: _outcomes,
              onChanged: (v) => setState(() => _callOutcome = v!),
            ),
            const SizedBox(height: 12),
            _FormLabel('SIM Used'),
            Wrap(
              spacing: 8,
              children: ['SIM 1', 'SIM 2']
                  .map(
                    (s) => _SheetChip(
                      label: s,
                      isSelected: _sim == s,
                      onTap: () => setState(() => _sim = s),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            _FormLabel('Notes'),
            TextField(
              controller: _notesCtrl,
              maxLines: 3,
              decoration: _inputDeco('Add call notes...'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Add Follow-up',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: _showFollowUp,
                  onChanged: (v) => setState(() => _showFollowUp = v),
                  activeThumbColor: AppTheme.primary,
                ),
              ],
            ),
            if (_showFollowUp) ...[
              const SizedBox(height: 8),
              _FormLabel('Follow-up Type'),
              _DropdownField(
                value: _followUpType ?? _followUpTypes.first,
                items: _followUpTypes,
                onChanged: (v) => setState(() => _followUpType = v),
              ),
              const SizedBox(height: 8),
              _FormLabel('Follow-up Date'),
              OutlinedButton.icon(
                onPressed: () async {
                  final d = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (d != null) setState(() => _followUpDate = d);
                },
                icon: const Icon(Icons.calendar_today_rounded, size: 16),
                label: Text(
                  _followUpDate != null
                      ? '${_followUpDate!.day}/${_followUpDate!.month}/${_followUpDate!.year}'
                      : 'Select date',
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
              const SizedBox(height: 8),
              _FormLabel('Priority'),
              Wrap(
                spacing: 8,
                children: ['High', 'Medium', 'Low']
                    .map(
                      (p) => _SheetChip(
                        label: p,
                        isSelected: _followUpPriority == p,
                        onTap: () => setState(() => _followUpPriority = p),
                      ),
                    )
                    .toList(),
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Call logged successfully'),
                      backgroundColor: AppTheme.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Save Call Log',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.plusJakartaSans(
      color: AppTheme.textMuted,
      fontSize: 13,
    ),
    filled: true,
    fillColor: AppTheme.surfaceVariantLight,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  );
}

// ─── Helper Widgets ───────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 9,
                color: AppTheme.textMuted,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _InfoBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  Color get _color {
    if (status.startsWith('Connected')) return AppTheme.success;
    if (status == 'No Answer' || status == 'Missed') return AppTheme.error;
    if (status == 'Busy' || status == 'Switched Off') return AppTheme.warning;
    if (status == 'Appointment Set' || status == 'Deal Closed') {
      return AppTheme.primary;
    }
    return AppTheme.textMuted;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withAlpha(20),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _color.withAlpha(60)),
      ),
      child: Text(
        status,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: _color,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _QuickBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withAlpha(40)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  const _ActiveChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              size: 12,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _SheetChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryContainer : AppTheme.surface100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.surface200,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  const _DetailSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariantLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppTheme.primary),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppTheme.textMuted,
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

class _FormLabel extends StatelessWidget {
  final String text;
  const _FormLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  const _DropdownField({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariantLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppTheme.textPrimary,
          ),
          items: items
              .map(
                (i) => DropdownMenuItem(
                  value: i,
                  child: Text(i, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
