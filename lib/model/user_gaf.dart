class UserGaf {
  Map product;
  String name;
  String secondName;
  String thirdName;
  String genre;
  String stores;
  bool image;
  UserGaf.map(this.product) {
    name = product['name'];
    secondName = product['secondName'];
    thirdName = product['thirdName'];
    genre = product['genre'];
    stores = product['stores'];
    image = product['image'];
  }
  UserGaf(this.name, this.secondName, this.thirdName, this.genre, this.stores,
      this.image) {
    product['name'] = name;
    product['secondName'] = secondName;
    product['thirdName'] = thirdName;
    product['genre'] = genre;
    product['stores'] = stores;
    product['image'] = image;
  }
}
