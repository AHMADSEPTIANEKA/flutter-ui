import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(const ExstoreApp());
}

class ExstoreApp extends StatelessWidget {
  const ExstoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EXSTORE SHOP',
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: ScrollBehavior().copyWith(overscroll: false),
          child: child!,
        );
      },
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.grey[900],
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: EdgeInsets.zero,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class Product {
  final String name;
  final double price;
  double rating;
  final String category;
  final String? assetImage;
  final Uint8List? imageBytes;
  final List<Color> availableColors;
  final String description;
  Color? selectedColor;
  int quantity;

  Product({
    required this.name,
    required this.price,
    required this.rating,
    required this.category,
    this.assetImage,
    this.imageBytes,
    required this.availableColors,
    required this.description,
    this.selectedColor,
    this.quantity = 1,
  });
}

List<Product> allProducts = [];
List<Product> cartItems = [];
List<Product> favoriteItems = [];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const FavoritePage(),
    const CartPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addProduct(Product product) {
    setState(() {
      allProducts.add(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('EXSTORE SHOP'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: ProductSearchDelegate());
            },
          ),
        ],
      ),
      drawer: isWideScreen ? null : _buildDrawer(context),
      body: _pages[_selectedIndex],
      bottomNavigationBar: isWideScreen ? null : _buildBottomNavigationBar(),
      floatingActionButton:
          isWideScreen ? _buildFloatingActionButton(context) : null,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.deepPurple.withOpacity(0.3),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.deepPurple),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add, color: Colors.deepPurple),
            title: const Text('Input Product'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => InputProductPage(onProductAdded: _addProduct),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.deepPurple),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(Navigator.of(context).context).showSnackBar(
                const SnackBar(
                  content: Text("Logged out"),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
          ],
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => InputProductPage(onProductAdded: _addProduct),
          ),
        );
      },
      backgroundColor: Colors.deepPurple,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    final isTablet = MediaQuery.of(context).size.width > 600;

    List<Product> filteredProducts =
        selectedCategory == 'All'
            ? allProducts
            : allProducts
                .where((product) => product.category == selectedCategory)
                .toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal:
                  isDesktop
                      ? 60
                      : isTablet
                      ? 40
                      : 24,
              vertical: isDesktop ? 30 : 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discover the most\nmodern tech',
                  style: TextStyle(
                    fontSize:
                        isDesktop
                            ? 36
                            : isTablet
                            ? 30
                            : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Find the best gadgets for your needs',
                  style: TextStyle(
                    fontSize:
                        isDesktop
                            ? 20
                            : isTablet
                            ? 18
                            : 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal:
                    isDesktop
                        ? 60
                        : isTablet
                        ? 40
                        : 16,
              ),
              children: [
                SizedBox(width: isDesktop ? 20 : 8),
                _buildCategoryButton('All'),
                _buildCategoryButton('Laptop'),
                _buildCategoryButton('Accessories'),
                _buildCategoryButton('Controller'),
                SizedBox(width: isDesktop ? 20 : 8),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  isDesktop
                      ? 60
                      : isTablet
                      ? 40
                      : 16,
            ),
            child:
                filteredProducts.isEmpty
                    ? _buildEmptyState()
                    : _buildProductGrid(isDesktop, isTablet, filteredProducts),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(
    bool isDesktop,
    bool isTablet,
    List<Product> products,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            isDesktop
                ? 4
                : isTablet
                ? 3
                : 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: isDesktop ? 0.7 : 0.75,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product, context, isDesktop);
      },
    );
  }

  Widget _buildCategoryButton(String title) {
    final bool isSelected = selectedCategory == title;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.deepPurple,
          ),
        ),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            selectedCategory = title;
          });
        },
        selectedColor: Colors.deepPurple,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? Colors.deepPurple : Colors.grey[300]!,
          ),
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  Widget _buildProductCard(
    Product product,
    BuildContext context,
    bool isDesktop,
  ) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailPage(product: product)),
          ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Container(
                height: isDesktop ? 180 : 120,
                width: double.infinity,
                color: Colors.grey[100],
                child: _buildProductImage(product),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: isDesktop ? 16 : 14,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$${product.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: isDesktop ? 18 : 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildProductRatingRow(product),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(Product product) {
    return kIsWeb
        ? (product.imageBytes != null
            ? Image.memory(product.imageBytes!, fit: BoxFit.contain)
            : const Icon(Icons.broken_image, size: 60, color: Colors.grey))
        : (product.assetImage != null
            ? Image.asset(
              product.assetImage!,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.broken_image,
                  size: 60,
                  color: Colors.grey,
                );
              },
            )
            : const Icon(Icons.broken_image, size: 60, color: Colors.grey));
  }

  Widget _buildProductRatingRow(Product product) {
    return Row(
      children: [
        Icon(Icons.star, color: Colors.amber[600], size: 16),
        const SizedBox(width: 4),
        Text(
          product.rating.toString(),
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        const Spacer(),
        IconButton(
          icon: Icon(
            favoriteItems.contains(product)
                ? Icons.favorite
                : Icons.favorite_border,
            color: favoriteItems.contains(product) ? Colors.red : Colors.grey,
            size: 18,
          ),
          onPressed: () => _toggleFavorite(product, context),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  void _toggleFavorite(Product product, BuildContext context) {
    setState(() {
      if (favoriteItems.contains(product)) {
        favoriteItems.remove(product);
        ScaffoldMessenger.of(
          Navigator.of(context).context,
        ).showSnackBar(const SnackBar(content: Text("Removed from favorites")));
      } else {
        favoriteItems.add(product);
        if (product.rating < 5.0) {
          product.rating += 0.1;
          product.rating = double.parse(product.rating.toStringAsFixed(1));
        }
        ScaffoldMessenger.of(
          Navigator.of(context).context,
        ).showSnackBar(const SnackBar(content: Text("Added to favorites")));
      }
    });
  }
}

class ProductSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text("Start typing to search products"));
    }

    final results =
        allProducts
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return _buildSearchResult(results, context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text("Type product name..."));
    }

    final suggestions =
        allProducts
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return _buildSearchResult(suggestions, context);
  }

  Widget _buildSearchResult(List<Product> results, BuildContext context) {
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text('No matching products found.'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 60,
                height: 60,
                color: Colors.grey[100],
                child:
                    kIsWeb
                        ? (product.imageBytes != null
                            ? Image.memory(
                              product.imageBytes!,
                              fit: BoxFit.cover,
                            )
                            : const Icon(Icons.broken_image))
                        : (product.assetImage != null
                            ? Image.asset(
                              product.assetImage!,
                              fit: BoxFit.cover,
                            )
                            : const Icon(Icons.broken_image)),
              ),
            ),
            title: Text(product.name),
            subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              close(context, null);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DetailPage(product: product)),
              );
            },
          ),
        );
      },
    );
  }
}

