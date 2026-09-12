import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class CallsPermissionScreen extends StatefulWidget {
  const CallsPermissionScreen({super.key});

  @override
  State<CallsPermissionScreen> createState() => _CallsPermissionScreenState();
}

class _CallsPermissionScreenState extends State<CallsPermissionScreen>
    with TickerProviderStateMixin {
  bool _callLogGranted = false;
  bool _whyExpanded = false;
  bool _skipWarningShown = false;

  late AnimationController _entryController;
  late AnimationController _pulseController;
  late AnimationController _iconController;
  late Animation<double> _entryFade;
  late Animation<Offset> _entrySlide;
  late Animation<double> _pulseAnim;
  late Animation<double> _iconBounce;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _entryFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOut));
    _entrySlide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
        );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _iconBounce = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _entryController.dispose();
    _pulseController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  void _requestPermission() async {
    // Simulate permission request
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _callLogGranted = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      context.go(AppRoutes.simSelectionScreen);
    }
  }

  void _showSkipWarning() {
    setState(() => _skipWarningShown = true);
    showDialog(
      context: context,
      builder: (_) => _SkipWarningDialog(
        onContinueWithLimited: () {
          Navigator.pop(context);
          context.go(AppRoutes.simSelectionScreen);
        },
        onGrantPermission: () {
          Navigator.pop(context);
          _requestPermission();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: FadeTransition(
          opacity: _entryFade,
          child: SlideTransition(
            position: _entrySlide,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 48 : 24,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 480 : double.infinity,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Step indicator (1 of 2)
                    _PermissionStepIndicator(currentStep: 0),
                    const SizedBox(height: 32),
                    // Main icon
                    Center(
                      child: ScaleTransition(
                        scale: _iconBounce,
                        child: Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppTheme.primary, Color(0xFF7C3AED)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withAlpha(60),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.phone_in_talk_rounded,
                            color: Colors.white,
                            size: 44,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Access Call Logs',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'AnbuCRM needs access to your call logs to automatically track and log your sales calls.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    // Benefit cards
                    _BenefitCard(
                      icon: Icons.auto_awesome_rounded,
                      iconColor: AppTheme.primary,
                      iconBg: AppTheme.primaryContainer,
                      title: 'Auto-Log Every Call',
                      description:
                          'Incoming, outgoing, and missed calls are automatically recorded with duration and outcome — no manual entry needed.',
                      delay: 0,
                    ),
                    const SizedBox(height: 12),
                    _BenefitCard(
                      icon: Icons.shield_outlined,
                      iconColor: AppTheme.success,
                      iconBg: AppTheme.successContainer,
                      title: 'Secure & Private',
                      description:
                          'Your call data stays on your device and is only synced to your AnbuCRM account. It is never shared with third parties.',
                      delay: 100,
                    ),
                    const SizedBox(height: 12),
                    _BenefitCard(
                      icon: Icons.insights_rounded,
                      iconColor: const Color(0xFFD97706),
                      iconBg: const Color(0xFFFEF3C7),
                      title: 'Smart Lead Insights',
                      description:
                          'Get instant context about a lead before you call — see past interactions, notes, and follow-up history.',
                      delay: 200,
                    ),
                    const SizedBox(height: 20),
                    // "Why we need this" expandable section
                    _WhyWeNeedThis(
                      expanded: _whyExpanded,
                      onToggle: () =>
                          setState(() => _whyExpanded = !_whyExpanded),
                    ),
                    const SizedBox(height: 24),
                    // Permission status
                    _PermissionStatusRow(
                      label: 'Read Call Logs',
                      granted: _callLogGranted,
                    ),
                    const SizedBox(height: 24),
                    // Allow Access button with pulse
                    AnimatedBuilder(
                      animation: _pulseAnim,
                      builder: (_, child) => Transform.scale(
                        scale: _callLogGranted ? 1.0 : _pulseAnim.value,
                        child: child,
                      ),
                      child: GestureDetector(
                        onTap: _callLogGranted ? null : _requestPermission,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: _callLogGranted
                                ? LinearGradient(
                                    colors: [
                                      AppTheme.success,
                                      const Color(0xFF059669),
                                    ],
                                  )
                                : const LinearGradient(
                                    colors: [
                                      AppTheme.primary,
                                      Color(0xFF7C3AED),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    (_callLogGranted
                                            ? AppTheme.success
                                            : AppTheme.primary)
                                        .withAlpha(70),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _callLogGranted
                                    ? Icons.check_circle_rounded
                                    : Icons.lock_open_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _callLogGranted
                                    ? 'Permission Granted!'
                                    : 'Allow Access',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Skip option
                    GestureDetector(
                      onTap: _showSkipWarning,
                      child: Center(
                        child: Text(
                          'Skip for now (limited features)',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Step Indicator ───────────────────────────────────────────────────────────

class _PermissionStepIndicator extends StatelessWidget {
  final int currentStep; // 0 = Call Logs, 1 = SIM Selection
  const _PermissionStepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _PermStepCircle(
          label: 'Call Logs',
          icon: Icons.phone_outlined,
          isActive: currentStep == 0,
          isDone: currentStep > 0,
        ),
        Expanded(
          child: Container(
            height: 2,
            margin: const EdgeInsets.only(bottom: 22),
            color: currentStep > 0 ? AppTheme.success : AppTheme.surface200,
          ),
        ),
        _PermStepCircle(
          label: 'SIM Select',
          icon: Icons.sim_card_outlined,
          isActive: currentStep == 1,
          isDone: currentStep > 1,
        ),
      ],
    );
  }
}

class _PermStepCircle extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final bool isDone;

  const _PermStepCircle({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDone
                  ? AppTheme.success
                  : isActive
                  ? AppTheme.primary
                  : AppTheme.surface200,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: AppTheme.primary.withAlpha(50),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: isDone
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 18,
                    )
                  : Icon(
                      icon,
                      size: 18,
                      color: isActive ? Colors.white : AppTheme.textMuted,
                    ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? AppTheme.primary : AppTheme.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Benefit Card ─────────────────────────────────────────────────────────────

class _BenefitCard extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String description;
  final int delay;

  const _BenefitCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.description,
    required this.delay,
  });

  @override
  State<_BenefitCard> createState() => _BenefitCardState();
}

class _BenefitCardState extends State<_BenefitCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.surface200),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.icon, color: widget.iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.description,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Why We Need This ─────────────────────────────────────────────────────────

class _WhyWeNeedThis extends StatelessWidget {
  final bool expanded;
  final VoidCallback onToggle;

  const _WhyWeNeedThis({required this.expanded, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surface200),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Icon(
                    Icons.help_outline_rounded,
                    size: 18,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Why we need this permission',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  _WhyItem(
                    icon: Icons.phone_callback_rounded,
                    text:
                        'We read call logs to automatically identify which calls are related to your CRM leads.',
                  ),
                  const SizedBox(height: 8),
                  _WhyItem(
                    icon: Icons.timer_outlined,
                    text:
                        'Call duration and timestamps help you track how much time you spend with each lead.',
                  ),
                  const SizedBox(height: 8),
                  _WhyItem(
                    icon: Icons.lock_outline_rounded,
                    text:
                        'We never upload raw call logs to any server. Only matched lead interactions are synced.',
                  ),
                  const SizedBox(height: 8),
                  _WhyItem(
                    icon: Icons.settings_outlined,
                    text:
                        'You can revoke this permission at any time from your device settings.',
                  ),
                ],
              ),
            ),
            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}

class _WhyItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _WhyItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppTheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Permission Status Row ────────────────────────────────────────────────────

class _PermissionStatusRow extends StatelessWidget {
  final String label;
  final bool granted;

  const _PermissionStatusRow({required this.label, required this.granted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: granted ? AppTheme.successContainer : AppTheme.surface100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: granted ? AppTheme.success.withAlpha(60) : AppTheme.surface200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.phone_outlined,
            size: 18,
            color: granted ? AppTheme.success : AppTheme.textSecondary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: granted ? AppTheme.success : AppTheme.textPrimary,
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: granted
                ? const Icon(
                    Icons.check_circle_rounded,
                    color: AppTheme.success,
                    size: 20,
                    key: ValueKey('granted'),
                  )
                : Container(
                    key: const ValueKey('pending'),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surface200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Pending',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Skip Warning Dialog ──────────────────────────────────────────────────────

class _SkipWarningDialog extends StatelessWidget {
  final VoidCallback onContinueWithLimited;
  final VoidCallback onGrantPermission;

  const _SkipWarningDialog({
    required this.onContinueWithLimited,
    required this.onGrantPermission,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFD97706),
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Limited Functionality',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Without call log access, the following features will be disabled:',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            ...[
              'Auto call logging',
              'Call duration tracking',
              'Missed call alerts',
              'Call-based lead insights',
            ].map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(
                      Icons.cancel_outlined,
                      size: 16,
                      color: AppTheme.error,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      f,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: onGrantPermission,
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primary, Color(0xFF7C3AED)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Grant Permission',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: onContinueWithLimited,
              child: Text(
                'Continue with limited features',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
