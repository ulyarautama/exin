import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../../../app/theme/app_theme.dart';
import '../../activity/presentation/activity_screen.dart';
import '../../messaging/presentation/messages_screen.dart';
import '../../shell/presentation/create_sheet.dart';
import '../../profile/presentation/public_profile_screen.dart';
import '../../../shared/widgets/person_avatar.dart';
import '../application/feed_controller.dart';
import '../domain/post.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(feedControllerProvider);
    return RefreshIndicator(
      onRefresh: () => ref.read(feedControllerProvider.notifier).load(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.extentAfter < 360) {
            ref.read(feedControllerProvider.notifier).loadMore();
          }
          return false;
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _HomeHeader()),
            SliverToBoxAdapter(child: _FieldNoteComposer()),
            SliverToBoxAdapter(child: _FieldNotesRail()),
            if (posts.isEmpty)
              SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else
              SliverList.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) =>
                    SocialPostTile(post: posts[index]),
              ),
            SliverToBoxAdapter(child: SizedBox(height: 28)),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(22, 12, 18, 10),
    child: Row(
      children: [
        Text(
          'waypoint',
          style: Theme.of(context).textTheme.headlineMedium
              ?.copyWith(fontSize: 27, letterSpacing: -1.4),
        ),
        SizedBox(width: 7),
        Icon(
          Icons.near_me_rounded,
          size: 15,
          color: Theme.of(context).colorScheme.primary,
        ),
        Spacer(),
        IconButton(
          onPressed: () {},
          visualDensity: VisualDensity.compact,
          icon: Icon(Icons.search_rounded, size: 24),
        ),
        IconButton(
          tooltip: 'Activity',
          visualDensity: VisualDensity.compact,
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (_) => ActivityScreen())),
          icon: Icon(Icons.notifications_none_rounded, size: 23),
        ),
      ],
    ),
  );
}

class _FieldNoteComposer extends StatelessWidget {
  const _FieldNoteComposer();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _openCreateSheet(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.lime, AppColors.peach],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.route_rounded, size: 21),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Leave a field note',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'A place, a thought, a small discovery…',
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_rounded,
              size: 19,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    ),
  );
}

void _openCreateSheet(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (_) => const CreateSheet(),
);

void _openPublicProfile(
  BuildContext context,
  String name,
  String handle,
  String initials,
  Color tint,
) => Navigator.of(context).push(
  MaterialPageRoute<void>(
    builder: (_) => PublicProfileScreen(
      profile: demoProfileFor(
        name: name,
        handle: handle,
        initials: initials,
        tint: tint,
      ),
    ),
  ),
);

class _FieldNotesRail extends StatelessWidget {
  const _FieldNotesRail();

