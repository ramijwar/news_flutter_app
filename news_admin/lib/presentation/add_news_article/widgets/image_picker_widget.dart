import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/app_export.dart';

class ImagePickerWidget extends StatefulWidget {
  final List<String> imageUrls;
  final Function(List<String>) onImagesChanged;
  final bool isEnabled;

  const ImagePickerWidget({
    Key? key,
    required this.imageUrls,
    required this.onImagesChanged,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _imagePicker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    if (!widget.isEnabled) return;

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
        // For demonstration, we'll use placeholder URLs
        // In a real app, you'd upload the image to a server
        final List<String> placeholderUrls = [
          'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=800&h=600&fit=crop',
          'https://images.pexels.com/photos/518543/pexels-photo-518543.jpeg?w=800&h=600&fit=crop',
          'https://images.pixabay.com/photo/2016/02/01/00/56/news-1172463_960_720.jpg',
          'https://images.unsplash.com/photo-1585776245991-cf89dd7fc73a?w=800&h=600&fit=crop',
          'https://images.pexels.com/photos/1000445/pexels-photo-1000445.jpeg?w=800&h=600&fit=crop',
        ];

        final newImageUrl =
            placeholderUrls[widget.imageUrls.length % placeholderUrls.length];
        final updatedImages = [...widget.imageUrls, newImageUrl];
        widget.onImagesChanged(updatedImages);
      }
    } catch (e) {
      // Handle error silently
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickMultipleImages() async {
    if (!widget.isEnabled) return;

    try {
      setState(() {
        _isLoading = true;
      });

      final List<XFile> images = await _imagePicker.pickMultiImage(
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (images.isNotEmpty) {
        // For demonstration, we'll use placeholder URLs
        final List<String> placeholderUrls = [
          'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=800&h=600&fit=crop',
          'https://images.pexels.com/photos/518543/pexels-photo-518543.jpeg?w=800&h=600&fit=crop',
          'https://images.pixabay.com/photo/2016/02/01/00/56/news-1172463_960_720.jpg',
          'https://images.unsplash.com/photo-1585776245991-cf89dd7fc73a?w=800&h=600&fit=crop',
          'https://images.pexels.com/photos/1000445/pexels-photo-1000445.jpeg?w=800&h=600&fit=crop',
        ];

        final List<String> newImageUrls = [];
        for (int i = 0; i < images.length && i < 5; i++) {
          newImageUrls.add(placeholderUrls[i]);
        }

        final updatedImages = [...widget.imageUrls, ...newImageUrls];
        widget.onImagesChanged(updatedImages);
      }
    } catch (e) {
      // Handle error silently
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _removeImage(int index) {
    final updatedImages = [...widget.imageUrls];
    updatedImages.removeAt(index);
    widget.onImagesChanged(updatedImages);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'صور الخبر',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        _buildImageGrid(),
        SizedBox(height: 2.h),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildImageGrid() {
    if (widget.imageUrls.isEmpty) {
      return Container(
        width: double.infinity,
        height: 20.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'image',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 10.w,
              ),
              SizedBox(height: 1.h),
              Text(
                'لا توجد صور للخبر',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 2.w,
        mainAxisSpacing: 2.w,
        childAspectRatio: 1.2,
      ),
      itemCount: widget.imageUrls.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow
                        .withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrls[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: (context, url) => Container(
                    color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'error',
                        color: AppTheme.lightTheme.colorScheme.error,
                        size: 8.w,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (widget.isEnabled)
              Positioned(
                top: 1.w,
                left: 1.w,
                child: GestureDetector(
                  onTap: () => _removeImage(index),
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onError,
                      size: 4.w,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: (widget.isEnabled && !_isLoading) ? _pickImage : null,
            icon: _isLoading
                ? SizedBox(
                    width: 4.w,
                    height: 4.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  )
                : CustomIconWidget(
                    iconName: 'add_photo_alternate',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
            label: Text(
              'إضافة صورة',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppTheme.lightTheme.colorScheme.primary),
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
            ),
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: ElevatedButton.icon(
            onPressed:
                (widget.isEnabled && !_isLoading) ? _pickMultipleImages : null,
            icon: CustomIconWidget(
              iconName: 'photo_library',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 5.w,
            ),
            label: Text(
              'صور متعددة',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
            ),
          ),
        ),
      ],
    );
  }
}
