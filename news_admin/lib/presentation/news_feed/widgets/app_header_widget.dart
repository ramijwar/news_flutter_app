import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppHeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool isLoggedIn;
  final VoidCallback? onLogin;
  final VoidCallback? onLogout;
  final VoidCallback? onAdminAccess;

  const AppHeaderWidget({
    Key? key,
    this.isLoggedIn = false,
    this.onLogin,
    this.onLogout,
    this.onAdminAccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 2.0,
      shadowColor: AppTheme.lightTheme.shadowColor,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: CustomIconWidget(
              iconName: 'newspaper',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 6.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'أخبار اليوم',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
      actions: [
        if (isLoggedIn) ...[
          IconButton(
            onPressed: onAdminAccess,
            icon: CustomIconWidget(
              iconName: 'admin_panel_settings',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            tooltip: 'لوحة الإدارة',
          ),
          IconButton(
            onPressed: onLogout,
            icon: CustomIconWidget(
              iconName: 'logout',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            tooltip: 'تسجيل الخروج',
          ),
        ] else ...[
          IconButton(
            onPressed: onLogin,
            icon: CustomIconWidget(
              iconName: 'login',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            tooltip: 'تسجيل الدخول للإدارة',
          ),
        ],
        SizedBox(width: 2.w),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
