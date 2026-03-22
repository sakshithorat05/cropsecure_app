import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';

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
  @override
  MarketplaceState build() {
    Future.microtask(() => loadProducts());
    return const MarketplaceState();
  }

  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Simulate network request
      await Future.delayed(const Duration(milliseconds: 800));
      
      final dummyProducts = [
        const ProductModel(
          id: 'p1',
          name: 'Blue Copper',
          brandName: 'Brand A',
          category: 'Fungicide',
          imageUrls: [],
          pricePerUnit: 550,
          unitLabel: 'per kg',
          weightOrVolume: 1,
          weightUnit: 'kg',
          inStock: true,
          rating: 4.5,
          reviewCount: 320,
          alsoKnownAs: ['Copper Oxychloride 50% WP'],
          targetDiseases: ['Leaf Spot', 'Canker', 'Late Blight'],
          safetyInstructions: 'Use gloves and mask during application. Avoid spraying on windy days.',
          dosagePerAcre: 2.5,
          dosageUnit: 'kg',
          relatedProductIds: ['p2', 'p3'],
        ),
        const ProductModel(
          id: 'p2',
          name: 'Trichoderma',
          brandName: 'Brand B',
          category: 'Fungicide',
          imageUrls: [],
          pricePerUnit: 250,
          unitLabel: 'per kg',
          weightOrVolume: 1,
          weightUnit: 'kg',
          inStock: true,
          rating: 4.8,
          reviewCount: 150,
          alsoKnownAs: ['Trichoderma Viride Powder'],
          targetDiseases: ['Root Rot', 'Wilt'],
          safetyInstructions: 'Keep away from direct sunlight. Do not mix with chemical fungicides.',
          dosagePerAcre: 1.0,
          dosageUnit: 'kg',
          relatedProductIds: ['p1'],
        ),
        const ProductModel(
          id: 'p3',
          name: 'Psuedomonas',
          brandName: 'Brand C',
          category: 'Fungicide',
          imageUrls: [],
          pricePerUnit: 250,
          unitLabel: 'per kg',
          weightOrVolume: 1,
          weightUnit: 'kg',
          inStock: false,
          rating: 4.3,
          reviewCount: 89,
          alsoKnownAs: ['Pseudomonas fluorescens'],
          targetDiseases: ['Blight', 'Wilt'],
          safetyInstructions: 'Store in cool place. Use within 6 months of manufacture.',
          dosagePerAcre: 1.5,
          dosageUnit: 'kg',
          relatedProductIds: ['p2'],
        ),
        const ProductModel(
          id: 'f1',
          name: 'Urea',
          brandName: 'Brand X',
          category: 'Fertiliser',
          imageUrls: [],
          pricePerUnit: 250,
          unitLabel: 'per 50kg bag',
          weightOrVolume: 50,
          weightUnit: 'kg',
          inStock: true,
          rating: 4.6,
          reviewCount: 500,
          alsoKnownAs: ['Nitrogen 46%'],
          targetDiseases: [],
          safetyInstructions: 'Apply to soil, avoid direct leaf contact.',
          dosagePerAcre: 50.0,
          dosageUnit: 'kg',
          relatedProductIds: [],
        ),
      ];

      state = state.copyWith(
        isLoading: false,
        allProducts: dummyProducts,
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
    if (state.selectedTab == 0) tabCategory = 'fungicide';
    else if (state.selectedTab == 1) tabCategory = 'fertiliser';
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
