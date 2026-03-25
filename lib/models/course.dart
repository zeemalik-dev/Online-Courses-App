class Course {
  final int id;
  final String title;
  final String thumbnail;
  final String price;
  final int discountedPrice;
  final int discountFlag;
  final String level;
  final String deliveryMethod;
  final String language;
  final int isPaid;
  final int isBest;
  final String instructorName;
  final String instructorImage;
  final double averageRating;
  final int totalEnrollment;
  final int totalReviews;
  final String shareableLink;
  final String? shortDescription;
  final String? banner;
  final String? preview;

  Course({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.price,
    required this.discountedPrice,
    required this.discountFlag,
    required this.level,
    required this.deliveryMethod,
    required this.language,
    required this.isPaid,
    required this.isBest,
    required this.instructorName,
    required this.instructorImage,
    required this.averageRating,
    required this.totalEnrollment,
    required this.totalReviews,
    required this.shareableLink,
    this.shortDescription,
    this.banner,
    this.preview,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      price: json['price'].toString(),
      discountedPrice: json['discounted_price'] ?? json['price'],
      discountFlag: json['discount_flag'] ?? 0,
      level: json['level'] ?? '',
      deliveryMethod: json['delivery_method'] ?? '',
      language: json['language'] ?? '',
      isPaid: json['is_paid'] ?? 0,
      isBest: json['is_best'] ?? 0,
      instructorName: json['instructor_name'] ?? '',
      instructorImage: json['instructor_image'] ?? '',
      averageRating: double.parse(json['average_rating']?.toString() ?? '0'),
      totalEnrollment: json['total_enrollment'] ?? 0,
      totalReviews: json['total_reviews'] ?? 0,
      shareableLink: json['shareable_link'] ?? '',
      shortDescription: json['short_description'],
      banner: json['banner'],
      preview: json['preview'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnail': thumbnail,
      'price': price,
      'discounted_price': discountedPrice,
      'discount_flag': discountFlag,
      'level': level,
      'delivery_method': deliveryMethod,
      'language': language,
      'is_paid': isPaid,
      'is_best': isBest,
      'instructor_name': instructorName,
      'instructor_image': instructorImage,
      'average_rating': averageRating,
      'total_enrollment': totalEnrollment,
      'total_reviews': totalReviews,
      'shareable_link': shareableLink,
      'short_description': shortDescription,
      'banner': banner,
      'preview': preview,
    };
  }
}