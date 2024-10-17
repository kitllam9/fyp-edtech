import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/widgets/buttons.dart';
import 'package:fyp_edtech/widgets/text_form_field.dart';
import 'package:material_symbols_icons/symbols.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Icon(
            Symbols.arrow_back_ios_new,
            color: AppColors.primary,
            size: 24,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 30),
        child: IconTextButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) {
              return;
            }
            Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
          },
          backgroundColor: AppColors.primary,
          width: Globals.screenWidth! * 0.55,
          height: 40,
          text: Text(
            'Continue',
            style: TextStyle(
              color: AppColors.secondary,
              fontSize: 16,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Text(
                'Forgot Your Password?',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'No worries. Enter your email and we\'ll help you reset your password.',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              MainTextFormField(
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty || !EmailValidator.validate(value)) {
                    return 'Invalid email address.';
                  }
                  return null;
                },
                hintText: 'Email',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
