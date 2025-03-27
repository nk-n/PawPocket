import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pawpocket/model/home_model.dart';
import 'package:pawpocket/services/image_manager.dart';
import 'pet_home.dart';

class Home extends StatelessWidget {
  const Home({super.key, required this.home});

  final HomeModel home;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          "/allpet",
          arguments: {"user": "user", "home": home},
        );
      },

      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            SizedBox(
              height: 150,
              width: 100,
              child: Image.network(
                ImageManager().getImageUrl(home.image),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                home.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  overflow: TextOverflow.fade,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
