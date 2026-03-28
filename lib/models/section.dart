// import 'package:flutter/cupertino.dart';

// import '../models/lesson.dart';

// class Section {
//   int? id;
//   int? numberOfCompletedLessons;
//   String? title;
//   String? totalDuration;
//   int? lessonCounterStarts;
//   int? lessonCounterEnds;
//   List<Lesson>? mLesson;

//   Section({
//     @required this.id,
//     @required this.numberOfCompletedLessons,
//     @required this.title,
//     @required this.totalDuration,
//     @required this.lessonCounterEnds,
//     @required this.lessonCounterStarts,
//     @required this.mLesson,
//   });
// }


import 'package:academy_app/models/lesson.dart';

class Section {
  final int id;
  final int userId;
  final int courseId;
  final String title;
  final int sort;
  final String createdAt;
  final String updatedAt;
  final List<Lesson> lessons;
  final String totalDuration;
  final int lessonCounterStarts;
  final int lessonCounterEnds;
  final int completedLessonNumber;
  final bool userValidity;

  Section({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.title,
    required this.sort,
    required this.createdAt,
    required this.updatedAt,
    required this.lessons,
    required this.totalDuration,
    required this.lessonCounterStarts,
    required this.lessonCounterEnds,
    required this.completedLessonNumber,
    required this.userValidity,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    List<Lesson> lessons = [];
    if (json['lessons'] != null && json['lessons'] is List) {
      lessons = (json['lessons'] as List)
          .map((lesson) => Lesson.fromJson(lesson))
          .toList();
    }

    return Section(
      id: json['id'],
      userId: json['user_id'] ?? 0,
      courseId: json['course_id'] ?? 0,
      title: json['title'] ?? '',
      sort: json['sort'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      lessons: lessons,
      totalDuration: json['total_duration'] ?? '00:00:00',
      lessonCounterStarts: json['lesson_counter_starts'] ?? 0,
      lessonCounterEnds: json['lesson_counter_ends'] ?? 0,
      completedLessonNumber: json['completed_lesson_number'] ?? 0,
      userValidity: json['user_validity'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'course_id': courseId,
      'title': title,
      'sort': sort,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'lessons': lessons.map((l) => l.toJson()).toList(),
      'total_duration': totalDuration,
      'lesson_counter_starts': lessonCounterStarts,
      'lesson_counter_ends': lessonCounterEnds,
      'completed_lesson_number': completedLessonNumber,
      'user_validity': userValidity,
    };
  }
}

