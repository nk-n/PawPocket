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
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Butter"),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: const ImageIcon(
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
                    const SizedBox(
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
                                const Text(
                                  "British Shorthair cat",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                ImageIcon(
                                  const AssetImage(
                                      "assets/images/female_icon.png"),
                                  color: Colors.pink[200],
                                  size: 30,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                ImageIcon(
                                  const AssetImage(
                                      "assets/images/location_icon.png"),
                                  color: Colors.grey[500],
                                  size: 30,
                                ),
                                const SizedBox(
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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.pink[200],
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const ImageIcon(
                              AssetImage("assets/images/aid_icon.png"),
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: List.generate(
                          petDesc.length,
                          (index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  ImageIcon(
                                    AssetImage(
                                        "assets/images/${petDesc[index]["icon"]}"),
                                    color: petDesc[index]["color"],
                                  ),
                                  const SizedBox(
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
                      margin: const EdgeInsets.only(top: 30),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ImageIcon(
                                const AssetImage(
                                    "assets/images/sand_clock_icon.png"),
                                color: Colors.yellow[800],
                                size: 30,
                              ),
                              const SizedBox(
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
                            margin: const EdgeInsets.only(top: 30),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: 5,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 35),
                                  child: Row(
                                    children: [
                                      const Column(
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
                                      const SizedBox(
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
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            const Text(
                                                "Got her from my mother. We clicked immediately!"),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Image.asset(
                                                  "assets/images/baby_cat.png"),
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
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.green[400],
                                borderRadius: BorderRadius.circular(15)),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ImageIcon(
                                  AssetImage("assets/images/plus_icon.png"),
                                  color: Colors.white,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Add new memories",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
