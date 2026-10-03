enum PostKind {
  text,
  photo,
  video,
  activity,
  challenge,
  tendency,
  achievement,
  exploration,
}

class SocialPost {
  SocialPost({
    required this.id,
    required this.author,
    required this.handle,
    required this.initials,
    required this.time,
    required this.body,
    required this.kind,
    required this.likes,
    required this.comments,
    this.place,
    this.distance,
    this.liked = false,
    this.reposted = false,
    this.quote,
    this.quoteAuthor,
    this.isReply = false,
    this.artwork = 0,
  });

  final String id, author, handle, initials, time, body;
  final PostKind kind;
  final int likes, comments;
  final String? place, distance, quote, quoteAuthor;
  final bool liked, reposted, isReply;
  final int artwork;

  SocialPost copyWith({bool? liked, bool? reposted, String? quote}) =>
      SocialPost(
        id: id,
        author: author,
        handle: handle,
        initials: initials,
        time: time,
        body: body,
        kind: kind,
        likes: likes,
        comments: comments,
        place: place,
        distance: distance,
        liked: liked ?? this.liked,
        reposted: reposted ?? this.reposted,
        quote: quote ?? this.quote,
        quoteAuthor: quoteAuthor,
        isReply: isReply,
        artwork: artwork,
      );
}