  static const _notes = [
    (
      'WEEKEND QUEST',
      'Three new corners to find',
      Icons.flag_rounded,
      AppColors.lime,
    ),
    (
      'CITY PULSE',
      '14 places glowing nearby',
      Icons.radar_rounded,
      AppColors.lavender,
    ),
    (
      'OPEN ROUTE',
      'A quiet walk after sunset',
      Icons.alt_route_rounded,
      AppColors.peach,
    ),
  ];

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 2, 18, 9),
          child: Row(
            children: [
              Text(
                'AROUND YOUR ORBIT',
                style: Theme.of(context).textTheme.labelSmall
                    ?.copyWith(letterSpacing: 1.1),
              ),
              const Spacer(),
              Icon(
                Icons.explore_outlined,
                size: 15,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                'Explore',
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 86,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _notes.length,
            separatorBuilder: (_, _) => const SizedBox(width: 9),
            itemBuilder: (context, index) {
              final note = _notes[index];
              return Container(
                width: 224,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: note.$4.withValues(alpha: .28),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: note.$4,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(note.$3, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.$1,
                            style: const TextStyle(
                              fontSize: 8,
                              letterSpacing: .9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            note.$2,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

class _FollowAvatar extends ConsumerWidget {
  const _FollowAvatar({
    required this.author,
    required this.handle,
    required this.initials,
    required this.color,
  });

  final String author;
  final String handle;
  final String initials;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followedHandles = ref.watch(followedHandlesProvider);
    final isFollowing = followedHandles.contains(handle);
    final primary = Theme.of(context).colorScheme.primary;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          customBorder: const CircleBorder(),
          onTap: () =>
              _openPublicProfile(context, author, handle, initials, color),
          child: PersonAvatar(initials: initials, size: 42, color: color),
        ),
        Positioned(
          right: -3,
          bottom: -3,
          child: Tooltip(
            message: isFollowing ? 'Following' : 'Follow',
            child: Material(
              color: isFollowing
                  ? Theme.of(context).colorScheme.surface
                  : primary,
              shape: CircleBorder(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.surface,
                  width: 2,
                ),
              ),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  final updated = {...followedHandles};
                  if (isFollowing) {
                    updated.remove(handle);
                  } else {
                    updated.add(handle);
                  }
                  ref.read(followedHandlesProvider.notifier).state = updated;
                },
                child: SizedBox(
                  width: 21,
                  height: 21,
                  child: Icon(
                    isFollowing ? Icons.check_rounded : Icons.add_rounded,
                    size: 13,
                    color: isFollowing
                        ? Theme.of(context).colorScheme.onSurface
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SocialPostTile extends ConsumerWidget {
  const SocialPostTile({super.key, required this.post});
  final SocialPost post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = post.artwork.isEven ? AppColors.peach : Color(0xFFD3D7B2);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.reposted)
            Padding(
              padding: EdgeInsets.fromLTRB(16, 13, 16, 0),
              child: Row(
                children: [
                  Icon(
                    Icons.repeat_rounded,
                    size: 15,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'You reposted',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 14, 8, 10),
            child: Row(
              children: [
                _FollowAvatar(
                  author: post.author,
                  handle: post.handle,
                  initials: post.initials,
                  color: color,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => _openPublicProfile(
                          context,
                          post.author,
                          post.handle,
                          post.initials,
                          color,
                        ),
                        child: Text(
                          post.author,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Text(
                        post.time,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _showPostMenu(context),
                  icon: Icon(
                    Icons.more_horiz,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (post.quote != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.quoteAuthor == null
                          ? 'Original post'
                          : '${post.isReply ? 'Replying to' : 'Post by'} ${post.quoteAuthor}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      post.quote!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              post.body,
              style: TextStyle(fontSize: 14, height: 1.45),
            ),
          ),
          if (post.kind == PostKind.photo || post.kind == PostKind.video)
            _PhotoArtwork(
              color: color,
              place: post.place ?? 'A little detour',
              index: post.artwork,
              isVideo: post.kind == PostKind.video,
            ),
          if (post.kind == PostKind.activity) _ActivityContent(post: post),
          if (post.kind == PostKind.challenge) const _ChallengeContent(),
          if (post.kind == PostKind.tendency) const _TendencyContent(),
          if (post.kind == PostKind.exploration)
            _ExplorationContent(place: post.place),
          if (post.kind == PostKind.achievement) const _AchievementContent(),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
            child: Row(
              children: [
                _PostAction(
                  icon: post.liked
                      ? Icons.favorite
                      : Icons.favorite_border_rounded,
                  label: '${post.likes + (post.liked ? 1 : 0)}',
                  color: post.liked ? Color(0xFFCB6A61) : null,
                  onTap: () => ref
                      .read(feedControllerProvider.notifier)
                      .toggleLike(post.id),
                ),
                _PostAction(
                  icon: Icons.mode_comment_outlined,
                  label: '${post.comments}',
                  onTap: () => _showComments(context),
                ),
                _PostAction(
                  icon: Icons.repeat_rounded,
                  label: '',
                  color: post.reposted
                      ? Theme.of(context).colorScheme.primary
                      : null,
                  onTap: () => _showRepost(context, ref),
                ),
                _PostAction(
                  icon: Icons.ios_share_rounded,
                  label: '',
                  onTap: () => _showShare(context),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {},
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    Icons.bookmark_border_rounded,
                    size: 21,
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

  void _showRepost(BuildContext context, WidgetRef ref) =>
      showModalBottomSheet<void>(
        context: context,
        builder: (sheetContext) => SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.reply_rounded),
                title: Text('Reply as a post'),
                subtitle: Text('Publish your reply on your profile'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _quoteDialog(context, ref, isReply: true);
                },
              ),
              ListTile(
                leading: Icon(Icons.repeat_rounded),
                title: Text('Repost'),
                subtitle: Text('Share this moment with your followers'),
                onTap: () {
                  ref.read(feedControllerProvider.notifier).repost(post.id);
                  Navigator.pop(sheetContext);
                },
              ),
              ListTile(
                leading: Icon(Icons.format_quote_rounded),
                title: Text('Quote repost'),
                subtitle: Text('Add your own thought'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _quoteDialog(context, ref);
                },
              ),
            ],
          ),
        ),
      );

  void _showShare(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    builder: (sheetContext) => SafeArea(
      child: Wrap(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 18, 20, 4),
            child: Text(
              'Share this moment',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.link_rounded),
            title: const Text('Copy link'),
            onTap: () async {
              await Clipboard.setData(
                ClipboardData(text: 'waypoint://post/${post.id}'),
              );
              if (sheetContext.mounted) Navigator.pop(sheetContext);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post link copied')),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.mail_outline_rounded),
            title: const Text('Send to inbox'),
            onTap: () {
              Navigator.pop(sheetContext);
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const MessagesScreen()),
              );
            },
          ),
        ],
      ),
    ),
  );

  Future<void> _quoteDialog(
    BuildContext context,
    WidgetRef ref, {
    bool isReply = false,
  }) async {
    final controller = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isReply ? 'Reply as a post' : 'Add a thought'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: isReply
                ? 'Write your reply'
                : 'Say something about this moment',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                if (isReply) {
                  ref
                      .read(feedControllerProvider.notifier)
                      .replyPost(post.id, text);
                } else {
                  ref
                      .read(feedControllerProvider.notifier)
                      .quoteRepost(post.id, text);
                }
              }
              Navigator.pop(dialogContext);
            },
            child: Text(isReply ? 'Post reply' : 'Quote'),
          ),
        ],
      ),
    );
    controller.dispose();
  }

  Future<void> _showComments(BuildContext context) async {
    final controller = TextEditingController();
    final comments = <_PostComment>[
      const _PostComment(
        'MP',
        'Maya Putri',
        'This light is so lovely.',
        AppColors.peach,
      ),
      const _PostComment(
        'RA',
        'Rafi Aditya',
        'Adding this to my weekend walk.',
        AppColors.lavender,
      ),
      const _PostComment('NS', 'Nadia S.', 'Where is this?', Color(0xFFE7C9A6)),
    ];

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: .24),
      builder: (sheetContext) => DraggableScrollableSheet(
        initialChildSize: .5,
        minChildSize: .44,
        maxChildSize: .72,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: StatefulBuilder(
            builder: (context, setSheetState) => Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Comments',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Text(
                        '${comments.length}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: Theme.of(context).dividerColor),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    itemCount: comments.length,
                    itemBuilder: (context, index) =>
                        _CommentRow(comment: comments[index]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    14,
                    8,
                    14,
                    MediaQuery.viewInsetsOf(context).bottom + 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          minLines: 1,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Add a comment…',
                            filled: true,
                            fillColor: Theme.of(context)
                                .scaffoldBackgroundColor,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 11,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),
                      IconButton.filled(
                        onPressed: () {
                          final text = controller.text.trim();
                          if (text.isEmpty) return;
                          setSheetState(
                            () => comments.insert(
                              0,
                              _PostComment(
                                'AP',
                                'Ari Pratama',
                                text,
                                AppColors.lime,
                              ),
                            ),
                          );
                          controller.clear();
                        },
                        icon: const Icon(Icons.send_rounded, size: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    controller.dispose();
  }

  void _showPostMenu(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    builder: (_) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.visibility_off_outlined),
            title: Text('Hide this post'),
          ),
          ListTile(
            leading: Icon(Icons.volume_off_outlined),
            title: Text('Mute account'),
          ),
          ListTile(leading: Icon(Icons.flag_outlined), title: Text('Report')),
        ],
      ),
    ),
  );
}

class _PostAction extends StatelessWidget {
  const _PostAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 19,
            color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: 5),
          if (label.isNotEmpty)
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    ),
  );
}

