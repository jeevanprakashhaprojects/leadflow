import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_skeleton_widget.dart';
import './widgets/lead_card_widget.dart';
import './widgets/lead_filter_bar_widget.dart';
import './widgets/pipeline_kpi_widget.dart';

// Global leads list so new leads added from AddLeadScreen appear immediately
final List<Map<String, dynamic>> globalLeadMaps = [
  {
    'id': '1',
    'name': 'Priya Sharma',
    'company': 'Infosys Ltd.',
    'status': 'Qualified',
    'priority': 'High',
    'score': 82,
    'dealValue': 2500000.0,
    'ownerInitials': 'RS',
    'ownerName': 'Rahul Singh',
    'lastContact': '2h ago',
    'phone': '+91 98765 43210',
    'email': 'priya.sharma@infosys.com',
    'industry': 'Technology',
    'tags': ['VIP', 'Follow-up'],
  },
  {
    'id': '2',
    'name': 'Mohammed Al-Rashid',
    'company': 'Tata Consultancy',
    'status': 'Proposal',
    'priority': 'High',
    'score': 91,
    'dealValue': 7500000.0,
    'ownerInitials': 'AP',
    'ownerName': 'Ananya Patel',
    'lastContact': '1d ago',
    'phone': '+91 87654 32109',
    'email': 'm.alrashid@tcs.com',
    'industry': 'IT Services',
    'tags': ['VIP', 'Urgent'],
  },
  {
    'id': '3',
    'name': 'Sunita Reddy',
    'company': 'Wipro Technologies',
    'status': 'Contacted',
    'priority': 'Medium',
    'score': 55,
    'dealValue': 1200000.0,
    'ownerInitials': 'KM',
    'ownerName': 'Kavya Menon',
    'lastContact': '3d ago',
    'phone': '+91 76543 21098',
    'email': 'sunita.r@wipro.com',
    'industry': 'Technology',
    'tags': ['Follow-up'],
  },
  {
    'id': '4',
    'name': 'Arjun Mehta',
    'company': 'HCL Technologies',
    'status': 'New',
    'priority': 'Low',
    'score': 32,
    'dealValue': 500000.0,
    'ownerInitials': 'RS',
    'ownerName': 'Rahul Singh',
    'lastContact': '5d ago',
    'phone': '+91 65432 10987',
    'email': 'arjun.m@hcl.com',
    'industry': 'Technology',
    'tags': [],
  },
  {
    'id': '5',
    'name': 'Fatima Nair',
    'company': 'Reliance Industries',
    'status': 'Negotiation',
    'priority': 'High',
    'score': 78,
    'dealValue': 15000000.0,
    'ownerInitials': 'AP',
    'ownerName': 'Ananya Patel',
    'lastContact': '6h ago',
    'phone': '+91 54321 09876',
    'email': 'f.nair@ril.com',
    'industry': 'Conglomerate',
    'tags': ['VIP', 'Urgent'],
  },
  {
    'id': '6',
    'name': 'Vikram Joshi',
    'company': 'HDFC Bank',
    'status': 'Won',
    'priority': 'Medium',
    'score': 95,
    'dealValue': 3200000.0,
    'ownerInitials': 'KM',
    'ownerName': 'Kavya Menon',
    'lastContact': '2d ago',
    'phone': '+91 43210 98765',
    'email': 'vikram.j@hdfc.com',
    'industry': 'Banking',
    'tags': ['VIP'],
  },
  {
    'id': '7',
    'name': 'Lakshmi Iyer',
    'company': 'Bajaj Finance',
    'status': 'Lost',
    'priority': 'Low',
    'score': 18,
    'dealValue': 800000.0,
    'ownerInitials': 'RS',
    'ownerName': 'Rahul Singh',
    'lastContact': '7d ago',
    'phone': '+91 32109 87654',
    'email': 'lakshmi.i@bajaj.com',
    'industry': 'Finance',
    'tags': [],
  },
  {
    'id': '8',
    'name': 'Rohan Kapoor',
    'company': 'Mahindra Group',
    'status': 'Qualified',
    'priority': 'Medium',
    'score': 67,
    'dealValue': 4500000.0,
    'ownerInitials': 'AP',
    'ownerName': 'Ananya Patel',
    'lastContact': '4h ago',
    'phone': '+91 21098 76543',
    'email': 'rohan.k@mahindra.com',
    'industry': 'Automotive',
    'tags': ['Follow-up'],
  },
  {
    'id': '9',
    'name': 'Deepika Verma',
    'company': 'Zomato Ltd.',
    'status': 'Contacted',
    'priority': 'Medium',
    'score': 44,
    'dealValue': 650000.0,
    'ownerInitials': 'KM',
    'ownerName': 'Kavya Menon',
    'lastContact': '2d ago',
    'phone': '+91 10987 65432',
    'email': 'd.verma@zomato.com',
    'industry': 'Food Tech',
    'tags': [],
  },
  {
    'id': '10',
    'name': 'Sameer Khan',
    'company': 'Paytm',
    'status': 'New',
    'priority': 'Low',
    'score': 22,
    'dealValue': 300000.0,
    'ownerInitials': 'RS',
    'ownerName': 'Rahul Singh',
    'lastContact': '1w ago',
    'phone': '+91 09876 54321',
    'email': 's.khan@paytm.com',
    'industry': 'Fintech',
    'tags': [],
  },
];

