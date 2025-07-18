import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppLogoWidget extends StatefulWidget {
  const AppLogoWidget({Key? key}) : super(key: key);

  @override
  State<AppLogoWidget> createState() => _AppLogoWidgetState();
}

class _AppLogoWidgetState extends State<AppLogoWidget> {
  String? _appLogoUrl;

  @override
  void initState() {
    super.initState();
    _loadAppLogo();
  }

  Future<void> _loadAppLogo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final logoUrl = prefs.getString('app_logo_url');
      setState(() {
        _appLogoUrl = logoUrl;
      });
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      child: Column(
        children: [
          // App Logo Container
          Container(
            width: 25.w,
            height: 25.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(4.w),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow,
                  blurRadius: 8.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _appLogoUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(4.w),
                    child: CachedNetworkImage(
                      imageUrl: _appLogoUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                      errorWidget: (context, url, error) => _buildDefaultLogo(),
                    ),
                  )
                : _buildDefaultLogo(),
          ),

          SizedBox(height: 2.h),

          // App Title
          Text(
            'إدارة الأخبار',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 20.sp,
            ),
            textDirection: TextDirection.rtl,
          ),

          SizedBox(height: 1.h),

          // App Subtitle
          Text(
            'لوحة التحكم الإدارية',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontSize: 14.sp,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultLogo() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'newspaper',
            color: AppTheme.lightTheme.colorScheme.secondaryContainer,
            size: 10.w,
          ),
          SizedBox(height: 1.h),
          Text(
            'أخبار',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.secondaryContainer,
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}
