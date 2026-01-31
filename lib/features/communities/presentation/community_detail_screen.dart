import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/community_model.dart';

class CommunityDetailScreen extends ConsumerStatefulWidget {
  final CommunityModel community;

  const CommunityDetailScreen({super.key, required this.community});

  @override
  ConsumerState<CommunityDetailScreen> createState() =>
      _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends ConsumerState<CommunityDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isMember = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCommunityHeader(),
                  const SizedBox(height: 24),
                  _buildStats(),
                  const SizedBox(height: 24),
                  _buildTabs(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            _buildTabContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.backgroundDark,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.share, color: Colors.white),
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.more_vert, color: Colors.white),
          ),
          onPressed: () {},
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Banner Image
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.cyanAccent.withValues(alpha: 0.3),
                    AppColors.royalPurple.withValues(alpha: 0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: widget.community.bannerUrl != null
                  ? Image.network(
                      widget.community.bannerUrl!,
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.backgroundDark.withValues(alpha: 0.9),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Community Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.cyanAccent, AppColors.royalPurple],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cyanAccent.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.community.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
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
                            widget.community.name,
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.community.isVerified) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.verified,
                            color: AppColors.cyanAccent,
                            size: 24,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.royalPurple.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.royalPurple.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        widget.community.sectorType.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.royalPurple,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            widget.community.description ?? 'No description available',
            style: TextStyle(
              color: AppColors.textSecondaryDark,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Tags
          if (widget.community.tags.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.community.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.cyanAccent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.tag,
                        size: 12,
                        color: AppColors.cyanAccent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        tag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          const SizedBox(height: 24),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() => _isMember = !_isMember);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _isMember
                    ? AppColors.surface
                    : AppColors.cyanAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: _isMember
                      ? BorderSide(
                          color: AppColors.cyanAccent.withValues(alpha: 0.5),
                        )
                      : BorderSide.none,
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isMember ? Icons.check_circle : Icons.add_circle,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isMember ? 'Joined' : 'Join Community',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.people,
              label: 'Members',
              value: widget.community.memberCount.toString(),
              color: AppColors.cyanAccent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.chat_bubble_outline,
              label: 'Posts',
              value: '1.2k',
              color: AppColors.royalPurple,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.trending_up,
              label: 'Active',
              value: '245',
              color: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.cyanAccent, AppColors.royalPurple],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondaryDark,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        tabs: const [
          Tab(text: 'Posts'),
          Tab(text: 'Members'),
          Tab(text: 'Events'),
          Tab(text: 'About'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return SliverFillRemaining(
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildPostsTab(),
          _buildMembersTab(),
          _buildEventsTab(),
          _buildAboutTab(),
        ],
      ),
    );
  }

  Widget _buildPostsTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _PostCard(index: index);
      },
    );
  }

  Widget _buildMembersTab() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return _MemberCard(index: index);
      },
    );
  }

  Widget _buildEventsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_outlined,
            size: 80,
            color: AppColors.textSecondaryDark,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Upcoming Events',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Stay tuned for community events',
            style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AboutSection(
            title: 'Community Guidelines',
            icon: Icons.info_outline,
            content: 'Be respectful\nNo spam\nStay on topic',
          ),
          const SizedBox(height: 16),
          _AboutSection(
            title: 'Created',
            icon: Icons.calendar_today,
            content: widget.community.createdAt.toString().substring(0, 10),
          ),
          const SizedBox(height: 16),
          _AboutSection(
            title: 'Entry Fee',
            icon: Icons.paid_outlined,
            content: widget.community.settings.entryFeeSparks > 0
                ? '${widget.community.settings.entryFeeSparks} Sparks'
                : 'Free',
          ),
        ],
      ),
    );
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
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// Post Card Widget
class _PostCard extends StatelessWidget {
  final int index;

  const _PostCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.cyanAccent,
                child: Text(
                  'U${index + 1}',
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
                      'User ${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '2 hours ago',
                      style: TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'This is a sample post in the community. Exciting things happening!',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _PostAction(icon: Icons.favorite_border, count: '24'),
              const SizedBox(width: 20),
              _PostAction(icon: Icons.comment_outlined, count: '8'),
              const SizedBox(width: 20),
              _PostAction(icon: Icons.share_outlined, count: '3'),
            ],
          ),
        ],
      ),
    );
  }
}

class _PostAction extends StatelessWidget {
  final IconData icon;
  final String count;

  const _PostAction({required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondaryDark, size: 18),
        const SizedBox(width: 4),
        Text(
          count,
          style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12),
        ),
      ],
    );
  }
}

// Member Card Widget
class _MemberCard extends StatelessWidget {
  final int index;

  const _MemberCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.royalPurple,
            child: Text(
              'M${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Member ${index + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.cyanAccent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'MEMBER',
              style: TextStyle(
                color: AppColors.cyanAccent,
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

// About Section Widget
class _AboutSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final String content;

  const _AboutSection({
    required this.title,
    required this.icon,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.cyanAccent, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              color: AppColors.textSecondaryDark,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
