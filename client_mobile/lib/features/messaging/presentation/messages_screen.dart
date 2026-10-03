import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../shared/widgets/person_avatar.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _search = TextEditingController();
  String _query = '';

  static const _threads = <_ThreadPreview>[
    _ThreadPreview(
      'Maya Putri',
      'MP',
      AppColors.peach,
      'That little bookshop was lovely.',
      'now',
      2,
    ),
    _ThreadPreview(
      'Rafi Aditya',
      'RA',
      AppColors.lavender,
      'Are you free for a walk Saturday?',
      '12m',
      0,
    ),
    _ThreadPreview(
      'Sunday walkers',
      'SW',
      Color(0xFFB8D2C1),
      'Nadia: meet by the old station?',
      '1h',
      3,
    ),
    _ThreadPreview(
      'Nadia S.',
      'NS',
      Color(0xFFE7C9A6),
      'Challenge accepted 🌿',
      '3h',
      0,
    ),
    _ThreadPreview(
      'Dimas Hari',
      'DH',
      Color(0xFFD7B7A7),
      'Sent you a place',
      'Yesterday',
      0,
    ),
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final threads = _threads
        .where(
          (thread) => thread.name.toLowerCase().contains(_query.toLowerCase()),
        )
        .toList();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (Navigator.of(context).canPop())
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                      Expanded(
                        child: Text(
                          'Messages',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        tooltip: 'New message',
                        icon: const Icon(Icons.edit_square),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _search,
                    onChanged: (value) => setState(() => _query = value),
                    decoration: InputDecoration(
                      hintText: 'Search conversations',
                      prefixIcon: const Icon(Icons.search_rounded),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                children: const [
                  _OnlinePerson(
                    name: 'Maya',
                    initials: 'MP',
                    tint: AppColors.peach,
                  ),
                  _OnlinePerson(
                    name: 'Rafi',
                    initials: 'RA',
                    tint: AppColors.lavender,
                  ),
                  _OnlinePerson(
                    name: 'Nadia',
                    initials: 'NS',
                    tint: Color(0xFFE7C9A6),
                  ),
                  _OnlinePerson(
                    name: 'Dimas',
                    initials: 'DH',
                    tint: Color(0xFFB8D2C1),
                  ),
                  _OnlinePerson(
                    name: 'Laras',
                    initials: 'LN',
                    tint: Color(0xFFD7B7A7),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 8),
              child: Text(
                'YOUR CONVERSATIONS',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ),
          if (threads.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text('No conversations found.')),
            )
          else
            SliverList.builder(
              itemCount: threads.length,
              itemBuilder: (context, index) => _ThreadTile(
                thread: threads[index],
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => _ConversationScreen(thread: threads[index]),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ThreadPreview {
  const _ThreadPreview(
    this.name,
    this.initials,
    this.tint,
    this.message,
    this.time,
    this.unread,
  );
  final String name, initials, message, time;
  final Color tint;
  final int unread;
}

class _OnlinePerson extends StatelessWidget {
  const _OnlinePerson({
    required this.name,
    required this.initials,
    required this.tint,
  });
  final String name, initials;
  final Color tint;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 68,
    child: Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            PersonAvatar(initials: initials, size: 54, color: tint),
            Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                color: const Color(0xFF6EA67F),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(name, style: const TextStyle(fontSize: 10)),
      ],
    ),
  );
}

class _ThreadTile extends StatelessWidget {
  const _ThreadTile({required this.thread, required this.onTap});
  final _ThreadPreview thread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    leading: PersonAvatar(
      initials: thread.initials,
      size: 48,
      color: thread.tint,
    ),
    title: Text(
      thread.name,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
    ),
    subtitle: Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        thread.message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 11,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    ),
    trailing: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          thread.time,
          style: TextStyle(
            fontSize: 9,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 5),
        if (thread.unread > 0)
          CircleAvatar(
            radius: 9,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              '${thread.unread}',
              style: const TextStyle(fontSize: 9, color: Colors.white),
            ),
          ),
      ],
    ),
  );
}

class _ConversationScreen extends StatefulWidget {
  const _ConversationScreen({required this.thread});
  final _ThreadPreview thread;

  @override
  State<_ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<_ConversationScreen> {
  final _composer = TextEditingController();
  final _messages = <_Message>[
    const _Message('Hey! I found that tiny bookshop you mentioned.', false),
    const _Message('The one near the old station?', true),
    const _Message('Yes! And there’s a lovely coffee place next door.', false),
  ];

  @override
  void dispose() {
    _composer.dispose();
    super.dispose();
  }

  void _send() {
    final text = _composer.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Message(text, true));
      _composer.clear();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      titleSpacing: 0,
      title: Row(
        children: [
          PersonAvatar(
            initials: widget.thread.initials,
            size: 36,
            color: widget.thread.tint,
          ),
          const SizedBox(width: 9),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.thread.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Here for a little while',
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
      ],
    ),
    body: Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Text(
                    'TODAY · 10:42 AM',
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 1,
                      color: AppColors.muted,
                    ),
                  ),
                ),
              ),
              for (final message in _messages) _MessageBubble(message: message),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.add_circle_outline_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _composer,
                    onSubmitted: (_) => _send(),
                    minLines: 1,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Write a message',
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _send,
                  icon: Icon(
                    Icons.arrow_upward_rounded,
                    color: Theme.of(context).colorScheme.primary,
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

class _Message {
  const _Message(this.text, this.mine);
  final String text;
  final bool mine;
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});
  final _Message message;

  @override
  Widget build(BuildContext context) => Align(
    alignment: message.mine ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      constraints: const BoxConstraints(maxWidth: 290),
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: message.mine
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Text(
        message.text,
        style: TextStyle(
          fontSize: 12,
          height: 1.4,
          color: message.mine
              ? Colors.white
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
    ),
  );
}
