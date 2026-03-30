// ignore_for_file: deprecated_member_use, use_build_context_synchronously, prefer_const_constructors

import 'package:wilan/models/common_functions.dart';
import 'package:wilan/models/course.dart';
import 'package:wilan/providers/shared_pref_helper.dart';
import 'package:wilan/screens/check_out_screen.dart';
import 'package:wilan/widgets/course_card_widget.dart';
import 'package:wilan/widgets/custom_text.dart';
import 'package:wilan/widgets/from_vimeo_player.dart';
import 'package:wilan/widgets/lesson_list_item.dart';
import 'package:wilan/widgets/new_youtube_player.dart';
import 'package:wilan/widgets/star_display_widget.dart';
import 'package:wilan/widgets/tab_view_details.dart';
import 'package:wilan/widgets/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../providers/courses.dart';
import '../widgets/app_bar_two.dart';

class CourseDetailScreen extends StatefulWidget {
  static const routeName = '/course-details';
  const CourseDetailScreen({super.key});

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with TickerProviderStateMixin {
  // ← Changed to TickerProviderStateMixin
  late TabController _tabController;
  late TabController _infoTabController;

  var _isInit = true;
  bool _isAuth = false;
  var _isLoading = false;
  String? _authToken;
  dynamic loadedCourseDetail;
  dynamic loadedCourse;
  dynamic courseId;
  int? selected;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      var token = await SharedPreferenceHelper().getAuthToken();
      setState(() {
        _isLoading = true;
        if (token != null && token.isNotEmpty) {
          _isAuth = true;
        } else {
          _isAuth = false;
        }
      });

      courseId = ModalRoute.of(context)!.settings.arguments as int;

      loadedCourse =
          Provider.of<Courses>(context, listen: false).findById(courseId);

      await Provider.of<Courses>(context, listen: false)
          .fetchCourseDetailById(courseId);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _infoTabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _infoTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarTwo(),
      backgroundColor: kBackgroundColor,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: kPrimaryColor.withOpacity(0.7)),
            )
          : Consumer<Courses>(
              builder: (context, courses, child) {
                final courseDetail = courses.getCourseDetail;

                if (courseDetail.courseId == null) {
                  return const Center(
                    child: Text('No course details available'),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Image Section with Play Button
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 2.5,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  courseDetail.thumbnail ??
                                      (loadedCourse?.thumbnail ?? ''),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 2.5,
                            width: double.infinity,
                            color: Colors.black,
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: kCategoryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _getCategoryLevel(courseDetail.level),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: InkWell(
                              onTap: () {
                                if (courseDetail.preview != null &&
                                    courseDetail.preview!.isNotEmpty) {
                                  if (courseDetail.preview!.contains('vimeo')) {
                                    String vimeoVideoId =
                                        courseDetail.preview!.split('/').last;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FromVimeoPlayer(
                                                    courseId:
                                                        courseDetail.courseId!,
                                                    vimeoVideoId:
                                                        vimeoVideoId)));
                                  } else if (courseDetail.preview!
                                          .contains('youtube') ||
                                      courseDetail.preview!
                                          .contains('youtu.be')) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              YoutubeVideoPlayerFlutter(
                                                  courseId:
                                                      courseDetail.courseId!,
                                                  videoUrl:
                                                      courseDetail.preview!),
                                        ));
                                  } else {
                                    CommonFunctions.showSuccessToast(
                                        'Video preview not available');
                                  }
                                } else {
                                  CommonFunctions.showSuccessToast(
                                      'Video preview not available');
                                }
                              },
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  size: 40,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Course Title Section
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              courseDetail.courseTitle ??
                                  loadedCourse?.title ??
                                  '',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Short Description
                            if (loadedCourse?.shortDescription != null)
                              Text(
                                loadedCourse!.shortDescription,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: kSecondaryColor,
                                  height: 1.5,
                                ),
                              ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ✅ COURSE CARD WIDGET (ADDED HERE)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CourseCardWidget(
                          course: courses.items[0],
                          onEnrollTap: () async {
                            Navigator.push(
                                context,
                                CupertinoDialogRoute(
                                    builder: (_) => CheckoutSessionScreen(
                                          course: courses.items[0],
                                        ),
                                    context: context));
                          },
                          onWishlistTap: () {
                            if (_isAuth) {
                              var msg = courseDetail.isWishlisted;
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    buildPopupDialogWishList(
                                        context,
                                        courseDetail.isWishlisted ?? false,
                                        courseDetail.courseId!,
                                        msg ?? false),
                              );
                            } else {
                              CommonFunctions.showSuccessToast(
                                  'Please login first');
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // About Program Section
                      if (courseDetail.description != null &&
                          courseDetail.description!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ABOUT THE PROGRAM',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: iCardColor,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: HtmlWidget(
                                  courseDetail.description!,
                                  textStyle: TextStyle(
                                    fontSize: 15,
                                    color: kSecondaryColor,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 24),

                      // What's Included Section (START Framework)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'OUR SIGNATURE APPROACH: THE START FRAMEWORK',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: iCardColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  _buildFrameworkItem('S', 'Self',
                                      'Identity, strengths, values, and career direction'),
                                  _buildFrameworkItem('T', 'Trust',
                                      'Confidence built through proof, practice, and boundaries'),
                                  _buildFrameworkItem('A', 'Articulate',
                                      'Clear speaking, writing, feedback, and professional relationships'),
                                  _buildFrameworkItem('R', 'Resources',
                                      'Money habits that create stability and options'),
                                  _buildFrameworkItem('T', 'Track',
                                      'Weekly review to ensure progress is intentional, not accidental'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Tab Section (Includes, Outcomes, Requirements)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: iCardColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: TabBar(
                                  dividerColor: Colors.transparent,
                                  controller: _infoTabController,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: kPrimaryColor,
                                  ),
                                  unselectedLabelColor: kSecondaryColor,
                                  labelColor: Colors.white,
                                  tabs: const [
                                    Tab(text: "Includes"),
                                    Tab(text: "Outcomes"),
                                    Tab(text: "Requirements"),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 250,
                                child: TabBarView(
                                  controller: _infoTabController,
                                  children: [
                                    _buildInfoList(
                                        courseDetail.courseIncludes ?? []),
                                    _buildInfoList(
                                        courseDetail.courseOutcomes ?? []),
                                    _buildInfoList(
                                        courseDetail.courseRequirements ?? []),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Course Curriculum
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'COURSE CURRICULUM',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView.builder(
                          key: Key('builder ${selected.toString()}'),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: courseDetail.mSection?.length ?? 0,
                          itemBuilder: (ctx, index) {
                            final section = courseDetail.mSection![index];
                            return Card(
                              elevation: 0,
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  dividerColor: Colors.transparent,
                                ),
                                child: ExpansionTile(
                                  key: Key(index.toString()),
                                  initiallyExpanded: index == selected,
                                  onExpansionChanged: ((newState) {
                                    setState(() {
                                      selected = newState ? index : -1;
                                    });
                                  }),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        HtmlUnescape()
                                            .convert(section.title.toString()),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: kTimeBackColor,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              section.totalDuration ?? '0.0',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: kTimeColor,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: kLessonBackColor,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              '${section.lessons.length} Lessons',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: kSecondaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (ctx, lessonIndex) {
                                        return Column(
                                          children: [
                                            LessonListItem(
                                              lesson:
                                                  section.lessons[lessonIndex],
                                              courseId: courseDetail.courseId!,
                                            ),
                                            if (lessonIndex <
                                                section.lessons.length - 1)
                                              Divider(
                                                height: 1,
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                              ),
                                          ],
                                        );
                                      },
                                      itemCount: section.lessons.length,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildFrameworkItem(String letter, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                letter,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: kSecondaryColor,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoList(List<String> items) {
    if (items.isEmpty) {
      return const Center(
        child: Text('No information available'),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (ctx, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle,
                size: 20,
                color: kPrimaryColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  items[index],
                  style: TextStyle(
                    fontSize: 14,
                    color: kSecondaryColor,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFAQItem(Map<String, dynamic> faq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: iCardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            faq['question'] ?? '',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            faq['answer'] ?? '',
            style: TextStyle(
              fontSize: 14,
              color: kSecondaryColor,
              height: 1.5,
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

  String _getTotalDuration(List? sections) {
    // Calculate total duration from sections
    return '6 Weeks • 2 Sessions/Week';
  }

  String _formatPrice(dynamic price) {
    if (price == null) return '0';
    if (price is String) return price.replaceAll('₦', '');
    return price.toString();
  }
}

// Simple HTML Widget for rendering HTML content
class HtmlWidget extends StatelessWidget {
  final String html;
  final TextStyle? textStyle;

  const HtmlWidget(this.html, {this.textStyle, super.key});

  @override
  Widget build(BuildContext context) {
    // Remove HTML tags for simplicity
    String plainText = html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");

    return Text(
      plainText,
      style: textStyle,
    );
  }
}
