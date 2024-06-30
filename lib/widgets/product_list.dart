import 'package:flutter/material.dart';
import 'package:shopping_app/global_variables.dart';
import 'package:shopping_app/widgets/product_card.dart';
import 'package:shopping_app/pages/products_details_page.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final List<String> filters = const ["All", "Addidas", "Nike", "Bata"];

  late String selectedFilter;
  late String searchedText = "";

  @override
  void initState() {
    super.initState();
    selectedFilter = filters[0];
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, Object>> visibleProducts = [];
    if (searchedText != "") {
      visibleProducts = products
          .where((product) => product["title"]
              .toString()
              .toLowerCase()
              .contains(searchedText.toLowerCase()))
          .toList();
    } else if (selectedFilter != "All") {
      visibleProducts = products
          .where((product) => product["company"] == selectedFilter)
          .toList();
    } else {
      visibleProducts = products;
    }
    final size = MediaQuery.of(context).size;
    const border = OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromRGBO(225, 225, 225, 1),
        ),
        borderRadius: BorderRadius.horizontal(left: Radius.circular(50)));
    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Shoes \nCollection",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                  child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchedText = value;
                  });
                },
                decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border),
              )),
            ],
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = filters[index];
                      });
                    },
                    child: Chip(
                      backgroundColor: selectedFilter == filters[index]
                          ? Theme.of(context).colorScheme.primary
                          : Color.fromRGBO(245, 247, 249, 1),
                      label: Text(filters[index]),
                      labelStyle: TextStyle(fontSize: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      side: BorderSide(color: Color.fromRGBO(50, 86, 121, 1)),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: size.width > 1080
                ? GridView.builder(
                    itemCount: visibleProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 1.75),
                    itemBuilder: (context, index) {
                      final product = visibleProducts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return ProductsDetailsPage(product: product);
                          }));
                        },
                        child: ProductCard(
                          title: product["title"] as String,
                          price: product["price"] as double,
                          image: product["imageUrl"] as String,
                          backgroundColor: index.isEven
                              ? Color.fromRGBO(216, 240, 253, 1)
                              : Color.fromRGBO(245, 247, 249, 1),
                        ),
                      );
                    })
                : ListView.builder(
                    itemBuilder: (context, index) {
                      final product = visibleProducts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return ProductsDetailsPage(product: product);
                          }));
                        },
                        child: ProductCard(
                          title: product["title"] as String,
                          price: product["price"] as double,
                          image: product["imageUrl"] as String,
                          backgroundColor: index.isEven
                              ? Color.fromRGBO(216, 240, 253, 1)
                              : Color.fromRGBO(245, 247, 249, 1),
                        ),
                      );
                    },
                    itemCount: visibleProducts.length,
                  ),
          )
        ],
      ),
    );
  }
}
