import 'package:flutter/material.dart';
import 'package:pawpocket/services/community_firestore.dart';
import 'community_widgets.dart';

class CommunityMainPage extends StatefulWidget {
  const CommunityMainPage({super.key});

  @override
  State<CommunityMainPage> createState() => _CommunityMainPageState();
}

class _CommunityMainPageState extends State<CommunityMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Community"),
        actions: [
          IconButton(
            onPressed: () => setState(() {}),
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: StreamBuilder(
            stream: CommunityFirestoreServices().getCommunityStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text('ERROR: ${snapshot.error}');
              }
              if (snapshot.hasData) {
                var sharedPets = snapshot.data?.docs ?? [];
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15
                  ),
                  itemCount: sharedPets.length,
                  itemBuilder: (context, index) {
                    var data = sharedPets[index].data() as Map<String, dynamic>;
                    return CommunityPetTile(petID: data['pet_id'], ownerID: data['owner_id'],);
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
