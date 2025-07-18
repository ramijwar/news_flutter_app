import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_header_widget.dart';
import './widgets/context_menu_widget.dart';
import './widgets/news_list_widget.dart';

class NewsFeed extends StatefulWidget {
  const NewsFeed({Key? key}) : super(key: key);

  @override
  State<NewsFeed> createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> with TickerProviderStateMixin {
  List<Map<String, dynamic>> _articles = [];
  bool _isLoading = false;
  bool _isLoggedIn = false;
  Map<String, dynamic>? _selectedArticle;
  OverlayEntry? _contextMenuOverlay;

  // Mock news data
  final List<Map<String, dynamic>> _mockArticles = [
    {
      "id": 1,
      "title": "تطورات جديدة في مجال التكنولوجيا المالية",
      "content":
          """شهدت التكنولوجيا المالية تطورات مهمة خلال الأشهر الماضية، حيث أعلنت عدة شركات عن إطلاق حلول مبتكرة تهدف إلى تسهيل المعاملات المالية وتحسين تجربة المستخدمين. تشمل هذه التطورات استخدام الذكاء الاصطناعي في تحليل البيانات المالية، وتطوير تطبيقات دفع أكثر أماناً وسهولة في الاستخدام. كما تركز الشركات على تحسين الأمان السيبراني لحماية بيانات العملاء.""",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "author": "فريق التحرير",
    },
    {
      "id": 2,
      "title": "مؤتمر دولي حول الاستدامة البيئية",
      "content":
          """انطلق اليوم المؤتمر الدولي للاستدامة البيئية بمشاركة خبراء من أكثر من 50 دولة حول العالم. يناقش المؤتمر أحدث الحلول والتقنيات المبتكرة لمواجهة تحديات التغير المناخي. من أبرز المواضيع المطروحة: الطاقة المتجددة، إدارة النفايات، والتنمية المستدامة في المدن الذكية. يستمر المؤتمر لمدة ثلاثة أيام ويتضمن ورش عمل تفاعلية ومعارض للتقنيات الحديثة.""",
      "timestamp": DateTime.now().subtract(const Duration(hours: 5)),
      "author": "مراسل خاص",
    },
    {
      "id": 3,
      "title": "إنجازات جديدة في مجال الطب والصحة",
      "content":
          """حققت الأبحاث الطبية إنجازات مهمة في مجال علاج الأمراض المزمنة، حيث أعلن فريق من الباحثين عن تطوير علاج جديد يظهر نتائج واعدة في التجارب السريرية. يركز البحث على استخدام العلاج الجيني والطب الشخصي لتحسين فعالية العلاج وتقليل الآثار الجانبية. من المتوقع أن تصل هذه العلاجات إلى المرضى خلال السنوات القادمة بعد إكمال جميع مراحل التجارب.""",
      "timestamp": DateTime.now().subtract(const Duration(hours: 8)),
      "author": "د. أحمد محمد",
    },
    {
      "id": 4,
      "title": "تطوير تطبيقات الذكاء الاصطناعي في التعليم",
      "content":
          """تشهد قطاعات التعليم تحولاً رقمياً كبيراً مع دمج تقنيات الذكاء الاصطناعي في العملية التعليمية. تهدف هذه التقنيات إلى تخصيص التعلم وفقاً لاحتياجات كل طالب. تشمل التطبيقات الجديدة: أنظمة التعلم التكيفي، المساعدين الافتراضيين للطلاب، وأدوات تقييم ذكية تساعد المعلمين في متابعة تقدم الطلاب. هذه التطورات تعد بثورة حقيقية في مجال التعليم.""",
      "timestamp": DateTime.now().subtract(const Duration(hours: 12)),
      "author": "فريق التعليم الرقمي",
    },
    {
      "id": 5,
      "title": "مبادرات جديدة لدعم ريادة الأعمال",
      "content":
          """أطلقت الحكومة مبادرات جديدة لدعم رواد الأعمال والشركات الناشئة، تتضمن برامج تمويل وتدريب وإرشاد لمساعدة الشباب على تحويل أفكارهم إلى مشاريع ناجحة. تشمل المبادرات: صناديق استثمار متخصصة، حاضنات أعمال، ومراكز للابتكار والتطوير. كما تركز على القطاعات الواعدة مثل التكنولوجيا المالية، الصحة الرقمية، والتجارة الإلكترونية.""",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "author": "وزارة الاقتصاد",
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _loadArticles();
  }

  @override
  void dispose() {
    _contextMenuOverlay?.remove();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      setState(() {
        _isLoggedIn = isLoggedIn;
      });
    } catch (e) {
      setState(() {
        _isLoggedIn = false;
      });
    }
  }

  Future<void> _loadArticles() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedArticles = prefs.getStringList('news_articles');

      if (savedArticles != null && savedArticles.isNotEmpty) {
        // Load saved articles (in a real app, you'd parse JSON here)
        setState(() {
          _articles = _mockArticles;
        });
      } else {
        // Load mock articles
        setState(() {
          _articles = _mockArticles;
        });
        // Save to preferences
        await _saveArticles();
      }
    } catch (e) {
      setState(() {
        _articles = _mockArticles;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveArticles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final articleTitles =
          _articles.map((article) => article['title'] as String).toList();
      await prefs.setStringList('news_articles', articleTitles);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _refreshArticles() async {
    HapticFeedback.lightImpact();
    await _loadArticles();
  }

  void _onArticleTap(Map<String, dynamic> article) {
    // Expand card or navigate to full article view
    HapticFeedback.selectionClick();
    _showArticleDetails(article);
  }

  void _onArticleLongPress(Map<String, dynamic> article) {
    HapticFeedback.mediumImpact();
    _showContextMenu(article);
  }

  void _showArticleDetails(Map<String, dynamic> article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article['title'] as String,
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Text(
                          'بواسطة: ${article['author'] as String}',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        const Spacer(),
                        Text(
                          _formatTimestamp(article['timestamp'] as DateTime),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      article['content'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        height: 1.8,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContextMenu(Map<String, dynamic> article) {
    _selectedArticle = article;

    _contextMenuOverlay = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _hideContextMenu,
        child: Container(
          color: Colors.black.withValues(alpha: 0.5),
          child: Center(
            child: Container(
              width: 80.w,
              child: ContextMenuWidget(
                article: article,
                onShare: _shareArticle,
                onReadLater: _saveForLater,
                onDismiss: _hideContextMenu,
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_contextMenuOverlay!);
  }

  void _hideContextMenu() {
    _contextMenuOverlay?.remove();
    _contextMenuOverlay = null;
    _selectedArticle = null;
  }

  void _shareArticle() {
    _hideContextMenu();
    if (_selectedArticle != null) {
      // In a real app, you would use the share package
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم نسخ رابط المقال',
            textDirection: TextDirection.rtl,
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        ),
      );
    }
  }

  void _saveForLater() {
    _hideContextMenu();
    if (_selectedArticle != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم حفظ المقال للقراءة لاحقاً',
            textDirection: TextDirection.rtl,
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        ),
      );
    }
  }

  void _navigateToLogin() {
    Navigator.pushNamed(context, '/login-screen');
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'تسجيل الخروج',
          textDirection: TextDirection.rtl,
        ),
        content: Text(
          'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
          textDirection: TextDirection.rtl,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'إلغاء',
              textDirection: TextDirection.rtl,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              Navigator.of(context).pop();
              setState(() {
                _isLoggedIn = false;
              });
            },
            child: Text(
              'تسجيل الخروج',
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAdmin() {
    Navigator.pushNamed(context, '/admin-dashboard');
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppHeaderWidget(
          isLoggedIn: _isLoggedIn,
          onLogin: _navigateToLogin,
          onLogout: _logout,
          onAdminAccess: _navigateToAdmin,
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              )
            : _articles.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'article',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 15.w,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'لا توجد أخبار متاحة حالياً',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  )
                : NewsListWidget(
                    articles: _articles,
                    onRefresh: _refreshArticles,
                    onArticleTap: _onArticleTap,
                    onArticleLongPress: _onArticleLongPress,
                  ),
      ),
    );
  }
}
