// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_registration/constant/constant.dart';
import 'package:form_registration/view/dashboard.dart';
import 'package:form_registration/database/database.helper.dart';
import 'package:form_registration/model/registration_model.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends HookWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  List<Registrationform> registerList;
  LoginScreen({super.key, required this.registerList});
  final dbHelper = DatabaseHelper.instance;

  bool validateCredentials(
      String email, String password, List<Registrationform> userDataList) {
    // Loop through the user data list and check if there's a match
    for (var userData in userDataList) {
      if (userData.email == email && userData.pwd == password) {
        return true; // Match found
      }
    }
    return false; // No match found
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0.sp),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(
                height: 50.h,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    maximumSize: MaterialStatePropertyAll(Size.infinite),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                onPressed: () async {
                  // final box = await Hive.openBox('userBox');
                  // print(box.values.toList());
                  final email = emailController.text;
                  final password = passwordController.text;
                  logger.i(registerList[0].email);
                  bool check =
                      validateCredentials(email, password, registerList);

                  if (check) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Dashboard(),
                      ),
                    );
                  } else {
                    // Handle invalid login credentials here
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Invalid Credentials'),
                        content: Text('Please check your email and password.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
