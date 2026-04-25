import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../core/services/database_service.dart';

class MarketplaceState {
  final int selectedTab;
  final List<ProductModel> allProducts;
  final List<ProductModel> filteredProducts;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final String sortOption;

  const MarketplaceState({
    this.selectedTab = 0,
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.sortOption = '',
  });

  MarketplaceState copyWith({
    int? selectedTab,
    List<ProductModel>? allProducts,
    List<ProductModel>? filteredProducts,
    bool? isLoading,
    String? error,
    String? searchQuery,
    String? sortOption,
  }) {
    return MarketplaceState(
      selectedTab: selectedTab ?? this.selectedTab,
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}

class MarketplaceNotifier extends Notifier<MarketplaceState> {
  final DatabaseService _db = DatabaseService();

  @override
  MarketplaceState build() {
    Future.microtask(() => loadProducts());
    return const MarketplaceState();
  }

  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final products = await _db.getAllProducts();
      
      state = state.copyWith(
        isLoading: false,
        allProducts: products,
      );
      _applyFilters();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void selectTab(int index) {
    state = state.copyWith(selectedTab: index);
    _applyFilters();
  }

  void search(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  void setSortOption(String option) {
    state = state.copyWith(sortOption: option);
    _applyFilters();
  }

  void _applyFilters() {
    List<ProductModel> filtered = List.of(state.allProducts);
    
    // Tab filtering: 0 = Fungicide, 1 = Fertiliser, 2 = Pesticide
    String tabCategory = '';
    if (state.selectedTab == 0) {
      tabCategory = 'fungicide';
    } else if (state.selectedTab == 1) tabCategory = 'fertiliser';
    else if (state.selectedTab == 2) tabCategory = 'pesticide';
    
    if (tabCategory.isNotEmpty) {
      filtered = filtered.where((p) => p.category.toLowerCase() == tabCategory).toList();
    }
    
    // Search query filtering
    if (state.searchQuery.trim().isNotEmpty) {
      final q = state.searchQuery.trim().toLowerCase();
      filtered = filtered.where((p) {
        return p.name.toLowerCase().contains(q) ||
               p.brandName.toLowerCase().contains(q) ||
               p.category.toLowerCase().contains(q) ||
               p.alsoKnownAs.any((a) => a.toLowerCase().contains(q)) ||
               p.targetDiseases.any((d) => d.toLowerCase().contains(q));
      }).toList();
    }
    // Sorting
    if (state.sortOption == 'price_low') {
      filtered.sort((a, b) => a.pricePerUnit.compareTo(b.pricePerUnit));
    } else if (state.sortOption == 'price_high') {
      filtered.sort((a, b) => b.pricePerUnit.compareTo(a.pricePerUnit));
    }

    state = state.copyWith(filteredProducts: filtered);
  }
}

final marketplaceProvider = NotifierProvider<MarketplaceNotifier, MarketplaceState>(() {
  return MarketplaceNotifier();
});
