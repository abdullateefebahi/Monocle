import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/sector_model.dart';
import '../providers/sectors_providers.dart';
import 'sector_detail_screen.dart';

// Helper to get icon from string name
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

// Helper to get color from hex string
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

class SectorsScreen extends ConsumerStatefulWidget {
  const SectorsScreen({super.key});

  @override
  ConsumerState<SectorsScreen> createState() => _SectorsScreenState();
}

class _SectorsScreenState extends ConsumerState<SectorsScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final sectorsAsync = ref.watch(sectorsProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(sectorsAsync),
              const SizedBox(height: 24),

              // Search Bar
              _buildSearchBar(),
              const SizedBox(height: 24),

              // Sectors Grid
              Expanded(
                child: sectorsAsync.when(
                  data: (sectors) => _buildSectorsGrid(_filterSectors(sectors)),
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
        ),
      ),
    );
  }

  List<SectorModel> _filterSectors(List<SectorModel> sectors) {
    if (_searchQuery.isEmpty) return sectors;

    return sectors.where((sector) {
      final nameLower = sector.name.toLowerCase();
      final descLower = (sector.description ?? '').toLowerCase();
      final queryLower = _searchQuery.toLowerCase();
      return nameLower.contains(queryLower) || descLower.contains(queryLower);
    }).toList();
  }

  Widget _buildHeader(AsyncValue<List<SectorModel>> sectorsAsync) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sectors',
                  style: GoogleFonts.outfit(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Explore communities by sector',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondaryDark,
                  ),
                ),
              ],
            ),
          ),
          sectorsAsync.when(
            data: (sectors) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.cyanAccent, AppColors.royalPurple],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.category, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    '${sectors.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
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
            hintText: 'Search sectors...',
            hintStyle: TextStyle(color: AppColors.textSecondaryDark),
            prefixIcon: const Icon(Icons.search, color: AppColors.cyanAccent),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white54),
                    onPressed: () => setState(() => _searchQuery = ''),
                  )
                : null,
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

  Widget _buildSectorsGrid(List<SectorModel> sectors) {
    if (sectors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textSecondaryDark,
            ),
            const SizedBox(height: 16),
            Text(
              'No sectors found',
              style: TextStyle(
                color: AppColors.textSecondaryDark,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(context),
        childAspectRatio: 1.1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: sectors.length,
      itemBuilder: (context, index) {
        return _SectorCard(
          sector: sectors[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SectorDetailScreen(
                  sectorId: sectors[index].id,
                  sectorName: sectors[index].name,
                ),
              ),
            );
          },
        );
      },
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
              'Failed to load sectors',
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
              onPressed: () => ref.invalidate(sectorsProvider),
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

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 2;
  }
}

// Sector Card Widget
class _SectorCard extends StatelessWidget {
  final SectorModel sector;
  final VoidCallback onTap;

  const _SectorCard({required this.sector, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final icon = _getIconFromName(sector.iconName);
    final color = _getColorFromHex(sector.colorHex);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surface, color.withValues(alpha: 0.05)],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const Spacer(),

                // Name
                Text(
                  sector.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),

                // Description
                Text(
                  sector.description ?? '',
                  style: TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 11,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Stats Row
                Row(
                  children: [
                    Icon(Icons.group_outlined, color: color, size: 14),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '${sector.communityCount ?? 0} communities',
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      color: AppColors.textSecondaryDark,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '${sector.totalMembers ?? 0} members',
                        style: TextStyle(
                          color: AppColors.textSecondaryDark,
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
