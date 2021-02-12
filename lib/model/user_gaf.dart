class UserGaf {
  Map<String, dynamic> userdata;
  String name;
  String secondName;
  String thirdName;
  String genre;
  String stores;
  bool image;
  UserGaf.map(this.userdata) {
    name = userdata['name'];
    secondName = userdata['secondName'];
    thirdName = userdata['thirdName'];
    genre = userdata['genre'];
    stores = userdata['stores'];
    image = userdata['image'];
  }
  UserGaf(this.name, this.secondName, this.thirdName, this.genre, this.stores,
      this.image) {
    userdata['name'] = name;
    userdata['secondName'] = secondName;
    userdata['thirdName'] = thirdName;
    userdata['genre'] = genre;
    userdata['stores'] = stores;
    userdata['image'] = image;
  }
}
