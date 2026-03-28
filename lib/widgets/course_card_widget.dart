import 'package:academy_app/models/course.dart';
import 'package:academy_app/models/section.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants.dart';

class CourseCardWidget extends StatelessWidget {
  final Course course;
  final VoidCallback? onEnrollTap;
  final VoidCallback? onWishlistTap;

  const CourseCardWidget({
    Key? key,
    required this.course,
    this.onEnrollTap,
    this.onWishlistTap,
  }) : super(key: key);

  String formatCurrency(dynamic value) {
    double amount = 0;
    if (value is String) {
      amount = double.tryParse(value.replaceAll('₦', '')) ?? 0;
    } else if (value is int) {
      amount = value.toDouble();
    } else if (value is double) {
      amount = value;
    }
    
    final formatter = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final bool hasDiscount = (course.discountFlag == 1 && 
                         course.discountedPrice != null && 
                         course.discountedPrice != (int.tryParse(course.price.replaceAll('₦', '')) ?? 0));
    final regularPrice = course.price;
    final discountedPrice = hasDiscount ? course.discountedPrice : int.tryParse(course.price.replaceAll('₦', '')) ?? 0;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: iCardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Image Section
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.network(
                  course.thumbnail,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Category Badge
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: kCategoryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getCategoryLevel(course.level),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              // Wishlist Button
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: onWishlistTap,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      course.isWishlisted 
                          ? Icons.favorite 
                          : Icons.favorite_border,
                      color: course.isWishlisted 
                          ? Colors.red 
                          : kSecondaryColor,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Content Section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course Title
                Text(
                  course.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 12),
                
                // Instructor Info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(
                        course.instructorImage,
                      ),
                      backgroundColor: Colors.grey[200],
                      child: course.instructorImage.isEmpty
                          ? const Icon(Icons.person, size: 16)
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        course.instructorName,
                        style: TextStyle(
                          fontSize: 14,
                          color: kSecondaryColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Rating and Duration Row
                Row(
                  children: [
                    // Rating Stars
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: kStarColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          course.averageRating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${course.totalReviews})',
                          style: TextStyle(
                            fontSize: 12,
                            color: kSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Duration
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: kSecondaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getCourseDuration(course.sections),
                          style: TextStyle(
                            fontSize: 12,
                            color: kSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                
                
                // Price Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasDiscount) ...[
                      Text(
                        formatCurrency(regularPrice),
                        style: TextStyle(
                          fontSize: 16,
                          color: kDiscountedPriceColor,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      formatCurrency(discountedPrice),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    // Divider
                      const SizedBox(height: 12),
                
                // Delivery Method Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.school,
                        size: 14,
                        color: kPrimaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getDeliveryMethod(course.deliveryMethod),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
             
                  
                  ],
                ),
                 
                Divider(
                  height: 1,
                  color: Colors.grey.withOpacity(0.2),
                ),
                
                const SizedBox(height: 16),
                    
                    // Enroll Button
                    SizedBox(
                      width: MediaQuery.of( context).size.width * 0.8 ,
                      child: ElevatedButton(
                        onPressed: onEnrollTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: course.isPurchased 
                              ? kGreenPurchaseColor 
                              : kPrimaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          course.isPurchased
                              ? 'Purchased'
                              : course.isPaid == 0
                                  ? 'Enroll'
                                  : 'Enroll Now',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  
              
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  String _getCategoryLevel(String? level) {
    switch (level?.toLowerCase()) {
      case 'beginner':
        return 'BEGINNER';
      case 'intermediate':
        return 'INTERMEDIATE';
      case 'advanced':
        return 'ADVANCED';
      default:
        return 'COURSE';
    }
  }
  
  String _getCourseDuration(List<Section>? sections) {
    if (sections == null || sections.isEmpty) {
      // Check if it's the LEAD FROM THE START course
      if (course.title.contains('LEAD FROM THE START')) {
        return '6 Weeks';
      }
      return '6 Weeks';
    }
    
    // Calculate total lessons
    int totalLessons = 0;
    for (var section in sections) {
      totalLessons += section.lessons.length;
    }
    
    if (totalLessons > 0) {
      return '$totalLessons Lessons';
    }
    
    return '6 Weeks';
  }
  
  String _getDeliveryMethod(String? method) {
    switch (method?.toLowerCase()) {
      case 'online':
        return 'Online Course';
      case 'hybrid':
        return 'Hybrid';
      case 'in_person':
        return 'In-Person';
      default:
        return 'Online Course';
    }
  }
}