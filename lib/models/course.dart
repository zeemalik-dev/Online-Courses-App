import 'package:wilan/models/section.dart';
import 'package:intl/intl.dart';

class Course {
  final int id;
  final String title;
  final String slug;
  final String? shortDescription;
  final int userId;
  final int categoryId;
  final String courseType;
  final String status;
  final String level;
  final String deliveryMethod;
  final String language;
  final int isPaid;
  final int isBest;
  final String price;
  final int discountedPrice;
  final int discountFlag;
  final int enableDripContent;
  final String? dripContentSettings;
  final String? metaKeywords;
  final String? metaDescription;
  final String thumbnail;
  final String? courseGuidePdf;
  final String? banner;
  final String? preview;
  final String description;
  final List<String> requirements;
  final Map<String, String> outcomes;
  final List<Map<String, dynamic>> faqs;
  final String instructorIds;
  final double averageRating;
  final String createdAt;
  final String updatedAt;
  final String? expiryPeriod;
  final List<String> instructors;
  final int priceCart;
  final String instructorName;
  final String instructorImage;
  final int totalEnrollment;
  final String shareableLink;
  final int totalReviews;
  final List<Section> sections;
  final bool isWishlisted;
  final bool isPurchased;
  final bool isCart;
  final List<String> includes;

