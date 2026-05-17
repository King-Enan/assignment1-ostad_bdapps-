import 'package:flutter/material.dart';
import 'add_product_screen.dart';
import 'update_product_screen.dart';

class ProductHomeScreen extends StatefulWidget {
  const ProductHomeScreen({super.key});

  @override
  State<ProductHomeScreen> createState() => _ProductHomeScreenState();
}

class _ProductHomeScreenState extends State<ProductHomeScreen> {
  final List<Map<String, dynamic>> products = [];

  bool sortLowToHigh = true;

  double get totalQuantity {
    double total = 0;
    for (final product in products) {
      total += product['quantity'] as double;
    }
    return total;
  }

  int get lowStockCount {
    return products.where((product) => (product['quantity'] as double) < 10).length;
  }

  Future<void> goToAddProductPage() async {
    final Map<String, dynamic>? newProduct = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddProductScreen(),
      ),
    );

    if (newProduct == null) {
      return;
    }

    setState(() {
      products.add(newProduct);
    });
  }

  Future<void> goToUpdateProductPage(int index) async {
    final Map<String, dynamic>? updatedProduct = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProductScreen(
          product: Map<String, dynamic>.from(products[index]),
        ),
      ),
    );

    if (updatedProduct == null) {
      return;
    }

    setState(() {
      products[index] = updatedProduct;
    });
  }

  void deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  void sortProductsByQuantity() {
    setState(() {
      products.sort((a, b) {
        final double quantityA = a['quantity'] as double;
        final double quantityB = b['quantity'] as double;

        if (sortLowToHigh) {
          return quantityA.compareTo(quantityB);
        }
        return quantityB.compareTo(quantityA);
      });

      sortLowToHigh = !sortLowToHigh;
    });
  }

  String formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Shop Product Manager',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF168A42), Color(0xFF41C86B)],
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Inventory Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _overviewBox(
                          title: 'Products',
                          value: products.length.toString(),
                          icon: Icons.inventory_2_outlined,
                        ),
                      ),
                      const SizedBox(width: 10),

                      Expanded(
                        child: _overviewBox(
                          title: 'Low Stock',
                          value: lowStockCount.toString(),
                          icon: Icons.warning_amber_rounded,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: goToAddProductPage,
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Product Add'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: sortProductsByQuantity,
                    icon: const Icon(Icons.sort),
                    label: Text(
                      sortLowToHigh ? 'Sort Low to High' : 'Sort High to Low',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(color: Colors.green),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: products.isEmpty
                  ? _emptyProductView()
                  : ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> product = products[index];
                        final double quantity = product['quantity'] as double;
                        final bool isLowStock = quantity < 10;

                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.only(bottom: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isLowStock
                                    ? Colors.red.withOpacity(0.30)
                                    : Colors.green.withOpacity(0.30),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: isLowStock
                                          ? Colors.red[50]
                                          : Colors.green[50],
                                      child: Icon(
                                        Icons.shopping_cart_outlined,
                                        color: isLowStock ? Colors.red : Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        product['name'].toString(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                _productInfoRow(
                                  icon: Icons.payments_outlined,
                                  title: 'Price Per Unit',
                                  value:
                                      '৳${formatNumber(product['price'] as double)}',
                                  valueColor: Colors.black87,
                                ),
                                const SizedBox(height: 8),
                                _productInfoRow(
                                  icon: Icons.inventory_outlined,
                                  title: 'Product Quantity',
                                  value: '${formatNumber(quantity)} kg',
                                  valueColor: isLowStock ? Colors.red : Colors.green,
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () => goToUpdateProductPage(index),
                                        icon: const Icon(Icons.edit),
                                        label: const Text('Update'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.blue,
                                          side: const BorderSide(color: Colors.blue),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () => deleteProduct(index),
                                        icon: const Icon(Icons.delete),
                                        label: const Text('Delete'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.red,
                                          side: const BorderSide(color: Colors.red),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _overviewBox({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _productInfoRow({
    required IconData icon,
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Text(
          '$title: ',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _emptyProductView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.storefront_outlined, size: 80, color: Colors.green[200]),
          const SizedBox(height: 12),
          const Text(
            'No products added yet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap Product Add to create your first product map.',
            style: TextStyle(color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
