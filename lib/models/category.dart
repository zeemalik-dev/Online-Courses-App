class Category {
  final int id;
  final int parentId;
  final String title;
  final String slug;
  final String icon;
  final int sort;
  final String? status;
  final String? keywords;
  final String? description;
  final String thumbnail;
  final String? categoryLogo;
  final String createdAt;
  final String updatedAt;
  final int numberOfCourses;
  final int numberOfSubCategories;
  final List<Category> childs;

  Category({
    required this.id,
    required this.parentId,
    required this.title,
    required this.slug,
    required this.icon,
    required this.sort,
    this.status,
    this.keywords,
    this.description,
    required this.thumbnail,
    this.categoryLogo,
    required this.createdAt,
    required this.updatedAt,
    required this.numberOfCourses,
    required this.numberOfSubCategories,
    required this.childs,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      parentId: json['parent_id'],
      title: json['title'],
      slug: json['slug'],
      icon: json['icon'],
      sort: json['sort'],
      status: json['status'],
      keywords: json['keywords'],
      description: json['description'],
      thumbnail: json['thumbnail'],
      categoryLogo: json['category_logo'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      numberOfCourses: json['number_of_courses'],
      numberOfSubCategories: json['number_of_sub_categories'],
      childs: (json['childs'] as List)
          .map((child) => Category.fromJson(child))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'title': title,
      'slug': slug,
      'icon': icon,
      'sort': sort,
      'status': status,
      'keywords': keywords,
      'description': description,
      'thumbnail': thumbnail,
      'category_logo': categoryLogo,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'number_of_courses': numberOfCourses,
      'number_of_sub_categories': numberOfSubCategories,
      'childs': childs.map((child) => child.toJson()).toList(),
    };
  }
}