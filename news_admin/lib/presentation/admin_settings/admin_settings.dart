import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/app_export.dart';

class AdminSettings extends StatefulWidget {
  const AdminSettings({Key? key}) : super(key: key);

  @override
  State<AdminSettings> createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  final ImagePicker _imagePicker = ImagePicker();
  String? _appLogoUrl;
  bool _isLoading = false;

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

  Future<void> _saveAppLogo(String logoUrl) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_logo_url', logoUrl);
      setState(() {
        _appLogoUrl = logoUrl;
      });
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _pickImage() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        // For demonstration, we'll use a placeholder URL
        // In a real app, you'd upload the image to a server
        const newLogoUrl =
            'https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=400&h=400&fit=crop';

        await _saveAppLogo(newLogoUrl);

        Fluttertoast.showToast(
          msg: 'تم تحديث شعار التطبيق بنجاح',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          textColor: AppTheme.lightTheme.colorScheme.onPrimary,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'حدث خطأ أثناء تحديث الشعار',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        textColor: AppTheme.lightTheme.colorScheme.onError,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resetToDefault() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('app_logo_url');
      setState(() {
        _appLogoUrl = null;
      });

      Fluttertoast.showToast(
        msg: 'تم إعادة تعيين الشعار الافتراضي',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        textColor: AppTheme.lightTheme.colorScheme.onPrimary,
      );
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'إعدادات التطبيق',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إعدادات الشعار',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              _buildLogoSection(),
              SizedBox(height: 4.h),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'شعار التطبيق الحالي',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4.w),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
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
                      errorWidget: (context, url, error) => Center(
                        child: CustomIconWidget(
                          iconName: 'error',
                          color: AppTheme.lightTheme.colorScheme.error,
                          size: 8.w,
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'newspaper',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 12.w,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'أخبار',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _pickImage,
            icon: _isLoading
                ? SizedBox(
                    width: 5.w,
                    height: 5.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                    ),
                  )
                : CustomIconWidget(
                    iconName: 'image',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 5.w,
                  ),
            label: Text(
              _isLoading ? 'جاري التحديث...' : 'تغيير الشعار',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              padding: EdgeInsets.symmetric(vertical: 2.h),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _isLoading ? null : _resetToDefault,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.lightTheme.colorScheme.outline,
              size: 5.w,
            ),
            label: Text(
              'إعادة تعيين الشعار الافتراضي',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.outline,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppTheme.lightTheme.colorScheme.outline),
              padding: EdgeInsets.symmetric(vertical: 2.h),
            ),
          ),
        ),
      ],
    );
  }
}
