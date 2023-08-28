import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fake_store/data/model/cart_item.dart';
import 'package:fake_store/data/model/product.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  List<CartItem> _cartItems = []; // Internal list to manage cart items

  CartBloc() : super(CartLoading()) {
    on<AddToCart>(_addToCart);
    on<UpdateCartItemCount>(_updateCartItemCount);
    on<PlaceOrder>(_placeOrder);
  }

  void _addToCart(AddToCart event, Emitter<CartState> emit) {
    if (event.productCount > 0) {
      bool alreadyInCart = false;

      for (var cartItem in _cartItems) {
        if (cartItem.product.id == event.product.id) {
          cartItem.quantity += event.productCount;
          alreadyInCart = true;
          break;
        }
      }

      if (!alreadyInCart) {
        _cartItems.add(CartItem(event.product, event.productCount));
      }
      emit(CartLoaded(_cartItems));
    }
  }

  void _updateCartItemCount(
      UpdateCartItemCount event, Emitter<CartState> emit) {
    _cartItems.clear();

    for (var product in event.products) {
      int quantity = 0;

      for (var newProduct in event.products) {
        if (newProduct.id == product.id) {
          quantity++;
        }
      }

      _cartItems.add(CartItem(product, quantity));
    }

    emit(CartLoaded(_cartItems));
  }

  void _placeOrder(PlaceOrder event, Emitter<CartState> emit) async {
    emit(CartPlacingOrder());

    // Simulate a loading delay
    await Future.delayed(Duration(seconds: 2));

    // Clear the cart items after placing an order
    _cartItems.clear();

    emit(CartLoaded([]));
  }
}
