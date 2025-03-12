class User {
  String uid;
  String username;
  String displayNname;
  String email;
  String location;
  String about;
  List<String> petHomes;
  List<String> socials;

  User({
    required this.uid,
    required this.username,
    required this.displayNname,
    required this.email,
    required this.location,
    required this.about,
    required this.petHomes,
    required this.socials,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      username: json['username'],
      displayNname: json['display_name'],
      email: json['email'],
      location: json['location'],
      about: json['about'],
      petHomes: List<String>.from(json['pet_homes']),
      socials: List<String>.from(json['socials']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'display_name': displayNname,
      'email': email,
      'location': location,
      'about': about,
      'pet_homes': petHomes,
      'socials': socials,
    };
  }

  void addPetHome(String petHome) {
    petHomes.add(petHome);
  }

  void removePetHome(String petHome) {
    petHomes.remove(petHome);
  }

  void addSocial(String social) {
    socials.add(social);
  }

  void removeSocial(String social) {
    socials.remove(social);
  }

  void updateLocation(String newLocation) {
    location = newLocation;
  }

  void updateAbout(String newAbout) {
    about = newAbout;
  }

  void updateDisplayName(String newDisplayName) {
    displayNname = newDisplayName;
  }

  get getUid => uid;
  get getUsername => username;
  get getDisplayName => displayNname;
  get getEmail => email;
  get getLocation => location;
  get getAbout => about;
  get getPetHomes => petHomes;
  get getSocials => socials;
} 

