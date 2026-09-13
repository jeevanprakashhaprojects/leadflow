import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import './widgets/section_address_widget.dart';
import './widgets/section_company_info_widget.dart';
import './widgets/section_contact_info_widget.dart';
import './widgets/section_interests_widget.dart';
import './widgets/section_lead_details_widget.dart';
import './widgets/section_notes_widget.dart';
import './widgets/section_relations_widget.dart';
import './widgets/section_social_widget.dart';
import './widgets/tablet_step_sidebar_widget.dart';
import './widgets/wizard_bottom_bar_widget.dart';
import './widgets/wizard_progress_fab_widget.dart';
import './widgets/wizard_step_indicator_widget.dart';

class AddLeadScreen extends StatefulWidget {
  const AddLeadScreen({super.key});

  @override
  State<AddLeadScreen> createState() => _AddLeadScreenState();
}

class _AddLeadScreenState extends State<AddLeadScreen> {
  int _currentStep = 0;
  bool _isSaving = false;
  String _autoSaveStatus = '';
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Expandable section states
  final List<bool> _sectionExpanded = List.filled(8, true);

  static const List<WizardStep> _steps = [
    WizardStep('Contact Info', Icons.person_outline_rounded),
    WizardStep('Business Details', Icons.business_outlined),
    WizardStep('Lead Details', Icons.trending_up_rounded),
    WizardStep('Address', Icons.location_on_outlined),
    WizardStep('Social', Icons.share_outlined),
    WizardStep('Notes', Icons.notes_rounded),
    WizardStep('Interests', Icons.star_outline_rounded),
    WizardStep('Relations', Icons.group_outlined),
  ];

  // Completion state per step — only true when compulsory fields are filled
  final List<bool> _stepCompleted = List.filled(8, false);

  // Track field fill counts per section for progress calculation
  // [filledFields, totalCompulsoryFields]
  final List<List<int>> _sectionProgress = [
    [
      0,
      3,
    ], // Contact Info: firstName + primaryMobile + primaryEmail (3 compulsory)
    [0, 0], // Business Details: fully optional
    [0, 1], // Lead Details: scheduledAction only (amount not compulsory)
    [0, 0], // Address: fully optional
    [0, 0], // Social: optional
    [0, 0], // Notes: optional
    [0, 0], // Interests: optional
    [0, 0], // Relations: optional
  ];