class DetailPage extends StatefulWidget {
  final Product product;
  const DetailPage({super.key, required this.product});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Color? selectedColor;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.product.availableColors.first;
    quantity = 1;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            icon: Icon(
              favoriteItems.contains(product)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: favoriteItems.contains(product) ? Colors.red : null,
            ),
            onPressed: () => _toggleFavorite(context),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                children: [
                  Container(
                    height: isDesktop ? 400 : 300,
                    width: double.infinity,
                    color: Colors.grey[100],
                    child: _buildProductImage(product),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 60 : 24,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProductHeader(product, isDesktop),
                        const SizedBox(height: 16),
                        _buildProductDescription(product),
                        const SizedBox(height: 24),
                        _buildColorSelection(product),
                        const SizedBox(height: 24),
                        _buildQuantitySelector(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _buildAddToCartButton(product),
    );
  }

  Widget _buildProductImage(Product product) {
    return kIsWeb
        ? (product.imageBytes != null
            ? Image.memory(product.imageBytes!, fit: BoxFit.contain)
            : const Icon(Icons.broken_image, size: 100, color: Colors.grey))
        : (product.assetImage != null
            ? Image.asset(
              product.assetImage!,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.broken_image,
                  size: 100,
                  color: Colors.grey,
                );
              },
            )
            : const Icon(Icons.broken_image, size: 100, color: Colors.grey));
  }

  Widget _buildProductHeader(Product product, bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                product.name,
                style: TextStyle(
                  fontSize: isDesktop ? 28 : 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.deepPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                product.category,
                style: const TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isDesktop ? 24 : 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.star, color: Colors.amber[600]),
            const SizedBox(width: 4),
            Text(
              product.rating.toString(),
              style: TextStyle(
                fontSize: isDesktop ? 18 : 16,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductDescription(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          product.description,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildColorSelection(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Colors',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children:
              product.availableColors.map((color) {
                return GestureDetector(
                  onTap: () => setState(() => selectedColor = color),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                      border: Border.all(
                        color:
                            selectedColor == color
                                ? Colors.deepPurple
                                : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quantity',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    if (quantity > 1) quantity--;
                  });
                },
                icon: const Icon(Icons.remove),
              ),
              SizedBox(
                width: 40,
                child: Center(
                  child: Text(
                    quantity.toString(),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (quantity < widget.product.quantity) {
                      quantity++;
                    } else {
                      ScaffoldMessenger.of(
                        Navigator.of(context).context,
                      ).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Maximum quantity is ${widget.product.quantity}",
                          ),
                        ),
                      );
                    }
                  });
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddToCartButton(Product product) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () => _addToCart(product),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text("ADD TO CART", style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  void _toggleFavorite(BuildContext context) {
    setState(() {
      if (widget.product.assetImage == null &&
          widget.product.imageBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product image is missing")),
        );
        return;
      }

      if (!favoriteItems.contains(widget.product)) {
        favoriteItems.add(widget.product);
        if (widget.product.rating < 5.0) {
          widget.product.rating += 0.1;
          widget.product.rating = double.parse(
            widget.product.rating.toStringAsFixed(1),
          );
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Added to favorites")));
      } else {
        favoriteItems.remove(widget.product);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Removed from favorites")));
      }
    });
  }

  void _addToCart(Product product) {
    setState(() {
      if (selectedColor == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Please select a color")));
        return;
      }

      if (product.assetImage == null && product.imageBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product image is missing")),
        );
        return;
      }

      if (!cartItems.contains(product)) {
        product.selectedColor = selectedColor;
        product.quantity = quantity;
        cartItems.add(product);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Added to cart"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Already in cart"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),
      body:
          cartItems.isEmpty
              ? _buildEmptyCartState()
              : _buildCartContent(isDesktop),
    );
  }

  Widget _buildEmptyCartState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text("Your cart is empty", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            "Add some products to your cart",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(bool isDesktop) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(isDesktop ? 24 : 16),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final product = cartItems[index];
              return _buildCartItem(product, isDesktop);
            },
          ),
        ),
        _buildCheckoutSection(),
      ],
    );
  }

  Widget _buildCartItem(Product product, bool isDesktop) {
    return Dismissible(
      key: Key(product.name),
      background: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.red),
      ),
      onDismissed: (direction) {
        setState(() {
          cartItems.remove(product);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${product.name} removed from cart"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: isDesktop ? 80 : 60,
              height: isDesktop ? 80 : 60,
              color: Colors.grey[100],
              child:
                  kIsWeb
                      ? (product.imageBytes != null
                          ? Image.memory(product.imageBytes!, fit: BoxFit.cover)
                          : const Icon(Icons.broken_image))
                      : (product.assetImage != null
                          ? Image.asset(product.assetImage!, fit: BoxFit.cover)
                          : const Icon(Icons.broken_image)),
            ),
          ),
          title: Text(
            product.name,
            style: TextStyle(
              fontSize: isDesktop ? 18 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("\$${product.price.toStringAsFixed(2)}"),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: product.selectedColor,
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text("Qty: ${product.quantity}"),
                ],
              ),
            ],
          ),
          trailing: Text(
            "\$${(product.price * product.quantity).toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isDesktop ? 18 : 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "\$${cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity)).toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Checkout completed!"),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text("CHECKOUT"),
            ),
          ),
        ],
      ),
    );
  }
}

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body:
          favoriteItems.isEmpty
              ? _buildEmptyFavoritesState()
              : _buildFavoritesList(isDesktop),
    );
  }

  Widget _buildEmptyFavoritesState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text("No favorites yet", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            "Tap the heart icon to add favorites",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(bool isDesktop) {
    return ListView.builder(
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      itemCount: favoriteItems.length,
      itemBuilder: (context, index) {
        final product = favoriteItems[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: isDesktop ? 80 : 60,
                height: isDesktop ? 80 : 60,
                color: Colors.grey[100],
                child:
                    kIsWeb
                        ? (product.imageBytes != null
                            ? Image.memory(
                              product.imageBytes!,
                              fit: BoxFit.cover,
                            )
                            : const Icon(Icons.broken_image))
                        : (product.assetImage != null
                            ? Image.asset(
                              product.assetImage!,
                              fit: BoxFit.cover,
                            )
                            : const Icon(Icons.broken_image)),
              ),
            ),
            title: Text(
              product.name,
              style: TextStyle(
                fontSize: isDesktop ? 18 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                favoriteItems.remove(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Removed from favorites"),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DetailPage(product: product)),
              );
            },
          ),
        );
      },
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Removed unnecessary context getter

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: isDesktop ? 250 : 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.deepPurple[700]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: isDesktop ? 70 : 50,
                      backgroundImage: const AssetImage(
                        'assets/images/profile_placeholder.png',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Eka",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "eka@example.com",
                      style: TextStyle(
                        fontSize: 16,
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(isDesktop ? 32 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAboutMeCard(),
                  const SizedBox(height: 16),
                  _buildAccountSettings(isDesktop),
                  const SizedBox(height: 24),
                  _buildLogoutButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutMeCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "About Me",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Hi, I'm Eka. Welcome to my profile! I love exploring modern tech and gadgets.",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSettings(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Account Settings",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Edit Profile"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text("Notifications"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text("Security"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Logged out"),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[50],
          foregroundColor: Colors.red,
        ),
        child: const Text("Logout"),
      ),
    );
  }
}

