import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_pos/theme/theme.dart';

import '../view_models/login_view_model.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  // late LogInController controller;
  LoginViewModel model = LoginViewModel();
  late OutlineInputBorder outlineInputBorder;
  late FocusNode _userNameFocus;
  final _formKey = GlobalKey<FormState>();
  String error = "";
  String userName = "deerstaff";
  String password = "123456";
  bool _passwordVisible = false;
  final _formUserNameFieldController = TextEditingController();
  final _formPasswordFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userNameFocus = FocusNode();
    _passwordVisible = false;

    outlineInputBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        return Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Smart POS',
                          style: POSTextTheme.titleL,
                        ),
                        const SizedBox(height: 32),

                        //LOGIN FORM
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // USERNAME FORM FIELD
                              TextFormField(
                                controller: _formUserNameFieldController,
                                style: POSTextTheme.bodyM,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(" "),
                                ],
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Tên đăng nhập không được để trống";
                                  } else if (value.length > 50) {
                                    return "Độ dài tối đa 50 kí tự";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value) => {
                                  setState(
                                    () => userName = value,
                                  )
                                },
                                decoration: InputDecoration(
                                    hintText: "Tên đăng nhập",
                                    hintStyle: POSTextTheme.bodyM,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    filled: true,
                                    isDense: true,
                                    labelStyle: POSTextTheme.labelL,
                                    fillColor: ThemeColor.backgroundColor,
                                    prefixIcon: const Icon(
                                      Icons.portrait_rounded,
                                      color: ThemeColor.onBackgroundColor,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        _formUserNameFieldController.text = "";
                                      },
                                      icon: const Icon(Icons.clear),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                            color: ThemeColor.primaryColor,
                                            width: 2.0)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                            color: ThemeColor.primaryColor,
                                            width: 2.0)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                            color: ThemeColor.primaryColor,
                                            width: 2.0)),
                                    contentPadding: const EdgeInsets.all(16),
                                    isCollapsed: true,
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                            color: ThemeColor.errorColor,
                                            width: 2.0))),
                                maxLines: 1,
                                focusNode: _userNameFocus,
                              ),

                              const SizedBox(height: 16),

                              //PASSWORD FORM FIELD
                              TextFormField(
                                controller: _formPasswordFieldController,
                                obscureText: !_passwordVisible,
                                obscuringCharacter: "*",
                                style: POSTextTheme.bodyM,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Mật khẩu không được để trống";
                                  } else if (value.length > 50) {
                                    return "Mật khẩu không quá 50 kí tự";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: ((value) => setState(() {
                                      password = value;
                                    })),
                                decoration: InputDecoration(
                                    hintText: "Mật khẩu",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    filled: true,
                                    isDense: true,
                                    fillColor: ThemeColor.backgroundColor,
                                    prefixIcon: const Icon(
                                      Icons.key,
                                      color: ThemeColor.onBackgroundColor,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        // Based on passwordVisible state choose the icon
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        // Update the state i.e. toogle the state of passwordVisible variable
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    )
                                    // IconButton(
                                    //   onPressed:
                                    //       _formPasswordFieldController.clear,
                                    //   icon: Icon(Icons.clear),
                                    // )
                                    ,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                            color: ThemeColor.primaryColor,
                                            width: 2.0)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                            color: ThemeColor.primaryColor,
                                            width: 2.0)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                            color: ThemeColor.primaryColor,
                                            width: 2.0)),
                                    contentPadding: const EdgeInsets.all(16),
                                    hintStyle: POSTextTheme.bodyM,
                                    isCollapsed: true,
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                            color: ThemeColor.errorColor,
                                            width: 2.0))),
                                maxLines: 1,
                                cursorColor: ThemeColor.onBackgroundColor,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 48,
                          child: FilledButton.tonal(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                model.posLogin(userName, password);
                              }
                            },
                            child: const Text("Đăng nhập",
                                style: POSTextTheme.bodyL),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Image.asset(
                    "assets/images/cash-register.png",
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
