
class Lesson {
  int? id;
  String? title;
  String? duration;
  String? videoUrl;
  String? lessonType;
  String? isFree;
  String? summary;
  String? attachmentType;
  String? attachment;
  String? attachmentUrl;
  String? isCompleted;
  String? videoUrlWeb;
  String? videoTypeWeb;
  String? videoType;
  String? vimeoVideoId;

  Lesson({
    this.id,
    this.title,
    this.duration,
    this.lessonType,
    this.isFree,
    this.videoUrl,
    this.summary,
    this.attachmentType,
    this.attachment,
    this.attachmentUrl,
    this.isCompleted,
    this.videoUrlWeb,
    this.videoTypeWeb,
    this.videoType,
    this.vimeoVideoId,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      duration: json['duration']?.toString(),
      lessonType: json['lesson_type'],
      isFree: json['is_free']?.toString(),
      videoUrl: json['video_url'],
      summary: json['summary'],
      attachmentType: json['attachment_type'],
      attachment: json['attachment'],
      attachmentUrl: json['attachment_url'],
      isCompleted: json['is_completed']?.toString(),
      videoUrlWeb: json['video_url_web'],
      videoTypeWeb: json['video_type_web'],
      videoType: json['video_type'],
      vimeoVideoId: json['vimeo_video_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
      'lesson_type': lessonType,
      'is_free': isFree,
      'video_url': videoUrl,
      'summary': summary,
      'attachment_type': attachmentType,
      'attachment': attachment,
      'attachment_url': attachmentUrl,
      'is_completed': isCompleted,
      'video_url_web': videoUrlWeb,
      'video_type_web': videoTypeWeb,
      'video_type': videoType,
      'vimeo_video_id': vimeoVideoId,
    };
  }

  // Helper method to check if lesson is free
  bool get isFreeLesson => isFree == '1' || isFree == 1;

  // Helper method to check if lesson is completed
  bool get isLessonCompleted => isCompleted == '1' || isCompleted == 1;

  // Helper method to get video URL based on platform
  String? getVideoUrl() {
    if (videoUrl != null && videoUrl!.isNotEmpty) {
      return videoUrl;
    }
    if (videoUrlWeb != null && videoUrlWeb!.isNotEmpty) {
      return videoUrlWeb;
    }
    return null;
  }

  // Helper method to check if it's a YouTube video
  bool get isYoutubeVideo {
    final url = getVideoUrl();
    return url != null && (url.contains('youtube.com') || url.contains('youtu.be'));
  }

  // Helper method to get YouTube video ID
  String? getYoutubeVideoId() {
    if (!isYoutubeVideo) return null;
    
    final url = getVideoUrl();
    if (url == null) return null;
    
    if (url.contains('youtu.be')) {
      return url.split('/').last;
    }
    
    if (url.contains('youtube.com')) {
      final uri = Uri.parse(url);
      return uri.queryParameters['v'];
    }
    
    return null;
  }

  // Helper method to check if it's a Vimeo video
  bool get isVimeoVideo {
    final url = getVideoUrl();
    return url != null && url.contains('vimeo.com');
  }

  // Helper method to get Vimeo video ID
  String? getVimeoVideoId() {
    if (!isVimeoVideo) return vimeoVideoId;
    
    final url = getVideoUrl();
    if (url == null) return null;
    
    return url.split('/').last;
  }
}
