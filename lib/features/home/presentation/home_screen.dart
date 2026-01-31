import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../communities/presentation/communities_screen.dart';
import '../../wallet/presentation/wallet_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return const DesktopDashboardLayout();
        }
        return const MobileDashboardLayout();
      },
    );
  }
}

// ==========================================
// DESKTOP DASHBOARD LAYOUT
// ==========================================

class DesktopDashboardLayout extends ConsumerStatefulWidget {
  const DesktopDashboardLayout({super.key});

  @override
  ConsumerState<DesktopDashboardLayout> createState() =>
      _DesktopDashboardLayoutState();
}

class _DesktopDashboardLayoutState
    extends ConsumerState<DesktopDashboardLayout> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Row(
          children: [
            // 1. LEFT SIDEBAR (Collapsible on hover)
            _CollapsibleSidebar(
              selectedIndex: _selectedIndex,
              onItemTap: (index) => setState(() => _selectedIndex = index),
            ),

            // 2. MAIN CONTENT AREA
            Expanded(
              flex: 5,
              child: _selectedIndex == 1
                  ? const SectorsScreen()
                  : _selectedIndex == 3
                  ? const WalletScreen()
                  : Padding(
                      padding: const EdgeInsets.only(
                        top: 24,
                        bottom: 24,
                        right: 24,
                      ),
                      child: Column(
                        children: [
                          // Header (Title)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Monocle',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Content Grid
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Feed Column
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Feed',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              color:
                                                  AppColors.textSecondaryDark,
                                            ),
                                      ),
                                      const SizedBox(height: 16),

                                      // Welcome Card
                                      const _FeedCard(
                                        avatarUrl: 'DQ',
                                        title:
                                            'Delly Quest: Welcome 3 New Members',
                                        subtitle:
                                            'to New Bee Sector\nViewed: 180 Friends',
                                        time: '2 min',
                                      ),
                                      const SizedBox(height: 16),

                                      // Daily Quest Card
                                      const _FeedCard(
                                        avatarUrl: 'DQ',
                                        title: 'Daily Quest',
                                        subtitle:
                                            'Deliver 5 New Members to\nForever 180 Sector',
                                        time: '+ 500',
                                        isQuest: true,
                                      ),
                                      const SizedBox(height: 24),

                                      // Mini Game
                                      Text(
                                        'Mini Game:',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              color:
                                                  AppColors.textSecondaryDark,
                                            ),
                                      ),
                                      const SizedBox(height: 16),
                                      const _MiniGameCard(),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),

                                // Middle Column (Guilds & Hub)
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 36,
                                      ), // Align with feed top
                                      // Creative Guild
                                      const _CreativeGuildCard(),
                                      const SizedBox(height: 16),
                                      // Explicit Challenge
                                      const _ChallengeCard(),
                                      const SizedBox(height: 24),

                                      // Global Hub
                                      Text(
                                        'Dosage the Global Hub',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              color:
                                                  AppColors.textSecondaryDark,
                                            ),
                                      ),
                                      const SizedBox(height: 16),
                                      const _GlobalHubFeed(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),
                          // Bottom Message Input
                          const _BottomMessageInput(),
                        ],
                      ),
                    ),
            ),

            // 3. RIGHT PANEL
            Container(
              width: 300,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              child: Column(
                children: [
                  // User Level Badge
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.royalPurple.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.bolt,
                            color: AppColors.royalPurple,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Level 7',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: AppColors.cyanAccent,
                            child: const Text(
                              'U',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Currency Stats
                  _CurrencyStat(
                    icon: '⚡',
                    label: 'Shards',
                    value: '9,256',
                    change: '45',
                    color: AppColors.spark,
                  ),
                  const SizedBox(height: 16),
                  _CurrencyStat(
                    icon: '🔮',
                    label:
                        'Orbs', // Replaced "11,230" with Orbs label for clarity based on context
                    value: '1,230',
                    change: '45',
                    color: AppColors.orb,
                  ),
                  const SizedBox(height: 48),

                  // Upcoming Events
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Upcoming Events',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _UpcomingEventCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// SUB-WIDGETS
// ==========================================

// Collapsible Sidebar with hover effect
class _CollapsibleSidebar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTap;

  const _CollapsibleSidebar({
    required this.selectedIndex,
    required this.onItemTap,
  });

  @override
  State<_CollapsibleSidebar> createState() => _CollapsibleSidebarState();
}

class _CollapsibleSidebarState extends State<_CollapsibleSidebar> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: _isHovered ? 240 : 80,
        padding: EdgeInsets.symmetric(
          vertical: 24,
          horizontal: _isHovered ? 16 : 12,
        ),
        color: AppColors.backgroundDark,
        child: Column(
          children: [
            // Logo
            _DashboardLogo(),
            const SizedBox(height: 48),

            // Navigation Items
            _CollapsibleSidebarItem(
              icon: Icons.home_filled,
              label: 'Home',
              isActive: widget.selectedIndex == 0,
              isExpanded: _isHovered,
              onTap: () => widget.onItemTap(0),
            ),
            _CollapsibleSidebarItem(
              icon: Icons.category_outlined,
              label: 'Sectors',
              isActive: widget.selectedIndex == 1,
              isExpanded: _isHovered,
              onTap: () => widget.onItemTap(1),
            ),
            _CollapsibleSidebarItem(
              icon: Icons.explore_outlined,
              label: 'Quests',
              isActive: widget.selectedIndex == 2,
              isExpanded: _isHovered,
              onTap: () => widget.onItemTap(2),
            ),
            _CollapsibleSidebarItem(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Wallet',
              isActive: widget.selectedIndex == 3,
              isExpanded: _isHovered,
              onTap: () => widget.onItemTap(3),
            ),
            _CollapsibleSidebarItem(
              icon: Icons.calendar_today_outlined,
              label: 'Events',
              isActive: widget.selectedIndex == 4,
              isExpanded: _isHovered,
              onTap: () => widget.onItemTap(4),
            ),
            const Spacer(),
            _CollapsibleSidebarItem(
              icon: Icons.settings_outlined,
              label: 'Settings',
              isActive: widget.selectedIndex == 5,
              isExpanded: _isHovered,
              onTap: () => widget.onItemTap(5),
            ),
          ],
        ),
      ),
    );
  }
}

