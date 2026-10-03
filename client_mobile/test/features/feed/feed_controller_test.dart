import 'package:client_mobile/features/feed/application/feed_controller.dart';
import 'package:client_mobile/features/feed/data/feed_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FeedController controller;

  setUp(() async {
    controller = FeedController(DemoFeedRepository());
    await controller.load();
  });

  tearDown(() => controller.dispose());

  test('loads the first feed page and appends the next page', () async {
    expect(controller.state, hasLength(3));

    await controller.loadMore();

    expect(controller.state, hasLength(5));
    expect(controller.state.map((post) => post.id).toSet(), hasLength(5));
  });

  test('like and repost actions update their post', () {
    controller.toggleLike('1');
    controller.repost('1');

    expect(controller.state.first.liked, isTrue);
    expect(controller.state.first.reposted, isTrue);
  });

  test('quote repost keeps its note on the original post', () {
    controller.quoteRepost('1', 'Saving this for the weekend.');

    expect(controller.state.first.reposted, isTrue);
    expect(controller.state.first.quote, 'Saving this for the weekend.');
  });

  test('publishing adds the new moment to the start of the feed', () async {
    await controller.publish('A quiet walk before dinner.');

    expect(controller.state.first.body, 'A quiet walk before dinner.');
    expect(controller.state.first.author, 'Ari Pratama');
  });
}