// TODO: Replace with [Riverpod/Bloc] for production
class LeadsListScreen extends StatefulWidget {
  const LeadsListScreen({super.key});

  @override
  State<LeadsListScreen> createState() => _LeadsListScreenState();
}

enum _SortOption {
  nameAZ,
  nameZA,
  dealValueHigh,
  dealValueLow,
  dateNewest,
  dateOldest,
  priorityHigh,
}

class _LeadsListScreenState extends State<LeadsListScreen> {
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedFilter = 'All';
  bool _isSearchActive = false;
  _SortOption _sortOption = _SortOption.dateNewest;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  List<LeadModel> _leads = [];

  @override
  void initState() {
    super.initState();
    _loadLeads();
  }

  Future<void> _loadLeads() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _leads = globalLeadMaps.map(LeadModel.fromMap).toList();
        _isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _leads = globalLeadMaps.map(LeadModel.fromMap).toList();
        _isLoading = false;
      });
    }
  }

  void removeLead(String id) {
    setState(() {
      _leads.removeWhere((l) => l.id == id);
      globalLeadMaps.removeWhere((m) => m['id'] == id);
    });
  }

  List<LeadModel> get _filteredLeads {
    List<LeadModel> result = _leads.where((lead) {
      final matchesFilter =
          _selectedFilter == 'All' || lead.status == _selectedFilter;
      final matchesSearch =
          _searchQuery.isEmpty ||
          lead.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          lead.company.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();

    // Apply sort
    switch (_sortOption) {
      case _SortOption.nameAZ:
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
      case _SortOption.nameZA:
        result.sort((a, b) => b.name.compareTo(a.name));
        break;
      case _SortOption.dealValueHigh:
        result.sort((a, b) => b.dealValue.compareTo(a.dealValue));
        break;
      case _SortOption.dealValueLow:
        result.sort((a, b) => a.dealValue.compareTo(b.dealValue));
        break;
      case _SortOption.priorityHigh:
        const order = {'High': 0, 'Medium': 1, 'Low': 2};
        result.sort(
          (a, b) => (order[a.priority] ?? 1).compareTo(order[b.priority] ?? 1),
        );
        break;
      case _SortOption.dateNewest:
      case _SortOption.dateOldest:
        // Keep original order (newest first by default, reverse for oldest)
        if (_sortOption == _SortOption.dateOldest) {
          result = result.reversed.toList();
        }
        break;
    }
    return result;
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
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
                'Sort Leads',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ...[
                (
                  _SortOption.dateNewest,
                  Icons.calendar_today_rounded,
                  'Newest First',
                ),
                (
                  _SortOption.dateOldest,
                  Icons.calendar_today_outlined,
                  'Oldest First',
                ),
                (_SortOption.nameAZ, Icons.sort_by_alpha_rounded, 'Name A → Z'),
                (_SortOption.nameZA, Icons.sort_by_alpha_rounded, 'Name Z → A'),
                (
                  _SortOption.dealValueHigh,
                  Icons.trending_up_rounded,
                  'Deal Value: High → Low',
                ),
                (
                  _SortOption.dealValueLow,
                  Icons.trending_down_rounded,
                  'Deal Value: Low → High',
                ),
                (
                  _SortOption.priorityHigh,
                  Icons.priority_high_rounded,
                  'Priority: High First',
                ),
              ].map((item) {
                final (opt, icon, label) = item;
                final isSelected = _sortOption == opt;
                return ListTile(
                  dense: true,
                  leading: Icon(
                    icon,
                    size: 20,
                    color: isSelected
                        ? AppTheme.primary
                        : AppTheme.textSecondary,
                  ),
                  title: Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.textPrimary,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          color: AppTheme.primary,
                          size: 18,
                        )
                      : null,
                  onTap: () {
                    setState(() => _sortOption = opt);
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: AppTheme.primary,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 0,
              floating: true,
              snap: true,
              backgroundColor: AppTheme.backgroundLight,
              elevation: 0,
              scrolledUnderElevation: 1,
              shadowColor: AppTheme.surface200,
              title: _isSearchActive
                  ? TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search leads, companies...',
                        hintStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: AppTheme.textMuted,
                        ),
                        border: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        color: AppTheme.textPrimary,
                      ),
                      onChanged: (v) => setState(() => _searchQuery = v),
                    )
                  : Text(
                      'Leads',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
              actions: [
                IconButton(
                  icon: Icon(
                    _isSearchActive
                        ? Icons.close_rounded
                        : Icons.search_rounded,
                    color: AppTheme.textPrimary,
                  ),
                  onPressed: () {
                    setState(() {
                      _isSearchActive = !_isSearchActive;
                      if (!_isSearchActive) {
                        _searchController.clear();
                        _searchQuery = '';
                      }
                    });
                  },
                  tooltip: 'Search leads',
                ),
                IconButton(
                  icon: Stack(
                    children: [
                      const Icon(
                        Icons.notifications_outlined,
                        color: AppTheme.textPrimary,
                      ),
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
                  onPressed: () => context.go(AppRoutes.notificationsScreen),
                  tooltip: 'Notifications',
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: AppTheme.primaryContainer,
                    child: Text(
                      'PS',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Pipeline KPI Cards
            SliverToBoxAdapter(
              child: _isLoading
                  ? _buildKpiSkeleton()
                  : PipelineKpiWidget(leads: _leads),
            ),

            // Filter Bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _FilterBarDelegate(
                child: LeadFilterBarWidget(
                  selectedFilter: _selectedFilter,
                  onFilterChanged: (f) => setState(() => _selectedFilter = f),
                ),
              ),
            ),

            // Results count + sort
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  children: [
                    Text(
                      _isLoading
                          ? 'Loading...'
                          : '${_filteredLeads.length} lead${_filteredLeads.length != 1 ? 's' : ''}',
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
                      label: Text(_sortLabel),
                      style: TextButton.styleFrom(
                        foregroundColor: _sortOption == _SortOption.dateNewest
                            ? AppTheme.textSecondary
                            : AppTheme.primary,
                        textStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // List content
            if (_isLoading)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => const LeadCardSkeletonWidget(),
                  childCount: 5,
                ),
              )
            else if (_filteredLeads.isEmpty)
              SliverFillRemaining(
                child: EmptyStateWidget(
                  icon: Icons.people_outline_rounded,
                  title: 'No leads found',
                  subtitle: _searchQuery.isNotEmpty
                      ? 'Try a different search term or clear filters'
                      : 'Start building your pipeline by adding your first lead',
                  ctaLabel: 'Add New Lead',
                  onCta: () => context.go(AppRoutes.addLeadScreen),
                ),
              )
            else
              isTablet
                  ? SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.6,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => LeadCardWidget(
                            lead: _filteredLeads[index],
                            index: index,
                            onRemove: () =>
                                removeLead(_filteredLeads[index].id),
                          ),
                          childCount: _filteredLeads.length,
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.only(bottom: 100),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => LeadCardWidget(
                            lead: _filteredLeads[index],
                            index: index,
                            onRemove: () =>
                                removeLead(_filteredLeads[index].id),
                          ),
                          childCount: _filteredLeads.length,
                        ),
                      ),
                    ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(AppRoutes.addLeadScreen),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Lead'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  String get _sortLabel {
    switch (_sortOption) {
      case _SortOption.nameAZ:
        return 'Name A-Z';
      case _SortOption.nameZA:
        return 'Name Z-A';
      case _SortOption.dealValueHigh:
        return 'Value ↓';
      case _SortOption.dealValueLow:
        return 'Value ↑';
      case _SortOption.priorityHigh:
        return 'Priority';
      case _SortOption.dateNewest:
        return 'Sort';
      case _SortOption.dateOldest:
        return 'Oldest';
    }
  }

  Widget _buildKpiSkeleton() {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, __) => const LoadingSkeletonWidget(
          width: 120,
          height: 86,
          borderRadius: 16,
        ),
      ),
    );
  }
}

class _FilterBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  const _FilterBarDelegate({required this.child});

  @override
  double get minExtent => 52;
  @override
  double get maxExtent => 52;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: AppTheme.backgroundLight, child: child);
  }

  @override
  bool shouldRebuild(_FilterBarDelegate oldDelegate) =>
      child != oldDelegate.child;
}

