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

  const CourseGrid({
    super.key,
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.instructorName,
    required this.instructorImage,
    required this.rating,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(CourseDetailScreen.routeName, arguments: id);
      },
      child: FittedBox(
        child: SizedBox(
          width: 200,
          child: Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Course Thumbnail with error handling
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: FadeInImage(
                      placeholder: const AssetImage('assets/images/loading_animated.gif'),
                      image: NetworkImage(thumbnail ?? ''),
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 130,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                              size: 40,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Course Details
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Course Title
                        SizedBox(
                          height: 50,
                          child: Text(
                            (title?.length ?? 0) > 35
                                ? '${title?.substring(0, 34)}...'
                                : title ?? 'No Title',
                            style: const TextStyle(
                                fontSize: 14, 
                                color: kTextLightColor,
                                fontWeight: FontWeight.w500),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Instructor Info
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: kLightBlueColor,
                              child: ClipOval(
                                child: FadeInImage(
                                  placeholder: const AssetImage('assets/images/loading_animated.gif'),
                                  image: NetworkImage(instructorImage ?? ''),
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.cover,
                                  imageErrorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 24,
                                      height: 24,
                                      color: Colors.grey[200],
                                      child: const Icon(
                                        Icons.person,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                instructorName ?? 'Unknown Instructor',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: kSecondaryColor,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Rating and Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            StarDisplayWidget(
                              value: rating?.toInt() ?? 0,
                              filledStar: const Icon(
                                Icons.star,
                                color: kStarColor,
                                size: 16,
                              ),
                              unfilledStar: const Icon(
                                Icons.star_border,
                                color: kStarColor,
                                size: 16,
                              ),
                            ),
                            Text(
                              price ?? 'Free',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: kPrimaryColor,
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
      ),
    );
  }
}