  Course({
    required this.id,
    required this.title,
    required this.slug,
    this.shortDescription,
    required this.userId,
    required this.categoryId,
    required this.courseType,
    required this.status,
    required this.level,
    required this.deliveryMethod,
    required this.language,
    required this.isPaid,
    required this.isBest,
    required this.price,
    required this.discountedPrice,
    required this.discountFlag,
    required this.enableDripContent,
    this.dripContentSettings,
    this.metaKeywords,
    this.metaDescription,
    required this.thumbnail,
    this.courseGuidePdf,
    this.banner,
    this.preview,
    required this.description,
    required this.requirements,
    required this.outcomes,
    required this.faqs,
    required this.instructorIds,
    required this.averageRating,
    required this.createdAt,
    required this.updatedAt,
    this.expiryPeriod,
    required this.instructors,
    required this.priceCart,
    required this.instructorName,
    required this.instructorImage,
    required this.totalEnrollment,
    required this.shareableLink,
    required this.totalReviews,
    required this.sections,
    required this.isWishlisted,
    required this.isPurchased,
    required this.isCart,
    required this.includes,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    // 🔹 Parse requirements
    List<String> requirements = [];
    if (json['requirements'] != null) {
      if (json['requirements'] is List) {
        requirements = List<String>.from(json['requirements']);
      } else if (json['requirements'] is Map) {
        requirements = (json['requirements'] as Map)
            .values
            .map((e) => e.toString())
            .toList();
      }
    }

    // 🔹 Parse outcomes
    Map<String, String> outcomes = {};
    if (json['outcomes'] != null) {
      if (json['outcomes'] is Map) {
        outcomes = Map<String, String>.from(json['outcomes']);
      } else if (json['outcomes'] is List) {
        for (var i = 0; i < json['outcomes'].length; i++) {
          outcomes[i.toString()] = json['outcomes'][i].toString();
        }
      }
    }

    // 🔹 Parse FAQs
    List<Map<String, dynamic>> faqs = [];
    if (json['faqs'] != null && json['faqs'] is List) {
      faqs = List<Map<String, dynamic>>.from(json['faqs']);
    }

    // 🔹 Parse sections
    List<Section> sections = [];
    if (json['sections'] != null && json['sections'] is List) {
      sections =
          (json['sections'] as List).map((e) => Section.fromJson(e)).toList();
    }

    // 🔹 Parse includes
    List<String> includes = [];
    if (json['includes'] != null && json['includes'] is List) {
      includes = List<String>.from(json['includes']);
    }

    return Course(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      shortDescription: json['short_description'],
      userId: json['user_id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      courseType: json['course_type'] ?? 'general',
      status: json['status'] ?? 'active',
      level: json['level'] ?? 'beginner',
      deliveryMethod: json['delivery_method'] ?? 'online',
      language: json['language'] ?? 'english',
      isPaid: json['is_paid'] ?? 0,
      isBest: json['is_best'] ?? 0,
      price: json['price']?.toString() ?? '0',

      // ✅ SAFE PARSING
      discountedPrice: int.tryParse(
            json['discounted_price']?.toString() ?? '0',
          ) ??
          0,

      discountFlag: json['discount_flag'] ?? 0,
      enableDripContent: json['enable_drip_content'] ?? 0,
      dripContentSettings: json['drip_content_settings'],
      metaKeywords: json['meta_keywords'],
      metaDescription: json['meta_description'],
      thumbnail: json['thumbnail'] ?? '',
      courseGuidePdf: json['course_guide_pdf'],
      banner: json['banner'],
      preview: json['preview'],
      description: json['description'] ?? '',
      requirements: requirements,
      outcomes: outcomes,
      faqs: faqs,
      instructorIds: json['instructor_ids'] ?? '[]',
      averageRating:
          double.tryParse(json['average_rating']?.toString() ?? '0') ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      expiryPeriod: json['expiry_period'],
      instructors: json['instructors'] != null
          ? List<String>.from(json['instructors'])
          : [],
      priceCart: json['price_cart'] ?? 0,
      instructorName: json['instructor_name'] ?? '',
      instructorImage: json['instructor_image'] ?? '',
      totalEnrollment: json['total_enrollment'] ?? 0,
      shareableLink: json['shareable_link'] ?? '',
      totalReviews: json['total_reviews'] ?? 0,
      sections: sections,
      isWishlisted: json['is_wishlisted'] ?? false,
      isPurchased: json['is_purchased'] ?? false,
      isCart: json['is_cart'] ?? false,
      includes: includes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'short_description': shortDescription,
      'user_id': userId,
      'category_id': categoryId,
      'course_type': courseType,
      'status': status,
      'level': level,
      'delivery_method': deliveryMethod,
      'language': language,
      'is_paid': isPaid,
      'is_best': isBest,
      'price': price,
      'discounted_price': discountedPrice,
      'discount_flag': discountFlag,
      'enable_drip_content': enableDripContent,
      'drip_content_settings': dripContentSettings,
      'meta_keywords': metaKeywords,
      'meta_description': metaDescription,
      'thumbnail': thumbnail,
      'course_guide_pdf': courseGuidePdf,
      'banner': banner,
      'preview': preview,
      'description': description,
      'requirements': requirements,
      'outcomes': outcomes,
      'faqs': faqs,
      'instructor_ids': instructorIds,
      'average_rating': averageRating,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'expiry_period': expiryPeriod,
      'instructors': instructors,
      'price_cart': priceCart,
      'instructor_name': instructorName,
      'instructor_image': instructorImage,
      'total_enrollment': totalEnrollment,
      'shareable_link': shareableLink,
      'total_reviews': totalReviews,
      'sections': sections.map((s) => s.toJson()).toList(),
      'is_wishlisted': isWishlisted,
      'is_purchased': isPurchased,
      'is_cart': isCart,
      'includes': includes,
    };
  }

  // ================== PRICE HELPERS ==================

  int _parsePrice(String value) {
    return int.tryParse(
          value.replaceAll(RegExp(r'[^\d]'), ''),
        ) ??
        0;
  }

  String formatPrice(String? price) {
    if (price == null || price.isEmpty) return 'Free';

    final value = double.tryParse(price);
    if (value == null) return 'Free';

    final formatter = NumberFormat.currency(
      locale: 'en_NG', // Nigeria format
      symbol: '₦',
      decimalDigits: 0, // remove decimals (optional)
    );

    return formatter.format(value);
  }

  double get finalPrice {
    if (discountFlag == 1 && discountedPrice > 0) {
      return discountedPrice.toDouble();
    }
    return _parsePrice(price).toDouble();
  }

  double get savings {
    if (discountFlag == 1) {
      return _parsePrice(price).toDouble() - discountedPrice;
    }
    return 0;
  }

  String getFormattedPrice() {
    return isPaid == 1 ? formatPrice(finalPrice.toString()) : 'Free';
  }

  String getOriginalPrice() {
    if (isPaid == 1 && discountFlag == 1) {
      return formatPrice(_parsePrice(price).toString());
    }
    return '';
  }

  // ================== EXTRA HELPERS ==================

  int getTotalLessons() {
    int total = 0;
    for (var section in sections) {
      total += section.lessons.length;
    }
    return total;
  }

  String getTotalDuration() {
    Duration total = Duration.zero;

    for (var section in sections) {
      if (section.totalDuration.isNotEmpty) {
        final parts = section.totalDuration.split(':');
        if (parts.length == 3) {
          total += Duration(
            hours: int.tryParse(parts[0]) ?? 0,
            minutes: int.tryParse(parts[1]) ?? 0,
            seconds: int.tryParse(parts[2]) ?? 0,
          );
        }
      }
    }

    if (total.inHours > 0) {
      return '${total.inHours}h ${total.inMinutes.remainder(60)}min';
    } else if (total.inMinutes > 0) {
      return '${total.inMinutes}min';
    }

    return '6 Weeks';
  }
}
