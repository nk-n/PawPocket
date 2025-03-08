import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 40, right: 40, top: 20),
        child: Column(
          spacing: 25,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                spacing: 10,
                children: [
                  CircleAvatar(
                    radius: 65,
                    backgroundImage: AssetImage("assets/images/dog.png"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5,
                    children: [
                      SizedBox(width: 30),
                      Column(
                        children: [
                          Text(
                            "Username",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("@nrkn", style: TextStyle(fontSize: 14)),
                        ],
                      ),
                      Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          ImageIcon(
                            AssetImage("assets/images/paw.png"),
                            size: 40,
                            color: const Color.fromRGBO(135, 65, 56, 1),
                          ),
                          Text(
                            "1",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // RichText(
            //   text: TextSpan(

            //     children: [
            //       WidgetSpan(
            //         child: Icon(
            //           Icons.email_outlined,
            //           size: 25,
            //           color: Colors.grey,
            //         ),
            //       ),
            //       TextSpan(text: '   emailSample@ku.th', style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 0, 0, 0))),
            //     ],
            //   ),
            // ),
            Row(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Icons.email_outlined, size: 25),
                Text(
                  'emailSample@ku.th',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ],
            ),
            Row(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Icons.key, size: 25),
                Text(
                  'XXXXXXXXXXXX',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ],
            ),
            Row(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Icons.location_on_outlined, size: 25),
                Text(
                  'Bangkok, Thailand',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ],
            ),
            RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.bottom,
                    child: Text("❝ ", style: TextStyle(fontSize: 24)),
                  ),
                  TextSpan(
                    text:
                        "Hello! Nice to see you! If you have pets, but you are in a situation where you can't regularly care for them, please do contact me! I'd love to help!",
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.top,
                    child: Text(" ❞", style: TextStyle(fontSize: 24)),
                  ),
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 230, 96, 78),
                  minimumSize: Size(150, 50),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
                child: Text(
                  "Logout",
                  style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
