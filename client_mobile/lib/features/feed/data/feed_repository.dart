import '../domain/post.dart';

abstract interface class FeedRepository {
  Future<List<SocialPost>> loadFeed({int page = 0});
  Future<void> publish(SocialPost post);
}

class DemoFeedRepository implements FeedRepository {
  final List<SocialPost> _posts = [
    SocialPost(
      id: '1',
      author: 'Maya Putri',
      handle: 'mayaputri',
      initials: 'MP',
      time: '12 min',
      body: 'Took the longer way home and found my new favorite corner of the city.',
      kind: PostKind.photo,
      likes: 128,
      comments: 14,
      place: 'Kota Tua, Jakarta',
      artwork: 1,
    ),
    SocialPost(
      id: '2',
      author: 'Rafi Aditya',
      handle: 'rafi.moves',
      initials: 'RA',
      time: '38 min',
      body: 'A small win for a Tuesday: three new places, all on foot.',
      kind: PostKind.activity,
      likes: 64,
      comments: 8,
      place: 'Menteng loop',
      distance: '4.2 km · 3 new places',
    ),
    SocialPost(
      id: '3',
      author: 'Nadia S.',
      handle: 'nadia.stories',
      initials: 'NS',
      time: '1 hr',
      body: 'Visit 3 new places this week',
      kind: PostKind.challenge,
      likes: 42,
      comments: 6,
    ),
    SocialPost(
      id: '4',
      author: 'Dimas & Friends',
      handle: 'dimas.hari',
      initials: 'DH',
      time: '2 hr',
      body: 'Sunday plans became a tiny neighborhood food tour. Highly recommend getting lost (a little).',
      kind: PostKind.exploration,
      likes: 87,
      comments: 11,
      place: 'South Jakarta',
    ),
    SocialPost(
      id: '5',
      author: 'Alya Rahman',
      handle: 'alyarahman',
      initials: 'AR',
      time: '3 hr',
      body: 'My week felt a little more social than usual.',
      kind: PostKind.tendency,
      likes: 31,
      comments: 4,
    ),
    SocialPost(
      id: '6',
      author: 'Maya Putri',
      handle: 'mayaputri',
      initials: 'MP',
      time: '4 hr',
      body: 'A wide-open view after the last turn uphill.',
      kind: PostKind.photo,
      likes: 96,
      comments: 9,
      place: 'Bukit Dago, Bandung',
      artwork: 2,
    ),
    SocialPost(
      id: '7',
      author: 'Rafi Aditya',
      handle: 'rafi.moves',
      initials: 'RA',
      time: '5 hr',
      body: 'The city sounds different before it wakes up.',
      kind: PostKind.video,
      likes: 73,
      comments: 12,
      place: 'Central Jakarta',
      artwork: 3,
    ),
  ];

  @override
  Future<List<SocialPost>> loadFeed({int page = 0}) async =>
      List.unmodifiable(_posts.skip(page * 3).take(3));

  @override
  Future<void> publish(SocialPost post) async => _posts.insert(0, post);
}
