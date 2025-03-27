import 'package:flutter/material.dart';
import 'package:pawpocket/services/community_firestore.dart';
import 'package:pawpocket/services/pet_firestore.dart';
import 'community_widgets.dart';
import 'package:pawpocket/model/pet.dart';

class CommunityMainPage extends StatefulWidget {
  const CommunityMainPage({super.key});

  @override
  State<CommunityMainPage> createState() => _CommunityMainPageState();
}

class _CommunityMainPageState extends State<CommunityMainPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void showSearch() {
    _searchController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Find pet via shared code"),
          content: TextField(
            controller: _searchController,
            decoration: InputDecoration(hintText: "Enter shared code here"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                var data = await CommunityFirestoreServices().isExist(
                  _searchController.text,
                );
                // print("searched");
                if (data.isNotEmpty) {
                  // print("found");
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    "/eachpet",
                    arguments: {
                      'pet': await PetFirestoreService().getPetData(
                        data['pet_id'],
                      ),
                      'edit_access': false,
                      'owner': data['owner_id'],
                    },
                  );
                }
              },
              child: Text("Search"),
            ),
          ],
        );
      },
    );
  }

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
      floatingActionButton: FloatingActionButton(
        onPressed: showSearch,
        child: Icon(Icons.search),
        backgroundColor: const Color.fromARGB(255, 162, 240, 192),
        ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Container(
            //       width: 300,
            //       padding: EdgeInsets.only(left: 10),
            //       decoration: BoxDecoration(
            //         color: const Color.fromARGB(255, 201, 201, 201),
            //         borderRadius: BorderRadius.circular(15),
            //       ),
            //       child: Expanded(
            //         child: TextField(
            //           controller: _searchController,
            //           decoration: InputDecoration(
            //             border: InputBorder.none,
            //             fillColor: Colors.grey,
            //             hintText: "Enter shared code here",
            //             icon: Icon(Icons.search),
            //           ),
            //         ),
            //       ),
            //     ),
            //     IconButton(
            //       icon: Icon(Icons.search),
            //       onPressed: () async {
            //         var data = await CommunityFirestoreServices().isExist(
            //           _searchController.text,
            //         );
            //         print("searched");
            //         if (data.isNotEmpty) {
            //           print("found");
            //           Navigator.pushNamed(
            //             context,
            //             "/eachpet",
            //             arguments: {
            //               'pet': await PetFirestoreService().getPetData(
            //                 data['pet_id'],
            //               ),
            //               'edit_access': false,
            //               'owner': data['owner_id'],
            //             },
            //           );
            //         }
            //       },
            //     ),
            //   ],
            // ),
            SizedBox(height: 15),
            ScrollConfiguration(
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
                    if (sharedPets.isEmpty) {
                      return Center(child: Text("The community is empty."));
                    }
                    // var filteredPets =
                    //     sharedPets.where((element) {
                    //       var data = element.data() as Map<String, dynamic>;
                    //       return data['pet_id'].toString().contains(
                    //         _searchController.text,
                    //       );
                    //     }).toList();

                    // if (filteredPets.isEmpty) {
                    //   return Center(child: Text("No pets found."));
                    // }
                    return Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                        ),
                        itemCount: sharedPets.length,
                        itemBuilder: (context, index) {
                          var data =
                              sharedPets[index].data()
                                  as Map<String, dynamic>;
                          return CommunityPetTile(
                            petID: data['pet_id'],
                            ownerID: data['owner_id'],
                          );
                        },
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
