import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_registration/constant/constant.dart';
import 'package:form_registration/database/database.helper.dart';
import 'package:form_registration/model/registration_model.dart';
import 'package:form_registration/view/login_screen.dart';
import 'package:form_registration/view/userlist.dart';
import 'package:hive/hive.dart';
import 'package:sizer/sizer.dart';

class RegisterForm extends HookWidget {
  RegisterForm({super.key});

  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final dbHelper = DatabaseHelper.instance;
    final ValueNotifier<List<Registrationform>> registerListState =
        useState<List<Registrationform>>([]);
    List<Registrationform> registerList = registerListState.value;
    final TextEditingController mobileCtr = useTextEditingController();
    final TextEditingController nameCtr = useTextEditingController();
    final TextEditingController emailctr = useTextEditingController();
    final TextEditingController pwdctr = useTextEditingController();

    void addUser(Registrationform form) async {
      final box = await Hive.openBox('userBox');
      box.add(form.toMap());
      print(box.values.toList());
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(registerList: []),
          ));
    }

    void _loadNotes() async {
      logger.i('Creating Db...');
      List<Registrationform> notes = await dbHelper.getAllNotes();
      registerList = notes;
    }

    void _addNote(Registrationform newNote) async {
      int id = await dbHelper.insert(newNote);
      newNote.id = id;
      registerList.add(newNote);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(registerList: registerList),
          ));
    }

    void _deleteNote(int index) async {
      await dbHelper.delete(registerList[index].id!);
      registerList.removeAt(index);
    }

    useEffect(() {
      _loadNotes();
    }, [
      mobileCtr.text = '',
      nameCtr.text = '',
      emailctr.text = '',
      pwdctr.text = '',
    ]);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Registration', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Userlist(
                              mlist: registerList,
                            )));
              },
              icon: Icon(
                Icons.list,
                color: Colors.white,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0.sp),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(12.0.sp),
                  child: Row(
                    children: [
                      Text(
                        'Please fill your details',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Name',
                    ),
                    textInputAction: TextInputAction.next,
                    controller: nameCtr,
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        // return "Name is Required";
                      } else {}

                      return null;
                    },
                    style: TextStyle(
                      color: Color(0xFF6A798A),
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'Mobile no.'),
                    controller: mobileCtr,
                    inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.toString().isEmpty ||
                          value.toString().length < 10) {
                        // return "Mobile Number Required";
                      } else {}

                      return null;
                    },
                    style: TextStyle(
                      color: Color(0xFF6A798A),
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'Email id'),
                    textInputAction: TextInputAction.next,
                    controller: emailctr,
                    validator: (value) {
                      if (value.toString().isEmpty) {
                      } else {}

                      return null;
                    },
                    style: TextStyle(
                      color: Color(0xFF6A798A),
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'Password'),
                    textInputAction: TextInputAction.next,
                    controller: pwdctr,
                    validator: (value) {
                      if (value.toString().isEmpty) {
                      } else {}

                      return null;
                    },
                    style: TextStyle(
                      color: Color(0xFF6A798A),
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                InkWell(
                  onTap: () async {
                    if (_formkey.currentState!.validate()) {
                      var registerData = Registrationform(
                          name: nameCtr.value.text,
                          email: emailctr.value.text,
                          mobileno: mobileCtr.value.text,
                          pwd: pwdctr.value.text);

                      _addNote(registerData);

                      nameCtr.clear();
                      emailctr.clear();
                      mobileCtr.clear();
                      pwdctr.clear();

                      // Hive method
                      // _updateNote(
                      //     index++,
                      //     nameCtr.value.text,
                      //     emailctr.value.text,
                      //     mobileCtr.value.text,
                      //     pwdctr.value.text);
                      // addUser(registerData);
                      // registerList.add(registerData);

                      // for (var i = 0; i < registerList.length; i++) {
                      //   print(
                      //       '${registerList[i].name} | ${registerList[i].email} | ${registerList[i].mobileno} | ${registerList[i].pwd}');
                      // }
                      // getUsers();
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      width: 90.w,
                      height: 7.h,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 19),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: Color(0xFF03BF9C),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)),
                      ),
                      child: Center(
                        child: Text(
                          'Sumbit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    emailctr.clear();
                    mobileCtr.clear();
                    nameCtr.clear();
                    pwdctr.clear();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 90.w,
                      height: 7.h,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 19),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side:
                              BorderSide(width: 0.50, color: Color(0xFF2E2D32)),
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF6A798A),
                            fontSize: 13.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
