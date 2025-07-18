import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBackPressed;
  final VoidCallback? onCancelPressed;
  final bool isLoading;

  const AppBarWidget({
    Key? key,
    required this.onBackPressed,
    this.onCancelPressed,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.surfaceLight,
      elevation: 2.0,
      shadowColor: AppTheme.shadowLight,
      leading: IconButton(
        onPressed: isLoading ? null : onBackPressed,
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: isLoading
              ? AppTheme.textDisabledLight
              : AppTheme.textPrimaryLight,
          size: 6.w,
        ),
      ),
      title: Text(
        'إضافة مقال جديد',
        textDirection: TextDirection.rtl,
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          color: AppTheme.textPrimaryLight,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        if (onCancelPressed != null)
          TextButton(
            onPressed: isLoading ? null : onCancelPressed,
            child: Text(
              'إلغاء',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: isLoading
                    ? AppTheme.textDisabledLight
                    : AppTheme.textAccentLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        SizedBox(width: 2.w),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
