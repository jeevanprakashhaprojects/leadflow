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

// TODO: Replace with [Riverpod/Bloc] for production
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
    WizardStep('Company', Icons.business_outlined),
    WizardStep('Lead Details', Icons.trending_up_rounded),
    WizardStep('Address', Icons.location_on_outlined),
    WizardStep('Social', Icons.share_outlined),
    WizardStep('Notes', Icons.notes_rounded),
    WizardStep('Interests', Icons.star_outline_rounded),
    WizardStep('Relations', Icons.group_outlined),
  ];

  // Completion state per step
  final List<bool> _stepCompleted = List.filled(8, false);

  @override
  void initState() {
    super.initState();
    _scheduleAutoSave();
  }

  void _scheduleAutoSave() async {
    // TODO: Replace with [Riverpod/Bloc] auto-save timer
    await Future.delayed(const Duration(seconds: 30));
    if (mounted) {
      setState(() => _autoSaveStatus = 'Saved ✓');
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) setState(() => _autoSaveStatus = '');
      _scheduleAutoSave();
    }
  }

  void _onStepTap(int index) {
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
      context.go(AppRoutes.leadsListScreen);
    }
  }

  Future<void> _onSubmit() async {
    setState(() => _isSaving = true);
    // TODO: Replace with [Riverpod/Bloc] submit handler
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
      context.go(AppRoutes.leadsListScreen);
    }
  }

  Widget _buildSectionContent(int index) {
    switch (index) {
      case 0:
        return const SectionContactInfoWidget();
      case 1:
        return const SectionCompanyInfoWidget();
      case 2:
        return const SectionLeadDetailsWidget();
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
            onPressed: () => context.go(AppRoutes.leadsListScreen),
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
            // Step indicator
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
                    key: ValueKey(_currentStep),
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
          onPressed: () => context.go(AppRoutes.leadsListScreen),
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
            onPressed: () => context.go(AppRoutes.leadsListScreen),
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
          // Left sidebar
          TabletStepSidebarWidget(
            steps: _steps,
            currentStep: _currentStep,
            completedSteps: _stepCompleted,
            onStepTap: _onStepTap,
          ),
          // Divider
          Container(width: 1, color: AppTheme.surface200),
          // Right content
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
                          key: ValueKey(_currentStep),
                          child: _buildSectionCard(_currentStep),
                        ),
                      ),
                    ),
                  ),
                  // Bottom bar
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
                      color: _stepCompleted[index]
                          ? AppTheme.success
                          : AppTheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _stepCompleted[index]
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
                  Text(
                    _steps[index].label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
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
