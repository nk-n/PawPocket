import 'package:flutter/material.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToItem(0);
    });
  }

  void _scrollToItem(int index) {
    double itemHeight = 500.0;
    double offset = itemHeight * index;
    _scrollController.jumpTo(offset);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Calendar"),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: IconButton(
              icon: ImageIcon(
                AssetImage("assets/images/calendar_complete.png"),
                size: 30,
              ),
              focusColor: Colors.white,
              onPressed: () {},
              style: ButtonStyle(
                iconColor: WidgetStateColor.resolveWith((states) {
                  if (states.contains(WidgetState.pressed)) {
                    return Colors.blue; // สีตอนกด
                  }
                  return Colors.grey;
                }),
                overlayColor: WidgetStateProperty.all(Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: 20,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 150,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                          child: Text(
                            "February 2568 BE ${index}",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/images/calendar-wallpaper/cw-${(index) % 12}.jpg",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/eventdetail");
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "TUE",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          "14",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(15),
                                        child: Row(
                                          children: [
                                            Container(
                                              clipBehavior: Clip.antiAlias,
                                              width: 50,
                                              height: 50,
                                              child: Image.asset(
                                                "assets/images/cat.png",
                                                fit: BoxFit.cover,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Header",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  "Carrot, Golden retriever",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  "09:00-11:00",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[400],
                                          borderRadius: BorderRadius.circular(
                                            10,
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
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: Container(
              child: IconButton(
                padding: const EdgeInsets.all(20),
                onPressed: () {
                  Navigator.pushNamed(context, "/addeventform");
                },
                icon: ImageIcon(
                  AssetImage("assets/images/plus_only_icon.png"),
                  size: 30,
                  color: Colors.green[400],
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3), // Shadow color
                    spreadRadius: 1, // Spread of shadow
                    blurRadius: 10, // Blur radius
                    offset: Offset(0, 5), // Shadow position
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
