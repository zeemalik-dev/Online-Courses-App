// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'package:academy_app/models/course.dart';
import 'package:academy_app/providers/bundles.dart';
import 'package:academy_app/widgets/bundle_grid.dart';
import '../providers/categories.dart';
import '../widgets/category_list_item.dart';
import '../widgets/course_grid.dart';
import '../providers/courses.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import 'bundle_list_screen.dart';
import 'courses_screen.dart';
import '../models/common_functions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isInit = true;
  var _isLoading = false;
  List<Course> _topCourses = [];
  List<dynamic> _bundles = [];
  bool _bundleStatus = false;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _loadInitialData();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load top courses
      await Provider.of<Courses>(context, listen: false).fetchTopCourses();
      _topCourses = Provider.of<Courses>(context, listen: false).topItems;

      // Load bundles
      await Provider.of<Bundles>(context, listen: false).fetchBundle(true);
      _bundles = Provider.of<Bundles>(context, listen: false).bundleItems;

      // Load filter courses
      await Provider.of<Courses>(context, listen: false)
          .filterCourses('all', 'all', 'all', 'all', 'all');
    } catch (error) {
      print('Error loading data: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> refreshList() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      await Provider.of<Courses>(context, listen: false).fetchTopCourses();
      await Provider.of<Bundles>(context, listen: false).fetchBundle(true);
      
      if (mounted) {
        setState(() {
          _topCourses = Provider.of<Courses>(context, listen: false).topItems;
          _bundles = Provider.of<Bundles>(context, listen: false).bundleItems;
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        const errorMsg = 'Could not refresh!';
        CommonFunctions.showErrorDialog(errorMsg, context);
      }
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshList,
      child: SingleChildScrollView(
        child: FutureBuilder(
          future:
              Provider.of<Categories>(context, listen: false).fetchCategories(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * .5,
                child: Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryColor.withOpacity(0.7),
                  ),
                ),
              );
            } else {
              if (dataSnapshot.error != null) {
                return _connectionStatus == ConnectivityResult.none
                    ? Center(
                        child: Column(
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .15),
                            Image.asset(
                              "assets/images/no_connection.png",
                              height: MediaQuery.of(context).size.height * .35,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text('There is no Internet connection'),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(4.0),
                              child:
                                  Text('Please check your Internet connection'),
                            ),
                          ],
                        ),
                      )
                    : const Center(
                        child: Text('Error Occurred'),
                      );
              } else {
                return Column(
                  children: [
                    // Top Courses Section
                    if (_topCourses.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'Top Courses',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  CoursesScreen.routeName,
                                  arguments: {
                                    'category_id': null,
                                    'seacrh_query': null,
                                    'type': 'all',
                                  },
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 30),
                              ),
                              child: Row(
                                children: [
                                  const Text('All courses'),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: kPrimaryColor.withOpacity(0.7),
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : _topCourses.isNotEmpty
                            ? Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 0.0),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                height: 260.0,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (ctx, index) {
                                    final course = _topCourses[index];
                                    log(course.thumbnail.toString());
                                    return CourseGrid(
                                      id: course.id,
                                      title: course.title,
                                      thumbnail: course.thumbnail,
                                      instructorName: course.instructorName,
                                      instructorImage: course.instructorImage,
                                      rating: course.averageRating.toDouble(),
                                      price: course.price,
                                    );
                                  },
                                  itemCount: _topCourses.length,
                                ),
                              )
                            : const SizedBox(height: 0),

                    // Bundles Section
                    if (_bundles.isNotEmpty)
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text(
                                  'Bundles',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                      BundleListScreen.routeName,
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(50, 30),
                                  ),
                                  child: Row(
                                    children: [
                                      const Text('All bundles'),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: kPrimaryColor.withOpacity(0.7),
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 0.0),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            height: 240.0,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (ctx, index) {
                                final bundle = _bundles[index];
                                return BundleGrid(
                                  id: bundle.id,
                                  title: bundle.title,
                                  banner: bundle.banner?.startsWith('http') == true
                                      ? bundle.banner
                                      : '$BASE_URL/uploads/course_bundle/banner/${bundle.banner}',
                                  averageRating: bundle.averageRating ?? 0.0,
                                  numberOfRatings: bundle.numberOfRatings ?? 0,
                                  price: bundle.price,
                                );
                              },
                              itemCount: _bundles.length,
                            ),
                          ),
                        ],
                      ),

                    // Categories Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            'Course Categories',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                CoursesScreen.routeName,
                                arguments: {
                                  'category_id': null,
                                  'seacrh_query': null,
                                  'type': 'all',
                                },
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(50, 30),
                            ),
                            child: Row(
                              children: [
                                const Text('All courses'),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: kPrimaryColor.withOpacity(0.7),
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    Consumer<Categories>(
                      builder: (context, categoriesData, child) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            final category = categoriesData.items[index];
                            return CategoryListItem(
                              id: category.id,
                              title: category.title,
                              thumbnail: category.thumbnail,
                              numberOfSubCategories: category.numberOfSubCategories,
                            );
                          },
                          itemCount: categoriesData.items.length,
                        ),
                      ),
                    ),
                  ],
                );
              }
            }
          },
        ),
      ),
    );
  }
}