import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoginFormWidget extends StatefulWidget {
  final Function(String username, String password) onLogin;
  final bool isLoading;

  const LoginFormWidget({
    Key? key,
    required this.onLogin,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  String? _usernameError;
  String? _passwordError;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    setState(() {
      _usernameError = null;
      _passwordError = null;
    });

    bool isValid = true;

    if (_usernameController.text.trim().isEmpty) {
      setState(() {
        _usernameError = 'يرجى إدخال اسم المستخدم';
      });
      isValid = false;
    }

    if (_passwordController.text.trim().isEmpty) {
      setState(() {
        _passwordError = 'يرجى إدخال كلمة المرور';
      });
      isValid = false;
    }

    if (isValid) {
      widget.onLogin(
          _usernameController.text.trim(), _passwordController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Username Field
              Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                            controller: _usernameController,
                            keyboardType: TextInputType.emailAddress,
                            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface),
                            decoration: InputDecoration(
                                hintText: 'اسم المستخدم',
                                hintStyle: AppTheme
                                    .lightTheme.inputDecorationTheme.hintStyle,
                                prefixIcon: Padding(
                                    padding: EdgeInsets.all(3.w),
                                    child: CustomIconWidget(
                                        iconName: 'person',
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary,
                                        size: 5.w)),
                                filled: true,
                                fillColor:
                                    AppTheme.lightTheme.colorScheme.surface,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.w),
                                    borderSide: BorderSide(
                                        color: _usernameError != null
                                            ? AppTheme
                                                .lightTheme.colorScheme.error
                                            : AppTheme
                                                .lightTheme.colorScheme.outline,
                                        width: 1.0)),
                                enabledBorder:
                                    OutlineInputBorder(borderRadius: BorderRadius.circular(2.w), borderSide: BorderSide(color: _usernameError != null ? AppTheme.lightTheme.colorScheme.error : AppTheme.lightTheme.colorScheme.outline, width: 1.0)),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(2.w), borderSide: BorderSide(color: _usernameError != null ? AppTheme.lightTheme.colorScheme.error : AppTheme.lightTheme.colorScheme.primary, width: 2.0)),
                                errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(2.w), borderSide: BorderSide(color: AppTheme.lightTheme.colorScheme.error, width: 1.0)),
                                focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(2.w), borderSide: BorderSide(color: AppTheme.lightTheme.colorScheme.error, width: 2.0)),
                                contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h))),
                        _usernameError != null
                            ? Padding(
                                padding: EdgeInsets.only(top: 1.h, right: 2.w),
                                child: Text(_usernameError!,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                            color: AppTheme
                                                .lightTheme.colorScheme.error),
                                    textDirection: TextDirection.rtl))
                            : const SizedBox.shrink(),
                      ])),

              // Password Field
              Container(
                  margin: EdgeInsets.only(bottom: 3.h),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface),
                            decoration: InputDecoration(
                                hintText: 'كلمة المرور',
                                hintStyle: AppTheme
                                    .lightTheme.inputDecorationTheme.hintStyle,
                                prefixIcon: Padding(
                                    padding: EdgeInsets.all(3.w),
                                    child: CustomIconWidget(
                                        iconName: 'lock',
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary,
                                        size: 5.w)),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.all(3.w),
                                        child: CustomIconWidget(
                                            iconName: _isPasswordVisible
                                                ? 'visibility'
                                                : 'visibility_off',
                                            color: AppTheme
                                                .lightTheme.colorScheme.primary,
                                            size: 5.w))),
                                filled: true,
                                fillColor:
                                    AppTheme.lightTheme.colorScheme.surface,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.w),
                                    borderSide: BorderSide(
                                        color: _passwordError != null
                                            ? AppTheme
                                                .lightTheme.colorScheme.error
                                            : AppTheme
                                                .lightTheme.colorScheme.outline,
                                        width: 1.0)),
                                enabledBorder:
                                    OutlineInputBorder(borderRadius: BorderRadius.circular(2.w), borderSide: BorderSide(color: _passwordError != null ? AppTheme.lightTheme.colorScheme.error : AppTheme.lightTheme.colorScheme.outline, width: 1.0)),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(2.w), borderSide: BorderSide(color: _passwordError != null ? AppTheme.lightTheme.colorScheme.error : AppTheme.lightTheme.colorScheme.primary, width: 2.0)),
                                errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(2.w), borderSide: BorderSide(color: AppTheme.lightTheme.colorScheme.error, width: 1.0)),
                                focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(2.w), borderSide: BorderSide(color: AppTheme.lightTheme.colorScheme.error, width: 2.0)),
                                contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h))),
                        _passwordError != null
                            ? Padding(
                                padding: EdgeInsets.only(top: 1.h, right: 2.w),
                                child: Text(_passwordError!,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                            color: AppTheme
                                                .lightTheme.colorScheme.error),
                                    textDirection: TextDirection.rtl))
                            : const SizedBox.shrink(),
                      ])),

              // Login Button
              SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                      onPressed: widget.isLoading ? null : _validateAndSubmit,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme
                              .lightTheme.colorScheme.secondaryContainer,
                          foregroundColor:
                              AppTheme.lightTheme.colorScheme.onPrimary,
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.w)),
                          padding: EdgeInsets.symmetric(vertical: 1.5.h)),
                      child: widget.isLoading
                          ? SizedBox(
                              width: 5.w,
                              height: 5.w,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme
                                      .lightTheme.colorScheme.onPrimary)))
                          : Text('تسجيل الدخول',
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.sp),
                              textDirection: TextDirection.rtl))),
            ]));
  }
}
