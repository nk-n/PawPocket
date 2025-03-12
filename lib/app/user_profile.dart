import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key? key, required this.userID}) : super(key: key);
  final userID;
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final userFirestoreServices = UserFirestoreServices();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: userFirestoreServices.readUserData(widget.userID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('ERROR: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          final userData =
              snapshot.data!.data() as Map<String, dynamic>;
          // snapshot.data

          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
              ],
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
                                  "${userData['display_name']}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text("@${userData['username']}", style: TextStyle(fontSize: 14)),
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
                        '${userData['email']}',
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
                        userData['location'],
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.bottom,
                            child: Text("❝ ", style: TextStyle(fontSize: 24)),
                          ),
                          TextSpan(
                            text:
                                userData['about'],
                                // "Hello! Nice to see you! If you have pets, but you are in a situation where you can't regularly care for them, please do contact me! I'd love to help!",
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
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
