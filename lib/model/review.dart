class Review {
  final int id;
  String reviewer;
  int rating;
  String comments;

  Review({
    required this.id,
    required this.reviewer,
    required this.rating,
    required this.comments,
  });

  void update({
    String? newReviewer,
    int? newRating,
    String? newComments,
  }) {
    reviewer = newReviewer ?? reviewer;
    rating = newRating ?? rating;
    comments = newComments ?? comments;
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as int,
      reviewer: json['reviewer'] as String,
      rating: json['rating'] as int,
      comments: json['comments'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reviewer': reviewer,
      'rating': rating,
      'comments': comments,
    };
  }

  @override
  String toString() {
    return 'Review(id: $id, reviewer: $reviewer, rating: $rating, comments: $comments)';
  }
}