import 'package:flutter/foundation.dart';
import './section.dart';

class CourseDetail {
  int? courseId;
  String? courseTitle;
  String? courseSlug;
  String? shortDescription;
  String? courseType;
  String? status;
  String? level;
  String? deliveryMethod;
  String? language;
  int? isPaid;
  int? isBest;
  String? price;
  int? discountedPrice;
  int? discountFlag;
  String? thumbnail;
  String? banner;
  String? preview;
  String? description;
  double? averageRating;
  String? instructorName;
  String? instructorImage;
  int? totalEnrollment;
  int? totalReviews;
  String? shareableLink;
  List<String>? courseIncludes;
  List<String>? courseRequirements;
  List<String>? courseOutcomes;
  bool? isWishlisted;
  bool? isPurchased;
  bool? isCart;
  List<Section>? mSection;

  CourseDetail({
    @required this.courseId,
    this.courseTitle,
    this.courseSlug,
    this.shortDescription,
    this.courseType,
    this.status,
    this.level,
    this.deliveryMethod,
    this.language,
    this.isPaid,
    this.isBest,
    this.price,
    this.discountedPrice,
    this.discountFlag,
    this.thumbnail,
    this.banner,
    this.preview,
    this.description,
    this.averageRating,
    this.instructorName,
    this.instructorImage,
    this.totalEnrollment,
    this.totalReviews,
    this.shareableLink,
    @required this.courseIncludes,
    @required this.courseRequirements,
    @required this.courseOutcomes,
    @required this.isWishlisted,
    @required this.isPurchased,
    this.isCart,
    @required this.mSection,
  });
}