class InputProductPage extends StatefulWidget {
  final Function(Product) onProductAdded;
  const InputProductPage({super.key, required this.onProductAdded});

  @override
  State<InputProductPage> createState() => _InputProductPageState();
}

class _InputProductPageState extends State<InputProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;
  File? _selectedImage;
  Uint8List? _selectedImageBytes;
  final List<Color> _selectedColors = [];
  int _quantity = 1;

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        if (kIsWeb) {
          setState(() {
            _selectedImageBytes = result.files.single.bytes;
          });
        } else {
          setState(() {
            _selectedImage = File(result.files.single.path!);
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error picking image: $e");
      }
    }
  }

  void _submitProduct() {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null && _selectedImageBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select an image"),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      if (_selectedColors.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select at least one color"),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final newProduct = Product(
        name: _nameController.text,
        price: double.parse(_priceController.text),
        rating: 0.0,
        category: _selectedCategory ?? "Uncategorized",
        assetImage: kIsWeb ? null : _selectedImage?.path,
        imageBytes: kIsWeb ? _selectedImageBytes : null,
        availableColors: _selectedColors,
        description: _descriptionController.text,
        quantity: _quantity,
      );

      widget.onProductAdded(newProduct);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Product added successfully!"),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    }
  }

  Widget _buildImagePreview() {
    if (kIsWeb) {
      if (_selectedImageBytes == null) {
        return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.image, size: 40, color: Colors.grey),
              const SizedBox(height: 8),
              Text("No image", style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        );
      }
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(
          _selectedImageBytes!,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
      );
    } else {
      if (_selectedImage == null) {
        return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.image, size: 40, color: Colors.grey),
              const SizedBox(height: 8),
              Text("No image", style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        );
      }
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          _selectedImage!,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
      );
    }
  }

  Widget _buildColorPicker() {
    final List<Color> availableColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.black,
      Colors.white,
      Colors.purple,
      Colors.orange,
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          availableColors.map((color) {
            final isSelected = _selectedColors.contains(color);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedColors.remove(color);
                  } else if (_selectedColors.length < 3) {
                    _selectedColors.add(color);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Maximum 3 colors selected"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  border: Border.all(
                    color: isSelected ? Colors.deepPurple : Colors.grey[300]!,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child:
                    isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
              ),
            );
          }).toList(),
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                if (_quantity > 1) _quantity--;
              });
            },
            icon: const Icon(Icons.remove),
          ),
          SizedBox(
            width: 40,
            child: Center(
              child: Text(
                _quantity.toString(),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                if (_quantity < 10) {
                  _quantity++;
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Maximum quantity is 10"),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              });
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(title: const Text("Add New Product")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductInfoCard(),
              const SizedBox(height: 16),
              _buildDescriptionCard(),
              const SizedBox(height: 16),
              _buildColorsCard(),
              const SizedBox(height: 16),
              _buildQuantityCard(),
              const SizedBox(height: 16),
              _buildImageCard(),
              const SizedBox(height: 24),
              _buildSubmitButton(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Product Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Product Name",
                prefixIcon: Icon(Icons.shopping_bag),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter the product name";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: "Price",
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter the price";
                }
                if (double.tryParse(value) == null) {
                  return "Please enter a valid number";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: "Category",
                prefixIcon: Icon(Icons.category),
              ),
              items: const [
                DropdownMenuItem(value: "Laptop", child: Text("Laptop")),
                DropdownMenuItem(
                  value: "Accessories",
                  child: Text("Accessories"),
                ),
                DropdownMenuItem(
                  value: "Controller",
                  child: Text("Controller"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please select a category";
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Product Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: "Description",
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a description";
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Product Colors",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("Select up to 3 colors:"),
            const SizedBox(height: 16),
            _buildColorPicker(),
            const SizedBox(height: 8),
            if (_selectedColors.isNotEmpty)
              Text(
                "Selected: ${_selectedColors.length}/3",
                style: TextStyle(color: Colors.grey[600]),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Product Quantity",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildQuantitySelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Product Image",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text("Select Image"),
                ),
                const SizedBox(width: 16),
                _buildImagePreview(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitProduct,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text("SUBMIT PRODUCT", style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
