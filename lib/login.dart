import 'package:flutter/material.dart';
import 'package:pawpocket/nav_bar.dart';

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
            const SizedBox(height: 250,),
            Container(
              width: 200,
              height: 200,
              child:  Image.asset("assets/images/login_page_dog.png", fit: BoxFit.contain,)
            ),
            const SizedBox(height: 50,),
            Stack(
              clipBehavior: Clip.none,
              fit: StackFit.passthrough,
              children: [
                Container(
                  height: MediaQuery.sizeOf(context).height - 500,
                  width: MediaQuery.sizeOf(context).width,
                  child: Image.asset("assets/images/login_page_background.png", fit: BoxFit.fill,)
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 300,),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Navbar()));
                        }, 
                        child: const Text("Login")
                        )
                    ]
                  ),
                )
                
              ],
            )
          ],
        ),
      ),
    );
  }
}