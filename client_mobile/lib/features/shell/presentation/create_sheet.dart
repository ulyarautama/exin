import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../feed/application/feed_controller.dart';
import '../../feed/domain/post.dart';

class CreateSheet extends ConsumerStatefulWidget {
  const CreateSheet({super.key});
  @override
  ConsumerState<CreateSheet> createState() => _CreateSheetState();
}

class _CreateSheetState extends ConsumerState<CreateSheet> {
  final _text = TextEditingController();
  PostKind _kind = PostKind.text;
  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.fromLTRB(
      24,
      16,
      24,
      MediaQuery.viewInsetsOf(context).bottom + 24,
    ),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(height: 24),
        Text(
          'A moment worth keeping.',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: 6),
        Text(
          'Share a thought from your day.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 20),
        Wrap(
          spacing: 7,
          children: [
            _CreateType(
              label: 'Post',
              selected: _kind == PostKind.text,
              onTap: () => setState(() => _kind = PostKind.text),
            ),
            _CreateType(
              label: 'Activity',
              selected: _kind == PostKind.activity,
              onTap: () => setState(() => _kind = PostKind.activity),
            ),
            _CreateType(
              label: 'Challenge',
              selected: _kind == PostKind.challenge,
              onTap: () => setState(() => _kind = PostKind.challenge),
            ),
            _CreateType(
              label: 'Achievement',
              selected: _kind == PostKind.achievement,
              onTap: () => setState(() => _kind = PostKind.achievement),
            ),
          ],
        ),
        SizedBox(height: 12),
        TextField(
          controller: _text,
          autofocus: true,
          maxLines: 4,
          maxLength: 280,
          decoration: InputDecoration(
            hintText: 'What did today feel like?',
            border: InputBorder.none,
            filled: true,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Icon(
              Icons.lock_outline,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: 7),
            Expanded(
              child: Text(
                'Your location stays private',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            FilledButton(
              onPressed: () async {
                final text = _text.text.trim();
                if (text.isEmpty) return;
                await ref
                    .read(feedControllerProvider.notifier)
                    .publish(text, kind: _kind);
                if (context.mounted) Navigator.pop(context);
              },
              child: Text('Share'),
            ),
          ],
        ),
      ],
    ),
  );
}

class _CreateType extends StatelessWidget {
  const _CreateType({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ChoiceChip(
    label: Text(label),
    selected: selected,
    onSelected: (_) => onTap(),
  );
}
