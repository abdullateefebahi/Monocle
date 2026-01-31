import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/community_model.dart';
import '../../../shared/models/sector_model.dart';
import '../providers/sectors_providers.dart';
import 'community_detail_screen.dart';

class SectorDetailScreen extends ConsumerStatefulWidget {
  final String sectorId;
  final String sectorName;

  const SectorDetailScreen({
    super.key,
    required this.sectorId,
    required this.sectorName,
  });

  @override
  ConsumerState<SectorDetailScreen> createState() => _SectorDetailScreenState();
}

class _SectorDetailScreenState extends ConsumerState<SectorDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

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

  @override
  Widget build(BuildContext context) {
    final sectorAsync = ref.watch(sectorByIdProvider(widget.sectorId));
    final communitiesAsync = ref.watch(
      communitiesBySectorProvider(widget.sectorId),
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: sectorAsync.when(
            data: (sector) => Column(
              children: [
                _buildHeader(sector),
                const SizedBox(height: 16),
                _buildStats(sector),
                const SizedBox(height: 20),
                _buildSearchBar(sector),
                const SizedBox(height: 20),
                _buildTabs(sector),
                const SizedBox(height: 16),
                Expanded(
                  child: communitiesAsync.when(
                    data: (communities) => TabBarView(
                      controller: _tabController,
                      children: [
                        _buildAllCommunitiesTab(communities, sector),
                        _buildPopularTab(communities, sector),
                        _buildRecentTab(communities, sector),
                      ],
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.cyanAccent,
                      ),
                    ),
                    error: (error, stack) => _buildErrorState(error),
                  ),
                ),
              ],
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.cyanAccent),
            ),
            error: (error, stack) => _buildErrorState(error),
          ),
        ),
      ),
      floatingActionButton: sectorAsync.maybeWhen(
        data: (sector) => _buildCreateButton(sector),
        orElse: () => null,
      ),
    );
  }

  Widget _buildHeader(SectorModel sector) {
    final color = _getColorFromHex(sector.colorHex);
    final icon = _getIconFromName(sector.iconName);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 12),
          // Sector Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${sector.name} Sector',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  sector.description ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondaryDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(SectorModel sector) {
    final color = _getColorFromHex(sector.colorHex);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.group_work,
              label: 'Communities',
              value: (sector.communityCount ?? 0).toString(),
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.people,
              label: 'Members',
              value: '${sector.totalMembers ?? 0}',
              color: AppColors.cyanAccent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.trending_up,
              label: 'Active',
              value: '${((sector.totalMembers ?? 0) * 0.3).toInt()}',
              color: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(SectorModel sector) {
    final color = _getColorFromHex(sector.colorHex);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: TextField(
          onChanged: (value) => setState(() => _searchQuery = value),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search communities in ${sector.name}...',
            hintStyle: TextStyle(color: AppColors.textSecondaryDark),
            prefixIcon: Icon(Icons.search, color: color),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white54),
                    onPressed: () => setState(() => _searchQuery = ''),
                  )
                : const Icon(Icons.tune, color: Colors.white54),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabs(SectorModel sector) {
    final color = _getColorFromHex(sector.colorHex);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 2),
        ),
        dividerColor: Colors.transparent,
        labelColor: color,
        unselectedLabelColor: AppColors.textSecondaryDark,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Popular'),
          Tab(text: 'Recent'),
        ],
      ),
    );
  }

  Widget _buildAllCommunitiesTab(
    List<CommunityModel> communities,
    SectorModel sector,
  ) {
    final filtered = _filterCommunities(communities);
    if (filtered.isEmpty) {
      return _buildEmptyState('No communities found');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return _CommunityCard(
          community: filtered[index],
          sectorColor: _getColorFromHex(sector.colorHex),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CommunityDetailScreen(community: filtered[index]),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPopularTab(
    List<CommunityModel> communities,
    SectorModel sector,
  ) {
    final sorted = List<CommunityModel>.from(communities)
      ..sort((a, b) => b.memberCount.compareTo(a.memberCount));
    final topCommunities = sorted.take(10).toList();

    if (topCommunities.isEmpty) {
      return _buildEmptyState('No popular communities yet');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: topCommunities.length,
      itemBuilder: (context, index) {
        return _CommunityCard(
          community: topCommunities[index],
          sectorColor: _getColorFromHex(sector.colorHex),
          rank: index + 1,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CommunityDetailScreen(community: topCommunities[index]),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRecentTab(List<CommunityModel> communities, SectorModel sector) {
    final sorted = List<CommunityModel>.from(communities)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (sorted.isEmpty) {
      return _buildEmptyState('No recent communities');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        return _CommunityCard(
          community: sorted[index],
          sectorColor: _getColorFromHex(sector.colorHex),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CommunityDetailScreen(community: sorted[index]),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCreateButton(SectorModel sector) {
    final color = _getColorFromHex(sector.colorHex);

    return FloatingActionButton.extended(
      onPressed: () {
        // Show create community dialog
      },
      backgroundColor: color,
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        'Create',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Failed to load data',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: TextStyle(
                color: AppColors.textSecondaryDark,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(sectorByIdProvider);
                ref.invalidate(communitiesBySectorProvider);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cyanAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: AppColors.textSecondaryDark,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 16),
          ),
        ],
      ),
    );
  }

  List<CommunityModel> _filterCommunities(List<CommunityModel> communities) {
    if (_searchQuery.isEmpty) return communities;

    return communities.where((community) {
      final nameLower = community.name.toLowerCase();
      final descLower = (community.description ?? '').toLowerCase();
      final queryLower = _searchQuery.toLowerCase();
      return nameLower.contains(queryLower) || descLower.contains(queryLower);
    }).toList();
  }

  IconData _getIconFromName(String? iconName) {
    switch (iconName?.toLowerCase()) {
      case 'computer':
        return Icons.computer;
      case 'palette':
        return Icons.palette;
      case 'sports_esports':
        return Icons.sports_esports;
      case 'school':
        return Icons.school;
      case 'business_center':
        return Icons.business_center;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'music_note':
        return Icons.music_note;
      case 'restaurant':
        return Icons.restaurant;
      default:
        return Icons.category;
    }
  }

  Color _getColorFromHex(String? colorHex) {
    if (colorHex == null || colorHex.isEmpty) {
      return AppColors.cyanAccent;
    }
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return AppColors.cyanAccent;
    }
  }
}

// Stat Card Widget
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// Community Card Widget
class _CommunityCard extends StatelessWidget {
  final CommunityModel community;
  final Color sectorColor;
  final int? rank;
  final VoidCallback onTap;

  const _CommunityCard({
    required this.community,
    required this.sectorColor,
    this.rank,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Rank or Icon
                if (rank != null)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          sectorColor,
                          sectorColor.withValues(alpha: 0.6),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '#$rank',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [sectorColor, AppColors.royalPurple],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        community.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 16),

                // Community Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              community.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (community.isVerified) ...[
                            const SizedBox(width: 6),
                            Icon(Icons.verified, color: sectorColor, size: 16),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        community.description ?? 'No description',
                        style: TextStyle(
                          color: AppColors.textSecondaryDark,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.people_outline,
                            color: AppColors.textSecondaryDark,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${community.memberCount} members',
                            style: TextStyle(
                              color: AppColors.textSecondaryDark,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow
                Icon(Icons.arrow_forward_ios, color: sectorColor, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
