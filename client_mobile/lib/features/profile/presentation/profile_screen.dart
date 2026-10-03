import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/theme/theme_mode_provider.dart';
import '../../../shared/widgets/person_avatar.dart';
import '../../feed/application/feed_controller.dart';
import '../../feed/domain/post.dart';
import '../../feed/presentation/home_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});
  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  int _section = 0;
  bool _shareStats = true;
  bool _showConnectionsOnProfile = true;
  int _maxVisibleConnections = 3;
  final Set<String> _favoriteArtists = {'niki', 'hindia'};
  final TextEditingController _interestController = TextEditingController();
  String _interestExpiryChoice = '1 month';
  DateTime _customInterestExpiry = DateTime.now().add(const Duration(days: 30));
  final List<_ProfileInterest> _interests = [
    _ProfileInterest('Hiking', DateTime.now().add(const Duration(days: 30))),
    _ProfileInterest('Live music', null),
    _ProfileInterest(
      'Photography',
      DateTime.now().add(const Duration(days: 7)),
    ),
  ];
  final List<String> _pinnedSections = ['YOUR WEEK', 'ACHIEVEMENTS'];
  final List<_ProfileConnection> _connections = [
    _ProfileConnection(
      name: 'Rafi Aditya',
      handle: 'rafi.moves',
      relation: 'Friend',
      status: _ConnectionStatus.accepted,
      showOnProfile: true,
    ),
    _ProfileConnection(
      name: 'Maya Putri',
      handle: 'mayaputri',
      relation: 'Close friend',
      status: _ConnectionStatus.incoming,
    ),
  ];
  final _musicPlayer = AudioPlayer();
  Future<Duration?>? _trackReady;

  @override
  void dispose() {
    unawaited(_musicPlayer.dispose());
    _interestController.dispose();
    super.dispose();
  }

  Future<void> _toggleFavoriteMusic() async {
    try {
      _trackReady ??= _musicPlayer.setAsset(
        'assets/audio/favorite_preview.wav',
      );
      await _trackReady;
      if (_musicPlayer.playing) {
        await _musicPlayer.pause();
      } else {
        if (_musicPlayer.processingState == ProcessingState.completed) {
          await _musicPlayer.seek(Duration.zero);
        }
        unawaited(_musicPlayer.play());
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not load the music preview.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final feed = ref.watch(feedControllerProvider);
    final visiblePosts = switch (_section) {
      0 =>
        feed
            .where((post) => post.handle == 'aripratama' && !post.isReply)
            .toList(),
      1 =>
        feed
            .where((post) => post.handle == 'aripratama' && post.isReply)
            .toList(),
      2 =>
        feed
            .where(
              (post) =>
                  post.handle == 'aripratama' &&
                  (post.kind == PostKind.photo || post.kind == PostKind.video),
            )
            .toList(),
      3 =>
        feed
            .where(
              (post) =>
                  post.kind == PostKind.activity ||
                  post.kind == PostKind.achievement,
            )
            .toList(),
      _ => feed.where((post) => post.reposted).toList(),
    };
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: _ProfileHeaderDelegate(
            onEdit: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile editing is coming soon.')),
            ),
            onSettings: () => _settings(context),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 19, 22, 18),
            child: Row(
              children: [
                _SocialCount(number: '248', label: 'followers'),
                _SocialCount(number: '186', label: 'following'),
                _SocialCount(
                  number: feed
                      .where(
                        (post) => post.handle == 'aripratama' && !post.isReply,
                      )
                      .length
                      .toString(),
                  label: 'posts',
                ),
                _SocialCount(
                  number: feed.where((post) => post.reposted).length.toString(),
                  label: 'reposted content',
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
            child: _SectionLabel(
              title: 'MY CIRCLE',
              action: 'Manage',
              onTap: () => _manageConnections(context),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 9, 20, 0),
            child: _connectionPreview(context),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
            child: _SectionLabel(title: 'INTERESTS', action: 'Add below'),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 9, 20, 0),
            child: _interestTags(context),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: _interestComposer(context),
          ),
        ),
        if (_pinnedSections.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
              child: _SectionLabel(
                title: 'PINNED HIGHLIGHTS',
                action: 'Arrange',
                onTap: () => _managePinnedSections(context),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 96,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 9, 20, 0),
                scrollDirection: Axis.horizontal,
                itemCount: _pinnedSections.length,
                separatorBuilder: (_, _) => const SizedBox(width: 9),
                itemBuilder: (context, index) =>
                    _PinnedHighlight(name: _pinnedSections[index]),
              ),
            ),
          ),
        ],
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
            child: _SectionLabel(title: 'FAVORITE MUSIC', action: 'Preview'),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
            child: _FavoriteMusicCard(
              player: _musicPlayer,
              onToggle: _toggleFavoriteMusic,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 13, 22, 0),
            child: _SectionLabel(
              title: 'FAVORITE ARTISTS',
              action: 'Tap to save',
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 11),
            child: SizedBox(
              height: 134,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _artists.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final artist = _artists[index];
                  return _ArtistCard(
                    artist: artist,
                    isFavorite: _favoriteArtists.contains(artist.id),
                    onToggle: () => setState(() {
                      if (!_favoriteArtists.add(artist.id)) {
                        _favoriteArtists.remove(artist.id);
                      }
                    }),
                  );
                },
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
            child: _SectionLabel(
              title: 'YOUR WEEK',
              action: 'See recap',
              onTap: () => _showRecap(context),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(17),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const _WeekMetric(
                        value: '23.4',
                        unit: 'km',
                        label: 'distance',
                      ),
                      const _WeekMetric(value: '8', unit: '', label: 'places'),
                      const _WeekMetric(value: '4', unit: '', label: 'new'),
                      const _WeekMetric(
                        value: '12',
                        unit: '',
                        label: 'activities',
                      ),
                    ],
                  ),
                  const SizedBox(height: 17),
                  const Divider(height: 1),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: AppColors.lime.withValues(alpha: .55),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.local_fire_department_rounded,
                          size: 19,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '6 day streak',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Your longest is 32 days',
                              style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text('🔥', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 25, 22, 10),
            child: const _SectionLabel(
              title: 'SOCIAL TENDENCY',
              action: 'How it works',
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'A little more social lately',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Text(
                        '+8',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const _TendencyScale(score: .64),
                  const SizedBox(height: 10),
                  Text(
                    'A pattern from your activity and optional self check-ins. Not a personality test.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 10,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 25, 22, 10),
            child: _SectionLabel(title: 'EXPLORATION', action: 'All places'),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 133,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFDDE2D2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _ProfileMapPainter(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 0,
                    top: 0,
                    child: Text(
                      '12 places explored',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 22,
                    child: Text(
                      '4 new places this week',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Text(
                      'Location shown approximately',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 9,
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
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 6),
            child: _SectionLabel(
              title: 'ACHIEVEMENTS',
              action: 'View all',
              onTap: () => setState(() => _section = 3),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 98,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _AchievementBadge(
                  icon: Icons.explore_rounded,
                  title: 'Explorer',
                  progress: '7 / 10',
                  color: AppColors.lime,
                ),
                _AchievementBadge(
                  icon: Icons.wb_sunny_outlined,
                  title: 'Weekend',
                  progress: '4 weekends',
                  color: AppColors.peach,
                ),
                _AchievementBadge(
                  icon: Icons.people_alt_outlined,
                  title: 'Community',
                  progress: '3 collabs',
                  color: AppColors.lavender,
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 9, 16, 0),
            child: Row(
              children: [
                for (final tab in [
                  (0, 'Posts'),
                  (1, 'Replies'),
                  (2, 'Moments'),
                  (3, 'Activity'),
                  (4, 'Reposts'),
                ])
                  Expanded(
                    child: _ProfileTab(
                      label: tab.$2,
                      selected: _section == tab.$1,
                      onTap: () => setState(() => _section = tab.$1),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (visiblePosts.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
              child: Text(
                switch (_section) {
                  0 => 'Your posts will appear here.',
                  1 => 'Your replies will appear here.',
                  2 => 'Your shared moments will appear here.',
                  3 => 'Your activity will appear here.',
                  _ => 'Content you repost will appear here.',
                },
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          SliverList.builder(
            itemCount: visiblePosts.length,
            itemBuilder: (context, index) =>
                SocialPostTile(post: visiblePosts[index]),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.shield_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your activity, your choice',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Choose what appears on your profile.',
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _shareStats,
                    onChanged: (value) => setState(() => _shareStats = value),
                    activeTrackColor: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _connectionPreview(BuildContext context) {
    if (!_showConnectionsOnProfile) {
      return Text(
        'Your circle is hidden from your profile.',
        style: TextStyle(
          fontSize: 11,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }
    final visible = _connections
        .where(
          (connection) =>
              connection.status == _ConnectionStatus.accepted &&
              connection.showOnProfile,
        )
        .take(_maxVisibleConnections)
        .toList();
    if (visible.isEmpty) {
      return Text(
        'No connections to show yet.',
        style: TextStyle(
          fontSize: 11,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }
    return Row(
      children: [
        for (final connection in visible)
          Expanded(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 19,
                  backgroundColor: AppColors.lavender,
                  child: Text(
                    _initials(connection.name),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  connection.name.split(' ').first,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  connection.relation,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: InkWell(
            onTap: () => _manageConnections(context),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 19,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest,
                  child: const Icon(Icons.add_rounded, size: 19),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Add',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                ),
                Text(
                  '${_connections.where((item) => item.status == _ConnectionStatus.incoming).length} requests',
                  style: TextStyle(
                    fontSize: 9,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _manageConnections(BuildContext pageContext) {
    showModalBottomSheet<void>(
      context: pageContext,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) {
          void update(void Function() action) {
            setState(action);
            setSheetState(() {});
          }

          return SafeArea(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * .78,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 12, 6),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Your circle',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(sheetContext),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ),
                  SwitchListTile.adaptive(
                    title: const Text('Show on my profile'),
                    subtitle: const Text('Only accepted connections appear.'),
                    value: _showConnectionsOnProfile,
                    onChanged: (value) =>
                        update(() => _showConnectionsOnProfile = value),
                  ),
                  if (_showConnectionsOnProfile)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Maximum shown',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          Text(
                            '$_maxVisibleConnections',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: Slider(
                              min: 1,
                              max: 6,
                              divisions: 5,
                              value: _maxVisibleConnections.toDouble(),
                              onChanged: (value) => update(
                                () => _maxVisibleConnections = value.round(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView(
                      children: [
                        for (final connection in _connections)
                          _connectionManagerTile(connection, update),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.pop(sheetContext);
                          _addConnectionDialog(pageContext);
                        },
                        icon: const Icon(Icons.person_add_alt_1_rounded),
                        label: const Text('Add someone'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _connectionManagerTile(
    _ProfileConnection connection,
    void Function(void Function()) update,
  ) {
    switch (connection.status) {
      case _ConnectionStatus.accepted:
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.lavender,
            child: Text(_initials(connection.name)),
          ),
          title: Text(connection.name),
          subtitle: Text(connection.relation),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Show', style: TextStyle(fontSize: 10)),
              Switch.adaptive(
                value: connection.showOnProfile,
                onChanged: (value) => update(
                  () => _replaceConnection(
                    connection.copyWith(showOnProfile: value),
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Remove connection',
                onPressed: () => update(() => _connections.remove(connection)),
                icon: const Icon(Icons.close_rounded, size: 18),
              ),
            ],
          ),
        );
      case _ConnectionStatus.incoming:
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.peach,
            child: Text(_initials(connection.name)),
          ),
          title: Text(connection.name),
          subtitle: Text(
            'Wants to add you as ${connection.relation.toLowerCase()}',
          ),
          trailing: Wrap(
            spacing: 4,
            children: [
              IconButton.filledTonal(
                tooltip: 'Approve request',
                onPressed: () => update(
                  () => _replaceConnection(
                    connection.copyWith(
                      status: _ConnectionStatus.accepted,
                      showOnProfile: true,
                    ),
                  ),
                ),
                icon: const Icon(Icons.check_rounded),
              ),
              IconButton(
                tooltip: 'Decline request',
                onPressed: () => update(() => _connections.remove(connection)),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
        );
      case _ConnectionStatus.outgoing:
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.lime,
            child: Text(_initials(connection.name)),
          ),
          title: Text(connection.name),
          subtitle: Text('${connection.relation} · waiting for approval'),
          trailing: TextButton(
            onPressed: () => update(() => _connections.remove(connection)),
            child: const Text('Cancel'),
          ),
        );
    }
  }

  void _replaceConnection(_ProfileConnection updated) {
    final index = _connections.indexWhere(
      (item) => item.handle == updated.handle,
    );
    if (index >= 0) _connections[index] = updated;
  }

  void _addConnectionDialog(BuildContext context) {
    final nameController = TextEditingController();
    var relation = 'Friend';
    showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Send a connection request'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Name or @username',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: relation,
                decoration: const InputDecoration(labelText: 'Relationship'),
                items:
                    const [
                          'Partner',
                          'Friend',
                          'Close friend',
                          'Trusted person',
                          'Other',
                        ]
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) setDialogState(() => relation = value);
                },
              ),
              const SizedBox(height: 8),
              Text(
                'They must approve before this connection appears on your profile.',
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final name = nameController.text.trim().replaceFirst(
                  RegExp(r'^@'),
                  '',
                );
                if (name.isEmpty) return;
                setState(
                  () => _connections.add(
                    _ProfileConnection(
                      name: name,
                      handle: name.toLowerCase().replaceAll(RegExp(r'\s+'), ''),
                      relation: relation,
                      status: _ConnectionStatus.outgoing,
                    ),
                  ),
                );
                Navigator.pop(dialogContext);
              },
              child: const Text('Send request'),
            ),
          ],
        ),
      ),
    ).whenComplete(nameController.dispose);
  }

  String _initials(String name) => name
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .take(2)
      .map((word) => word[0].toUpperCase())
      .join();

  void _managePinnedSections(BuildContext context) {
    const options = [
      'YOUR WEEK',
      'STREAK',
      'SOCIAL TENDENCY',
      'EXPLORATION',
      'ACHIEVEMENTS',
      'FAVORITE MUSIC',
      'FAVORITE ARTISTS',
    ];
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) {
          void togglePin(String section) {
            setState(() {
              if (_pinnedSections.contains(section)) {
                _pinnedSections.remove(section);
              } else {
                _pinnedSections.add(section);
              }
            });
            setSheetState(() {});
          }

          return SafeArea(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * .72,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 12, 4),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Pinned highlights',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(sheetContext),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Choose what appears near the top of your profile.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Wrap(
                      spacing: 7,
                      runSpacing: 2,
                      children: [
                        for (final option in options)
                          FilterChip(
                            label: Text(_pinTitle(option)),
                            selected: _pinnedSections.contains(option),
                            onSelected: (_) => togglePin(option),
                            visualDensity: VisualDensity.compact,
                          ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ReorderableListView.builder(
                      padding: const EdgeInsets.only(top: 4),
                      itemCount: _pinnedSections.length,
                      onReorderItem: (oldIndex, newIndex) {
                        setState(() {
                          final section = _pinnedSections.removeAt(oldIndex);
                          _pinnedSections.insert(newIndex, section);
                        });
                        setSheetState(() {});
                      },
                      itemBuilder: (context, index) {
                        final name = _pinnedSections[index];
                        final detail = _pinDetails(name);
                        return ListTile(
                          key: ValueKey(name),
                          leading: CircleAvatar(
                            backgroundColor: detail.color,
                            child: Icon(detail.icon, size: 18),
                          ),
                          title: Text(_pinTitle(name)),
                          subtitle: Text(detail.subtitle),
                          trailing: const Icon(Icons.drag_handle_rounded),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => Navigator.pop(sheetContext),
                        child: const Text('Done'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _pinTitle(String key) => switch (key) {
    'YOUR WEEK' => 'Your week',
    'STREAK' => 'Streak',
    'SOCIAL TENDENCY' => 'Social tendency',
    'EXPLORATION' => 'Exploration',
    'ACHIEVEMENTS' => 'Achievements',
    'FAVORITE MUSIC' => 'Favorite music',
    _ => 'Favorite artists',
  };

  ({IconData icon, String subtitle, Color color}) _pinDetails(String key) =>
      switch (key) {
        'YOUR WEEK' => (
          icon: Icons.insights_rounded,
          subtitle: '12 activities · 8 places',
          color: AppColors.lime,
        ),
        'STREAK' => (
          icon: Icons.local_fire_department_rounded,
          subtitle: '6 day streak',
          color: AppColors.peach,
        ),
        'SOCIAL TENDENCY' => (
          icon: Icons.people_alt_outlined,
          subtitle: 'A little more social lately',
          color: AppColors.lavender,
        ),
        'EXPLORATION' => (
          icon: Icons.explore_rounded,
          subtitle: '12 places explored',
          color: const Color(0xFFB8D2C1),
        ),
        'ACHIEVEMENTS' => (
          icon: Icons.workspace_premium_rounded,
          subtitle: '3 badges earned',
          color: AppColors.peach,
        ),
        'FAVORITE MUSIC' => (
          icon: Icons.music_note_rounded,
          subtitle: 'Golden hour loop',
          color: AppColors.lavender,
        ),
        _ => (
          icon: Icons.favorite_rounded,
          subtitle: 'Favorite artists',
          color: AppColors.lime,
        ),
      };

  IconData _interestIcon(String interest) {
    final topic = interest.toLowerCase();
    if (topic.contains('music') || topic.contains('song')) {
      return Icons.music_note_rounded;
    }
    if (topic.contains('photo') || topic.contains('camera')) {
      return Icons.camera_alt_outlined;
    }
    if (topic.contains('hike') || topic.contains('outdoor')) {
      return Icons.hiking_rounded;
    }
    if (topic.contains('coffee')) {
      return Icons.coffee_rounded;
    }
    if (topic.contains('travel')) {
      return Icons.flight_takeoff_rounded;
    }
    if (topic.contains('food') || topic.contains('cook')) {
      return Icons.restaurant_outlined;
    }
    if (topic.contains('book') || topic.contains('read')) {
      return Icons.menu_book_outlined;
    }
    if (topic.contains('fashion')) {
      return Icons.checkroom_outlined;
    }
    if (topic.contains('fitness') || topic.contains('sport')) {
      return Icons.fitness_center_rounded;
    }
    return Icons.auto_awesome_outlined;
  }

  Widget _interestTags(BuildContext context) {
    final now = DateTime.now();
    final active = _interests
        .where(
          (interest) =>
              interest.expiresAt == null || interest.expiresAt!.isAfter(now),
        )
        .toList();
    if (active.isEmpty) {
      return Text(
        'Add a few things you enjoy.',
        style: TextStyle(
          fontSize: 11,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final interest in active)
          Container(
            padding: const EdgeInsets.fromLTRB(10, 7, 5, 7),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: .55),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_interestIcon(interest.name), size: 15),
                const SizedBox(width: 6),
                Text(
                  interest.name,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (interest.expiresAt case final expiresAt?) ...[
                  const SizedBox(width: 5),
                  Text(
                    '${(expiresAt.difference(now).inDays + 1)}d',
                    style: TextStyle(
                      fontSize: 9,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(width: 3),
                InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => setState(() => _interests.remove(interest)),
                  child: const Padding(
                    padding: EdgeInsets.all(3),
                    child: Icon(Icons.close_rounded, size: 13),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _interestComposer(BuildContext context) => Row(
    children: [
      Expanded(
        child: TextField(
          controller: _interestController,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _addInterest(),
          decoration: InputDecoration(
            hintText: 'Add your own interest',
            isDense: true,
            prefixIcon: const Icon(Icons.add_rounded, size: 19),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 11,
              horizontal: 12,
            ),
          ),
        ),
      ),
      const SizedBox(width: 8),
      DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _interestExpiryChoice,
          borderRadius: BorderRadius.circular(12),
          items: const [
            DropdownMenuItem(value: 'Never', child: Text('Never')),
            DropdownMenuItem(value: '1 day', child: Text('1 day')),
            DropdownMenuItem(value: '1 week', child: Text('1 week')),
            DropdownMenuItem(value: '1 month', child: Text('1 month')),
            DropdownMenuItem(value: 'Custom date', child: Text('Custom')),
          ],
          onChanged: _setInterestExpiry,
        ),
      ),
      IconButton.filledTonal(
        tooltip: 'Add interest',
        onPressed: _addInterest,
        icon: const Icon(Icons.arrow_upward_rounded, size: 18),
      ),
    ],
  );

  void _addInterest() {
    final name = _interestController.text.trim();
    _interests.removeWhere(
      (item) => item.expiresAt?.isBefore(DateTime.now()) ?? false,
    );
    if (name.isEmpty ||
        _interests.any(
          (item) => item.name.toLowerCase() == name.toLowerCase(),
        )) {
      return;
    }
    final days = switch (_interestExpiryChoice) {
      '1 day' => 1,
      '1 week' => 7,
      '1 month' => 30,
      _ => null,
    };
    final expiresAt = switch (_interestExpiryChoice) {
      'Custom date' => _customInterestExpiry,
      'Never' => null,
      _ => DateTime.now().add(Duration(days: days ?? 30)),
    };
    setState(() {
      _interests.insert(0, _ProfileInterest(name, expiresAt));
      _interestController.clear();
    });
  }

  Future<void> _setInterestExpiry(String? value) async {
    if (value == null) return;
    if (value == 'Custom date') {
      final selected = await showDatePicker(
        context: context,
        initialDate: _customInterestExpiry.isAfter(DateTime.now())
            ? _customInterestExpiry
            : DateTime.now().add(const Duration(days: 1)),
        firstDate: DateTime.now().add(const Duration(days: 1)),
        lastDate: DateTime.now().add(const Duration(days: 3650)),
      );
      if (selected == null || !mounted) return;
      setState(() {
        _customInterestExpiry = selected;
        _interestExpiryChoice = value;
      });
      return;
    }
    setState(() => _interestExpiryChoice = value);
  }

  void _settings(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.palette_outlined),
            title: Text('Appearance'),
            subtitle: Text('System default, light or dark'),
            onTap: () {
              Navigator.pop(sheetContext);
              _chooseTheme(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.lock_outline),
            title: Text('Privacy and visibility'),
          ),
          ListTile(
            leading: Icon(Icons.location_on_outlined),
            title: Text('Location settings'),
          ),
          ListTile(
            leading: Icon(Icons.notifications_outlined),
            title: Text('Notifications'),
          ),
        ],
      ),
    ),
  );

  void _chooseTheme(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        final selectedMode = ref.read(themeModeProvider);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Choose your theme',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              _themeOption(
                sheetContext,
                ThemeMode.system,
                'System default',
                Icons.brightness_auto_rounded,
                selectedMode,
              ),
              _themeOption(
                sheetContext,
                ThemeMode.light,
                'Light mode',
                Icons.light_mode_outlined,
                selectedMode,
              ),
              _themeOption(
                sheetContext,
                ThemeMode.dark,
                'Dark mode',
                Icons.dark_mode_outlined,
                selectedMode,
              ),
              SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _themeOption(
    BuildContext context,
    ThemeMode mode,
    String label,
    IconData icon,
    ThemeMode selectedMode,
  ) => ListTile(
    leading: Icon(icon),
    title: Text(label),
    trailing: selectedMode == mode
        ? Icon(
            Icons.check_rounded,
            color: Theme.of(context).colorScheme.primary,
          )
        : null,
    selected: selectedMode == mode,
    onTap: () {
      ref.read(themeModeProvider.notifier).state = mode;
      Navigator.pop(context);
    },
  );

  void _showRecap(BuildContext context) => showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Your week'),
      content: const Text(
        '12 activities across 8 places. Four were somewhere new. You showed up on 6 days.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Done'),
        ),
      ],
    ),
  );
}

class _ProfileHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _ProfileHeaderDelegate({
    required this.onEdit,
    required this.onSettings,
  });

  final VoidCallback onEdit;
  final VoidCallback onSettings;

  @override
  double get minExtent => 66;

  @override
  double get maxExtent => 198;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final collapse = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final bannerHeight = 100 * (1 - collapse);
    final avatarSize = 70 - (28 * collapse);
    final theme = Theme.of(context);

    return Material(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          SizedBox(
            height: bannerHeight,
            child: Opacity(
              opacity: 1 - collapse,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.lime,
                          AppColors.lavender,
                          AppColors.peach,
                        ],
                      ),
                    ),
                    child: CustomPaint(painter: _ProfileBannerPainter()),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _headerAction(
                          context,
                          Icons.edit_outlined,
                          'Edit profile',
                          onEdit,
                        ),
                        _headerAction(
                          context,
                          Icons.settings_outlined,
                          'Settings',
                          onSettings,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    child: PersonAvatar(
                      initials: 'AP',
                      size: avatarSize,
                      color: AppColors.lime,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ari Pratama',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18 - (4 * collapse),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '@aripratama',
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        ClipRect(
                          child: Align(
                            alignment: Alignment.topLeft,
                            heightFactor: 1 - collapse,
                            child: Opacity(
                              opacity: 1 - collapse,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  'Finding the long way home. Usually with coffee.',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Opacity(
                    opacity: collapse,
                    child: IgnorePointer(
                      ignoring: collapse < .5,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _headerAction(
                            context,
                            Icons.edit_outlined,
                            'Edit profile',
                            onEdit,
                          ),
                          _headerAction(
                            context,
                            Icons.settings_outlined,
                            'Settings',
                            onSettings,
                          ),
                        ],
                      ),
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

  Widget _headerAction(
    BuildContext context,
    IconData icon,
    String tooltip,
    VoidCallback onPressed,
  ) => IconButton(
    tooltip: tooltip,
    onPressed: onPressed,
    visualDensity: VisualDensity.compact,
    icon: Icon(icon),
    style: IconButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.surface
          .withValues(alpha: .82),
    ),
  );

  @override
  bool shouldRebuild(covariant _ProfileHeaderDelegate oldDelegate) =>
      oldDelegate.onEdit != onEdit || oldDelegate.onSettings != onSettings;
}

class _ProfileInterest {
  const _ProfileInterest(this.name, this.expiresAt);

  final String name;
  final DateTime? expiresAt;
}

enum _ConnectionStatus { incoming, outgoing, accepted }

class _ProfileConnection {
  const _ProfileConnection({
    required this.name,
    required this.handle,
    required this.relation,
    required this.status,
    this.showOnProfile = false,
  });

  final String name;
  final String handle;
  final String relation;
  final _ConnectionStatus status;
  final bool showOnProfile;

  _ProfileConnection copyWith({
    String? relation,
    _ConnectionStatus? status,
    bool? showOnProfile,
  }) => _ProfileConnection(
    name: name,
    handle: handle,
    relation: relation ?? this.relation,
    status: status ?? this.status,
    showOnProfile: showOnProfile ?? this.showOnProfile,
  );
}

class _PinnedHighlight extends StatelessWidget {
  const _PinnedHighlight({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final (title, subtitle, icon, color) = switch (name) {
      'YOUR WEEK' => (
        'Your week',
        '12 activities · 8 places',
        Icons.insights_rounded,
        AppColors.lime,
      ),
      'STREAK' => (
        'Streak',
        '6 day streak',
        Icons.local_fire_department_rounded,
        AppColors.peach,
      ),
      'SOCIAL TENDENCY' => (
        'Social tendency',
        'A little more social',
        Icons.people_alt_outlined,
        AppColors.lavender,
      ),
      'EXPLORATION' => (
        'Exploration',
        '12 places explored',
        Icons.explore_rounded,
        const Color(0xFFB8D2C1),
      ),
      'ACHIEVEMENTS' => (
        'Achievements',
        '3 badges earned',
        Icons.workspace_premium_rounded,
        AppColors.peach,
      ),
      'FAVORITE MUSIC' => (
        'Favorite music',
        'Golden hour loop',
        Icons.music_note_rounded,
        AppColors.lavender,
      ),
      _ => (
        'Favorite artists',
        'Your current favorites',
        Icons.favorite_rounded,
        AppColors.lime,
      ),
    };
    return Container(
      width: 166,
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .27),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 19,
            backgroundColor: color,
            child: Icon(icon, size: 19),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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

class _FavoriteMusicCard extends StatelessWidget {
  const _FavoriteMusicCard({required this.player, required this.onToggle});
  final AudioPlayer player;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.surfaceContainerHighest,
        ],
      ),
      borderRadius: BorderRadius.circular(21),
      border: Border.all(
        color: Theme.of(context).dividerColor.withValues(alpha: .5),
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.peach, AppColors.lavender],
            ),
            borderRadius: BorderRadius.circular(17),
          ),
          child: const Icon(
            Icons.album_rounded,
            size: 38,
            color: Color(0xFF3D554A),
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ON REPEAT',
                style: TextStyle(
                  fontSize: 8,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                'Golden hour loop',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              const SizedBox(height: 3),
              Text(
                'Waypoint original · instrumental',
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 9),
              StreamBuilder<Duration>(
                stream: player.positionStream,
                builder: (context, snapshot) {
                  final duration = player.duration?.inMilliseconds ?? 8000;
                  final position = snapshot.data?.inMilliseconds ?? 0;
                  return LinearProgressIndicator(
                    value: duration == 0
                        ? 0
                        : (position / duration).clamp(0.0, 1.0),
                    minHeight: 3,
                    color: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).dividerColor,
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 7),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playing = snapshot.data?.playing ?? false;
            return IconButton.filledTonal(
              onPressed: onToggle,
              tooltip: playing ? 'Pause favorite music' : 'Play favorite music',
              icon: Icon(
                playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
              ),
            );
          },
        ),
      ],
    ),
  );
}

const _artists = <_Artist>[
  _Artist('niki', 'NIKI', 'Pop · R&B', 'N', Color(0xFFD7A888)),
  _Artist('hindia', 'Hindia', 'Indie pop', 'H', Color(0xFF829982)),
  _Artist('laufey', 'Laufey', 'Jazz · Pop', 'L', Color(0xFFB2A1C9)),
  _Artist(
    'reality-club',
    'Reality Club',
    'Indie rock',
    'RC',
    Color(0xFF7897A1),
  ),
];

class _Artist {
  const _Artist(this.id, this.name, this.genre, this.initials, this.color);

  final String id;
  final String name;
  final String genre;
  final String initials;
  final Color color;
}

class _ArtistCard extends StatelessWidget {
  const _ArtistCard({
    required this.artist,
    required this.isFavorite,
    required this.onToggle,
  });

  final _Artist artist;
  final bool isFavorite;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) => Container(
    width: 140,
    padding: const EdgeInsets.fromLTRB(12, 11, 9, 10),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          artist.color.withValues(alpha: .4),
          Theme.of(context).colorScheme.surface,
        ],
      ),
      borderRadius: BorderRadius.circular(19),
      border: Border.all(color: artist.color.withValues(alpha: .35)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: artist.color,
              child: Text(
                artist.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: onToggle,
              visualDensity: VisualDensity.compact,
              tooltip: isFavorite
                  ? 'Remove favorite artist'
                  : 'Favorite artist',
              icon: Icon(
                isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                size: 19,
                color: isFavorite
                    ? const Color(0xFFCB6A61)
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const Spacer(),
        Text(
          artist.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 3),
        Text(
          artist.genre,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 9,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );
}

class _SocialCount extends StatelessWidget {
  const _SocialCount({required this.number, required this.label});
  final String number, label;
  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        Text(
          number,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );
}

class _WeekMetric extends StatelessWidget {
  const _WeekMetric({
    required this.value,
    required this.unit,
    required this.label,
  });

  final String value;
  final String unit;
  final String label;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
              TextSpan(text: unit, style: const TextStyle(fontSize: 10)),
            ],
          ),
        ),
        const SizedBox(height: 3),
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title, required this.action, this.onTap});
  final String title, action;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(title, style: Theme.of(context).textTheme.labelSmall),
      ),
      if (action.isNotEmpty)
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
    ],
  );
}

class _ProfileBannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(size.width * .78, size.height * .7),
      size.height * .72,
      Paint()..color = Colors.white.withValues(alpha: .18),
    );
    canvas.drawCircle(
      Offset(size.width * .95, size.height * .08),
      size.height * .42,
      Paint()..color = Colors.white.withValues(alpha: .2),
    );
    final hill = Path()
      ..moveTo(0, size.height * .8)
      ..quadraticBezierTo(
        size.width * .35,
        size.height * .48,
        size.width * .62,
        size.height * .78,
      )
      ..quadraticBezierTo(
        size.width * .84,
        size.height * .98,
        size.width,
        size.height * .63,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hill, Paint()..color = Colors.white.withValues(alpha: .2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TendencyScale extends StatelessWidget {
  const _TendencyScale({required this.score});

  final double score;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(
        'Reserved',
        style: TextStyle(
          fontSize: 10,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9),
          child: LayoutBuilder(
            builder: (context, box) => Stack(
              children: [
                Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  color: Theme.of(context).dividerColor,
                ),
                Positioned(
                  left: (box.maxWidth - 14) * score,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Text(
        'Social',
        style: TextStyle(
          fontSize: 10,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      const SizedBox(width: 8),
      const Text(
        '64',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    ],
  );
}

class _ProfileMapPainter extends CustomPainter {
  const _ProfileMapPainter(this.markerColor);

  final Color markerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()
      ..color = Colors.white.withValues(alpha: .72)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * .15, size.height * .9),
      Offset(size.width * .65, size.height * .1),
      road,
    );
    canvas.drawLine(
      Offset(size.width * .48, size.height * .38),
      Offset(size.width * .9, size.height * .86),
      road,
    );
    for (final point in [
      Offset(size.width * .34, size.height * .56),
      Offset(size.width * .71, size.height * .47),
      Offset(size.width * .84, size.height * .25),
    ]) {
      canvas.drawCircle(point, 6, Paint()..color = markerColor);
      canvas.drawCircle(point, 2.5, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AchievementBadge extends StatelessWidget {
  const _AchievementBadge({
    required this.icon,
    required this.title,
    required this.progress,
    required this.color,
  });
  final IconData icon;
  final String title, progress;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    width: 148,
    margin: const EdgeInsets.only(right: 9),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: color,
          child: Icon(
            icon,
            size: 18,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(width: 9),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
              ),
              Text(
                progress,
                style: TextStyle(
                  fontSize: 9,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 2,
          color: selected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
        ),
      ],
    ),
  );
}
