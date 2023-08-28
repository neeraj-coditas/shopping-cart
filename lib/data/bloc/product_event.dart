part of 'product_bloc.dart';

sealed class ProductEvent {}


class FetchProducts extends ProductEvent{}

class IncrementProductCount extends ProductEvent{
  final int productId;

  IncrementProductCount(this.productId);
}

class DecrementProductCount extends ProductEvent{
  final int productId;

  DecrementProductCount(this.productId);
}
