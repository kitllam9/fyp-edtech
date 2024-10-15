import 'package:flutter/material.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/widgets/buttons.dart';
import 'package:fyp_edtech/widgets/text_form_field.dart';
import 'package:material_symbols_icons/symbols.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _confirmPwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Icon(
            Symbols.close,
            color: AppColors.primary,
            size: 24,
          ),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Icon(
              Symbols.login,
              color: AppColors.primary,
              size: 40,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign In To Continue',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            TabBar(
              dividerColor: Colors.transparent,
              isScrollable: false,
              tabAlignment: TabAlignment.fill,
              labelColor: AppColors.primary,
              indicatorColor: AppColors.primary,
              unselectedLabelColor: AppColors.unselected,
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.symmetric(horizontal: 5),
              tabs: [
                Tab(
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Tab(
                  child: Text(
                    'Register',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              'Username',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          MainTextFormField(
                            controller: _usernameController,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              'Password',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          MainTextFormField(
                            controller: _pwdController,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GenericButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Forget Password?',
                                  style: TextStyle(
                                    color: AppColors.text,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconTextButton(
                                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false),
                                backgroundColor: AppColors.primary,
                                width: Globals.screenWidth! * 0.55,
                                height: 40,
                                text: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: AppColors.secondary,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              'Username',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          MainTextFormField(
                            controller: _usernameController,
                            validator: (value) {
                              if (value == null || value.length < 6 || value.length > 12) {
                                return 'Username must consist of 6-12 characters.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              'Password',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          MainTextFormField(
                            controller: _pwdController,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              'Confirm Password',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          MainTextFormField(
                            controller: _confirmPwdController,
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconTextButton(
                                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false),
                                backgroundColor: AppColors.primary,
                                width: Globals.screenWidth! * 0.55,
                                height: 40,
                                text: Text(
                                  'Register',
                                  style: TextStyle(
                                    color: AppColors.secondary,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
