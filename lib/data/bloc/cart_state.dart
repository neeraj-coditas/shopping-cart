part of 'cart_bloc.dart';

abstract class CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;
  //final int cartCount;

  CartLoaded(this.cartItems);

  @override
  List<Object?> get props => [cartItems];
}

class CartError extends CartState {
  final String errorMessage;

  CartError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class CartPlacingOrder extends CartState {}
