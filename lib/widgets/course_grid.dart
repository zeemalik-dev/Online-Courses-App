import 'package:flutter/material.dart';

import '../constants.dart';
import '../screens/course_detail_screen.dart';
import '../widgets/star_display_widget.dart';

class CourseGrid extends StatelessWidget {
  final int? id;
  final String? title;
  final String? thumbnail;
  final String? instructorName;
  final String? instructorImage;
  final double? rating;
  final String? price;
  final String? courseType;

  const CourseGrid({
    super.key,
    required this.id,
    required this.title,
    required this.instructorName,
    required this.instructorImage,
    required this.rating,
    required this.price,
    this.thumbnail, required this.courseType,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final cardWidth = isSmallScreen ? 280.0 : 320.0;
    final thumbnailHeight = isSmallScreen ? 140.0 : 160.0;

    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(CourseDetailScreen.routeName, arguments: id);
      },
      child: SizedBox(
        width: cardWidth,
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Course Thumbnail with Badge
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: thumbnail != null && thumbnail!.isNotEmpty
                          ? Image.network(
                              thumbnail!,
                              height: thumbnailHeight,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: thumbnailHeight,
                                  width: double.infinity,
                                  color: Colors.grey[100],
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey[400],
                                        size: 40,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'No Image',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Container(
                              height: thumbnailHeight,
                              width: double.infinity,
                              color: Colors.grey[100],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey[400],
                                    size: 40,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'No Image',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    // Launch Pad Badge
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              kPrimaryColor,
                              kPrimaryColor.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: kPrimaryColor.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child:  Text(
                          courseType != null && courseType!.isNotEmpty ? courseType! : 'General'  ,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                            
                          ),
                          
                        ),
                      ),
                    ),
                  ],
                ),
                // Course Details
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Course Title with style
                      Text(
                        'LEAD FROM THE START',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor.withOpacity(0.7),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Course Subtitle/Name
                      Text(
                        (title?.length ?? 0) > 45
                            ? '${title!.substring(0, 42)}...'
                            : title ?? 'Course Title',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      // Instructor Info
                      Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  kPrimaryColor.withOpacity(0.2),
                                  kPrimaryColor.withOpacity(0.1),
                                ],
                              ),
                            ),
                            child: ClipOval(
                              child: instructorImage != null &&
                                      instructorImage!.isNotEmpty
                                  ? Image.network(
                                      instructorImage!,
                                      width: 28,
                                      height: 28,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(
                                          Icons.person_outline,
                                          size: 16,
                                          color: kPrimaryColor,
                                        );
                                      },
                                    )
                                  : Icon(
                                      Icons.person_outline,
                                      size: 16,
                                      color: kPrimaryColor,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              instructorName ?? 'Expert Instructor',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Program Description
                      Text(
                        'A 6-week program designed for early-career women (0 to 5 years experience)',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      // Rating and Price Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // Rating Stars
                          Row(
                            children: [
                              StarDisplayWidget(
                                value: rating?.toInt() ?? 0,
                                filledStar: const Icon(
                                  Icons.star,
                                  color: Color(0xFFFFB800),
                                  size: 14,
                                ),
                                unfilledStar: const Icon(
                                  Icons.star_border,
                                  color: Color(0xFFFFB800),
                                  size: 14,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                rating?.toStringAsFixed(1) ?? '0.0',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                          // Price Tag
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  kPrimaryColor.withOpacity(0.1),
                                  kPrimaryColor.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: kPrimaryColor.withOpacity(0.2),
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              price != null && price!.isNotEmpty
                                  ? '\$${price}'
                                  : 'Free',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}