import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;

  const CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      name: name,
      price: price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl,
    );
  }
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(() {
  return CartNotifier();
});

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() => [];

  void addItem(CartItem item) {
    final index = state.indexWhere((element) => element.id == item.id);
    if (index >= 0) {
      final updatedList = List<CartItem>.from(state);
      updatedList[index] = updatedList[index].copyWith(
        quantity: updatedList[index].quantity + item.quantity,
      );
      state = updatedList;
    } else {
      state = [...state, item];
    }
  }

  void updateQuantity(String id, int quantity) {
    if (quantity <= 0) {
      removeItem(id);
      return;
    }
    state = state.map((item) {
      if (item.id == id) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();
  }

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  double get total => state.fold(0, (sum, item) => sum + (item.price * item.quantity));
}