  // Unique form key to force rebuild/clear on discard
  Key _formInstanceKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _scheduleAutoSave();
  }

  void _updateSectionProgress(int sectionIndex, int filledCount) {
    setState(() {
      _sectionProgress[sectionIndex][0] = filledCount;
      _stepCompleted[sectionIndex] =
          filledCount >= _sectionProgress[sectionIndex][1];
    });
  }

  double get _overallProgress {
    int totalFilled = 0;
    int totalRequired = 0;
    for (final p in _sectionProgress) {
      totalFilled += p[0];
      totalRequired += p[1];
    }
    if (totalRequired == 0) return 0;
    return (totalFilled / totalRequired).clamp(0.0, 1.0);
  }

  void _scheduleAutoSave() async {
    await Future.delayed(const Duration(seconds: 30));
    if (mounted) {
      setState(() => _autoSaveStatus = 'Saved ✓');
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) setState(() => _autoSaveStatus = '');
      _scheduleAutoSave();
    }
  }

  /// Step tap: only allow navigating to already-completed steps or current step.
  /// Cannot skip ahead to a step that hasn't been reached yet.
  void _onStepTap(int index) {
    // Can only go to current step or any previously completed/visited step
    if (index > _currentStep) {
      // Check if all steps between current and target are completed
      for (int i = _currentStep; i < index; i++) {
        if (_sectionProgress[i][1] > 0 && !_stepCompleted[i]) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Complete "${_steps[i].label}" first before jumping ahead.',
                      style: GoogleFonts.plusJakartaSans(fontSize: 13),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppTheme.warning,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          return;
        }
      }
    }
    setState(() {
      _currentStep = index;
      _sectionExpanded[index] = true;
    });
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _onContinue() {
    // Check if current section's compulsory fields are filled
    if (_sectionProgress[_currentStep][1] > 0 &&
        _sectionProgress[_currentStep][0] < _sectionProgress[_currentStep][1]) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_rounded, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Please fill all required fields in ${_steps[_currentStep].label} before continuing.',
                  style: GoogleFonts.plusJakartaSans(fontSize: 13),
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    if (_currentStep < _steps.length - 1) {
      setState(() {
        _stepCompleted[_currentStep] = true;
        _currentStep++;
        _sectionExpanded[_currentStep] = true;
      });
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    } else {
      _onSubmit();
    }
  }

  void _onBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      _confirmDiscard();
    }
  }

  void _confirmDiscard() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Discard Lead?',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'All entered data will be cleared. Are you sure you want to discard?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.plusJakartaSans(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _clearAndExit();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Discard',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _clearAndExit() {
    // Reset all state
    setState(() {
      _currentStep = 0;
      _formInstanceKey = UniqueKey();
      for (int i = 0; i < _stepCompleted.length; i++) {
        _stepCompleted[i] = false;
      }
      for (int i = 0; i < _sectionProgress.length; i++) {
        _sectionProgress[i][0] = 0;
      }
      for (int i = 0; i < _sectionExpanded.length; i++) {
        _sectionExpanded[i] = true;
      }
    });

    context.go(AppRoutes.leadsListScreen);
  }

  Future<void> _onSubmit() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              const Text('Lead created successfully!'),
            ],
          ),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      _clearAndExit();
    }
  }

  Widget _buildSectionContent(int index) {
    switch (index) {
      case 0:
        return SectionContactInfoWidget(
          onCompulsoryChanged: (filled) => _updateSectionProgress(0, filled),
        );
      case 1:
        return SectionCompanyInfoWidget(
          onCompulsoryChanged: (filled) => _updateSectionProgress(1, filled),
        );
      case 2:
        return SectionLeadDetailsWidget(
          onCompulsoryChanged: (filled) => _updateSectionProgress(2, filled),
        );
      case 3:
        return const SectionAddressWidget();
      case 4:
        return const SectionSocialWidget();
      case 5:
        return const SectionNotesWidget();
      case 6:
        return const SectionInterestsWidget();
      case 7:
        return const SectionRelationsWidget();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 768;
    final theme = Theme.of(context);

    if (isTablet) {
      return _buildTabletLayout(theme);
    }
    return _buildPhoneLayout(theme);
  }

  Widget _buildPhoneLayout(ThemeData theme) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceLight,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _onBack,
          tooltip: 'Back',
        ),
        title: Text(
          'Add New Lead',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_autoSaveStatus.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: Text(
                  _autoSaveStatus,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppTheme.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          TextButton(
            onPressed: _confirmDiscard,
            child: Text(
              'Discard',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppTheme.error,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Step indicator (no flat progress bar)
            WizardStepIndicatorWidget(
              steps: _steps.map((s) => s.label).toList(),
              currentStep: _currentStep,
              completedSteps: _stepCompleted,
              onStepTap: _onStepTap,
            ),
            // Section content
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0.04, 0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                      child: child,
                    ),
                  ),
                  child: KeyedSubtree(
                    key: ValueKey('${_formInstanceKey}_$_currentStep'),
                    child: _buildSectionCard(_currentStep),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: WizardProgressFabWidget(
        currentStep: _currentStep,
        totalSteps: _steps.length,
        completedSteps: _stepCompleted,
        overallProgress: _overallProgress,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: WizardBottomBarWidget(
        currentStep: _currentStep,
        totalSteps: _steps.length,
        stepLabel: _steps[_currentStep].label,
        isLastStep: _currentStep == _steps.length - 1,
        isSaving: _isSaving,
        onBack: _onBack,
        onContinue: _onContinue,
      ),
    );
  }

  Widget _buildTabletLayout(ThemeData theme) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceLight,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => _confirmDiscard(),
          tooltip: 'Back',
        ),
        title: Text(
          'Add New Lead',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_autoSaveStatus.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: Text(
                  _autoSaveStatus,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppTheme.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          TextButton(
            onPressed: _confirmDiscard,
            child: Text(
              'Discard',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppTheme.error,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          TabletStepSidebarWidget(
            steps: _steps,
            currentStep: _currentStep,
            completedSteps: _stepCompleted,
            onStepTap: _onStepTap,
          ),
          Container(width: 1, color: AppTheme.surface200),
          Expanded(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(24),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        transitionBuilder: (child, animation) =>
                            FadeTransition(opacity: animation, child: child),
                        child: KeyedSubtree(
                          key: ValueKey('${_formInstanceKey}_$_currentStep'),
                          child: _buildSectionCard(_currentStep),
                        ),
                      ),
                    ),
                  ),
                  WizardBottomBarWidget(
                    currentStep: _currentStep,
                    totalSteps: _steps.length,
                    stepLabel: _steps[_currentStep].label,
                    isLastStep: _currentStep == _steps.length - 1,
                    isSaving: _isSaving,
                    onBack: _onBack,
                    onContinue: _onContinue,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(int index) {
    final isCompleted = _stepCompleted[index];
    final progress = _sectionProgress[index];
    final hasRequired = progress[1] > 0;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          InkWell(
            onTap: () => setState(
              () => _sectionExpanded[index] = !_sectionExpanded[index],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppTheme.success
                          : AppTheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: isCompleted
                        ? const Icon(
                            Icons.check_rounded,
                            size: 18,
                            color: Colors.white,
                          )
                        : Center(
                            child: Text(
                              '${index + 1}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _steps[index].label,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        if (hasRequired)
                          Text(
                            '${progress[0]}/${progress[1]} required fields filled',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: isCompleted
                                  ? AppTheme.success
                                  : AppTheme.textMuted,
                            ),
                          ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _sectionExpanded[index] ? 0 : -0.5,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Section content
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: _sectionExpanded[index]
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    child: _buildSectionContent(index),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
