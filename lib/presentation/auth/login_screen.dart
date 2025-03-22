import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:next_door/routes/pages.dart';
import 'package:next_door/theme/app_colors.dart';
import 'package:next_door/utils/custom_text_field.dart';
import 'package:next_door/utils/wave_clipper.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  late TextEditingController _emailController, _passwordController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _emailController.dispose();
    _passwordController.dispose();
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
                            "Log into",
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
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Remember Me"),
                              GestureDetector(
                                onTap: () => context.go(Pages.forgotPassword),
                                child: Text("Forgot Password?"),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Column(
                            children: [
                              Center(
                                child: Text("or log in with"),
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
                                  Text("Don't have an account?"),
                                  SizedBox(
                                    width: 1.w,
                                  ),
                                  GestureDetector(
                                    onTap: () => context.go(Pages.auth),
                                    child: Text(
                                      "Sign Up",
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
