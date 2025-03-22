import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:next_door/routes/pages.dart';
import 'package:next_door/theme/app_colors.dart';
import 'package:next_door/utils/custom_text_field.dart';
import 'package:next_door/utils/email_validator.dart';
import 'package:next_door/utils/password_validator.dart';
import 'package:next_door/utils/wave_clipper.dart';
import 'package:sizer/sizer.dart';
import 'package:email_validator/email_validator.dart';
import 'package:validators/validators.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  late TextEditingController _nameController,
      _emailController,
      _passwordController,
      _confirmPasswordController;

  String? _name, _email, _password;
  bool _obscureText = true;
  bool _obscureTextConfirmPassword = true;
  bool _loadWithProgress = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
      final form = _formKey.currentState;

      if (form == null || !form.validate()) return;

      form.save();

      _loadWithProgress = !_loadWithProgress;
      log("name: $_name, email: $_email, password: $_password");
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // Background Image (Covers Halfway)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: MediaQuery.of(context).size.height *
                      0.5, // 40% of screen height

                  color: AppColors.background,
                ),
              ),
            ),

            // Login Form (Foreground)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 39,
                        spreadRadius: 9,
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: _autovalidateMode,
                    child: SizedBox(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Text(
                            "Create",
                            style: TextStyle(
                                fontSize: 22.sp, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "your account",
                            style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.background),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          CustomTextField(
                            textInputType: TextInputType.text,
                            textEditingController: _nameController,
                            labelText: 'Enter your name',
                            validator: (String? value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Name is required";
                              }
                              if (value.trim().length < 2) {
                                return "Name must be at least 2 characters";
                              }
                              return null;
                            },
                            onSaved: (String? value) {
                              _name = value;
                            },
                          ),
                          SizedBox(height: 2.h),
                          CustomTextField(
                            textInputType: TextInputType.text,
                            textEditingController: _emailController,
                            labelText: 'Email address',
                            validator: (value) {
                              return emailValidator(value);
                            },
                            onSaved: (String? value) {
                              setState(() {
                                _email = value;
                              });
                            },
                          ),
                          SizedBox(height: 2.h),
                          CustomTextField(
                            textInputType: TextInputType.text,
                            textEditingController: _passwordController,
                            labelText: 'Password',
                            obscureText: _obscureText,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? FontAwesomeIcons.eyeSlash
                                    : FontAwesomeIcons.eye,
                                size: 17.sp,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText =
                                      !_obscureText; // Toggle visibility
                                });
                              },
                            ),
                            validator: (value) {
                              return passwordValidator(value);
                            },
                            onSaved: (value) {
                              setState(() {
                                _password = value;
                              });
                            },
                          ),
                          SizedBox(height: 2.h),
                          CustomTextField(
                            labelText: "Confirm Password",
                            textInputType: TextInputType.visiblePassword,
                            textEditingController: _confirmPasswordController,
                            obscureText: _obscureTextConfirmPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureTextConfirmPassword
                                    ? FontAwesomeIcons.eyeSlash
                                    : FontAwesomeIcons.eye,
                                size: 17.sp,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureTextConfirmPassword =
                                      !_obscureTextConfirmPassword; // Toggle visibility
                                });
                              },
                            ),
                            validator: (value) {
                              return confirmPasswordValidator(
                                  value, _passwordController.text);
                            },
                          ),
                          SizedBox(height: 2.h),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.background,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Column(
                            children: [
                              Center(
                                child: Text("or sign up with"),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: AppColors.grey,
                                    radius: 3.h,
                                    child: CircleAvatar(
                                      radius: 3.h - 1,
                                      backgroundColor: AppColors.white,
                                      child: Center(
                                        child: SvgPicture.asset(
                                          "assets/images/Apple.svg",
                                          width: 36, // Adjust size as needed
                                          height: 36,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width: 16), // Add spacing between icons
                                  CircleAvatar(
                                    radius: 3.h,
                                    backgroundColor: AppColors.grey,
                                    child: CircleAvatar(
                                      radius: 3.h - 1,
                                      backgroundColor: AppColors.white,
                                      child: SvgPicture.asset(
                                        "assets/images/google_icon.svg",
                                        width: 36, // Adjust size as needed
                                        height: 36,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Already have an account?"),
                                  SizedBox(
                                    width: 1.w,
                                  ),
                                  GestureDetector(
                                    onTap: () => context.go(Pages.login),
                                    child: Text(
                                      "Log in",
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
