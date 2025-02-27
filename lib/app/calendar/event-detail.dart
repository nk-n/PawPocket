import 'package:flutter/material.dart';

class EventDetail extends StatelessWidget {
  const EventDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: ImageIcon(AssetImage("assets/images/pen-icon.png")),
          ),
          IconButton(
            onPressed: () {},
            icon: ImageIcon(AssetImage("assets/images/menu_icon.png")),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                child: Image.asset("assets/images/dog.png"),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Header",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Text("Carrot, Golden retriever", style: TextStyle(fontSize: 18)),
              SizedBox(height: 15),
              Row(
                children: [
                  ImageIcon(AssetImage("assets/images/calendar-icon.png")),
                  SizedBox(width: 10),
                  Text("Thursday 14 February 2568"),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  ImageIcon(AssetImage("assets/images/clock-icon.png")),
                  SizedBox(width: 10),
                  Text("09:00-11:00"),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  ImageIcon(AssetImage("assets/images/location_icon.png")),
                  SizedBox(width: 10),
                  Text("Bangkok, Thailand"),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled ",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
