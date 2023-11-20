// ignore_for_file: deprecated_member_use

import 'package:course_app/auth/login_screen.dart';
import 'package:course_app/auth/provider/auth_provider_state.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../constant/constant.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.3,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 20),
                height: 8,
                width: 100,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 209, 209, 209),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Column(
                children: [
                  _text("Welcome",
                      fontSize: 30, color: black, fontWeight: FontWeight.w600),
                  _text("Please register to make an account",
                      color: black.withOpacity(0.5),
                      fontWeight: FontWeight.normal,
                      fontSize: 15),

                  // form
                  _form(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // ======================= WIDGET ==========================
  // title
  Widget _text(String nama,
      {required double fontSize,
      required Color color,
      required FontWeight fontWeight}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        nama,
        style: GoogleFonts.roboto(
            fontSize: fontSize, color: color, fontWeight: fontWeight),
      ),
    );
  }

  // form
  Widget _form() {
    AuthProviderState provider =
        Provider.of<AuthProviderState>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _emailField(
              "Email or Phone number",
              "user@gmail.com",
              Icons.email,
              provider.email,
              (value) {
                if (value == null || value.isEmpty) {
                  return 'The Email field is required';
                } else if (!RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                    .hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            _passwordField(
              "Input Password",
              "Password",
              Icons.key,
              Icons.remove_red_eye,
              provider.password,
              (value) {
                if (value!.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              },
            ),
            _confirPassField(
              "Repeat Password",
              "Confirm Password",
              Icons.key,
              Icons.remove_red_eye,
              provider.confirmPassword,
              (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                } else if (value != provider.password.value.text) {
                  return 'Passwords do not match';
                } else if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              },
            ),
            _signUpButton(
              () {
                if (formKey.currentState!.validate()) {
                  provider.register(context);
                  setState(() {});
                }
              },
              provider.isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Text('Register'),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Already have an account",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet<void>(
                        isScrollControlled: true,
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(45),
                            topRight: Radius.circular(45),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return const LoginScreen();
                        },
                      );
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Icon(
                    Icons.arrow_right_alt,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // email textfile
  Widget _emailField(
    String label,
    String hint,
    IconData prefix,
    TextEditingController? controller,
    FormFieldValidator<String>? validate,
  ) {
    return TextFormField(
      controller: controller,
      validator: validate,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 25),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(15),
          ),
          label: Text(label),
          hintText: hint,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(15),
          ),
          prefixIcon: Icon(prefix),
          filled: false),
      autofocus: true,
      // focusNode: FocusNode(),
    );
  }

  // password textfile
  Widget _passwordField(
    String label,
    String hint,
    IconData prefix,
    IconData sufix,
    TextEditingController? controller,
    FormFieldValidator<String>? validate,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TextFormField(
        controller: controller,
        validator: validate,
        obscureText: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 25),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(15),
          ),
          label: Text(label),
          hintText: hint,
          prefixIcon: Icon(prefix),
          suffixIcon: Icon(sufix),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        autofocus: true,
      ),
    );
  }

  // confirm pass textfile
  Widget _confirPassField(
    String label,
    String hint,
    IconData prefix,
    IconData sufix,
    TextEditingController controller,
    FormFieldValidator<String>? validate,
  ) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: validate,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 25),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(15),
        ),
        label: Text(label),
        hintText: hint,
        prefixIcon: Icon(prefix),
        suffixIcon: Icon(sufix),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      autofocus: true,
    );
  }

  Widget _signUpButton(Function()? onPressed, Widget? child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 40),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: green,
            onPrimary: Colors.white,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
            minimumSize: Size(MediaQuery.of(context).size.width, 70),
          ),
          onPressed: onPressed,
          child: child),
    );
  }
}
