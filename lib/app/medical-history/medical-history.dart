import 'package:flutter/material.dart';

class MedicalHistory extends StatelessWidget {
  const MedicalHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Butter"),
                SizedBox(width: 10),
                ImageIcon(
                  AssetImage("assets/images/female_icon.png"),
                  color: Colors.pink[300],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "British Shorthair cat",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  ImageIcon(
                    AssetImage("assets/images/aid_icon.png"),
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "History",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 66, 133, 244),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "ฉีดวัคซีน",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ImageIcon(
                                AssetImage("assets/images/pen-icon.png"),
                                size: 20,
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Row(
                                children: [
                                  ImageIcon(
                                    AssetImage("assets/images/clock-icon.png"),
                                  ),
                                  SizedBox(width: 5),
                                  Text("9.30-10.00"),
                                ],
                              ),
                              SizedBox(width: 10),
                              Row(
                                children: [
                                  ImageIcon(
                                    AssetImage(
                                      "assets/images/calendar-icon.png",
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text("15/07/2025"),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 25),
                          Text("ฉีดวัคซีนพิษสุนัขบ้า ตรวจสุขภาพปกติ"),
                          SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            child: Text(
                              "medical",
                              style: TextStyle(color: Colors.white),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.pink[200],
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 2, color: Colors.grey[200]!),
                      ),
                    );
                  },
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[200]!, width: 2),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(),
      ),
    );
  }
}
