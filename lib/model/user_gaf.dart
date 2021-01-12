class UserGaf {
  Map product;
  String name;
  String secondName;
  double thirdName;
  double stores;
  String permissions;
  double image;
  UserGaf.map(this.product) {
    name = product['name'];
    secondName = product['secondName'];
    thirdName = product['thirdName'];
    stores = product['stores'];
    permissions = product['permissions'];
    image = product['image'];
  }
  UserGaf(this.name, this.secondName, this.thirdName, this.stores,
      this.permissions, this.image) {
    product['name'] = name;
    product['secondName'] = secondName;
    product['thirdName'] = thirdName;
    product['stores'] = stores;
    product['permissions'] = permissions;
    product['image'] = image;
  }
}
