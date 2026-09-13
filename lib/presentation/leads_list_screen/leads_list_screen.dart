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

// Global leads list — starts empty, populated when leads are added
final List<Map<String, dynamic>> globalLeadMaps = [];

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
  // null = no filter, true = existing customer only, false = new customer only
  bool? _existingCustomerFilter;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  List<LeadModel> _leads = [];

  @override
  void initState() {
    super.initState();
    _loadLeads();
  }

  Future<void> _loadLeads() async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      setState(() {
        _leads = globalLeadMaps.map(LeadModel.fromMap).toList();
        _isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 400));
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
          lead.phone.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          lead.company.toLowerCase().contains(_searchQuery.toLowerCase());
      // Existing customer filter: Won/Result = existing customer
      final isExistingCustomer =
          lead.status == 'Won' || lead.status == 'Result';
      final matchesExistingFilter =
          _existingCustomerFilter == null ||
          (_existingCustomerFilter == true && isExistingCustomer) ||
          (_existingCustomerFilter == false && !isExistingCustomer);
      return matchesFilter && matchesSearch && matchesExistingFilter;
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
          child: SingleChildScrollView(
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
                  'Sort & Filter',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                // Sort options
                Text(
                  'Sort By',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
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
                  (
                    _SortOption.nameAZ,
                    Icons.sort_by_alpha_rounded,
                    'Name A → Z',
                  ),
                  (
                    _SortOption.nameZA,
                    Icons.sort_by_alpha_rounded,
                    'Name Z → A',
                  ),
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
                      setSheet(() {});
                    },
                  );
                }),
                const Divider(height: 24),
                // Existing customer filter
                Text(
                  'Existing Customer',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      isSelected: _existingCustomerFilter == null,
                      onTap: () {
                        setState(() => _existingCustomerFilter = null);
                        setSheet(() {});
                      },
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Yes (Won/Result)',
                      isSelected: _existingCustomerFilter == true,
                      onTap: () {
                        setState(() => _existingCustomerFilter = true);
                        setSheet(() {});
                      },
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'No',
                      isSelected: _existingCustomerFilter == false,
                      onTap: () {
                        setState(() => _existingCustomerFilter = false);
                        setSheet(() {});
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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
                      'Apply',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                        hintText: 'Search leads, phone...',
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
                    if (_existingCustomerFilter != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Existing: ${_existingCustomerFilter! ? 'Yes' : 'No'}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _showSortSheet,
                      icon: const Icon(Icons.sort_rounded, size: 16),
                      label: Text(_sortLabel),
                      style: TextButton.styleFrom(
                        foregroundColor:
                            _sortOption == _SortOption.dateNewest &&
                                _existingCustomerFilter == null
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _FilterChip({
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
  // Additional fields for full data display
  final String? firstName;
  final String? lastName;
  final String? whatsapp;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? source;
  final String? campaign;
  final String? notes;

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
    this.firstName,
    this.lastName,
    this.whatsapp,
    this.address,
    this.city,
    this.state,
    this.country,
    this.source,
    this.campaign,
    this.notes,
  });

  factory LeadModel.fromMap(Map<String, dynamic> map) => LeadModel(
    id: map['id'] as String? ?? '',
    name: map['name'] as String? ?? '',
    company: map['company'] as String? ?? '',
    status: map['status'] as String? ?? 'New',
    priority: map['priority'] as String? ?? 'Medium',
    score: (map['score'] as num?)?.toInt() ?? 0,
    dealValue: (map['dealValue'] as num?)?.toDouble() ?? 0.0,
    ownerInitials: map['ownerInitials'] as String? ?? 'PS',
    ownerName: map['ownerName'] as String? ?? 'Priya Sharma',
    lastContact: map['lastContact'] as String? ?? 'Just now',
    phone: map['phone'] as String? ?? '',
    email: map['email'] as String? ?? '',
    industry: map['industry'] as String? ?? '',
    tags: List<String>.from(map['tags'] as List? ?? []),
    firstName: map['firstName'] as String?,
    lastName: map['lastName'] as String?,
    whatsapp: map['whatsapp'] as String?,
    address: map['address'] as String?,
    city: map['city'] as String?,
    state: map['state'] as String?,
    country: map['country'] as String?,
    source: map['source'] as String?,
    campaign: map['campaign'] as String?,
    notes: map['notes'] as String?,
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
    if (firstName != null) 'firstName': firstName,
    if (lastName != null) 'lastName': lastName,
    if (whatsapp != null) 'whatsapp': whatsapp,
    if (address != null) 'address': address,
    if (city != null) 'city': city,
    if (state != null) 'state': state,
    if (country != null) 'country': country,
    if (source != null) 'source': source,
    if (campaign != null) 'campaign': campaign,
    if (notes != null) 'notes': notes,
  };

  LeadModel copyWith({
    String? id,
    String? name,
    String? company,
    String? status,
    String? priority,
    int? score,
    double? dealValue,
    String? ownerInitials,
    String? ownerName,
    String? lastContact,
    String? phone,
    String? email,
    String? industry,
    List<String>? tags,
  }) => LeadModel(
    id: id ?? this.id,
    name: name ?? this.name,
    company: company ?? this.company,
    status: status ?? this.status,
    priority: priority ?? this.priority,
    score: score ?? this.score,
    dealValue: dealValue ?? this.dealValue,
    ownerInitials: ownerInitials ?? this.ownerInitials,
    ownerName: ownerName ?? this.ownerName,
    lastContact: lastContact ?? this.lastContact,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    industry: industry ?? this.industry,
    tags: tags ?? this.tags,
  );
}