// Collapsible Sidebar Item
class _CollapsibleSidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isExpanded;
  final VoidCallback onTap;

  const _CollapsibleSidebarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(
              vertical: 16,
              horizontal: isExpanded ? 16 : 12,
            ),
            decoration: isActive
                ? BoxDecoration(
                    color: AppColors.cyanAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: const Border(
                      left: BorderSide(color: AppColors.cyanAccent, width: 3),
                    ),
                  )
                : null,
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isActive
                      ? AppColors.cyanAccent
                      : AppColors.textSecondaryDark,
                  size: 24,
                ),
                if (isExpanded) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isExpanded ? 1.0 : 0.0,
                      child: Text(
                        label,
                        style: TextStyle(
                          color: isActive
                              ? Colors.white
                              : AppColors.textSecondaryDark,
                          fontSize: 16,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardLogo extends StatelessWidget {
  const _DashboardLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0072FF).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'M',
          style: GoogleFonts.outfit(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _FeedCard extends StatelessWidget {
  final String avatarUrl;
  final String title;
  final String subtitle;
  final String time;
  final bool isQuest;

  const _FeedCard({
    required this.avatarUrl,
    required this.title,
    required this.subtitle,
    required this.time,
    this.isQuest = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isQuest
              ? AppColors.royalPurple.withValues(alpha: 0.4)
              : Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.cyanAccent,
            child: Text(
              avatarUrl,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isQuest
                  ? AppColors.royalPurple.withValues(alpha: 0.2)
                  : AppColors.glassBorder,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              time,
              style: TextStyle(
                color: isQuest
                    ? AppColors.royalPurple
                    : AppColors.textSecondaryDark,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniGameCard extends StatelessWidget {
  const _MiniGameCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1614728263952-84ea256f9679?q=80&w=1000&auto=format&fit=crop',
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1550745165-9bc0b252726f?q=80&w=1000&auto=format&fit=crop',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Codbreaker Challenge',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Chronowards Experience lines',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.bolt, color: Colors.white54, size: 12),
                    const SizedBox(width: 4),
                    const Text(
                      'Load: 80%',
                      style: TextStyle(color: Colors.white54, fontSize: 10),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.royalPurple,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '+ 250 XP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CreativeGuildCard extends StatelessWidget {
  const _CreativeGuildCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface, // Matches "Creative Guild" bg
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Creative Guild',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(Icons.more_horiz, color: AppColors.textSecondaryDark),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://images.unsplash.com/photo-1511512578047-dfb367046420?q=80&w=150&auto=format&fit=crop',
                  width: 100,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Treatment tools reviews trends',
                      style: TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                      ),
                    ),
                    const Text(
                      'Inc. architecture',
                      style: TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 12,
                          color: AppColors.emeraldGreen,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'meet Stand.co',
                          style: TextStyle(
                            color: AppColors.emeraldGreen,
                            fontSize: 10,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '+0.01',
                          style: TextStyle(
                            color: AppColors.warning,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://images.unsplash.com/photo-1535930749574-1399327ce78f?q=80&w=150&auto=format&fit=crop',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=150&auto=format&fit=crop',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Explity lite... Challenge',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Next 28',
                  style: TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlobalHubFeed extends StatelessWidget {
  const _GlobalHubFeed();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // Reduced height to fit layout
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            AppColors.surface,
            AppColors.royalPurple.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.royalPurple,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'SCENES',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                const Text(
                  'Móu ti8 to teo',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Stop into Etheryalism',
                  style: TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://images.unsplash.com/photo-1614726365206-880fa8ea4256?q=80&w=200&auto=format&fit=crop',
              width: 100,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrencyStat extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final String change;
  final Color color;

  const _CurrencyStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.change,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textSecondaryDark,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const Icon(Icons.arrow_upward, size: 10, color: Colors.grey),
                const SizedBox(width: 2),
                Text(
                  change,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UpcomingEventCard extends StatelessWidget {
  const _UpcomingEventCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.royalPurple.withValues(
                alpha: 0.2,
              ), // Typo handled below
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Range',
              style: TextStyle(
                color: AppColors.royalPurple,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://images.unsplash.com/photo-1596495578065-6e0763fa1178?q=80&w=100&auto=format&fit=crop',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Live AMA with',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Text(
                      'Indusiry Leaders',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Community Powered\nDesign Tournament',
            style: TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _BottomMessageInput extends StatelessWidget {
  const _BottomMessageInput();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.chat_bubble_outline,
            color: AppColors.textSecondaryDark,
            size: 20,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Message the Global Hub...',
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.check_box_outlined,
              color: AppColors.textSecondaryDark,
              size: 20,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.add_circle_outline,
              color: AppColors.textSecondaryDark,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// MOBILE DASHBOARD LAYOUT
// ==========================================

class MobileDashboardLayout extends ConsumerStatefulWidget {
  const MobileDashboardLayout({super.key});

  @override
  ConsumerState<MobileDashboardLayout> createState() =>
      _MobileDashboardLayoutState();
}

class _MobileDashboardLayoutState extends ConsumerState<MobileDashboardLayout> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      // Top App Bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const _DashboardLogo(),
            const SizedBox(width: 12),
            Text(
              'Monocle',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          // Level Badge (Mini)
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.royalPurple.withValues(alpha: 0.3),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.bolt, color: AppColors.royalPurple, size: 14),
                SizedBox(width: 4),
                Text(
                  'Lvl 7',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom Navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.cyanAccent,
          unselectedItemColor: AppColors.textSecondaryDark,
          elevation: 0,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              label: 'Sectors',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              label: 'Quests',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),

      // Main Body
      body: _currentIndex == 1
          ? const SectorsScreen()
          : _currentIndex == 3
          ? const WalletScreen()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Wallet Summary (Horizontal Scroll)
                  SizedBox(
                    height: 80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Container(
                          width: 160,
                          margin: const EdgeInsets.only(right: 12),
                          child: _CurrencyStat(
                            icon: '⚡',
                            label: 'Shards',
                            value: '9,256',
                            change: '45',
                            color: AppColors.spark,
                          ),
                        ),
                        Container(
                          width: 160,
                          margin: const EdgeInsets.only(right: 12),
                          child: _CurrencyStat(
                            icon: '🔮',
                            label: 'Orbs',
                            value: '1,230',
                            change: '12',
                            color: AppColors.orb,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Feed Section Header
                  Text(
                    'Your Feed',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Feed Items
                  const _FeedCard(
                    avatarUrl: 'WN',
                    title: 'Welcome New Members',
                    subtitle: 'Bee Sector • Viewed 180',
                    time: '2m',
                  ),
                  const SizedBox(height: 12),
                  const _FeedCard(
                    avatarUrl: 'DQ',
                    title: 'Daily Quest Available',
                    subtitle: 'Deliver 5 New Members',
                    time: '+500',
                    isQuest: true,
                  ),

                  const SizedBox(height: 24),

                  // Mini Game Section
                  Text(
                    'Active Challenge',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _MiniGameCard(),

                  const SizedBox(height: 24),

                  // Guilds & Social
                  const _CreativeGuildCard(),
                  const SizedBox(height: 12),
                  const _ChallengeCard(),

                  const SizedBox(height: 24),

                  // Global Hub Preview
                  const _GlobalHubFeed(),

                  const SizedBox(height: 80), // Bottom padding for FAB/Nav
                ],
              ),
            ),
    );
  }
}
