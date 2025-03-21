import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:next_door/routes/pages.dart';
import 'package:next_door/theme/app_colors.dart';
import 'package:next_door/utils/custom_text_field.dart';
import 'package:next_door/utils/wave_clipper.dart';
import 'package:sizer/sizer.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  late TextEditingController _nameController,
      _emailController,
      _passwordController,
      _confirmPasswordController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                          ),
                          SizedBox(height: 2.h),
                          CustomTextField(
                            textInputType: TextInputType.text,
                            textEditingController: _emailController,
                            labelText: 'Email address',
                          ),
                          SizedBox(height: 2.h),
                          CustomTextField(
                            textInputType: TextInputType.text,
                            textEditingController: _passwordController,
                            labelText: 'Password',
                          ),
                          SizedBox(height: 2.h),
                          CustomTextField(
                            textInputType: TextInputType.text,
                            textEditingController: _confirmPasswordController,
                            labelText: 'Confirm password',
                          ),
                          SizedBox(height: 2.h),
                          ElevatedButton(
                            onPressed: () {},
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
