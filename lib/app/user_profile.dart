import 'package:flutter/material.dart';
import 'package:pawpocket/services/authentication.dart';
import '../services/user_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

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
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          Map socials = userData['socials'];

          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
              ],
            ),
            body: ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Container(
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
                                backgroundImage: AssetImage(
                                  "assets/images/dog.png",
                                ),
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
                                      Text(
                                        "@${userData['username']}",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  Stack(
                                    alignment:
                                        AlignmentDirectional.bottomCenter,
                                    children: [
                                      ImageIcon(
                                        AssetImage("assets/images/paw.png"),
                                        size: 40,
                                        color: const Color.fromRGBO(
                                          135,
                                          65,
                                          56,
                                          1,
                                        ),
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
                        if (socials.isNotEmpty)
                          ScrollConfiguration(
                            behavior: ScrollBehavior(),
                            child: SizedBox(
                              height: 25,
                              child: Center(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: socials.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    var entry = socials.entries.toList()[index];
                                    return Container(
                                      margin: EdgeInsets.only(
                                        right: 10,
                                        left: 10,
                                      ),
                                      child: SocialWidget(
                                        platform: entry.key,
                                        identifier: entry.value,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
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
                                  child: Text(
                                    "❝ ",
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ),
                                TextSpan(
                                  text: userData['about'],
                                  // "Hello! Nice to see you! If you have pets, but you are in a situation where you can't regularly care for them, please do contact me! I'd love to help!",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.top,
                                  child: Text(
                                    " ❞",
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                230,
                                96,
                                78,
                              ),
                              minimumSize: Size(150, 50),
                            ),
                            onPressed: () async {
                              Authentication().signOut();
                              if (context.mounted) {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/login',
                                );
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
                  );
                },
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class SocialWidget extends StatelessWidget {
  SocialWidget({super.key, required this.identifier, required this.platform});

  final String identifier;
  final String platform;
  Uri _url = Uri.parse('https://cs.sci.ku.ac.th/home');

  @override
  Widget build(BuildContext context) {
    switch (platform) {
      case 'ig':
        _url = Uri.parse('https://www.instagram.com/');
        break;
      case 'fb':
        _url = Uri.parse('https://www.facebook.com/');
        break;
      case 'twitter':
        _url = Uri.parse('https://x.com/');
        break;
    }
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Open Social Link?"),
              content: Text("redirect to $_url$identifier/"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 102, 98, 97),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _launcnURL(),
                  child: Text(
                    "Open",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 62, 138, 65),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Image.asset(
        'assets/images/$platform.png',
        fit: BoxFit.fill,
        scale: 5,
      ),
    );
  }

  Future<void> _launcnURL() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not open URL.');
    }
  }
}
