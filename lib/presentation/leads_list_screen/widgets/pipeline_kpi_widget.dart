import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../leads_list_screen.dart';

class PipelineKpiWidget extends StatelessWidget {
  final List<LeadModel> leads;
  const PipelineKpiWidget({super.key, required this.leads});

  String _formatValue(double value) {
    if (value >= 10000000) return '₹${(value / 10000000).toStringAsFixed(1)}Cr';
    if (value >= 100000) return '₹${(value / 100000).toStringAsFixed(1)}L';
    if (value >= 1000) return '₹${(value / 1000).toStringAsFixed(0)}K';
    return '₹${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final totalLeads = leads.length;
    final pipelineValue = leads
        .where((l) => !['Won', 'Lost', 'Junk'].contains(l.status))
        .fold(0.0, (sum, l) => sum + l.dealValue);
    final qualified = leads.where((l) => l.status == 'Qualified').length;
    final convRate = totalLeads > 0
        ? ((leads.where((l) => l.status == 'Won').length / totalLeads) * 100)
              .toStringAsFixed(0)
        : '0';
    final followUps = leads.where((l) => l.status == 'Contacted').length;

    final kpis = [
      _KpiData(
        label: 'Total Leads',
        value: '$totalLeads',
        icon: Icons.people_rounded,
        color: AppTheme.primary,
        trend: '+12%',
        trendUp: true,
      ),
      _KpiData(
        label: 'Pipeline',
        value: _formatValue(pipelineValue),
        icon: Icons.account_balance_wallet_rounded,
        color: AppTheme.secondary,
        trend: '+8%',
        trendUp: true,
      ),
      _KpiData(
        label: 'Win Rate',
        value: '$convRate%',
        icon: Icons.emoji_events_rounded,
        color: AppTheme.success,
        trend: '-2%',
        trendUp: false,
      ),
      _KpiData(
        label: 'Follow-ups',
        value: '$followUps',
        icon: Icons.schedule_rounded,
        color: AppTheme.warning,
        trend: '$followUps due',
        trendUp: false,
      ),
    ];

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: kpis.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) => _KpiCard(data: kpis[i]),
      ),
    );
  }
}

class _KpiData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;
  final bool trendUp;
  const _KpiData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.trend,
    required this.trendUp,
  });
}

class _KpiCard extends StatelessWidget {
  final _KpiData data;
  const _KpiCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: data.color.withAlpha(31),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(data.icon, size: 14, color: data.color),
              ),
              Row(
                children: [
                  Icon(
                    data.trendUp
                        ? Icons.trending_up_rounded
                        : Icons.trending_down_rounded,
                    size: 11,
                    color: data.trendUp ? AppTheme.success : AppTheme.warning,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    data.trend,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: data.trendUp ? AppTheme.success : AppTheme.warning,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            data.value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 2),
          Text(
            data.label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
