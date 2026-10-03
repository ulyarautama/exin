import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../shared/widgets/person_avatar.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});
  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final _search = TextEditingController();
  final _joined = <String>{};
  String _filter = 'For you';
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomScrollView(
    slivers: [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Find your\nnext somewhere.',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _search,
                decoration: InputDecoration(
                  hintText: 'People, places, challenges',
                  prefixIcon: Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: ['For you', 'People', 'Places', 'Challenges', 'Trending']
                .map(
                  (label) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(label),
                      selected: _filter == label,
                      onSelected: (_) => setState(() => _filter = label),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
      if (_filter == 'For you' || _filter == 'People') ...[
        SliverToBoxAdapter(
          child: _SectionTitle(
            title: 'People you may like',
            trailing: 'See all',
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 158,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _PersonSuggestion(
                  initials: 'LN',
                  name: 'Laras N.',
                  detail: '12 mutual friends',
                  tint: AppColors.peach,
                ),
                _PersonSuggestion(
                  initials: 'BW',
                  name: 'Bima W.',
                  detail: 'Explores nearby',
                  tint: AppColors.lavender,
                ),
                _PersonSuggestion(
                  initials: 'SK',
                  name: 'Salsa K.',
                  detail: '3 shared interests',
                  tint: Color(0xFFB8D2C1),
                ),
              ],
            ),
          ),
        ),
      ],
      if (_filter == 'For you' || _filter == 'Places') ...[
        SliverToBoxAdapter(
          child: _SectionTitle(
            title: 'Close to your orbit',
            trailing: 'Approximate',
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 184,
              decoration: BoxDecoration(
                color: Color(0xFFD8DDCA),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(painter: _DiscoverMapPainter()),
                  ),
                  Positioned(
                    left: 15,
                    top: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .9),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lock_outline, size: 13),
                          SizedBox(width: 5),
                          Text(
                            'No exact location shown',
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    bottom: 18,
                    child: _MapLabel(
                      icon: Icons.coffee_rounded,
                      label: 'Coffee & quiet',
                    ),
                  ),
                  Positioned(
                    right: 21,
                    bottom: 45,
                    child: _MapLabel(
                      icon: Icons.park_rounded,
                      label: 'Green spaces',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
      if (_filter == 'For you' || _filter == 'Challenges') ...[
        SliverToBoxAdapter(
          child: _SectionTitle(
            title: 'Small plans, shared',
            trailing: 'This week',
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: _ChallengeCard(
              title: 'Three new corners',
              detail: 'Visit 3 new places this week',
              progress: '2 / 3',
              members: '128 people joined',
              joined: _joined.contains('corners'),
              onJoin: () => setState(() => _joined.add('corners')),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: _ChallengeCard(
              title: 'A little more outside',
              detail: 'Log 5 activities before Sunday',
              progress: '3 / 5',
              members: '86 people joined',
              joined: _joined.contains('outside'),
              onJoin: () => setState(() => _joined.add('outside')),
            ),
          ),
        ),
      ],
      if (_filter == 'Trending')
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(28),
            child: Text(
              'The most shared moments from your circles will show up here.',
            ),
          ),
        ),
    ],
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.trailing});
  final String title, trailing;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(22, 25, 22, 12),
    child: Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        Text(
          trailing,
          style: TextStyle(
            fontSize: 11,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );
}

class _PersonSuggestion extends StatefulWidget {
  const _PersonSuggestion({
    required this.initials,
    required this.name,
    required this.detail,
    required this.tint,
  });
  final String initials, name, detail;
  final Color tint;

  @override
  State<_PersonSuggestion> createState() => _PersonSuggestionState();
}

class _PersonSuggestionState extends State<_PersonSuggestion> {
  bool _following = false;

  @override
  Widget build(BuildContext context) => Container(
    width: 138,
    margin: const EdgeInsets.only(right: 10),
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PersonAvatar(initials: widget.initials, size: 39, color: widget.tint),
        SizedBox(height: 10),
        Text(
          widget.name,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        ),
        SizedBox(height: 2),
        Text(
          widget.detail,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 10,
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: () => setState(() => _following = !_following),
          child: Text(
            _following ? 'Following ✓' : '+ Follow',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ),
      ],
    ),
  );
}

class _MapLabel extends StatelessWidget {
  const _MapLabel({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(9),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Theme.of(context).colorScheme.primary),
        SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}

class _DiscoverMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()
      ..color = Colors.white.withValues(alpha: .75)
      ..strokeWidth = 11
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(-8, size.height * .68),
      Offset(size.width * .46, size.height * .26),
      road,
    );
    canvas.drawLine(
      Offset(size.width * .42, size.height * .25),
      Offset(size.width * .82, size.height * .8),
      road,
    );
    canvas.drawLine(
      Offset(size.width * .08, size.height * .15),
      Offset(size.width * .66, size.height * .63),
      road,
    );
    final thin = Paint()
      ..color = Color(0xFFBCC8AE)
      ..strokeWidth = 3;
    canvas.drawLine(
      Offset(0, size.height * .9),
      Offset(size.width, size.height * .36),
      thin,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({
    required this.title,
    required this.detail,
    required this.progress,
    required this.members,
    required this.joined,
    required this.onJoin,
  });
  final String title, detail, progress, members;
  final bool joined;
  final VoidCallback onJoin;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.lime,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.explore_rounded),
            ),
            SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.w700)),
                  Text(
                    detail,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              progress,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          children: [
            Text(
              members,
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: joined ? null : onJoin,
              child: Text(joined ? 'Joined ✓' : 'Join challenge'),
            ),
          ],
        ),
      ],
    ),
  );
}
