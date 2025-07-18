import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NewsArticleCardWidget extends StatelessWidget {
  final Map<String, dynamic> article;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onDuplicate;

  const NewsArticleCardWidget({
    super.key,
    required this.article,
    required this.onEdit,
    required this.onDelete,
    this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(article['id'].toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomIconWidget(
              iconName: 'edit',
              color: AppTheme.lightTheme.colorScheme.secondaryContainer,
              size: 6.w,
            ),
            SizedBox(width: 4.w),
            CustomIconWidget(
              iconName: 'delete',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 6.w,
            ),
            if (onDuplicate != null) ...[
              SizedBox(width: 4.w),
              CustomIconWidget(
                iconName: 'content_copy',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
            ],
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        return await _showActionDialog(context);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      article['title'] as String? ?? 'عنوان غير محدد',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          onEdit();
                          break;
                        case 'delete':
                          onDelete();
                          break;
                        case 'duplicate':
                          onDuplicate?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'edit',
                              color: AppTheme
                                  .lightTheme.colorScheme.secondaryContainer,
                              size: 5.w,
                            ),
                            SizedBox(width: 2.w),
                            Text('تعديل'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'delete',
                              color: AppTheme.lightTheme.colorScheme.error,
                              size: 5.w,
                            ),
                            SizedBox(width: 2.w),
                            Text('حذف'),
                          ],
                        ),
                      ),
                      if (onDuplicate != null)
                        PopupMenuItem(
                          value: 'duplicate',
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'content_copy',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 5.w,
                              ),
                              SizedBox(width: 2.w),
                              Text('نسخ'),
                            ],
                          ),
                        ),
                    ],
                    child: CustomIconWidget(
                      iconName: 'more_vert',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 6.w,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                article['content'] as String? ?? 'محتوى غير متوفر',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'schedule',
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.5),
                    size: 4.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    _formatDate(article['publishedAt']),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.5),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.secondaryContainer
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      article['status'] as String? ?? 'منشور',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color:
                            AppTheme.lightTheme.colorScheme.secondaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showActionDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'إجراءات المقال',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'اختر الإجراء المطلوب',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              onEdit();
            },
            child: Text('تعديل'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              onDelete();
            },
            child: Text(
              'حذف',
              style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('إلغاء'),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'تاريخ غير محدد';

    try {
      DateTime dateTime;
      if (date is String) {
        dateTime = DateTime.parse(date);
      } else if (date is DateTime) {
        dateTime = date;
      } else {
        return 'تاريخ غير صحيح';
      }

      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return 'تاريخ غير صحيح';
    }
  }
}
