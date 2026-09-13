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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color get _priorityColor => AppTheme.priorityColor(widget.lead.priority);
  Color get _statusColor => AppTheme.leadStatusColor(widget.lead.status);

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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => context.go(AppRoutes.leadsListScreen),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.white),
                onPressed: () {},
                tooltip: 'Edit Lead',
              ),
              IconButton(
                icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
                onPressed: () => _showMoreOptions(),
                tooltip: 'More options',
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primary, AppTheme.primary.withAlpha(200)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.white.withAlpha(50),
                              child: Text(
                                widget.lead.name.substring(0, 1),
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
                                    widget.lead.name,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    widget.lead.company,
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
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _StatusBadge(
                              label: widget.lead.status,
                              color: _statusColor,
                            ),
                            const SizedBox(width: 8),
                            _StatusBadge(
                              label: widget.lead.priority,
                              color: _priorityColor,
                            ),
                            const SizedBox(width: 8),
                            _StatusBadge(
                              label: _formatValue(widget.lead.dealValue),
                              color: Colors.white.withAlpha(100),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withAlpha(150),
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
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
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildTimelineTab(),
            _buildNotesTab(),
          ],
        ),
      ),
      // Quick action buttons
      bottomNavigationBar: _buildQuickActions(),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contact info
          _InfoCard(
            title: 'Contact Information',
            icon: Icons.person_outline_rounded,
            children: [
              _InfoRow(
                label: 'Phone',
                value: widget.lead.phone,
                icon: Icons.phone_outlined,
              ),
              _InfoRow(
                label: 'Email',
                value: widget.lead.email,
                icon: Icons.email_outlined,
              ),
              _InfoRow(
                label: 'Industry',
                value: widget.lead.industry,
                icon: Icons.business_outlined,
              ),
              _InfoRow(
                label: 'Owner',
                value: widget.lead.ownerName,
                icon: Icons.person_pin_outlined,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Deal info
          _InfoCard(
            title: 'Deal Information',
            icon: Icons.trending_up_rounded,
            children: [
              _InfoRow(
                label: 'Deal Value',
                value: _formatValue(widget.lead.dealValue),
                icon: Icons.currency_rupee_rounded,
              ),
              _InfoRow(
                label: 'Status',
                value: widget.lead.status,
                icon: Icons.flag_outlined,
              ),
              _InfoRow(
                label: 'Priority',
                value: widget.lead.priority,
                icon: Icons.priority_high_rounded,
              ),
              _InfoRow(
                label: 'Last Contact',
                value: widget.lead.lastContact,
                icon: Icons.access_time_rounded,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Tags
          if (widget.lead.tags.isNotEmpty) ...[
            _InfoCard(
              title: 'Tags',
              icon: Icons.label_outline_rounded,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: widget.lead.tags
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
            children: [_PipelineProgress(currentStatus: widget.lead.status)],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineTab() {
    final events = [
      _TimelineEvent(
        title: 'Lead Created',
        description: 'Lead added to the system',
        time: '2 weeks ago',
        icon: Icons.add_circle_outline_rounded,
        color: AppTheme.primary,
      ),
      _TimelineEvent(
        title: 'First Contact Made',
        description: 'Called and discussed requirements',
        time: '10 days ago',
        icon: Icons.phone_rounded,
        color: AppTheme.secondary,
      ),
      _TimelineEvent(
        title: 'Status Updated',
        description: 'Moved to ${widget.lead.status} stage',
        time: '5 days ago',
        icon: Icons.update_rounded,
        color: _statusColor,
      ),
      _TimelineEvent(
        title: 'Follow-up Scheduled',
        description: 'Appointment set for next week',
        time: '2 days ago',
        icon: Icons.event_rounded,
        color: AppTheme.warning,
      ),
      _TimelineEvent(
        title: 'Last Activity',
        description: 'Sent proposal document via email',
        time: widget.lead.lastContact,
        icon: Icons.email_rounded,
        color: AppTheme.success,
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Add note field
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.surface200),
            ),
            child: Column(
              children: [
                TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Add a note...',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      color: AppTheme.textMuted,
                    ),
                    border: InputBorder.none,
                    filled: false,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Add Note',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Existing notes
          Expanded(
            child: ListView(
              children: [
                _NoteCard(
                  author: 'Priya Sharma',
                  initials: 'PS',
                  note:
                      'Customer is interested in the premium plan. Budget confirmed at ₹25L. Decision expected by end of month.',
                  time: '2 days ago',
                ),
                _NoteCard(
                  author: 'Rahul Singh',
                  initials: 'RS',
                  note:
                      'Had a detailed call. They want a demo next week. Sent calendar invite.',
                  time: '5 days ago',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
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
          Expanded(
            child: _QuickActionButton(
              icon: Icons.phone_rounded,
              label: 'Call',
              color: AppTheme.success,
              onTap: () => _showSnackBar('Calling ${widget.lead.name}...'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _QuickActionButton(
              icon: Icons.email_rounded,
              label: 'Email',
              color: AppTheme.primary,
              onTap: () =>
                  _showSnackBar('Opening email to ${widget.lead.email}...'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _QuickActionButton(
              icon: Icons.chat_rounded,
              label: 'WhatsApp',
              color: const Color(0xFF25D366),
              onTap: () =>
                  _showSnackBar('Opening WhatsApp for ${widget.lead.name}...'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _QuickActionButton(
              icon: Icons.event_rounded,
              label: 'Schedule',
              color: AppTheme.warning,
              onTap: () => _showSnackBar('Scheduling follow-up...'),
            ),
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
              onTap: () => Navigator.pop(context),
            ),
            _OptionTile(
              icon: Icons.swap_horiz_rounded,
              label: 'Change Status',
              onTap: () => Navigator.pop(context),
            ),
            _OptionTile(
              icon: Icons.person_add_rounded,
              label: 'Reassign Lead',
              onTap: () => Navigator.pop(context),
            ),
            _OptionTile(
              icon: Icons.share_rounded,
              label: 'Share Lead',
              onTap: () => Navigator.pop(context),
            ),
            _OptionTile(
              icon: Icons.delete_outline_rounded,
              label: 'Delete Lead',
              color: AppTheme.error,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Helper Widgets ───────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Column(
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
            ),
          ],
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
