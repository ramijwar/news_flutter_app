import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './news_card_widget.dart';

class NewsListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> articles;
  final VoidCallback? onRefresh;
  final Function(Map<String, dynamic>)? onArticleTap;
  final Function(Map<String, dynamic>)? onArticleLongPress;

  const NewsListWidget({
    Key? key,
    required this.articles,
    this.onRefresh,
    this.onArticleTap,
    this.onArticleLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (articles.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        onRefresh?.call();
      },
      color: AppTheme.lightTheme.colorScheme.primary,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return NewsCardWidget(
            article: article,
            onTap: () => onArticleTap?.call(article),
            onLongPress: () => onArticleLongPress?.call(article),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'article',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 15.w,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'لا توجد أخبار متاحة',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: 2.h),
          Text(
            'اسحب للأسفل لتحديث الأخبار',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}
