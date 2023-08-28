part of 'cart_bloc.dart';

sealed class CartEvent {}


class AddToCart extends CartEvent {
  final Product product;
  final int productCount;

  AddToCart(this.product, this.productCount);
}


class UpdateCartItemCount extends CartEvent{
  final List<Product> products;

  UpdateCartItemCount(this.products);
}

class PlaceOrder extends CartEvent {}