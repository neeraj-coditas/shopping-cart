import 'package:fake_store/data/bloc/cart_bloc.dart';
import 'package:fake_store/data/bloc/product_bloc.dart';
import 'package:fake_store/presentation/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:fake_store/data/repository/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashBoard(),
    );
  }
}

class DashBoard extends StatefulWidget {
  DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    final ProductRepository repository = ProductRepository();
    final drawerHeader = Container(
      height: 200.0,
      child: Center(
        child: FlutterLogo(size: 100.0),
      ),
    );

    final drawerItems = ListView(
      children: [
        drawerHeader,
        ListTile(
          leading: Icon(Icons.home),
          title: const Text('Shopping'),
          onTap: () {
            Navigator.pop(context);
            // Navigate to shopping view
          },
        ),
        Divider(color: Colors.black), // Add a separator line
        ListTile(
          leading: Icon(Icons.shopping_cart),
          title: const Text('Cart'),
          onTap: () {
            Navigator.pop(context);
            // Navigate to cart view
          },
        ),
        Divider(color: Colors.black), // Add a separator line
        ListTile(
          leading: Icon(Icons.history),
          title: const Text('Orders'),
          onTap: () {
            Navigator.pop(context);
            // Navigate to orders/history view
          },
        ),
        Divider(color: Colors.black),
      ],
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductBloc(repository)
            ..add(
              FetchProducts(),
            ),
        ),
        BlocProvider(
          create: (context) => CartBloc(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Blipkart'),
          centerTitle: true,
          actions: [
            BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state is CartLoaded) {
                  int cartItemCount = state.cartItems.length;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Open cart view
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CartScreen(cartItems: state.cartItems)));
                        },
                        icon: Icon(Icons.shopping_cart),
                      ),
                      Positioned(
                        right: 3,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: Text(
                            '$cartItemCount',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.shopping_cart),
                );
              },
            )
          ],
        ),
        drawer: Drawer(
          child: drawerItems,
        ),
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              return ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return Card(
                    margin: EdgeInsets.all(10.0),
                    elevation: 4.0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150.0,
                          width: 150.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(product.image),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                product.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 16.0),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 30.0,
                                        height: 30.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          iconSize: 18.0,
                                          icon: Icon(Icons.remove),
                                          onPressed: () {
                                            context.read<ProductBloc>().add(
                                                DecrementProductCount(
                                                    product.id));
                                          },
                                        ),
                                      ),
                                      BlocBuilder<ProductBloc, ProductState>(
                                        builder: (context, state) {
                                          if (state is ProductLoaded) {
                                            final productCount =
                                                state.productCounts[
                                                        product.id] ??
                                                    0;
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text(
                                                '$productCount',
                                                style: const TextStyle(
                                                    fontSize: 16.0),
                                              ),
                                            );
                                          }
                                          return SizedBox.shrink();
                                        },
                                      ),
                                      Container(
                                        width: 30.0,
                                        height: 30.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          iconSize: 18.0,
                                          icon: Icon(Icons.add),
                                          onPressed: () {
                                            context.read<ProductBloc>().add(
                                                IncrementProductCount(
                                                    product.id));
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 10.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        final productCount =
                                            state.productCounts[product.id] ??
                                                0;
                                        context.read<CartBloc>().add(
                                            AddToCart(product, productCount));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 16.0),
                                        backgroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      child: const Text(
                                        'Add',
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is ProductError) {
              return const Center(child: Text('Error loading products'));
            } else {
              return const Center(child: Text('No data'));
            }
          },
        ),
      ),
    );
  }
}
