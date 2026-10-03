import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';

class PersonAvatar extends StatelessWidget {
  const PersonAvatar({
    super.key,
    required this.initials,
    this.size = 42,
    this.color = AppColors.lavender,
    this.story = false,
  });
  final String initials;
  final double size;
  final Color color;
  final bool story;

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      radius: size / 2,
      backgroundColor: color,
      child: Text(
        initials,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: size * .28,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
    return story
        ? Container(
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.surface,
              ),
              child: avatar,
            ),
          )
        : avatar;
  }
}
