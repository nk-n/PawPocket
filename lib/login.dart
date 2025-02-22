import 'package:flutter/material.dart';
import 'package:pawpocket/nav_bar.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            const SizedBox(height: 50),
            Stack(
              clipBehavior: Clip.none,
              fit: StackFit.passthrough,
              children: [
                Container(
                  height: MediaQuery.sizeOf(context).height - 500,
                  width: MediaQuery.sizeOf(context).width,
                  child: Image.asset(
                    "assets/images/login_page_background.png",
                    fit: BoxFit.fill,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 200),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(300, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          backgroundColor: const Color.fromRGBO(78, 70, 70, 1),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
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

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providers: [EmailAuthProvider()],
      actions: [
        AuthStateChangeAction<UserCreated>((context, state) {
          Navigator.pushReplacementNamed(context, '/home');
        }),
        AuthStateChangeAction<SignedIn>((context, state) {
          Navigator.pushReplacementNamed(context, '/home');
        }),
      ],
      headerBuilder: (context, constraints, shrinkOffset) {
        return Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.topLeft,
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_rounded, size: 35,),
            ),

        );
      },
    );
  }
}
