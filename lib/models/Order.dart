// @dart=2.9

class Order {
  String email, creationdate, product, password;
  bool isfinish, hasorder;

  Order(
      {this.email,
      this.creationdate,
      this.product,
      this.password,
      this.isfinish,
      this.hasorder});

  Order.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }

    email = map["email"];
    creationdate = map["creationdate"];
    product = map["product"];
    password = map["password"];
    isfinish = map["isfinish"];
    hasorder = map["hasorder"];
  }

  toJson() {
    return {
      'email': email,
      'creationdate': creationdate,
      'product': product,
      'password': password,
      // cast bool
      'isfinish': isfinish ? 1 : 0,
      'hasorder': hasorder ? 1 : 0,
    };
  }
}
