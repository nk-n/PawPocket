import 'package:flutter/material.dart';
import 'pet_home.dart';

class Home extends StatelessWidget {
  const Home({super.key, required this.homeName, required this.homeImage});

  final String homeName;
  final String homeImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          "/allpet",
          arguments: {"user": "user", "homename": homeName},
        );
      },

      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            SizedBox(
              height: 150,
              width: 100,
              child: Image.asset(
                "assets/images/homePic.png",
                fit: BoxFit.contain,
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                homeName,
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
