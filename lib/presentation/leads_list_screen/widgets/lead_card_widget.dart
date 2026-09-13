import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/status_badge_widget.dart';
import '../leads_list_screen.dart';
import 'package:go_router/go_router.dart';
import '../../../routes/app_routes.dart';

class LeadCardWidget extends StatefulWidget {
  final LeadModel lead;
  final int index;
  final VoidCallback? onRemove;

  const LeadCardWidget({
    super.key,
    required this.lead,
    required this.index,
    this.onRemove,
  });

  @override
  State<LeadCardWidget> createState() => _LeadCardWidgetState();
}

class _LeadCardWidgetState extends State<LeadCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnim = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    );
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutCubic,
          ),
        );

    Future.delayed(
      Duration(milliseconds: (widget.index * 60).clamp(0, 400)),
      () {
        if (mounted) _entranceController.forward();
      },
    );
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  String _formatDealValue(double value) {
    if (value >= 10000000) return '₹${(value / 10000000).toStringAsFixed(1)}Cr';
    if (value >= 100000) return '₹${(value / 100000).toStringAsFixed(1)}L';
    if (value >= 1000) return '₹${(value / 1000).toStringAsFixed(0)}K';
    return '₹${value.toStringAsFixed(0)}';
  }

  Color _priorityColor(String p) => AppTheme.priorityColor(p);

  @override
  Widget build(BuildContext context) {
    final lead = widget.lead;
    final statusColor = AppTheme.leadStatusColor(lead.status);
    final priorityColor = _priorityColor(lead.priority);

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Dismissible(
          key: Key(lead.id),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.error,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            child: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          confirmDismiss: (_) async {
            return await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Text(
                      'Remove Lead',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    content: Text(
                      'Remove ${lead.name} from your pipeline?',
                      style: GoogleFonts.plusJakartaSans(fontSize: 14),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.error,
                        ),
                        child: const Text('Remove'),
                      ),
                    ],
                  ),
                ) ??
                false;
          },
          onDismissed: (_) => widget.onRemove?.call(),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border(left: BorderSide(color: priorityColor, width: 3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: InkWell(
              onTap: () => context.go(AppRoutes.leadDetailScreen, extra: lead),
              borderRadius: BorderRadius.circular(16),
              splashColor: AppTheme.primaryContainer.withAlpha(128),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: priority badge + status + last contact
                    Row(
                      children: [
                        StatusBadgeWidget(
                          label: lead.priority,
                          color: priorityColor,
                        ),
                        const SizedBox(width: 8),
                        StatusBadgeWidget(
                          label: lead.status,
                          color: statusColor,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 12,
                              color: AppTheme.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              lead.lastContact,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Name + company
                    Text(
                      lead.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.business_rounded,
                          size: 12,
                          color: AppTheme.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            lead.company,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: const BoxDecoration(
                            color: AppTheme.textMuted,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          lead.industry,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Bottom row: deal value + tags + owner avatar (tappable) + actions
                    Row(
                      children: [
                        Text(
                          _formatDealValue(lead.dealValue),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (lead.tags.contains('VIP'))
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'VIP',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFB45309),
                              ),
                            ),
                          ),
                        const Spacer(),
                        // Owner avatar — taps to employee details
                        GestureDetector(
                          onTap: () => _showOwnerDetails(context),
                          child: Tooltip(
                            message: lead.ownerName,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: AppTheme.primaryContainer,
                              child: Text(
                                lead.ownerInitials,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(
                            Icons.more_vert_rounded,
                            size: 18,
                            color: AppTheme.textMuted,
                          ),
                          onPressed: () => _showLeadActions(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          tooltip: 'Lead actions',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showOwnerDetails(BuildContext context) {
    // Navigate to employee details — show a bottom sheet with owner info
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppTheme.surface200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            CircleAvatar(
              radius: 36,
              backgroundColor: AppTheme.primaryContainer,
              child: Text(
                widget.lead.ownerInitials,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.lead.ownerName,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _getOwnerRole(widget.lead.ownerInitials),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _OwnerStatItem(label: 'Leads', value: '12'),
                _OwnerStatItem(label: 'Won', value: '4'),
                _OwnerStatItem(label: 'Rate', value: '33%'),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.pop(ctx),
                icon: const Icon(Icons.person_rounded, size: 18),
                label: Text(
                  'View Full Profile',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getOwnerRole(String initials) {
    switch (initials) {
      case 'PS':
        return 'Admin · ADM-1042';
      case 'RS':
        return 'Senior Rep · EMP-2031';
      case 'AP':
        return 'Manager · EMP-1187';
      case 'KM':
        return 'Sales Rep · EMP-3045';
      default:
        return 'Employee';
    }
  }

  void _showLeadActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) =>
          _LeadActionsSheet(lead: widget.lead, onRemove: widget.onRemove),
    );
  }
}

class _OwnerStatItem extends StatelessWidget {
  final String label;
  final String value;
  const _OwnerStatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppTheme.primary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _LeadActionsSheet extends StatelessWidget {
  final LeadModel lead;
  final VoidCallback? onRemove;
  const _LeadActionsSheet({required this.lead, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppTheme.surface200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              lead.name,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              lead.company,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            _ActionTile(Icons.edit_outlined, 'Edit Lead', AppTheme.primary, () {
              Navigator.pop(context);
              context.go(AppRoutes.addLeadScreen);
            }),
            _ActionTile(
              Icons.phone_outlined,
              'Call ${lead.name.split(' ')[0]}',
              AppTheme.success,
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Calling ${lead.name} at ${lead.phone}...',
                      style: GoogleFonts.plusJakartaSans(fontSize: 13),
                    ),
                    backgroundColor: AppTheme.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
            _ActionTile(
              Icons.schedule_rounded,
              'Schedule Follow-up',
              AppTheme.warning,
              () {
                Navigator.pop(context);
                _showScheduleDialog(context);
              },
            ),
            _ActionTile(
              Icons.swap_horiz_rounded,
              'Change Status',
              AppTheme.secondary,
              () {
                Navigator.pop(context);
                _showChangeStatusDialog(context);
              },
            ),
            _ActionTile(
              Icons.delete_outline_rounded,
              'Remove Lead',
              AppTheme.error,
              () {
                Navigator.pop(context);
                _showDeleteConfirmation(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showScheduleDialog(BuildContext context) {
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
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 4,
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
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
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
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
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
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '$selectedType scheduled for ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      style: GoogleFonts.plusJakartaSans(fontSize: 13),
                    ),
                    backgroundColor: AppTheme.warning,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              style: FilledButton.styleFrom(backgroundColor: AppTheme.primary),
              child: const Text('Schedule'),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangeStatusDialog(BuildContext context) {
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
            final isCurrent = s == lead.status;
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Status changed to $s',
                      style: GoogleFonts.plusJakartaSans(fontSize: 13),
                    ),
                    backgroundColor: color,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Remove Lead',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Remove ${lead.name} from your pipeline? This cannot be undone.',
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
              onRemove?.call();
            },
            style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile(this.icon, this.label, this.color, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withAlpha(26),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
