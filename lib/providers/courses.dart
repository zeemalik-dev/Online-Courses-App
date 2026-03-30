import 'dart:convert';
import 'dart:developer';
import 'package:wilan/models/course.dart';
import 'package:wilan/models/course_detail.dart';
import 'package:wilan/models/lesson.dart';
import 'package:wilan/models/section.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'shared_pref_helper.dart';

class Courses with ChangeNotifier {
  List<Course> _items = [];
  List<Course> _topItems = [];
  List<CourseDetail> _courseDetailsitems = [];

  Courses(this._items, this._topItems);

  List<Course> get items {
    return [..._items];
  }

  List<Course> get topItems {
    return [..._topItems];
  }

  CourseDetail get getCourseDetail {
    return _courseDetailsitems.first;
  }

  int get itemCount {
    return _items.length;
  }

  Course findById(int id) {
    // return _topItems.firstWhere((course) => course.id == id);
    return _items.firstWhere((course) => course.id == id,
        orElse: () => _topItems.firstWhere((course) => course.id == id));
  }

  Future<void> fetchTopCourses() async {
    // debugger();
    var url = '$BASE_URL/api/top_courses';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      log(response.body);
      // debugger();
      if (extractedData == null) {
        return;
      }
      // print(extractedData);
      _topItems = buildCourseList(extractedData);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchCoursesByCategory(int categoryId) async {
    var url = '$BASE_URL/api/category_wise_course?category_id=$categoryId';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      // print(extractedData);

      _items = buildCourseList(extractedData);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchCoursesBySearchQuery(String searchQuery) async {
    var url =
        '$BASE_URL/api/courses_by_search_string?search_string=$searchQuery';
    // print(url);
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      log(response.body);
      // debugger();
      if (extractedData == null) {
        return;
      }
      // print(extractedData);

      _items = buildCourseList(extractedData);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> filterCourses(
      String selectedCategory,
      String selectedPrice,
      String selectedLevel,
      String selectedLanguage,
      String selectedRating) async {
    var url =
        '$BASE_URL/api/filter_course?selected_category=$selectedCategory&selected_price=$selectedPrice&selected_level=$selectedLevel&selected_language=$selectedLanguage&selected_rating=$selectedRating&selected_search_string=';
    // print(url);
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      // print(extractedData);

      _items = buildCourseList(extractedData);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchMyWishlist() async {
    var authToken = await SharedPreferenceHelper().getAuthToken();
    var url = '$BASE_URL/api/my_wishlist?auth_token=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      // print(extractedData);
      _items = buildCourseList(extractedData);
      // print(_items);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  List<Course> buildCourseList(List extractedData) {
    final List<Course> loadedCourses = [];

    for (var courseData in extractedData) {
      loadedCourses.add(Course.fromJson(courseData));
    }

    return loadedCourses;
  }

  Future<void> toggleWishlist(int courseId, bool removeItem) async {
    var authToken = await SharedPreferenceHelper().getAuthToken();
    var url =
        '$BASE_URL/api/toggle_wishlist_items?auth_token=$authToken&course_id=$courseId';
    if (!removeItem) {
      _courseDetailsitems.first.isWishlisted!
          ? _courseDetailsitems.first.isWishlisted = false
          : _courseDetailsitems.first.isWishlisted = true;
      notifyListeners();
    }
    try {
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);
      if (responseData['status'] == 'removed') {
        if (removeItem) {
          final existingMyCourseIndex =
              _items.indexWhere((mc) => mc.id == courseId);

          _items.removeAt(existingMyCourseIndex);
          notifyListeners();
        } else {
          _courseDetailsitems.first.isWishlisted = false;
        }
      } else if (responseData['status'] == 'added') {
        if (!removeItem) {
          _courseDetailsitems.first.isWishlisted = true;
        }
      }
      // notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchCourseDetailById(int courseId) async {
    var authToken = await SharedPreferenceHelper().getAuthToken();
    var url = '$BASE_URL/api/course_details_by_id?course_id=$courseId';

    if (authToken != null) {
      url =
          '$BASE_URL/api/course_details_by_id?auth_token=$authToken&course_id=$courseId';
    }

    try {
      final response = await http.get(Uri.parse(url));
      log(response.body);
      // debugger();

      final extractedData = json.decode(response.body) as List;
      if (extractedData.isEmpty) {
        return;
      }

      final List<CourseDetail> loadedCourseDetails = [];

      for (var courseData in extractedData) {
        // Handle outcomes - it might be a Map or List
        List<String> outcomes = [];
        if (courseData['outcomes'] != null) {
          if (courseData['outcomes'] is Map) {
            // If outcomes is a Map (like in your response)
            outcomes = (courseData['outcomes'] as Map)
                .values
                .map((e) => e.toString())
                .toList();
          } else if (courseData['outcomes'] is List) {
            // If outcomes is a List
            outcomes = (courseData['outcomes'] as List<dynamic>).cast<String>();
          }
        }

        // Handle requirements - might be List or null
        List<String> requirements = [];
        if (courseData['requirements'] != null &&
            courseData['requirements'] is List) {
          requirements =
              (courseData['requirements'] as List<dynamic>).cast<String>();
        }

        // Handle includes - might be List or null
        List<String> includes = [];
        if (courseData['includes'] != null && courseData['includes'] is List) {
          includes = (courseData['includes'] as List<dynamic>).cast<String>();
        }

        // Handle sections - ensure it's a list
        List<dynamic> sections = [];
        if (courseData['sections'] != null && courseData['sections'] is List) {
          sections = courseData['sections'] as List<dynamic>;
        }

        loadedCourseDetails.add(CourseDetail(
          courseId: courseData['id'],
          courseTitle: courseData['title'] ?? '',
          courseSlug: courseData['slug'] ?? '',
          shortDescription: courseData['short_description'] ?? '',
          courseType: courseData['course_type'] ?? 'general',
          status: courseData['status'] ?? '',
          level: courseData['level'] ?? '',
          deliveryMethod: courseData['delivery_method'] ?? '',
          language: courseData['language'] ?? '',
          isPaid: courseData['is_paid'] ?? 0,
          isBest: courseData['is_best'] ?? 0,
          price: courseData['price']?.toString() ?? '0',
          discountedPrice: courseData['discounted_price'] ?? 0,
          discountFlag: courseData['discount_flag'] ?? 0,
          thumbnail: courseData['thumbnail'] ?? '',
          banner: courseData['banner'] ?? '',
          preview: courseData['preview'] ?? '',
          description: courseData['description'] ?? '',
          averageRating:
              double.parse(courseData['average_rating']?.toString() ?? '0'),
          instructorName: courseData['instructor_name'] ?? '',
          instructorImage: courseData['instructor_image'] ?? '',
          totalEnrollment: courseData['total_enrollment'] ?? 0,
          totalReviews: courseData['total_reviews'] ?? 0,
          shareableLink: courseData['shareable_link'] ?? '',
          courseIncludes: includes,
          courseRequirements: requirements,
          courseOutcomes: outcomes,
          isWishlisted: courseData['is_wishlisted'] ?? false,
          isPurchased: courseData['is_purchased'] == 1
              ? true
              : (courseData['is_purchased'] ?? false),
          isCart: courseData['is_cart'] ?? false,
          mSection: buildCourseSections(sections),
        ));
      }

      _courseDetailsitems = loadedCourseDetails;
      notifyListeners();
    } catch (error) {
      print('Error fetching course detail: $error');
      rethrow;
    }
  }

  Future<void> getEnrolled(int courseId) async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url =
        '$BASE_URL/api/enroll_free_course?course_id=$courseId&auth_token=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);
      if (responseData['message'] == 'success') {
        _courseDetailsitems.first.isPurchased = true;

        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  List<Section> buildCourseSections(List extractedSections) {
    final List<Section> loadedSections = [];

    for (var sectionData in extractedSections) {
      loadedSections.add(Section.fromJson(sectionData as Map<String, dynamic>)
          //   Section(
          //   id: sectionData['id'] is int
          //       ? sectionData['id']
          //       : int.parse(sectionData['id'].toString()),
          //   numberOfCompletedLessons: sectionData['completed_lesson_number'] ?? 0,
          //   title: sectionData['title'] ?? '',
          //   totalDuration: sectionData['total_duration'] ?? '00:00:00',
          //   lessonCounterEnds: sectionData['lesson_counter_ends'] ?? 0,
          //   lessonCounterStarts: sectionData['lesson_counter_starts'] ?? 0,
          //   mLesson: sectionData['lessons'] != null
          //       ? buildCourseLessons(sectionData['lessons'] as List<dynamic>)
          //       : [],
          // )
          );
    }
    return loadedSections;
  }

  List<Lesson> buildCourseLessons(List extractedLessons) {
    final List<Lesson> loadedLessons = [];

    for (var lessonData in extractedLessons) {
      loadedLessons.add(Lesson.fromJson(lessonData as Map<String, dynamic>)
          //   Lesson(
          //   id: lessonData['id'] is int
          //       ? lessonData['id']
          //       : int.parse(lessonData['id'].toString()),
          //   title: lessonData['title'] ?? '',
          //   duration: lessonData['duration'] ?? '00:00:00',
          //   lessonType: lessonData['lesson_type'] ?? '',
          //   isFree: lessonData['is_free'] ?? 0,
          //   videoUrl: lessonData['video_url'] ?? '',
          //   summary: lessonData['summary'] ?? '',
          //   attachmentType: lessonData['attachment_type'] ?? '',
          //   attachment: lessonData['attachment'] ?? '',
          //   attachmentUrl: lessonData['attachment_url'] ?? '',
          //   isCompleted: lessonData['is_completed']?.toString() ?? '0',
          //   videoUrlWeb: lessonData['video_url_web'] ?? '',
          //   videoTypeWeb: lessonData['video_type_web'] ?? '',
          //   vimeoVideoId: lessonData['vimeo_video_id'] ?? '',
          // )
          );
    }
    return loadedLessons;
  }
}
