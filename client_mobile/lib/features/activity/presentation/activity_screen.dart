import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../shared/widgets/person_avatar.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Activity')),
    body: CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your circle,\nin motion.',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                SizedBox(height: 9),
                Text(
                  'A few moments you might have missed.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(22, 0, 22, 10),
            child: Text(
              'TODAY',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _ActivityItem(
            initials: 'MP',
            tint: AppColors.peach,
            name: 'Maya Putri',
            action: 'started following you',
            time: '8 min ago',
            followBack: true,
          ),
        ),
        SliverToBoxAdapter(
          child: _ActivityItem(
            initials: 'RA',
            tint: AppColors.lavender,
            name: 'Rafi Aditya',
            action: 'and 3 others liked your post',
            time: '42 min ago',
            followBack: false,
          ),
        ),
        SliverToBoxAdapter(
          child: _ActivityItem(
            initials: 'NS',
            tint: Color(0xFFE7C9A6),
            name: 'Nadia S.',
            action: 'invited you to a challenge',
            time: '2 hr ago',
            followBack: false,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 28, 22, 10),
            child: Text(
              'YESTERDAY',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _ActivityItem(
            initials: 'DH',
            tint: Color(0xFFB8D2C1),
            name: 'Dimas Hari',
            action: 'mentioned you in a moment',
            time: 'Yesterday',
            followBack: false,
          ),
        ),
        SliverToBoxAdapter(child: _MilestoneCard()),
      ],
    ),
  );
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({
    required this.initials,
    required this.tint,
    required this.name,
    required this.action,
    required this.time,
    required this.followBack,
  });
  final String initials, name, action, time;
  final Color tint;
  final bool followBack;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PersonAvatar(initials: initials, size: 43, color: tint),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 12,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: name,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: ' $action'),
                  ],
                ),
              ),
              SizedBox(height: 3),
              Text(
                time,
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (followBack)
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              side: BorderSide(color: Theme.of(context).dividerColor),
            ),
            child: Text('Follow back', style: TextStyle(fontSize: 10)),
          ),
      ],
    ),
  );
}

class _MilestoneCard extends StatelessWidget {
  const _MilestoneCard();
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(20, 18, 20, 24),
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Icon(
          Icons.local_fire_department_rounded,
          color: Theme.of(context).colorScheme.primary,
          size: 31,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You’re on a 6 day streak',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              SizedBox(height: 4),
              Text(
                'A gentle nudge to step out today, if you feel like it.',
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_forward_rounded, size: 18),
        ),
      ],
    ),
  );
}
