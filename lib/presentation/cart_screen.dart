import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store/data/bloc/cart_bloc.dart';
import 'package:fake_store/data/model/cart_item.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  CartScreen({required this.cartItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    double totalCartPrice = 0.0;

    // Calculate the total cart price
    for (final cartItem in widget.cartItems) {
      totalCartPrice += cartItem.product.price * cartItem.quantity;
    }

    return BlocProvider(
      create: (context) => CartBloc(),
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartPlacingOrder) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Cart'),
              ),
              body: Center(
                child:
                    CircularProgressIndicator(), // Show circular progress when placing order
              ),
            );
          } else if (state is CartLoaded) {
            if (state.cartItems.isEmpty) {
              // Cart is empty, show the "Add something to cart" message
              return Scaffold(
                appBar: AppBar(
                  title: Text('Cart'),
                ),
                body: Center(
                  child: Text('Add something to cart'),
                ),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text('Cart'),
                ),
                body: Container(
                  color: Colors.grey[200],
                  child: ListView.separated(
                    padding: EdgeInsets.all(8.0),
                    itemCount: state.cartItems.length,
                    separatorBuilder: (context, index) => SizedBox(height: 8.0),
                    itemBuilder: (context, index) {
                      final cartItem = state.cartItems[index];
                      return Card(
                        color: Colors.white,
                        child: ListTile(
                          leading: Image.network(cartItem.product.image),
                          title: Text(cartItem.product.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Price: \$${cartItem.product.price.toStringAsFixed(2)}'),
                              Text('Quantity: ${cartItem.quantity}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                floatingActionButton: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Total Price: \$${totalCartPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              //context.read<CartBloc>().add(PlaceOrder());
                              BlocProvider.of<CartBloc>(context)
                                  .add(PlaceOrder());
                            },
                            child: Text('Buy'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          } else {
            // Default state, show the initial cart content
            return Scaffold(
              appBar: AppBar(
                title: Text('Cart'),
              ),
              body: Container(
                color: Colors.grey[200],
                child: ListView.separated(
                  padding: EdgeInsets.all(8.0),
                  itemCount: widget.cartItems.length,
                  separatorBuilder: (context, index) => SizedBox(height: 8.0),
                  itemBuilder: (context, index) {
                    final cartItem = widget.cartItems[index];
                    return Card(
                      color: Colors.white,
                      child: ListTile(
                        leading: Image.network(cartItem.product.image),
                        title: Text(cartItem.product.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Price: \$${cartItem.product.price.toStringAsFixed(2)}'),
                            Text('Quantity: ${cartItem.quantity}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Total Price: \$${totalCartPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.read<CartBloc>().add(PlaceOrder());
                          },
                          child: Text('Buy'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
