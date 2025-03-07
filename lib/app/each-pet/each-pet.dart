import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawpocket/app/add-pet/each-form-field.dart';
import 'package:pawpocket/app/calendar/date-time-field.dart';

class EachPet extends StatefulWidget {
  const EachPet({super.key});

  @override
  State<EachPet> createState() => _EachPetState();
}

class _EachPetState extends State<EachPet> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isPictureError = false;
  String _selectedImage = "";
  final List<Map<String, dynamic>> petDesc = [
    {
      "icon": "hbd_icon.png",
      "desc": "21 January 2022",
      "color": Colors.grey[600],
    },
    {
      "icon": "like_icon.png",
      "desc": "ball, bath, chicken nugget",
      "color": Colors.blue[400],
    },
    {"icon": "dislike_icon.png", "desc": "medicine", "color": Colors.red[400]},
    {
      "icon": "doc_icon.png",
      "desc":
          "cheerful and outgoing. I got her from my mom when she was only 1-year-old.",
      "color": Colors.grey[600],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Butter"),
        actions: [
          IconButton(
            padding: EdgeInsets.all(0),
            focusColor: Colors.white,
            onPressed: () {},
            icon: ImageIcon(AssetImage("assets/images/pen-icon.png"), size: 25),
            style: ButtonStyle(
              iconColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return Colors.blue; // สีตอนกด
                }
                return Colors.blueGrey;
              }),
              overlayColor: WidgetStateProperty.all(Colors.white),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
            child: SizedBox(
              width: 30,
              height: 30,
              child: IconButton(
                padding: EdgeInsets.all(0),
                focusColor: Colors.white,
                onPressed: () {},
                icon: Icon(Icons.delete),
                style: ButtonStyle(
                  iconColor: WidgetStateColor.resolveWith((states) {
                    if (states.contains(WidgetState.pressed)) {
                      return Colors.redAccent;
                    }
                    return Colors.blueGrey;
                  }),
                  overlayColor: WidgetStateProperty.all(Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Image.asset("assets/images/cat.png"),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "British Shorthair cat",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            ImageIcon(
                              const AssetImage("assets/images/female_icon.png"),
                              color: Colors.pink[200],
                              size: 30,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            ImageIcon(
                              const AssetImage(
                                "assets/images/location_icon.png",
                              ),
                              color: Colors.grey[500],
                              size: 30,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Bangkok, Thailand",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/medicalhistory");
                      },
                      padding: const EdgeInsets.all(15),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.pink[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      icon: const ImageIcon(
                        AssetImage("assets/images/aid_icon.png"),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: List.generate(petDesc.length, (index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            ImageIcon(
                              AssetImage(
                                "assets/images/${petDesc[index]["icon"]}",
                              ),
                              color: petDesc[index]["color"],
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "${petDesc[index]["desc"]}",
                                style: TextStyle(
                                  color: petDesc[index]["color"],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        child: Column(
                          children: [
                            ImageIcon(
                              const AssetImage(
                                "assets/images/sand_clock_icon.png",
                              ),
                              color: Colors.white,
                              size: 80,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Your Precious Memories",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 66, 133, 244),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 5,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              child: IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "2024",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Color.fromARGB(
                                              255,
                                              66,
                                              133,
                                              244,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "JUN",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Color.fromARGB(
                                              255,
                                              66,
                                              133,
                                              244,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          width: 50,
                                          height: 50,
                                          child: Text(
                                            "31",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 23,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              100,
                                            ),
                                            color: Color.fromARGB(
                                              255,
                                              66,
                                              133,
                                              244,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Expanded(
                                          child: Container(
                                            width: 7,
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                255,
                                                66,
                                                133,
                                                244,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "My cat born",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Text(
                                              "Got her from my mother. We clicked immediately!",
                                            ),
                                            const SizedBox(height: 10),
                                            Container(
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Image.asset(
                                                "assets/images/baby_cat.png",
                                              ),
                                            ),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.grey[200]!,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      ElevatedButton(
                        onPressed:
                            () => showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: Column(
                                        children: [
                                          Image.asset(
                                            "assets/images/book_square_icon.png",
                                            width: 70,
                                            height: 70,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            "Add new memory",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      content: SingleChildScrollView(
                                        child: SizedBox(
                                          width: 300,
                                          child: Container(
                                            child: Form(
                                              key: _formKey,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  EachFormField(
                                                    label: "Name",
                                                    controller: _nameController,
                                                    textSize: 14,
                                                  ),
                                                  SizedBox(height: 20),
                                                  DateTimeField(
                                                    needTime: false,
                                                    fontSize: 14,
                                                    dateController:
                                                        _dateController,
                                                    timeController:
                                                        _timeController,
                                                  ),
                                                  SizedBox(height: 20),
                                                  Text("Home image"),
                                                  SizedBox(height: 10),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          30,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        width: 2,
                                                        color:
                                                            isPictureError
                                                                ? Colors
                                                                    .redAccent
                                                                : Colors
                                                                    .grey[400]!,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    child: SizedBox(
                                                      width: double.infinity,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          _selectedImage == ""
                                                              ? Image.asset(
                                                                "assets/images/gallery_icon.png",
                                                                height: 100,
                                                              )
                                                              : SizedBox(
                                                                width:
                                                                    double
                                                                        .infinity,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child: Container(
                                                                            height:
                                                                                150,
                                                                            margin: const EdgeInsets.only(
                                                                              bottom:
                                                                                  30,
                                                                            ),
                                                                            clipBehavior:
                                                                                Clip.antiAlias,
                                                                            child:
                                                                                _selectedImage !=
                                                                                        null
                                                                                    ? Image.file(
                                                                                      File(
                                                                                        _selectedImage!,
                                                                                      ),
                                                                                      fit:
                                                                                          BoxFit.cover,
                                                                                    )
                                                                                    : Image.asset(
                                                                                      "",
                                                                                    ),
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(
                                                                                15,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                          ElevatedButton(
                                                            onPressed: () async {
                                                              final returnedImage =
                                                                  await ImagePicker()
                                                                      .pickImage(
                                                                        source:
                                                                            ImageSource.gallery,
                                                                      );
                                                              if (returnedImage ==
                                                                  null)
                                                                return;
                                                              setState(() {
                                                                _selectedImage =
                                                                    returnedImage
                                                                        .path;
                                                              });
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                              overlayColor:
                                                                  Colors.white,
                                                              backgroundColor:
                                                                  Color.fromARGB(
                                                                    255,
                                                                    66,
                                                                    133,
                                                                    244,
                                                                  ),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      10,
                                                                    ),
                                                              ),
                                                            ),
                                                            child: const Text(
                                                              "Choose image",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 20),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _selectedImage = "";
                                                          });
                                                          _nameController
                                                              .clear();
                                                          setState(() {
                                                            isPictureError =
                                                                false;
                                                          });
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          overlayColor:
                                                              Colors.redAccent,
                                                          shape: RoundedRectangleBorder(
                                                            side: BorderSide(
                                                              color:
                                                                  Colors
                                                                      .redAccent,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          "Cancle",
                                                          style: TextStyle(
                                                            color:
                                                                Colors
                                                                    .redAccent,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 20),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          if (_formKey
                                                                  .currentState!
                                                                  .validate() &&
                                                              _selectedImage !=
                                                                  "") {
                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              SnackBar(
                                                                content: Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .check_circle,
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                      size: 40,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                      "Add memory successfully",
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                backgroundColor:
                                                                    Colors
                                                                        .green[400],
                                                              ),
                                                            );
                                                            setState(() {
                                                              _selectedImage =
                                                                  "";
                                                            });
                                                            setState(() {
                                                              isPictureError =
                                                                  false;
                                                            });
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          } else if (_selectedImage !=
                                                              "") {
                                                            setState(() {
                                                              isPictureError =
                                                                  false;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              isPictureError =
                                                                  true;
                                                            });
                                                          }
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          foregroundColor:
                                                              Colors.white,
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                255,
                                                                66,
                                                                133,
                                                                244,
                                                              ),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                        ),
                                                        child: Text("Submit"),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                        style: ElevatedButton.styleFrom(
                          overlayColor: Colors.white,
                          backgroundColor: Color.fromARGB(255, 66, 133, 244),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ImageIcon(
                                AssetImage("assets/images/plus_icon.png"),
                                color: Colors.white,
                                size: 30,
                              ),
                              SizedBox(width: 20),
                              Text(
                                "Add new memories",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
