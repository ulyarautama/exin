import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../shared/widgets/person_avatar.dart';

class PublicProfile {
  const PublicProfile({
    required this.name,
    required this.handle,
    required this.initials,
    required this.bio,
    required this.followers,
    required this.following,
    required this.posts,
    required this.reposts,
    required this.achievementCount,
    required this.achievements,
    required this.interests,
    required this.featuredPost,
    required this.tint,
    this.verified = false,
    this.isNew = false,
  });

  final String name;
  final String handle;
  final String initials;
  final String bio;
  final String followers;
  final String following;
  final String posts;
  final String reposts;
  final int achievementCount;
  final List<String> achievements;
  final List<String> interests;
  final String featuredPost;
  final Color tint;
  final bool verified;
  final bool isNew;
}

PublicProfile demoProfileFor({
  required String name,
  required String handle,
  required String initials,
  required Color tint,
}) {
  final profiles = <String, PublicProfile>{
    'mayaputri': PublicProfile(
      name: 'Maya Putri',
      handle: 'mayaputri',
      initials: 'MP',
      bio: 'Collecting quiet streets, bright mornings, and good coffee.',
      followers: '128.4K',
      following: '412',
      posts: '326',
      reposts: '87',
      achievementCount: 24,
      achievements: ['City cartographer', '100 new corners', 'Early bird'],
      interests: ['Street photo', 'Slow travel', 'Coffee'],
      featuredPost: 'A softer route through Kota Tua, before the city woke up.',
      tint: AppColors.peach,
      verified: true,
    ),
    'rafi.moves': PublicProfile(
      name: 'Rafi Aditya',
      handle: 'rafi.moves',
      initials: 'RA',
      bio: 'One more block. One more view. Usually on foot.',
      followers: '4.8K',
      following: '690',
      posts: '72',
      reposts: '16',
      achievementCount: 8,
      achievements: ['Weekend walker', '10 new places', '4 day streak'],
      interests: ['Hiking', 'City walks', 'Maps'],
      featuredPost: 'Four kilometers, three new places, no rush to get home.',
      tint: AppColors.lavender,
    ),
    'nadia.stories': PublicProfile(
      name: 'Nadia S.',
      handle: 'nadia.stories',
      initials: 'NS',
      bio: 'New here. Looking for small adventures nearby.',
      followers: '43',
      following: '120',
      posts: '3',
      reposts: '0',
      achievementCount: 1,
      achievements: ['First field note'],
      interests: ['Live music', 'Bookshops'],
      featuredPost: 'Found a tiny bookshop tucked behind the old station.',
      tint: const Color(0xFFE7C9A6),
      isNew: true,
    ),
    'dimas.hari': PublicProfile(
      name: 'Dimas & Friends',
      handle: 'dimas.hari',
      initials: 'DH',
      bio: 'Neighborhood food trails with whoever is free.',
      followers: '52.1K',
      following: '980',
      posts: '204',
      reposts: '131',
      achievementCount: 19,
      achievements: ['Local guide', 'Food trail maker', 'Community host'],
      interests: ['Food', 'Friends', 'Hidden places'],
      featuredPost: 'A Sunday lunch route that turned into a whole afternoon.',
      tint: const Color(0xFFB8D2C1),
      verified: true,
    ),
    'alyarahman': PublicProfile(
      name: 'Alya Rahman',
      handle: 'alyarahman',
      initials: 'AR',
      bio: 'Saving little moments between work and the weekend.',
      followers: '642',
      following: '220',
      posts: '18',
      reposts: '5',
      achievementCount: 3,
      achievements: ['First 10 places', 'Weekend explorer', '5 day streak'],
      interests: ['Design', 'Photography', 'Tea'],
      featuredPost: 'A small detour made an ordinary Tuesday feel lighter.',
      tint: const Color(0xFFE8BED2),
      isNew: true,
    ),
  };
  return profiles[handle] ??
      PublicProfile(
        name: name,
        handle: handle,
        initials: initials,
        bio: 'Sharing discoveries along the way.',
        followers: '318',
        following: '204',
        posts: '12',
        reposts: '2',
        achievementCount: 2,
        achievements: const ['First field note', 'New route'],
        interests: const ['Exploring', 'Photography'],
        featuredPost: 'A new place worth remembering.',
        tint: tint,
        isNew: true,
      );
}

