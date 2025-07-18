import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './image_picker_widget.dart';

class ArticleFormWidget extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;
  final DateTime? selectedDate;
  final VoidCallback onDateTap;
  final String? titleError;
  final String? contentError;
  final bool isLoading;
  final List<String> imageUrls;
  final Function(List<String>) onImagesChanged;

  const ArticleFormWidget({
    Key? key,
    required this.titleController,
    required this.contentController,
    required this.selectedDate,
    required this.onDateTap,
    this.titleError,
    this.contentError,
    required this.isLoading,
    required this.imageUrls,
    required this.onImagesChanged,
  }) : super(key: key);

  @override
  State<ArticleFormWidget> createState() => _ArticleFormWidgetState();
}

class _ArticleFormWidgetState extends State<ArticleFormWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleField(),
          SizedBox(height: 3.h),
          _buildContentField(),
          SizedBox(height: 3.h),
          ImagePickerWidget(
            imageUrls: widget.imageUrls,
            onImagesChanged: widget.onImagesChanged,
            isEnabled: !widget.isLoading,
          ),
          SizedBox(height: 3.h),
          _buildDatePicker(),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'عنوان الخبر',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: widget.titleController,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          enabled: !widget.isLoading,
          maxLength: 100,
          decoration: InputDecoration(
            hintText: 'أدخل عنوان الخبر...',
            hintTextDirection: TextDirection.rtl,
            counterText: '${widget.titleController.text.length}/100',
            counterStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            errorText: widget.titleError,
            errorStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.error,
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'title',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
            ),
          ),
          onChanged: (value) {
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget _buildContentField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'محتوى الخبر',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: widget.contentController,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          enabled: !widget.isLoading,
          maxLines: 8,
          minLines: 6,
          decoration: InputDecoration(
            hintText: 'اكتب محتوى الخبر هنا...',
            hintTextDirection: TextDirection.rtl,
            errorText: widget.contentError,
            errorStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.error,
            ),
            alignLabelWithHint: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.h,
            ),
          ),
          onChanged: (value) {
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تاريخ النشر',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        InkWell(
          onTap: widget.isLoading ? null : widget.onDateTap,
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
              color: AppTheme.lightTheme.colorScheme.surface,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomIconWidget(
                  iconName: 'calendar_today',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
                Expanded(
                  child: Text(
                    widget.selectedDate != null
                        ? '${widget.selectedDate!.day.toString().padLeft(2, '0')}/${widget.selectedDate!.month.toString().padLeft(2, '0')}/${widget.selectedDate!.year}'
                        : 'اختر تاريخ النشر',
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: widget.selectedDate != null
                          ? AppTheme.lightTheme.colorScheme.onSurface
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
