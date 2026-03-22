import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartNotifier extends Notifier<List<CartItemModel>> {
  @override
  List<CartItemModel> build() => [];

  void addItem(ProductModel product) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      final updatedList = List<CartItemModel>.from(state);
      updatedList[index] = updatedList[index].copyWith(
        quantity: updatedList[index].quantity + 1,
      );
      state = updatedList;
    } else {
      state = [...state, CartItemModel(product: product, quantity: 1)];
    }
  }

  void removeItem(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void increment(String productId) {
    state = state.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: item.quantity + 1);
      }
      return item;
    }).toList();
  }

  void decrement(String productId) {
    final index = state.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      final item = state[index];
      if (item.quantity > 1) {
        final updatedList = List<CartItemModel>.from(state);
        updatedList[index] = item.copyWith(quantity: item.quantity - 1);
        state = updatedList;
      } else {
        removeItem(productId);
      }
    }
  }

  void clearCart() {
    state = [];
  }

  int quantityOf(String productId) {
    final index = state.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      return state[index].quantity;
    }
    return 0;
  }

  double get totalAmount {
    return state.fold(0, (sum, item) => sum + item.totalPrice);
  }
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItemModel>>(() {
  return CartNotifier();
});
