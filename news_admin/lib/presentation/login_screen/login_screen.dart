import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_logo_widget.dart';
import './widgets/login_form_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  // Mock credentials
  final String _validUsername = 'ramijwar';
  final String _validPassword = 'jwar20062006';

  @override
  void initState() {
    super.initState();
    _checkExistingSession();
  }

  Future<void> _checkExistingSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (isLoggedIn && mounted) {
        Navigator.pushReplacementNamed(context, '/admin-dashboard');
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _handleLogin(String username, String password) async {
    setState(() {
      _isLoading = true;
    });

    // Add haptic feedback
    HapticFeedback.lightImpact();

    // Simulate authentication delay
    await Future.delayed(const Duration(milliseconds: 1500));

    if (username == _validUsername && password == _validPassword) {
      try {
        // Store session
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('username', username);
        await prefs.setString('loginTime', DateTime.now().toIso8601String());

        // Success haptic feedback
        HapticFeedback.mediumImpact();

        if (mounted) {
          // Navigate to admin dashboard
          Navigator.pushReplacementNamed(context, '/admin-dashboard');
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showErrorMessage('حدث خطأ في حفظ جلسة العمل');
      }
    } else {
      setState(() {
        _isLoading = false;
      });

      // Error haptic feedback
      HapticFeedback.heavyImpact();

      _showErrorMessage('اسم المستخدم أو كلمة المرور غير صحيحة');
    }
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onError,
            ),
            textDirection: TextDirection.rtl,
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.w),
          ),
          margin: EdgeInsets.all(4.w),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _navigateToNewsFeed() {
    Navigator.pushReplacementNamed(context, '/news-feed');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          elevation: 0,
          leading: IconButton(
            onPressed: _navigateToNewsFeed,
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
          title: Text(
            'تسجيل دخول المشرف',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textDirection: TextDirection.rtl,
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    kToolbarHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Top spacing
                      SizedBox(height: 4.h),

                      // App Logo
                      const AppLogoWidget(),

                      SizedBox(height: 3.h),

                      // Admin login description
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppTheme
                              .lightTheme.colorScheme.primaryContainer
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(2.w),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            CustomIconWidget(
                              iconName: 'admin_panel_settings',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 8.w,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'تسجيل الدخول مخصص للمشرفين فقط',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'يمكن لجميع الزوار مطالعة الأخبار بدون تسجيل الدخول',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Login Form
                      Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          maxWidth: 90.w,
                        ),
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(3.w),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.lightTheme.colorScheme.shadow,
                              blurRadius: 12.0,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: LoginFormWidget(
                          onLogin: _handleLogin,
                          isLoading: _isLoading,
                        ),
                      ),

                      // Bottom spacing
                      SizedBox(height: 6.h),

                      // Footer text
                      Text(
                        'تطبيق إدارة الأخبار © 2025',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          fontSize: 12.sp,
                        ),
                        textDirection: TextDirection.rtl,
                      ),

                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
