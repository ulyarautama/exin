import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';

enum _ContentFilter {
  all,
  photosVideo,
  carousel,
  text,
  achievements,
  challenges,
}

enum _ChallengeFilter { ongoing, completed }

class ContentScreen extends StatefulWidget {
  const ContentScreen({super.key});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  _ContentFilter _filter = _ContentFilter.all;
  _ChallengeFilter _challengeFilter = _ChallengeFilter.ongoing;

  @override
  Widget build(BuildContext context) => CustomScrollView(
    slivers: [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 18, 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your kind of content.',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Choose a lane and see what your circle shares.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _showPreferences,
                tooltip: 'Content preferences',
                icon: const Icon(Icons.tune_rounded),
              ),
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: SizedBox(
          height: 47,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            children: [
              _FilterChip(
                label: 'For you',
                selected: _filter == _ContentFilter.all,
                onTap: () => _setFilter(_ContentFilter.all),
              ),
              _FilterChip(
                label: 'Photos & video',
                selected: _filter == _ContentFilter.photosVideo,
                onTap: () => _setFilter(_ContentFilter.photosVideo),
              ),
              _FilterChip(
                label: 'Photo carousel',
                selected: _filter == _ContentFilter.carousel,
                onTap: () => _setFilter(_ContentFilter.carousel),
              ),
              _FilterChip(
                label: 'Text',
                selected: _filter == _ContentFilter.text,
                onTap: () => _setFilter(_ContentFilter.text),
              ),
              _FilterChip(
                label: 'Achievements',
                selected: _filter == _ContentFilter.achievements,
                onTap: () => _setFilter(_ContentFilter.achievements),
              ),
              _FilterChip(
                label: 'Challenges',
                selected: _filter == _ContentFilter.challenges,
                onTap: () => _setFilter(_ContentFilter.challenges),
              ),
            ],
          ),
        ),
      ),
      if (_filter == _ContentFilter.all ||
          _filter == _ContentFilter.photosVideo) ...[
        SliverToBoxAdapter(
          child: _SectionHeading(
            title: 'Photos & video',
            trailing: 'Visual moments',
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: _MediaCard(
                    title: 'A slower Sunday',
                    kind: 'PHOTO',
                    tint: const Color(0xFFD6CEAC),
                    icon: Icons.photo_outlined,
                    duration: null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MediaCard(
                    title: 'Walk with us',
                    kind: 'VIDEO',
                    tint: const Color(0xFF829888),
                    icon: Icons.play_circle_outline_rounded,
                    duration: '0:18',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      if (_filter == _ContentFilter.all ||
          _filter == _ContentFilter.carousel) ...[
        SliverToBoxAdapter(
          child: _SectionHeading(
            title: 'Photo carousels',
            trailing: 'Swipe through',
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _CarouselPreview(),
          ),
        ),
      ],
      if (_filter == _ContentFilter.all || _filter == _ContentFilter.text) ...[
        SliverToBoxAdapter(
          child: _SectionHeading(
            title: 'Words from your circle',
            trailing: 'Text moments',
          ),
        ),
        SliverToBoxAdapter(
          child: _TextMoment(
            text: '“Took the longer way home and found my new favorite corner of the city.”',
            author: 'Maya Putri',
            initials: 'MP',
          ),
        ),
        SliverToBoxAdapter(
          child: _TextMoment(
            text: '“Some days the best plan is leaving a little room for a detour.”',
            author: 'Rafi Aditya',
            initials: 'RA',
          ),
        ),
      ],
      if (_filter == _ContentFilter.all ||
          _filter == _ContentFilter.achievements) ...[
        SliverToBoxAdapter(
          child: _SectionHeading(
            title: 'Achievements',
            trailing: 'Recently unlocked',
          ),
        ),
        SliverToBoxAdapter(
          child: _AchievementContentCard(
            title: 'Weekend Explorer',
            detail: 'Four weekends spent somewhere new',
            icon: Icons.workspace_premium_rounded,
            progress: 'UNLOCKED',
          ),
        ),
        SliverToBoxAdapter(
          child: _AchievementContentCard(
            title: 'Explorer',
            detail: 'Visit 10 new places · 7 completed',
            icon: Icons.explore_rounded,
            progress: '7 / 10',
          ),
        ),
      ],
      if (_filter == _ContentFilter.all ||
          _filter == _ContentFilter.challenges) ...[
        SliverToBoxAdapter(
          child: _SectionHeading(
            title: 'Challenges',
            trailing: 'Your progress',
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 7),
            child: SegmentedButton<_ChallengeFilter>(
              segments: const [
                ButtonSegment(
                  value: _ChallengeFilter.ongoing,
                  label: Text('Ongoing'),
                ),
                ButtonSegment(
                  value: _ChallengeFilter.completed,
                  label: Text('Completed'),
                ),
              ],
              selected: {_challengeFilter},
              onSelectionChanged: (values) =>
                  setState(() => _challengeFilter = values.first),
            ),
          ),
        ),
        if (_challengeFilter == _ChallengeFilter.ongoing) ...[
          SliverToBoxAdapter(
            child: _ChallengeContentCard(
              title: 'Three new corners',
              detail: 'Visit 3 new places this week',
              progress: '2 / 3',
              completed: false,
            ),
          ),
          SliverToBoxAdapter(
            child: _ChallengeContentCard(
              title: 'A little more outside',
              detail: 'Log 5 activities before Sunday',
              progress: '3 / 5',
              completed: false,
            ),
          ),
        ] else
          SliverToBoxAdapter(
            child: _ChallengeContentCard(
              title: 'A new route',
              detail: 'Walk somewhere you had never been',
              progress: 'Completed · Sep 21',
              completed: true,
            ),
          ),
      ],
      const SliverToBoxAdapter(child: SizedBox(height: 30)),
    ],
  );

  void _setFilter(_ContentFilter filter) => setState(() {
    _filter = filter;
    if (filter == _ContentFilter.challenges) {
      _challengeFilter = _ChallengeFilter.ongoing;
    }
  });

  void _showPreferences() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Content preferences',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              Text(
                'Choose a content type to browse.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 7,
                runSpacing: 2,
                children: [
                  for (final entry in _FilterOption.values)
                    ChoiceChip(
                      label: Text(entry.label),
                      selected: _filter == entry.filter,
                      onSelected: (_) {
                        Navigator.pop(context);
                        _setFilter(entry.filter);
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _FilterOption {
  all('For you', _ContentFilter.all),
  media('Photos & video', _ContentFilter.photosVideo),
  carousel('Photo carousel', _ContentFilter.carousel),
  text('Text', _ContentFilter.text),
  achievements('Achievements', _ContentFilter.achievements),
  challenges('Challenges', _ContentFilter.challenges);

  const _FilterOption(this.label, this.filter);
  final String label;
  final _ContentFilter filter;
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    ),
  );
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.trailing});
  final String title, trailing;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(22, 22, 22, 11),
    child: Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        Text(
          trailing,
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );
}

class _MediaCard extends StatelessWidget {
  const _MediaCard({
    required this.title,
    required this.kind,
    required this.tint,
    required this.icon,
    required this.duration,
  });
  final String title, kind;
  final Color tint;
  final IconData icon;
  final String? duration;
  @override
  Widget build(BuildContext context) => Container(
    height: 186,
    decoration: BoxDecoration(
      color: tint,
      borderRadius: BorderRadius.circular(16),
    ),
    clipBehavior: Clip.antiAlias,
    child: Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(painter: _MediaArtworkPainter(tint)),
        ),
        Positioned(
          left: 11,
          top: 11,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .26),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              kind,
              style: const TextStyle(
                fontSize: 8,
                letterSpacing: .8,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        if (duration != null)
          Center(
            child: Icon(
              icon,
              size: 37,
              color: Colors.white.withValues(alpha: .95),
            ),
          ),
        if (duration != null)
          Positioned(
            right: 9,
            bottom: 9,
            child: Text(
              duration!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        Positioned(
          left: 11,
          bottom: 12,
          right: 8,
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
}

class _CarouselPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 138,
    child: ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        for (var i = 0; i < 3; i++)
          Container(
            width: 115,
            margin: const EdgeInsets.only(right: 9),
            decoration: BoxDecoration(
              color: [
                const Color(0xFFE0C9AC),
                const Color(0xFFBCC8AE),
                const Color(0xFFD5BED0),
              ][i],
              borderRadius: BorderRadius.circular(14),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _MediaArtworkPainter(
                      [
                        const Color(0xFFE0C9AC),
                        const Color(0xFFBCC8AE),
                        const Color(0xFFD5BED0),
                      ][i],
                    ),
                  ),
                ),
                Positioned(
                  left: 9,
                  bottom: 9,
                  child: Text(
                    '${i + 1} / 3',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Container(
          width: 120,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.swipe_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              const Text(
                'Weekend in Bandung',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
              ),
              Text(
                '5 photos',
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

class _TextMoment extends StatelessWidget {
  const _TextMoment({
    required this.text,
    required this.author,
    required this.initials,
  });
  final String text, author, initials;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            height: 1.4,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: AppColors.lavender,
              child: Text(
                initials,
                style: const TextStyle(
                  fontSize: 8,
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 7),
            Text(
              author,
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _AchievementContentCard extends StatelessWidget {
  const _AchievementContentCard({
    required this.title,
    required this.detail,
    required this.icon,
    required this.progress,
  });
  final String title, detail, progress;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.lime,
          child: Icon(icon, color: AppColors.ink, size: 19),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                detail,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        Text(
          progress,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: .4,
          ),
        ),
      ],
    ),
  );
}

class _ChallengeContentCard extends StatelessWidget {
  const _ChallengeContentCard({
    required this.title,
    required this.detail,
    required this.progress,
    required this.completed,
  });
  final String title, detail, progress;
  final bool completed;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        Container(
          width: 39,
          height: 39,
          decoration: BoxDecoration(
            color: AppColors.lime,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            completed ? Icons.check_rounded : Icons.flag_outlined,
            size: 18,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                detail,
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              if (!completed) ...[
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: title == 'Three new corners' ? .67 : .6,
                  minHeight: 4,
                  color: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).dividerColor,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          progress,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: completed
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );
}

class _MediaArtworkPainter extends CustomPainter {
  const _MediaArtworkPainter(this.tint);
  final Color tint;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = tint);
    canvas.drawCircle(
      Offset(size.width * .72, size.height * .25),
      size.width * .15,
      Paint()..color = const Color(0xFFF3E1B9).withValues(alpha: .85),
    );
    final hill = Path()
      ..moveTo(0, size.height * .72)
      ..quadraticBezierTo(
        size.width * .25,
        size.height * .35,
        size.width * .5,
        size.height * .72,
      )
      ..quadraticBezierTo(
        size.width * .77,
        size.height * .42,
        size.width,
        size.height * .63,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      hill,
      Paint()..color = const Color(0xFF536D5B).withValues(alpha: .9),
    );
    canvas.drawCircle(
      Offset(size.width * .16, size.height * .68),
      size.width * .1,
      Paint()..color = const Color(0xFFF4E8CB).withValues(alpha: .8),
    );
  }

  @override
  bool shouldRepaint(covariant _MediaArtworkPainter oldDelegate) =>
      oldDelegate.tint != tint;
}
