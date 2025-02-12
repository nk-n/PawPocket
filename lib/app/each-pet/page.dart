import 'package:flutter/material.dart';

class EachPet extends StatelessWidget {
  EachPet({super.key});
  final List<Map<String, dynamic>> petDesc = [
    {
      "icon": "hbd_icon.png",
      "desc": "21 January 2022",
      "color": Colors.grey[600]
    },
    {
      "icon": "like_icon.png",
      "desc": "ball, bath, chicken nugget",
      "color": Colors.blue[400]
    },
    {"icon": "dislike_icon.png", "desc": "medicine", "color": Colors.red[400]},
    {
      "icon": "doc_icon.png",
      "desc":
          "cheerful and outgoing. I got her from my mom when she was only 1-year-old.",
      "color": Colors.grey[600]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: Text("Butter"),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 20),
              child: ImageIcon(
                AssetImage("assets/images/menu_icon.png"),
                size: 30,
              ),
            )
          ],
        ),
        body: ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset("assets/images/cat.png"),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "British Shorthair cat",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                ImageIcon(
                                  AssetImage("assets/images/female_icon.png"),
                                  color: Colors.pink[200],
                                  size: 30,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                ImageIcon(
                                  AssetImage("assets/images/location_icon.png"),
                                  color: Colors.grey[500],
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Bangkok, Thailand",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey[500]),
                                ),
                              ],
                            )
                          ],
                        ),
                        Container(
                          child: IconButton(
                            onPressed: () {},
                            icon: ImageIcon(
                              AssetImage("assets/images/aid_icon.png"),
                              color: Colors.white,
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.pink[200],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: List.generate(
                          petDesc.length,
                          (index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  ImageIcon(
                                    AssetImage(
                                        "assets/images/${petDesc[index]["icon"]}"),
                                    color: petDesc[index]["color"],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${petDesc[index]["desc"]}",
                                      style: TextStyle(
                                          color: petDesc[index]["color"]),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ImageIcon(
                                AssetImage("assets/images/sand_clock_icon.png"),
                                color: Colors.yellow[800],
                                size: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Your Precious Memories",
                                style: TextStyle(
                                    color: Colors.yellow[800], fontSize: 18),
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 30),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: 5,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: EdgeInsets.only(bottom: 35),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            "3",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            "June",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Text(
                                            "2022",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: Colors.green[500]),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                                "Got her from my mother. We clicked immediately!"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              clipBehavior: Clip.antiAlias,
                                              child: Image.asset(
                                                  "assets/images/baby_cat.png"),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