class _PostComment {
  const _PostComment(this.initials, this.name, this.text, this.tint);
  final String initials, name, text;
  final Color tint;
}

class _CommentRow extends StatelessWidget {
  const _CommentRow({required this.comment});
  final _PostComment comment;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PersonAvatar(initials: comment.initials, size: 34, color: comment.tint),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment.name,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                comment.text,
                style: const TextStyle(fontSize: 12, height: 1.4),
              ),
            ],
          ),
        ),
        Icon(
          Icons.favorite_border_rounded,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ],
    ),
  );
}

class _PhotoArtwork extends StatefulWidget {
  const _PhotoArtwork({
    required this.color,
    required this.place,
    required this.index,
    required this.isVideo,
  });
  final Color color;
  final String place;
  final int index;
  final bool isVideo;

  @override
  State<_PhotoArtwork> createState() => _PhotoArtworkState();
}

class _PhotoArtworkState extends State<_PhotoArtwork> {
  static const _tagPoints = <_TagPoint>[
    _TagPoint(.31, .52, '@mayaputri'),
    _TagPoint(.68, .62, '@rafi.moves'),
  ];
  _TagPoint? _activeTag;
  int _page = 0;
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final isPortrait = widget.index.isOdd;
      final mediaHeight = constraints.maxWidth * (isPortrait ? 1.25 : 9 / 16);
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: (details) {
          _TagPoint? nearest;
          var nearestDistance = 52 * 52.0;
          for (final point in _tagPoints) {
            final dx =
                details.localPosition.dx - constraints.maxWidth * point.x;
            final dy = details.localPosition.dy - mediaHeight * point.y;
            final distance = dx * dx + dy * dy;
            if (distance < nearestDistance) {
              nearest = point;
              nearestDistance = distance;
            }
          }
          setState(() => _activeTag = nearest);
        },
        child: SizedBox(
          height: mediaHeight,
          width: double.infinity,
          child: ClipRect(
            child: Stack(
              children: [
                Positioned.fill(
                  child: PageView.builder(
                    itemCount: 3,
                    onPageChanged: (page) => setState(() {
                      _page = page;
                      _activeTag = null;
                    }),
                    itemBuilder: (context, page) => CustomPaint(
                      painter: _LandscapePainter(widget.index + page * 2),
                    ),
                  ),
                ),
                if (widget.isVideo)
                  Center(
                    child: IconButton.filled(
                      onPressed: () => setState(() => _isPlaying = !_isPlaying),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withValues(alpha: .55),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(58, 58),
                      ),
                      icon: Icon(
                        _isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        size: 31,
                      ),
                    ),
                  ),
                for (final point in _tagPoints)
                  Positioned(
                    left: constraints.maxWidth * point.x - 10,
                    top: mediaHeight * point.y - 10,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .92),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 12,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                if (_activeTag case final active?)
                  Positioned(
                    left: (constraints.maxWidth * active.x - 52)
                        .clamp(8.0, constraints.maxWidth - 112)
                        .toDouble(),
                    top: (mediaHeight * active.y - 48)
                        .clamp(8.0, mediaHeight - 36)
                        .toDouble(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: .82),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        active.username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  left: 14,
                  bottom: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .9),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.place_outlined, size: 15),
                        const SizedBox(width: 4),
                        Text(
                          widget.place,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 14,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: .35),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_page + 1} / 3',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                if (widget.isVideo)
                  Positioned(
                    left: 14,
                    top: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: .35),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.videocam_outlined,
                            size: 13,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'VIDEO · 0:18',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 19,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var page = 0; page < 3; page++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: _page == page ? 15 : 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(
                              alpha: _page == page ? .95 : .55,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _TagPoint {
  const _TagPoint(this.x, this.y, this.username);
  final double x, y;
  final String username;
}

class _LandscapePainter extends CustomPainter {
  _LandscapePainter(this.variant);
  final int variant;
  @override
  void paint(Canvas canvas, Size size) {
    final sky = Paint()
      ..color = variant.isEven ? Color(0xFFE5BC9E) : Color(0xFFE9E4CE);
    canvas.drawRect(Offset.zero & size, sky);
    canvas.drawCircle(
      Offset(size.width * .75, size.height * .24),
      29,
      Paint()..color = Color(0xFFF7E6B5),
    );
    final ridge = Path()
      ..moveTo(0, size.height * .65)
      ..quadraticBezierTo(
        size.width * .35,
        size.height * .3,
        size.width * .6,
        size.height * .62,
      )
      ..quadraticBezierTo(
        size.width * .8,
        size.height * .45,
        size.width,
        size.height * .58,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(ridge, Paint()..color = Color(0xFF687E67));
    final foreground = Path()
      ..moveTo(0, size.height * .85)
      ..quadraticBezierTo(
        size.width * .4,
        size.height * .57,
        size.width * .7,
        size.height * .82,
      )
      ..lineTo(size.width, size.height * .67)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(foreground, Paint()..color = Color(0xFF344F48));
    final building = Paint()..color = Color(0xFFB06F51);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * .12,
          size.height * .44,
          45,
          size.height * .31,
        ),
        const Radius.circular(4),
      ),
      building,
    );
    for (var i = 0; i < 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(size.width * .12 + i * 13, size.height * .5, 6, 12),
        Paint()..color = Color(0xFFF2D39A),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LandscapePainter oldDelegate) =>
      oldDelegate.variant != variant;
}

class _ActivityContent extends StatelessWidget {
  const _ActivityContent({required this.post});
  final SocialPost post;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
    constraints: const BoxConstraints(minHeight: 112),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.lime,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.directions_walk_rounded,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.place ?? 'On the move',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              SizedBox(height: 3),
              Text(
                post.distance ?? 'Activity logged',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.arrow_outward_rounded,
          size: 17,
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    ),
  );
}

class _ChallengeContent extends StatelessWidget {
  const _ChallengeContent();
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
    constraints: const BoxConstraints(minHeight: 112),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(Icons.flag_rounded, color: Theme.of(context).colorScheme.primary),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '2 of 3 places',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
              ),
              SizedBox(height: 8),
              LinearProgressIndicator(
                value: .67,
                minHeight: 5,
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).dividerColor,
              ),
            ],
          ),
        ),
        SizedBox(width: 14),
        Text(
          'WEEKLY',
          style: TextStyle(
            fontSize: 9,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
            letterSpacing: .7,
          ),
        ),
      ],
    ),
  );
}

