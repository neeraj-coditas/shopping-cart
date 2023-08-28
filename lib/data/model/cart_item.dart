import 'package:fake_store/data/model/product.dart'; // Import your Product class

class CartItem {
  final Product product;
  int quantity;

  CartItem(this.product, this.quantity);
}