// ─── Model ────────────────────────────────────────────────────
class LeadModel {
  final String id;
  final String name;
  final String company;
  final String status;
  final String priority;
  final int score;
  final double dealValue;
  final String ownerInitials;
  final String ownerName;
  final String lastContact;
  final String phone;
  final String email;
  final String industry;
  final List<String> tags;

  const LeadModel({
    required this.id,
    required this.name,
    required this.company,
    required this.status,
    required this.priority,
    required this.score,
    required this.dealValue,
    required this.ownerInitials,
    required this.ownerName,
    required this.lastContact,
    required this.phone,
    required this.email,
    required this.industry,
    required this.tags,
  });

  factory LeadModel.fromMap(Map<String, dynamic> map) => LeadModel(
    id: map['id'] as String,
    name: map['name'] as String,
    company: map['company'] as String,
    status: map['status'] as String,
    priority: map['priority'] as String,
    score: map['score'] as int,
    dealValue: (map['dealValue'] as num).toDouble(),
    ownerInitials: map['ownerInitials'] as String,
    ownerName: map['ownerName'] as String,
    lastContact: map['lastContact'] as String,
    phone: map['phone'] as String,
    email: map['email'] as String,
    industry: map['industry'] as String,
    tags: List<String>.from(map['tags'] as List),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'company': company,
    'status': status,
    'priority': priority,
    'score': score,
    'dealValue': dealValue,
    'ownerInitials': ownerInitials,
    'ownerName': ownerName,
    'lastContact': lastContact,
    'phone': phone,
    'email': email,
    'industry': industry,
    'tags': tags,
  };
}
