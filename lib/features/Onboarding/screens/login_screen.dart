import 'package:flutter/material.dart';
import 'package:shortly_customer/core/app_imports.dart';
import 'package:shortly_customer/core/utils/screen_utils.dart';
import 'package:shortly_customer/route/app_pages.dart';
import 'package:shortly_customer/route/custom_navigator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    phoneController.addListener(_validatePhone);
  }

  void _validatePhone() {
    final phone = phoneController.text.trim();
    final valid = RegExp(r'^[0-9]{10}$').hasMatch(phone);
    if (valid != isValid) {
      setState(() {
        isValid = valid;
      });
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomSpacers.height70,
              Image.asset(
                AppIcons.app_logo,
                height: 100.h,
              ),
              CustomSpacers.height36,

              const Text(
                'Shortly',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              CustomSpacers.height8,
              const Text('Get the best home services',
                  style: TextStyle(fontSize: 16)),
              CustomSpacers.height4,
              const Text('Quick • Affordable • Trusted',
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
              CustomSpacers.height30,

              // Phone Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Semantics(
                    label: 'Mobile number input field',
                    textField: true,
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: 'Enter your mobile number',
                        border: InputBorder.none,
                      ),
                      maxLength: 10,
                      buildCounter: (_, {required currentLength, maxLength, required isFocused}) => null,
                    ),
                  ),
                ),
              ),
              CustomSpacers.height30,

              // Verify Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SizedBox(
                  width: 300.w,
                  child: Semantics(
                    label: 'Get Verification Code button',
                    button: true,
                    child: ElevatedButton(
                      onPressed: isValid
                          ? () {
                              CustomNavigator.pushReplace(
                                context,
                                AppPages.otpverification,
                                arguments: {
                                  "phoneNumber": phoneController.text,
                                },
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5D3FD3),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Get Verification Code',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
