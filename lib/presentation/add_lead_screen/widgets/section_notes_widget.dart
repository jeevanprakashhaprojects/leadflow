import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class SectionNotesWidget extends StatefulWidget {
  const SectionNotesWidget({super.key});

  @override
  State<SectionNotesWidget> createState() => _SectionNotesWidgetState();
}

class _SectionNotesWidgetState extends State<SectionNotesWidget> {
  final _notesCtrl = TextEditingController();
  final _remarksCtrl = TextEditingController();
  final _planCtrl = TextEditingController();
  bool _showAgentRemarks = false;
  static const int _maxChars = 500;

  @override
  void dispose() {
    _notesCtrl.dispose();
    _remarksCtrl.dispose();
    _planCtrl.dispose();
    super.dispose();
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
        // AI assist + voice buttons
        Row(
          children: [
            _ActionButton(
              icon: Icons.auto_awesome_rounded,
              label: 'AI Assist',
              color: AppTheme.primary,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('AI suggestions coming soon'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            _ActionButton(
              icon: Icons.mic_rounded,
              label: 'Voice Input',
              color: AppTheme.error,
              onTap: () {},
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

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withAlpha(26),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withAlpha(77)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
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
