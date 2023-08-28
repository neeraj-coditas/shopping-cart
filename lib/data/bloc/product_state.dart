part of 'product_bloc.dart';

sealed class ProductState {}

final class ProductInitial extends ProductState {}

class ProductLoading extends ProductState{}

class ProductLoaded extends ProductState{
  final List<Product> products;
  final Map<int,int> productCounts;

  ProductLoaded(this.products,this.productCounts);

}

class ProductError extends ProductState{
  final String error;

  ProductError(this.error);
}
