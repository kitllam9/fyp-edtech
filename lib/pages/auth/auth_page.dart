import 'package:email_validator/email_validator.dart';
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

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _confirmPwdController = TextEditingController();

  List<bool> obsurePwd = [true, true, true];

  late final TabController _tabController = TabController(length: 2, vsync: this);

  @override
  void initState() {
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _usernameController.clear();
        _pwdController.clear();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
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
            controller: _tabController,
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
              controller: _tabController,
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
                          obsureText: obsurePwd[2],
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                obsurePwd[2] = !obsurePwd[2];
                              });
                            },
                            style: IconButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.only(right: 12),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              overlayColor: Colors.transparent,
                            ),
                            icon: Icon(
                              obsurePwd[2] ? Symbols.visibility : Symbols.visibility_off,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GenericButton(
                          onPressed: () => Navigator.of(context).pushNamed('/forget-password'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Forgot Password?',
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
                            'Email',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        MainTextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || !EmailValidator.validate(value)) {
                              return 'Invalid email address.';
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
                          obsureText: obsurePwd[0],
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                obsurePwd[0] = !obsurePwd[0];
                              });
                            },
                            style: IconButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.only(right: 12),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              overlayColor: Colors.transparent,
                            ),
                            icon: Icon(
                              obsurePwd[0] ? Symbols.visibility : Symbols.visibility_off,
                            ),
                          ),
                          onChanged: (value) => setState(() {
                            // validate
                          }),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          '• At least 8 characters',
                          style: TextStyle(
                            color: _pwdController.text.length >= 8 ? AppColors.success : AppColors.unselected,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '• Contains both uppercase and lowercase letters',
                          style: TextStyle(
                            color: RegExp(r'(?=.*[a-z])(?=.*[A-Z])').hasMatch(_pwdController.text)
                                ? AppColors.success
                                : AppColors.unselected,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '• Contains 1 number',
                          style: TextStyle(
                            color: RegExp(r'(?=.*\d)').hasMatch(_pwdController.text)
                                ? AppColors.success
                                : AppColors.unselected,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
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
                          validator: (value) {
                            if (value == null || value != _pwdController.text) {
                              return 'The confirm password does not match.';
                            }
                            return null;
                          },
                          obsureText: obsurePwd[1],
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                obsurePwd[1] = !obsurePwd[1];
                              });
                            },
                            style: IconButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.only(right: 12),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              overlayColor: Colors.transparent,
                            ),
                            icon: Icon(
                              obsurePwd[1] ? Symbols.visibility : Symbols.visibility_off,
                            ),
                          ),
                          onChanged: (value) => setState(() {
                            // validate
                          }),
                        ),
                        SizedBox(
                          height: 36,
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
    );
  }
}