class _TendencyContent extends StatelessWidget {
  const _TendencyContent();
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
    constraints: const BoxConstraints(minHeight: 132),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SOCIAL TENDENCY · THIS WEEK',
          style: TextStyle(
            fontSize: 9,
            letterSpacing: .8,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 12),
        Row(
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
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(height: 3, color: Theme.of(context).dividerColor),
                    Align(
                      alignment: Alignment(.28, 0),
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
            Text(
              'Social',
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(width: 7),
            Text(
              '64',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Based on your activity and optional check-ins.',
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );
}

class _ExplorationContent extends StatelessWidget {
  const _ExplorationContent({this.place});
  final String? place;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
    height: 142,
    decoration: BoxDecoration(
      color: Color(0xFFD1D8C1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _MapPainter(Theme.of(context).colorScheme.primary),
          ),
        ),
        Positioned(
          left: 14,
          top: 12,
          child: Row(
            children: [
              Icon(
                Icons.explore_rounded,
                size: 17,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(width: 6),
              Text(
                'A new place discovered',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 14,
          bottom: 12,
          child: Text(
            place ?? 'Somewhere new · shared approximately',
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    ),
  );
}

class _MapPainter extends CustomPainter {
  const _MapPainter(this.markerColor);
  final Color markerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withValues(alpha: .66)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(0, size.height * .76),
      Offset(size.width * .43, size.height * .3),
      p,
    );
    canvas.drawLine(
      Offset(size.width * .43, size.height * .3),
      Offset(size.width * .76, size.height * .68),
      p,
    );
    canvas.drawLine(
      Offset(size.width * .6, 0),
      Offset(size.width * .68, size.height),
      p,
    );
    canvas.drawCircle(
      Offset(size.width * .79, size.height * .35),
      8,
      Paint()..color = markerColor,
    );
    canvas.drawCircle(
      Offset(size.width * .79, size.height * .35),
      3,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AchievementContent extends StatelessWidget {
  const _AchievementContent();
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
    constraints: const BoxConstraints(minHeight: 104),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(
          Icons.workspace_premium_rounded,
          color: Color(0xFFB77B39),
          size: 30,
        ),
        SizedBox(width: 11),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WEEKEND EXPLORER',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Four weekends out exploring',
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
