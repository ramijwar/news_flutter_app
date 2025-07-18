import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SaveButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;

  const SaveButtonWidget({
    Key? key,
    required this.onPressed,
    required this.isLoading,
    required this.isEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? AppTheme.secondaryVariantLight
              : AppTheme.textDisabledLight,
          foregroundColor: AppTheme.onPrimaryLight,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: isEnabled ? 2.0 : 0.0,
        ),
        child: isLoading
            ? SizedBox(
                height: 5.w,
                width: 5.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.onPrimaryLight,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'save',
                    color: AppTheme.onPrimaryLight,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'حفظ المقال',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.onPrimaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
