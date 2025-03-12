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
                  child: Column(
                    spacing: 25,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      SizedBox(
                        width: 300,
                        child: TextField(
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
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: Text("Password"),
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      // const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(300, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          backgroundColor: const Color.fromRGBO(78, 70, 70, 1),
                        ),
                        onPressed: () async {
                          // await UserFirestoreServices().checkUserExistWithUsername(_usernameController.text);
                          try {
                            if (emailRegEx.hasMatch(_usernameController.text)) {
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
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
  final _displayNameController = TextEditingController();

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
              height: 50,
              child: TextField(
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
              ),
            ),
            SizedBox(
              width: 300,
              height: 50,
              child: TextField(
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
              ),
            ),
            SizedBox(
              width: 300,
              height: 50,
              child: TextField(
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
              ),
            ),
            SizedBox(
              width: 300,
              height: 50,
              child: TextField(
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
                  await Authentication().signUp(
                    email: _emailController.text,
                    password: _passwordController.text,
                    username: _usernameController.text,
                    displayName: _displayNameController.text,
                  );

                  Navigator.pop(context);
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
                Navigator.pop(context);
              },
              child: Text("Already have an account?"),
            ),
          ],
        ),
      ),
    );
  }
}
