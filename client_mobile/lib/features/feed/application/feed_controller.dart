import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/feed_repository.dart';
import '../domain/post.dart';

final feedRepositoryProvider = Provider<FeedRepository>(
  (ref) => DemoFeedRepository(),
);
final feedControllerProvider =
    StateNotifierProvider<FeedController, List<SocialPost>>(
      (ref) => FeedController(ref.watch(feedRepositoryProvider)),
    );
final followedHandlesProvider = StateProvider<Set<String>>((ref) => <String>{});

class FeedController extends StateNotifier<List<SocialPost>> {
  FeedController(this._repository) : super([]) {
    load();
  }
  final FeedRepository _repository;
  int _page = 0;
  bool _hasMore = true;
  bool _loadingMore = false;

  Future<void> load() async {
    _page = 0;
    _hasMore = true;
    state = await _repository.loadFeed(page: _page);
  }

  Future<void> loadMore() async {
    if (_loadingMore || !_hasMore) return;
    _loadingMore = true;
    try {
      final nextPage = _page + 1;
      final next = await _repository.loadFeed(page: nextPage);
      _page = nextPage;
      _hasMore = next.isNotEmpty;
      final seen = state.map((post) => post.id).toSet();
      state = [...state, ...next.where((post) => !seen.contains(post.id))];
    } finally {
      _loadingMore = false;
    }
  }

  void toggleLike(String id) => state = [
    for (final post in state)
      if (post.id == id) post.copyWith(liked: !post.liked) else post,
  ];

  void repost(String id) => state = [
    for (final post in state)
      if (post.id == id) post.copyWith(reposted: !post.reposted) else post,
  ];

  void quoteRepost(String id, String thought, {bool isReply = false}) {
    SocialPost? original;
    for (final post in state) {
      if (post.id == id) {
        original = post;
        break;
      }
    }
    if (original == null) return;
    final post = SocialPost(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      author: 'Ari Pratama',
      handle: 'aripratama',
      initials: 'AP',
      time: 'now',
      body: thought,
      kind: PostKind.text,
      likes: 0,
      comments: 0,
      quote: original.body,
      quoteAuthor: original.author,
      isReply: isReply,
    );
    _repository.publish(post);
    state = [post, ...state];
  }

  void replyPost(String id, String reply) =>
      quoteRepost(id, reply, isReply: true);

  Future<void> publish(String text, {PostKind kind = PostKind.text}) async {
    final post = SocialPost(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      author: 'Ari Pratama',
      handle: 'aripratama',
      initials: 'AP',
      time: 'now',
      body: text,
      kind: kind,
      likes: 0,
      comments: 0,
    );
    await _repository.publish(post);
    state = [post, ...state];
  }
}
