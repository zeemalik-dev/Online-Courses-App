// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:academy_app/models/course.dart';
import 'package:academy_app/providers/bundles.dart';
import '../providers/categories.dart';
import '../widgets/category_list_item.dart';
import '../widgets/course_grid.dart';
import '../providers/courses.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
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
  bool _categoriesLoaded = false;

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
    if (mounted) {
      setState(() {
        _connectionStatus = result;
      });
    }
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
    // Prevent multiple loads
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      // Load top courses
      final coursesProvider = Provider.of<Courses>(context, listen: false);
      await coursesProvider.fetchCoursesBySearchQuery('');
      
      if (mounted) {
        setState(() {
          _topCourses = coursesProvider.items;
        });
      }

      // Load bundles (uncomment when ready)
      // final bundlesProvider = Provider.of<Bundles>(context, listen: false);
      // await bundlesProvider.fetchBundle(true);
      // if (mounted) {
      //   setState(() {
      //     _bundles = bundlesProvider.bundleItems;
      //   });
      // }
    } catch (error) {
      print('Error loading data: $error');
      if (mounted) {
        CommonFunctions.showErrorDialog('Error loading data', context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> refreshList() async {
    if (_isLoading) return;
    
    try {
      setState(() {
        _isLoading = true;
      });
      
      final coursesProvider = Provider.of<Courses>(context, listen: false);
      await coursesProvider.fetchCoursesBySearchQuery('');
      
      final bundlesProvider = Provider.of<Bundles>(context, listen: false);
      await bundlesProvider.fetchBundle(true);
      
      if (mounted) {
        setState(() {
          _topCourses = coursesProvider.topItems;
          _bundles = bundlesProvider.bundleItems;
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
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section with Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    kPrimaryColor.withOpacity(0.1),
                    kPrimaryColor.withOpacity(0.05),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'COURSES',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Browse our comprehensive collection of leadership and professional development courses designed for women at every stage of their career.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Showing courses count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Showing ${_topCourses.length} courses',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // Filter & Sort button
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.filter_list,
                              size: 18,
                              color: Colors.grey[700],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Filter & Sort',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Loading State
            if (_isLoading && _topCourses.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            
            // Top Courses Section - Vertical List
            if (_topCourses.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Section header with accent line
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'COURSE',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Vertical list of courses
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        final course = _topCourses[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildStyledCourseCard(course),
                        );
                      },
                      itemCount: _topCourses.length,
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Categories Section with FutureBuilder for async loading
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'COURSE CATEGORIES',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  FutureBuilder(
                    future: Provider.of<Categories>(context, listen: false).fetchCategories(),
                    builder: (ctx, dataSnapshot) {
                      if (dataSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (dataSnapshot.hasError) {
                        return Center(
                          child: Column(
                            children: [
                              const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                              const SizedBox(height: 8),
                              Text(
                                'Error loading categories',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {});
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Consumer<Categories>(
                          builder: (context, categoriesData, child) {
                            if (categoriesData.items.isEmpty) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32.0),
                                  child: Text('No categories available'),
                                ),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (ctx, index) {
                                final category = categoriesData.items[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: CategoryListItem(
                                    id: category.id,
                                    title: category.title,
                                    thumbnail: category.thumbnail,
                                    numberOfSubCategories: category.numberOfSubCategories,
                                  ),
                                );
                              },
                              itemCount: categoriesData.items.length,
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledCourseCard(Course course) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CourseGrid(
        courseType: course.courseType,
        id: course.id,
        title: course.title,
        instructorName: course.instructorName,
        instructorImage: course.instructorImage,
        rating: course.averageRating,
        price: course.price,
      ),
    );
  }
}
