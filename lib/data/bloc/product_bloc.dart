import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fake_store/data/model/product.dart';
import 'package:fake_store/data/repository/product_repository.dart';
import 'package:flutter/material.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc(this.repository) : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<IncrementProductCount>(_onIncrementProductCount);
    on<DecrementProductCount>(_onDecrementProductCount);
  }

  void _onFetchProducts(FetchProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());

    try {
      final List<Product> products = await repository.getProducts();
      final Map<int, int> productCounts = {}; // Initialize counts
      for (final product in products) {
        productCounts[product.id] = 0;
      }

      emit(ProductLoaded(products, productCounts));
    } catch (error) {
      emit(ProductError('Error loading products'));
    }
  }

  void _onIncrementProductCount(
      IncrementProductCount event, Emitter<ProductState> emit) {
    //Get the current state
    final currentState = state as ProductLoaded;

    //Update the product count for a specific product

    final upadtedCount = Map<int, int>.from(currentState.productCounts);
    final productId = event.productId;
    
    upadtedCount[productId] = (upadtedCount[productId] ?? 0) + 1;

    emit(ProductLoaded(currentState.products, upadtedCount));
  }

  void _onDecrementProductCount(
      DecrementProductCount event, Emitter<ProductState> emit) {
    final currentState = state as ProductLoaded;

    final updatedCount = Map<int, int>.from(currentState.productCounts);

    final productId = event.productId;

    if (updatedCount[productId] != null && updatedCount[productId]! > 0) {
      updatedCount[productId] = updatedCount[productId]! - 1;
    }
    emit(ProductLoaded(currentState.products, updatedCount));
  }
}
