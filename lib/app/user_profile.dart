import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pawpocket/services/authentication.dart';
import 'package:pawpocket/services/pet_firestore.dart';
import '../services/user_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/image_manager.dart';

class UserProfile extends StatefulWidget {
  late String? userID;
  UserProfile({Key? key, this.userID}) : super(key: key);
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final userFirestoreServices = UserFirestoreServices();

  final _displayNameController = TextEditingController();
  // final _passwordController = TextEditingController();
  // final _confirmPasswordController = TextEditingController();
  final _locationController = TextEditingController();
  final _aboutController = TextEditingController();
  String _profilePicture = '';
  final _igController = TextEditingController();
  final _fbController = TextEditingController();
  final _twitterController = TextEditingController();
  bool editable = true;
  Map data = {};

  final _formKey = GlobalKey<FormState>();

  void editUserData(BuildContext context, Map<String, dynamic> userData) {
    _displayNameController.text = userData['display_name'];
    _locationController.text = userData['location'];
    _aboutController.text = userData['about'];
    _profilePicture = userData['profile_picture'];
    Map socials = userData['socials'];
    _igController.text = socials.containsKey('ig') ? socials['ig'] : '';
    _fbController.text = socials.containsKey('fb') ? socials['fb'] : '';
    _twitterController.text =
        socials.containsKey('twitter') ? socials['twitter'] : '';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Edit Profile"),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  spacing: 20,
                  children: [
                    Container(
                      width: 75,
                      height: 75,
                      child: Image.asset(
                        "assets/images/login_page_dog.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    Row(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: ImageIcon(
                            AssetImage("assets/images/picture_icon.png"),
                            color: Colors.white,
                            size: 40,
                          ),
                          onPressed: () async {
                            final returnedImage = await ImagePicker().pickImage(
                              source: ImageSource.gallery,
                            );
                            if (returnedImage == null) return;
                            final path = await ImageManager().uploadImage(
                              returnedImage.path,
                              _profilePicture,
                            );
                            setState(() {
                              _profilePicture = path;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            overlayColor: Colors.white,
                            backgroundColor: Color.fromARGB(255, 66, 133, 244),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: ImageIcon(
                            AssetImage("assets/images/camera_icon.png"),
                            color: Colors.white,
                            size: 40,
                          ),
                          onPressed: () async {
                            final returnedImage = await ImagePicker().pickImage(
                              source: ImageSource.camera,
                            );
                            if (returnedImage == null) return;
                            final path = await ImageManager().uploadImage(
                              returnedImage.path,
                              _profilePicture,
                            );
                            setState(() {
                              _profilePicture = path;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            overlayColor: Colors.white,
                            backgroundColor: Color.fromARGB(255, 66, 133, 244),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: _displayNameController,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          label: Text("Display name"),
                          hintText: "Display name",
                          hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 150, 113, 92),
                          ),
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
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: _aboutController,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          label: Text("About me"),
                          hintText: "Anything about you!",
                          hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 150, 113, 92),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        maxLines: null,
                        minLines: 1,
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: "location",
                          label: Text("Location"),
                          hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 150, 113, 92),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return "This field can't be empty.";
                        //   }
                        //   return null;
                        // },
                        // autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: _igController,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          label: Text("Instagram"),
                          hintText: "Instagram username",
                          hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 150, 113, 92),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: _fbController,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          label: Text("Facebook"),
                          hintText: "Facebook username",
                          hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 150, 113, 92),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: _twitterController,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          label: Text("Twitter"),
                          hintText: "Twitter username",
                          hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 150, 113, 92),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                onPressed: () {
                  Map newSocials = {};
                  if (_igController.text.isNotEmpty) {
                    newSocials['ig'] = _igController.text;
                  }
                  if (_fbController.text.isNotEmpty) {
                    newSocials['fb'] = _fbController.text;
                  }
                  if (_twitterController.text.isNotEmpty) {
                    newSocials['twitter'] = _twitterController.text;
                  }

                  if (_locationController.text.isEmpty) {
                    _locationController.text = "N/A";
                  }

                  UserFirestoreServices().updateUserData(
                    username: userData['username'],
                    displayName: _displayNameController.text,
                    email: userData['email'],
                    uuid: widget.userID!,
                    about: _aboutController.text,
                    profilePicture: _profilePicture,
                    location: _locationController.text,
                    petHome: userData['pet_home'],
                    socials: newSocials,
                  );

                  Navigator.pop(context);
                },
                child: Text(
                  "Save",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 62, 138, 65),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userID == null) {
      data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      widget.userID = data['userID']!;
      if (FirebaseAuth.instance.currentUser!.uid != widget.userID) {
        editable = false;
      }
    }
    return StreamBuilder<DocumentSnapshot>(
      stream: userFirestoreServices.readUserData(widget.userID!),
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
                if (editable)
                  IconButton(
                    onPressed: () {
                      editUserData(context, userData);
                    },
                    icon: Icon(Icons.settings),
                  ),
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
                                // backgroundImage: userData['profile_picture'] == 'none' ? AssetImage('assets/images/dog.png') : FileImage(File(userData['profile_picture'])),
                                backgroundImage: ImageManager()
                                    .getImageProvider(
                                      userData['profile_picture'],
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
                                      FutureBuilder(
                                        future: PetFirestoreService()
                                            .getPetCount(widget.userID!),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return Text(
                                              '0',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            );
                                          }

                                          if (!snapshot.hasData ||
                                              snapshot.data == null) {
                                            return CircularProgressIndicator();
                                          }
                                          if (snapshot.hasData) {
                                            return Text(
                                              snapshot.data?.toString() ?? '0',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            );
                                          } else {
                                            return CircularProgressIndicator();
                                          }
                                        },
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
                        if (editable && !data.containsKey('community_view'))
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
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ),
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
  // Uri _nativeUrl = Uri.parse('instagram://user?username=cnc.csku');

  @override
  Widget build(BuildContext context) {
    switch (platform) {
      case 'ig':
        _url = Uri.parse('https://www.instagram.com/$identifier');
        // _nativeUrl = Uri.parse('instagram://user?username=$identifier');
        break;
      case 'fb':
        _url = Uri.parse('https://www.facebook.com/$identifier');
        // _nativeUrl = Uri.parse("fb://profile/$identifier");
        break;
      case 'twitter':
        _url = Uri.parse('https://x.com/$identifier');
        // _nativeUrl = Uri.parse("twitter://user?screen_name=$identifier");
        break;
    }
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Open Social Link?"),
              content: Text("redirect to $_url"),
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
                  onPressed: () {
                    _launcnURL();
                    Navigator.pop(context);
                  },
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
    // if (await canLaunchUrl(_nativeUrl)) {
    //   await launchUrl(_nativeUrl);
    // } else if (await canLaunchUrl(_url)) {
    //   await launchUrl(_url);
    // } else {
    //   throw Exception('Could not open URL.');
    // }
  }
}
