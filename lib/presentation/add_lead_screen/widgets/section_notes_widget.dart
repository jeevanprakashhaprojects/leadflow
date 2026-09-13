import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class SectionNotesWidget extends StatefulWidget {
  const SectionNotesWidget({super.key});

  @override
  State<SectionNotesWidget> createState() => _SectionNotesWidgetState();
}

class _SectionNotesWidgetState extends State<SectionNotesWidget>
    with SingleTickerProviderStateMixin {
  final _notesCtrl = TextEditingController();
  final _remarksCtrl = TextEditingController();
  final _planCtrl = TextEditingController();
  bool _showAgentRemarks = false;
  bool _isRecording = false;
  static const int _maxChars = 500;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    _remarksCtrl.dispose();
    _planCtrl.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleVoiceRecording() {
    setState(() => _isRecording = !_isRecording);
    if (_isRecording) {
      _pulseController.repeat(reverse: true);
      // Simulate voice recording — in production integrate speech_to_text package
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && _isRecording) {
          _stopRecording();
        }
      });
    } else {
      _stopRecording();
    }
  }

  void _stopRecording() {
    _pulseController.stop();
    _pulseController.reset();
    setState(() => _isRecording = false);
    // Append placeholder transcription text
    final existing = _notesCtrl.text;
    final appended = existing.isEmpty
        ? '[Voice note recorded]'
        : '$existing [Voice note recorded]';
    _notesCtrl.text = appended;
    _notesCtrl.selection = TextSelection.fromPosition(
      TextPosition(offset: _notesCtrl.text.length),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.mic_rounded, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              'Voice note saved to notes',
              style: GoogleFonts.plusJakartaSans(fontSize: 13),
            ),
          ],
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final charCount = _notesCtrl.text.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Notes textarea
        TextFormField(
          controller: _notesCtrl,
          maxLines: 6,
          maxLength: _maxChars,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: 'Notes',
            alignLabelWithHint: true,
            hintText:
                'Add notes about this lead... Use @name to mention a colleague',
            counterText: '${_notesCtrl.text.length}/$_maxChars',
            counterStyle: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: charCount > _maxChars * 0.9
                  ? AppTheme.error
                  : AppTheme.textMuted,
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        // Voice input button only (AI assist removed)
        Row(
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) => Transform.scale(
                scale: _isRecording ? _pulseAnimation.value : 1.0,
                child: child,
              ),
              child: InkWell(
                onTap: _toggleVoiceRecording,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: _isRecording
                        ? AppTheme.error.withAlpha(26)
                        : AppTheme.primary.withAlpha(26),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _isRecording
                          ? AppTheme.error.withAlpha(128)
                          : AppTheme.primary.withAlpha(77),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isRecording
                            ? Icons.stop_circle_rounded
                            : Icons.mic_rounded,
                        size: 16,
                        color: _isRecording ? AppTheme.error : AppTheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _isRecording ? 'Stop Recording' : 'Voice Input',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _isRecording
                              ? AppTheme.error
                              : AppTheme.primary,
                        ),
                      ),
                      if (_isRecording) ...[
                        const SizedBox(width: 6),
                        _RecordingDot(),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Agent remarks (private)
        GestureDetector(
          onTap: () => setState(() => _showAgentRemarks = !_showAgentRemarks),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.surface100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.surface200),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Agent Remarks (Private)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const Spacer(),
                AnimatedRotation(
                  turns: _showAgentRemarks ? 0.5 : 0,
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
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: _showAgentRemarks
              ? Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _remarksCtrl,
                        maxLines: 4,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          labelText: 'Private Remarks',
                          alignLabelWithHint: true,
                          hintText: 'Internal notes — not visible to lead',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _planCtrl,
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          labelText: 'Plan Suggested',
                          alignLabelWithHint: true,
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(bottom: 40),
                            child: Icon(
                              Icons.lightbulb_outline_rounded,
                              size: 18,
                              color: AppTheme.warning,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

/// Animated red dot shown while recording
class _RecordingDot extends StatefulWidget {
  @override
  State<_RecordingDot> createState() => _RecordingDotState();
}

class _RecordingDotState extends State<_RecordingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: AppTheme.error,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
