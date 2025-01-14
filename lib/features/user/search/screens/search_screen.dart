import 'package:flutter/material.dart';
import 'package:shopez/features/user/search/screens/searched_products.dart';
import 'package:shopez/features/user/search/services/search_services.dart';
import 'package:shopez/models/product.dart';


class SearchScreen extends StatefulWidget {
  static const String routeName = '/search-screen';

  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Product>? products;
  final SearchServices searchServices = SearchServices();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Optionally, you can fetch initial product list or suggestions here
  }

  fetchSearchedProduct(String searchQuery) async {
    products = await searchServices.fetchSearchedProduct(
        context: context, searchQuery: searchQuery);
    setState(() {});
  }

  void onSearchSubmitted(String query) {
    fetchSearchedProduct(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(

          automaticallyImplyLeading: false, // This hides the default back button
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              // gradient: GlobalVariables.appBarGradient,
              color: Colors.white
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 30,bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 42,
                    margin: const EdgeInsets.only(left: 10),
                    child: Material(
                      borderRadius: BorderRadius.circular(15),
                      elevation: 1,
                      child: TextFormField(
                        controller: _searchController,
                        onFieldSubmitted: onSearchSubmitted,
                        decoration: InputDecoration(
                          prefixIcon: InkWell(
                            onTap: () {
                              Navigator.pop(context); // This will pop the screen when back arrow is tapped
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                                size: 23,
                              ),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.only(top: 10),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(1),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            borderSide: BorderSide(
                              color: Colors.black38,
                              width: 1,
                            ),
                          ),
                          hintText: 'Search Products',
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: products == null
          ? Container()
          : Column(
              children: [
                // const AddressBox(),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: products!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Navigator.pushNamed(
                          //   context,
                          //   ProductDetailScreen.routeName,
                          //   arguments: products![index],
                          // );
                        },
                        child: SearchedProduct(
                          product: products![index],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}



// class OrderSearchScreen extends StatefulWidget {
//   static const String routeName = '/order-search-screen';

//   const OrderSearchScreen({Key? key}) : super(key: key);

//   @override
//   State<OrderSearchScreen> createState() => _OrderSearchScreenState();
// }

// class _OrderSearchScreenState extends State<OrderSearchScreen> {
//   List<Order>? orders;
//   final SearchServices searchServices = SearchServices();
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//   }

//   fetchSearchedOrder(String searchQuery) async {
//     orders = await searchServices.fetchSearchedOrders(
//         context: context, searchQuery: searchQuery);
//     setState(() {});
//   }

//   void onSearchSubmitted(String query) {
//     fetchSearchedOrder(query);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(70),
//         child: AppBar(
//           automaticallyImplyLeading: false,
//           flexibleSpace: Container(
//             decoration: const BoxDecoration(
//               color: Colors.white,
//             ),
//           ),
//           title: Padding(
//             padding: const EdgeInsets.only(top: 30, bottom: 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Container(
//                     height: 42,
//                     margin: const EdgeInsets.only(left: 10),
//                     child: Material(
//                       borderRadius: BorderRadius.circular(15),
//                       elevation: 1,
//                       child: TextFormField(
//                         controller: _searchController,
//                         onFieldSubmitted: onSearchSubmitted,
//                         decoration: InputDecoration(
//                           prefixIcon: InkWell(
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                             child: const Padding(
//                               padding: EdgeInsets.only(left: 6),
//                               child: Icon(
//                                 Icons.arrow_back,
//                                 color: Colors.black,
//                                 size: 23,
//                               ),
//                             ),
//                           ),
//                           filled: true,
//                           fillColor: Colors.white,
//                           contentPadding: const EdgeInsets.only(top: 10),
//                           border: const OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(1),
//                             ),
//                             borderSide: BorderSide.none,
//                           ),
//                           enabledBorder: const OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(15),
//                             ),
//                             borderSide: BorderSide(
//                               color: Colors.black38,
//                               width: 1,
//                             ),
//                           ),
//                           hintText: 'Search orders',
//                           hintStyle: const TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 17,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: orders == null
//           ? Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 const SizedBox(height: 10),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: orders!.length,
//                     itemBuilder: (context, index) {
//                       return SearchedOrder(
//                         order: orders![index],
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }