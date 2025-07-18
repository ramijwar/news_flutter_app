import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/admin_header_widget.dart';
import './widgets/admin_stats_card_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/news_article_card_widget.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _newsArticles = [];
  bool _isLoading = true;
  Set<int> _selectedArticles = {};
  bool _isSelectionMode = false;

  // Mock data for news articles
  final List<Map<String, dynamic>> _mockNewsData = [
    {
      "id": 1,
      "title": "أخبار التكنولوجيا الجديدة في عام 2025",
      "content":
          "تشهد صناعة التكنولوجيا تطورات مذهلة في عام 2025، حيث تركز الشركات على الذكاء الاصطناعي والحوسبة الكمية. هذه التطورات ستغير طريقة عملنا وحياتنا اليومية بشكل جذري.",
      "publishedAt": "2025-01-15T10:30:00Z",
      "status": "منشور",
      "author": "ramijwar",
      "imageUrl":
          "https://images.unsplash.com/photo-1518709268805-4e9042af2176?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 2,
      "title": "الاقتصاد العالمي والتحديات المستقبلية",
      "content":
          "يواجه الاقتصاد العالمي تحديات جديدة في ظل التطورات التكنولوجية والتغيرات المناخية. الخبراء يتوقعون نمواً متوسطاً مع ضرورة التكيف مع الواقع الجديد.",
      "publishedAt": "2025-01-14T14:20:00Z",
      "status": "منشور",
      "author": "ramijwar",
      "imageUrl":
          "https://images.pexels.com/photos/259027/pexels-photo-259027.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
    {
      "id": 3,
      "title": "الرياضة والصحة: نصائح للحياة الصحية",
      "content":
          "تلعب الرياضة دوراً مهماً في الحفاظ على الصحة العامة. الأطباء ينصحون بممارسة الرياضة لمدة 30 دقيقة يومياً للحصول على أفضل النتائج الصحية.",
      "publishedAt": "2025-01-13T09:15:00Z",
      "status": "مسودة",
      "author": "ramijwar",
      "imageUrl":
          "https://images.pixabay.com/photo/2017/08/07/14/02/man-2604149_1280.jpg",
    },
    {
      "id": 4,
      "title": "التعليم الرقمي وتطوير المهارات",
      "content":
          "يشهد التعليم الرقمي نمواً متسارعاً، حيث تتيح المنصات التعليمية الحديثة فرصاً جديدة لتطوير المهارات والحصول على المعرفة من أي مكان في العالم.",
      "publishedAt": "2025-01-12T16:45:00Z",
      "status": "منشور",
      "author": "ramijwar",
      "imageUrl":
          "https://images.unsplash.com/photo-1522202176988-66273c2fd55f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 5,
      "title": "البيئة والاستدامة في المدن الذكية",
      "content":
          "تسعى المدن الذكية إلى تحقيق التوازن بين التطور التكنولوجي والحفاظ على البيئة. المشاريع الجديدة تركز على الطاقة المتجددة والنقل المستدام.",
      "publishedAt": "2025-01-11T11:30:00Z",
      "status": "منشور",
      "author": "ramijwar",
      "imageUrl":
          "https://images.pexels.com/photos/2422915/pexels-photo-2422915.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _loadNewsArticles();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadNewsArticles() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedArticles = prefs.getStringList('news_articles');

      if (savedArticles != null && savedArticles.isNotEmpty) {
        _newsArticles = savedArticles
            .map((article) => Map<String, dynamic>.from(
                  article.split('|').asMap().map((index, value) {
                    switch (index) {
                      case 0:
                        return MapEntry('id', int.tryParse(value) ?? 0);
                      case 1:
                        return MapEntry('title', value);
                      case 2:
                        return MapEntry('content', value);
                      case 3:
                        return MapEntry('publishedAt', value);
                      case 4:
                        return MapEntry('status', value);
                      case 5:
                        return MapEntry('author', value);
                      case 6:
                        return MapEntry('imageUrl', value);
                      default:
                        return MapEntry('unknown', value);
                    }
                  }),
                ))
            .toList();
      } else {
        _newsArticles = List.from(_mockNewsData);
        await _saveNewsArticles();
      }
    } catch (e) {
      _newsArticles = List.from(_mockNewsData);
    }

    setState(() => _isLoading = false);
  }

  Future<void> _saveNewsArticles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final articlesString = _newsArticles
          .map((article) =>
              '${article['id']}|${article['title']}|${article['content']}|${article['publishedAt']}|${article['status']}|${article['author']}|${article['imageUrl']}')
          .toList();
      await prefs.setStringList('news_articles', articlesString);
    } catch (e) {
      // Handle save error silently
    }
  }

  Future<void> _refreshData() async {
    await _loadNewsArticles();
  }

  void _handleLogout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', false);
      await prefs.remove('admin_username');

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login-screen',
          (route) => false,
        );
      }
    } catch (e) {
      // Handle logout error
    }
  }

  void _navigateToAddArticle() {
    Navigator.pushNamed(context, '/add-news-article').then((_) {
      _refreshData();
    });
  }

  void _navigateToNewsFeed() {
    Navigator.pushNamed(context, '/news-feed');
  }

  void _navigateToSettings() {
    Navigator.pushNamed(context, '/admin-settings');
  }

  void _editArticle(Map<String, dynamic> article) {
    Navigator.pushNamed(
      context,
      '/add-news-article',
      arguments: article,
    ).then((_) {
      _refreshData();
    });
  }

  void _deleteArticle(Map<String, dynamic> article) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'حذف الخبر',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'هل أنت متأكد من رغبتك في حذف هذا الخبر؟ لا يمكن التراجع عن هذا الإجراء.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performDeleteArticle(article);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text(
              'حذف',
              style: TextStyle(color: AppTheme.lightTheme.colorScheme.onError),
            ),
          ),
        ],
      ),
    );
  }

  void _performDeleteArticle(Map<String, dynamic> article) async {
    setState(() {
      _newsArticles.removeWhere((item) => item['id'] == article['id']);
    });
    await _saveNewsArticles();
  }

  void _duplicateArticle(Map<String, dynamic> article) async {
    final newArticle = Map<String, dynamic>.from(article);
    newArticle['id'] = DateTime.now().millisecondsSinceEpoch;
    newArticle['title'] = 'نسخة من ${article['title']}';
    newArticle['publishedAt'] = DateTime.now().toIso8601String();
    newArticle['status'] = 'مسودة';

    setState(() {
      _newsArticles.insert(0, newArticle);
    });
    await _saveNewsArticles();
  }

  void _toggleSelection(int articleId) {
    setState(() {
      if (_selectedArticles.contains(articleId)) {
        _selectedArticles.remove(articleId);
      } else {
        _selectedArticles.add(articleId);
      }

      if (_selectedArticles.isEmpty) {
        _isSelectionMode = false;
      }
    });
  }

  void _deleteSelectedArticles() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'حذف الأخبار المحددة',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'هل أنت متأكد من رغبتك في حذف ${_selectedArticles.length} خبر؟',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performBulkDelete();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text(
              'حذف الكل',
              style: TextStyle(color: AppTheme.lightTheme.colorScheme.onError),
            ),
          ),
        ],
      ),
    );
  }

  void _performBulkDelete() async {
    setState(() {
      _newsArticles
          .removeWhere((article) => _selectedArticles.contains(article['id']));
      _selectedArticles.clear();
      _isSelectionMode = false;
    });
    await _saveNewsArticles();
  }

  int get _publishedCount =>
      _newsArticles.where((article) => article['status'] == 'منشور').length;
  int get _draftCount =>
      _newsArticles.where((article) => article['status'] == 'مسودة').length;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              AdminHeaderWidget(onLogout: _handleLogout),
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'feed',
                          color: _tabController.index == 0
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                          size: 5.w,
                        ),
                        SizedBox(width: 2.w),
                        Text('الأخبار'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'admin_panel_settings',
                          color: _tabController.index == 1
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                          size: 5.w,
                        ),
                        SizedBox(width: 2.w),
                        Text('الإدارة'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'settings',
                          color: _tabController.index == 2
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                          size: 5.w,
                        ),
                        SizedBox(width: 2.w),
                        Text('الإعدادات'),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildNewsFeedTab(),
                    _buildAdminTab(),
                    _buildSettingsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _tabController.index == 1
            ? FloatingActionButton.extended(
                onPressed: _navigateToAddArticle,
                backgroundColor:
                    AppTheme.lightTheme.colorScheme.secondaryContainer,
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 6.w,
                ),
                label: Text(
                  'خبر جديد',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }

  Widget _buildSettingsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'settings',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 15.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'إعدادات التطبيق',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'قم بإدارة إعدادات التطبيق والشعار',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 4.h),
          ElevatedButton.icon(
            onPressed: _navigateToSettings,
            icon: CustomIconWidget(
              iconName: 'tune',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 5.w,
            ),
            label: Text(
              'إعدادات التطبيق',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AdminStatsCardWidget(
                          title: 'الأخبار المنشورة',
                          count: _publishedCount.toString(),
                          iconName: 'publish',
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: AdminStatsCardWidget(
                          title: 'المسودات',
                          count: _draftCount.toString(),
                          iconName: 'draft',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: AdminStatsCardWidget(
                          title: 'إجمالي الأخبار',
                          count: _newsArticles.length.toString(),
                          iconName: 'article',
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: AdminStatsCardWidget(
                          title: 'هذا الشهر',
                          count: _getThisMonthCount().toString(),
                          iconName: 'calendar_today',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isSelectionMode)
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondaryContainer
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      'تم تحديد ${_selectedArticles.length} خبر',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _deleteSelectedArticles,
                      icon: CustomIconWidget(
                        iconName: 'delete',
                        color: AppTheme.lightTheme.colorScheme.error,
                        size: 5.w,
                      ),
                      label: Text(
                        'حذف المحدد',
                        style: TextStyle(
                            color: AppTheme.lightTheme.colorScheme.error),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedArticles.clear();
                          _isSelectionMode = false;
                        });
                      },
                      child: Text('إلغاء'),
                    ),
                  ],
                ),
              ),
            ),
          _isLoading
              ? SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                )
              : _newsArticles.isEmpty
                  ? SliverFillRemaining(
                      child:
                          EmptyStateWidget(onAddArticle: _navigateToAddArticle),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final article = _newsArticles[index];
                          final isSelected =
                              _selectedArticles.contains(article['id']);

                          return GestureDetector(
                            onLongPress: () {
                              setState(() {
                                _isSelectionMode = true;
                                _toggleSelection(article['id']);
                              });
                            },
                            onTap: _isSelectionMode
                                ? () => _toggleSelection(article['id'])
                                : null,
                            child: Container(
                              decoration: isSelected
                                  ? BoxDecoration(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    )
                                  : null,
                              child: Stack(
                                children: [
                                  NewsArticleCardWidget(
                                    article: article,
                                    onEdit: () => _editArticle(article),
                                    onDelete: () => _deleteArticle(article),
                                    onDuplicate: () =>
                                        _duplicateArticle(article),
                                  ),
                                  if (isSelected)
                                    Positioned(
                                      top: 1.h,
                                      left: 4.w,
                                      child: Container(
                                        padding: EdgeInsets.all(1.w),
                                        decoration: BoxDecoration(
                                          color: AppTheme
                                              .lightTheme.colorScheme.primary,
                                          shape: BoxShape.circle,
                                        ),
                                        child: CustomIconWidget(
                                          iconName: 'check',
                                          color: AppTheme
                                              .lightTheme.colorScheme.onPrimary,
                                          size: 4.w,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: _newsArticles.length,
                      ),
                    ),
        ],
      ),
    );
  }

  Widget _buildNewsFeedTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _navigateToNewsFeed,
                      icon: CustomIconWidget(
                        iconName: 'visibility',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 5.w,
                      ),
                      label: Text(
                        'عرض الأخبار العامة',
                        style: TextStyle(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _isLoading
              ? SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                )
              : _newsArticles.isEmpty
                  ? SliverFillRemaining(
                      child:
                          EmptyStateWidget(onAddArticle: _navigateToAddArticle),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final article = _newsArticles[index];
                          return NewsArticleCardWidget(
                            article: article,
                            onEdit: () => _editArticle(article),
                            onDelete: () => _deleteArticle(article),
                            onDuplicate: () => _duplicateArticle(article),
                          );
                        },
                        childCount: _newsArticles.length,
                      ),
                    ),
        ],
      ),
    );
  }

  int _getThisMonthCount() {
    final now = DateTime.now();
    return _newsArticles.where((article) {
      try {
        final publishedDate = DateTime.parse(article['publishedAt']);
        return publishedDate.year == now.year &&
            publishedDate.month == now.month;
      } catch (e) {
        return false;
      }
    }).length;
  }
}