class PublicProfileScreen extends StatefulWidget {
  const PublicProfileScreen({super.key, required this.profile});

  final PublicProfile profile;

  @override
  State<PublicProfileScreen> createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  bool _following = false;

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 150,
            title: Text(profile.name),
            actions: [
              IconButton(
                tooltip: 'More options',
                onPressed: () {},
                icon: const Icon(Icons.more_horiz_rounded),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [profile.tint, AppColors.lavender, AppColors.lime],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -32,
                      bottom: -55,
                      child: Icon(
                        Icons.route_rounded,
                        size: 220,
                        color: Colors.white.withValues(alpha: .25),
                      ),
                    ),
                    Positioned(
                      left: 22,
                      bottom: 18,
                      child: Text(
                        profile.isNew
                            ? 'FIRST STEPS'
                            : 'FIELD NOTES · ${profile.achievementCount} BADGES',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: profile.tint, width: 2),
                    ),
                    child: PersonAvatar(
                      initials: profile.initials,
                      size: 66,
                      color: profile.tint,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                profile.name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            if (profile.verified) ...[
                              const SizedBox(width: 5),
                              Icon(
                                Icons.verified_rounded,
                                size: 17,
                                color: theme.colorScheme.primary,
                              ),
                            ],
                            if (profile.isNew) ...[
                              const SizedBox(width: 5),
                              _NewBadge(color: theme.colorScheme.primary),
                            ],
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '@${profile.handle}',
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Text(
                profile.bio,
                style: const TextStyle(fontSize: 12, height: 1.4),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 17, 20, 0),
              child: Row(
                children: [
                  _PublicStat(value: profile.followers, label: 'followers'),
                  _PublicStat(value: profile.following, label: 'following'),
                  _PublicStat(value: profile.posts, label: 'posts'),
                  _PublicStat(value: profile.reposts, label: 'reposts'),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () => setState(() => _following = !_following),
                      child: Text(_following ? 'Following' : 'Follow'),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.mail_outline_rounded, size: 17),
                      label: const Text('Message'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 21, 20, 0),
              child: _PublicSectionTitle(
                title: 'INTERESTS',
                trailing: profile.isNew ? 'JUST STARTING' : 'IN THEIR ORBIT',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 9, 20, 0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final interest in profile.interests)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        interest,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 9),
              child: _PublicSectionTitle(
                title: 'ACHIEVEMENTS',
                trailing: '${profile.achievementCount} earned',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 86,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: profile.achievements.length,
                separatorBuilder: (_, _) => const SizedBox(width: 9),
                itemBuilder: (context, index) => Container(
                  width: 158,
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: profile.tint.withValues(alpha: .35),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.workspace_premium_rounded, size: 23),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          profile.achievements[index],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
              child: _PublicSectionTitle(
                title: 'RECENT POSTS',
                trailing: '${profile.posts} total',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.notes_rounded,
                      size: 19,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        profile.featuredPost,
                        style: const TextStyle(fontSize: 13, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PublicStat extends StatelessWidget {
  const _PublicStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );
}

class _PublicSectionTitle extends StatelessWidget {
  const _PublicSectionTitle({required this.title, required this.trailing});

  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(title, style: Theme.of(context).textTheme.labelSmall),
      const Spacer(),
      Text(
        trailing,
        style: TextStyle(
          fontSize: 9,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    ],
  );
}

class _NewBadge extends StatelessWidget {
  const _NewBadge({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .16),
      borderRadius: BorderRadius.circular(7),
    ),
    child: Text(
      'NEW',
      style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: color),
    ),
  );
}
