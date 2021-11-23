class MovieReview {

  final String id;
  final String authorUserName;
  final String review;
  final String createdAt;
  final String reviewUrl;

  MovieReview(this.id, this.authorUserName, this.review,
      this.createdAt, this.reviewUrl);

  MovieReview.fromJson(Map<String, dynamic> json)
    : id = json["id"],
      authorUserName = json["author_details"]["username"],
      review = json["content"],
      createdAt = json["created_at"],
      reviewUrl = json["url"];
}