import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pawpocket/services/authentication.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  RegExp emailRegEx = RegExp(
    r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$",
  );

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 250),
            Container(
              width: 200,
              height: 200,
              child: Image.asset(
                "assets/images/login_page_dog.png",
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              clipBehavior: Clip.none,
              fit: StackFit.passthrough,
              children: [
                Container(
                  height: MediaQuery.sizeOf(context).height - 470,
                  width: MediaQuery.sizeOf(context).width,
                  child: Image.asset(
                    "assets/images/login_page_background.png",
                    fit: BoxFit.fill,
                  ),
                ),
                Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      spacing: 25,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        SizedBox(
                          width: 300,
                          child: TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintText: "Username or Email",
                              label: Text("Username"),
                              hintStyle: TextStyle(
                                color: const Color.fromARGB(255, 116, 114, 114),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "username or email can't be empty.";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              label: Text("Password"),
                              hintText: "Password",
                              hintStyle: TextStyle(
                                color: const Color.fromARGB(255, 116, 114, 114),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "password field can't be empty.";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                        ),
                        // const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(300, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            backgroundColor: const Color.fromRGBO(
                              78,
                              70,
                              70,
                              1,
                            ),
                          ),
                          onPressed: () async {
                            // if (_formKey.currentState!.validate()) {

                            //   return;
                            // }
                            // await UserFirestoreServices().checkUserExistWithUsername(_usernameController.text);
                            try {
                              // _formKey.currentState!.validate();
                              // _passwordKey.currentState!.validate();
                              if (!_formKey.currentState!.validate()) {
                                throw FirebaseAuthException(
                                  code: 'invalid-credential',
                                );
                              }
                              if (emailRegEx.hasMatch(
                                _usernameController.text,
                              )) {
                                await Authentication().signInWithEmail(
                                  email: _usernameController.text,
                                  password: _passwordController.text,
                                );
                              } else {
                                await Authentication().signInWithUsername(
                                  username: _usernameController.text,
                                  password: _passwordController.text,
                                );
                              }

                              Navigator.pushReplacementNamed(context, '/home');
                            } catch (e) {
                              Fluttertoast.showToast(
                                msg: "Invalid username or password",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black38,
                                textColor: Colors.white,
                                fontSize: 14.0,
                              );
                            }
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 185, 25, 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _displayNameController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  RegExp emailRegEx = RegExp(
    r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$",
  );

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromRGBO(218, 170, 127, 1),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Form(
          key: _formkey,
          child: Column(
            spacing: 18,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 150,
                height: 150,
                child: Image.asset(
                  "assets/images/login_page_dog.png",
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Username",
                    label: Text("Username"),
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Username can't be empty.";
                    }
                    if (value.contains(
                      RegExp(r'^[A-Za-z0-9._]*[A-Za-z][A-Za-z0-9._]*$'),
                    )) {
                      return null;
                    }
                    return "Only A-Z, 0-9, dots and _ are allowed.";
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    label: Text("Email"),
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email can't be empty.";
                    }
                    if (emailRegEx.hasMatch(value)) {
                      return null;
                    }
                    return "Please enter a valid email address.";
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              SizedBox(
                width: 300,
                child: TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    label: Text("Password"),
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password can't be empty";
                    }
                    if (value.length < 5) {
                      return "Password must has least 5 characters.";
                    }
                    if (value.contains(" ")) {
                      return "Password must not contains space.";
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              SizedBox(
                width: 300,
                child: TextFormField(
                  obscureText: true,
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    label: Text("Confirm Password"),
                    hintText: "Confirm Password",
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password can't be empty";
                    }
                    if (value.length < 5) {
                      return "Password must has least 5 characters.";
                    }
                    if (value.contains(" ")) {
                      return "Password must not contains space.";
                    }
                    if (value != _passwordController.text) {
                      return "Password do not match.";
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: _displayNameController,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    label: Text("Display name"),
                    hintText: "Display name",
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Display name can't be empty";
                    }
                    if (value.contains(
                      RegExp(
                        r'^[A-Za-z\u0E00-\u0E7F0-9._ ]*[A-Za-z\u0E00-\u0E7F][A-Za-z\u0E00-\u0E7F0-9._ ]*$',
                      ),
                    )) {
                      return null;
                    }
                    return "Some characters are not allowed.";
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(300, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  backgroundColor: const Color.fromRGBO(78, 70, 70, 1),
                ),
                onPressed: () async {
                  try {
                    if (!_formkey.currentState!.validate()) {
                      throw FirebaseAuthException(
                        code: 'invalid-email',
                        message:
                            "Please ensure that all information is correct and in the right format.",
                      );
                    }
                    await Authentication().signUp(
                      email: _emailController.text,
                      password: _passwordController.text,
                      username: _usernameController.text,
                      displayName: _displayNameController.text,
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  } catch (e) {
                    Fluttertoast.showToast(
                      msg: e.toString().substring(e.toString().indexOf(' ')),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black38,
                      textColor: Colors.white,
                      fontSize: 14.0,
                    );
                  }
                },
                child: Text("Sign Up", style: TextStyle(color: Colors.white)),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text("Already have an account?"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
