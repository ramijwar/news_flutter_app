import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/app_bar_widget.dart';
import './widgets/article_form_widget.dart';
import './widgets/save_button_widget.dart';

class AddNewsArticle extends StatefulWidget {
  const AddNewsArticle({Key? key}) : super(key: key);

  @override
  State<AddNewsArticle> createState() => _AddNewsArticleState();
}

class _AddNewsArticleState extends State<AddNewsArticle> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  DateTime? _selectedDate;
  String? _titleError;
  String? _contentError;
  bool _isLoading = false;
  Timer? _autoSaveTimer;
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _startAutoSave();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _autoSaveTimer?.cancel();
    super.dispose();
  }

  void _startAutoSave() {
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_titleController.text.isNotEmpty ||
          _contentController.text.isNotEmpty) {
        _saveDraft();
      }
    });
  }

  Future<void> _saveDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftData = {
        'title': _titleController.text,
        'content': _contentController.text,
        'date': _selectedDate?.toIso8601String(),
        'timestamp': DateTime.now().toIso8601String(),
        'imageUrls': _imageUrls,
      };
      await prefs.setString('news_draft', json.encode(draftData));
    } catch (e) {
      // Silent fail for draft save
    }
  }

  Future<void> _loadDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftString = prefs.getString('news_draft');
      if (draftString != null) {
        final draftData = json.decode(draftString) as Map<String, dynamic>;
        setState(() {
          _titleController.text = draftData['title'] ?? '';
          _contentController.text = draftData['content'] ?? '';
          if (draftData['date'] != null) {
            _selectedDate = DateTime.parse(draftData['date']);
          }
          _imageUrls = List<String>.from(draftData['imageUrls'] ?? []);
        });
      }
    } catch (e) {
      // Silent fail for draft load
    }
  }

  Future<void> _clearDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('news_draft');
    } catch (e) {
      // Silent fail for draft clear
    }
  }

  bool _validateForm() {
    setState(() {
      _titleError = null;
      _contentError = null;
    });

    bool isValid = true;

    if (_titleController.text.trim().isEmpty) {
      setState(() {
        _titleError = 'عنوان الخبر مطلوب';
      });
      isValid = false;
    } else if (_titleController.text.trim().length < 5) {
      setState(() {
        _titleError = 'عنوان الخبر يجب أن يكون 5 أحرف على الأقل';
      });
      isValid = false;
    }

    if (_contentController.text.trim().isEmpty) {
      setState(() {
        _contentError = 'محتوى الخبر مطلوب';
      });
      isValid = false;
    } else if (_contentController.text.trim().length < 20) {
      setState(() {
        _contentError = 'محتوى الخبر يجب أن يكون 20 حرف على الأقل';
      });
      isValid = false;
    }

    return isValid;
  }

  Future<void> _saveArticle() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();

      // Get existing articles
      final existingArticlesString = prefs.getString('news_articles') ?? '[]';
      final existingArticles =
          json.decode(existingArticlesString) as List<dynamic>;

      // Create new article
      final newArticle = {
        'id': DateTime.now().millisecondsSinceEpoch,
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim(),
        'publishDate': _selectedDate?.toIso8601String() ??
            DateTime.now().toIso8601String(),
        'createdAt': DateTime.now().toIso8601String(),
        'author': 'ramijwar',
        'isPublished': true,
        'imageUrls': _imageUrls,
      };

      // Add to articles list
      existingArticles.insert(0, newArticle);

      // Save updated articles
      await prefs.setString('news_articles', json.encode(existingArticles));

      // Clear draft
      await _clearDraft();

      // Show success message
      Fluttertoast.showToast(
        msg: 'تم حفظ الخبر بنجاح',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        textColor: AppTheme.lightTheme.colorScheme.onPrimary,
        fontSize: 14.sp,
      );

      // Navigate back to admin dashboard
      Navigator.pushReplacementNamed(context, '/admin-dashboard');
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'حدث خطأ أثناء حفظ الخبر',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        textColor: AppTheme.lightTheme.colorScheme.onError,
        fontSize: 14.sp,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('ar', 'SA'),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Theme(
            data: Theme.of(context).copyWith(
              datePickerTheme: DatePickerThemeData(
                backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                headerBackgroundColor: AppTheme.lightTheme.colorScheme.primary,
                headerForegroundColor:
                    AppTheme.lightTheme.colorScheme.onPrimary,
                dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppTheme.lightTheme.colorScheme.onPrimary;
                  }
                  return AppTheme.lightTheme.colorScheme.onSurface;
                }),
                dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppTheme.lightTheme.colorScheme.primary;
                  }
                  return Colors.transparent;
                }),
                todayForegroundColor: WidgetStateProperty.all(
                    AppTheme.lightTheme.colorScheme.secondary),
                todayBackgroundColor:
                    WidgetStateProperty.all(Colors.transparent),
                todayBorder: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.secondary, width: 1),
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showCancelDialog() {
    if (_titleController.text.trim().isEmpty &&
        _contentController.text.trim().isEmpty) {
      Navigator.pop(context);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            title: Text(
              'تأكيد الإلغاء',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text(
              'هل أنت متأكد من إلغاء إضافة الخبر؟ سيتم فقدان جميع التغييرات غير المحفوظة.',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'متابعة التحرير',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onError,
                ),
                child: Text(
                  'إلغاء',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onError,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool get _isFormValid {
    return _titleController.text.trim().length >= 5 &&
        _contentController.text.trim().length >= 20 &&
        _selectedDate != null;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBarWidget(
          onBackPressed: _showCancelDialog,
          onCancelPressed: _showCancelDialog,
          isLoading: _isLoading,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ArticleFormWidget(
                  titleController: _titleController,
                  contentController: _contentController,
                  selectedDate: _selectedDate,
                  onDateTap: _selectDate,
                  titleError: _titleError,
                  contentError: _contentError,
                  isLoading: _isLoading,
                  imageUrls: _imageUrls,
                  onImagesChanged: (images) {
                    setState(() {
                      _imageUrls = images;
                    });
                  },
                ),
              ),
              SaveButtonWidget(
                onPressed: _saveArticle,
                isLoading: _isLoading,
                isEnabled: _isFormValid,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
