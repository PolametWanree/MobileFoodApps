import 'package:flutter/material.dart';
import 'package:pj/shopping_cart_page.dart';
import '../pages/search.dart';
import '../database/model.dart';
import 'package:pj/shopping_cart_page.dart';
// Import Firebase
import '../database/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProductUserScreen extends StatefulWidget {
  ProductUserScreen({Key? key, required this.dbHelper, required this.userEmail})
      : super(key: key);

  final DatabaseHelper dbHelper;
  final String userEmail; // Add userEmail as a parameter



  @override
  _ProductUserScreenState createState() => _ProductUserScreenState();
}



class _ProductUserScreenState extends State<ProductUserScreen> {
  List<Product> products = [];
  List<Product> selectedItems = []; // List to store selected items

  // Variable to store the total
  double total = 0;
  
  void resetCart() {
    setState(() {
      selectedItems.clear();
      calculateTotal(); // Recalculate the total (should be zero now)
    });
  }


void addToCart(Product product) {
  setState(() {
    // Check if the product is already in the cart
    int index = selectedItems.indexWhere((item) => item.referenceId == product.referenceId);

    if (index != -1) {
      // If the product is in the cart, increase its quantity
      selectedItems[index].quantity++;
    } else {
      // If the product is not in the cart, add it with a quantity of 1
      product.quantity = 1;
      selectedItems.add(product);
    }

    calculateTotal(); // Recalculate the total
  });
}



  // Function to calculate the total
  void calculateTotal() {
  total = 0;
  for (var product in selectedItems) {
    total += (product.price * product.quantity);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
       
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SearchProduct(
                    dbHelper: widget.dbHelper,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.search_outlined),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ShoppingCartPage(
                    selectedItems: selectedItems,
                    resetCart: resetCart,
                    userEmail: widget.userEmail, // Pass userEmail
                    total: total,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart),
          ),
          
        ],

        title: const Text('รายการอาหาร'),
        backgroundColor: Colors.amber,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: widget.dbHelper.getStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          products.clear();
          for (var element in snapshot.data!.docs) {
            products.add(Product(
                name: element.get('name'),
                description: element.get('description'),
                price: element.get('price'),
                quantity: element.get('quantity'),
                favorite: element.get('favorite'),
                referenceId: element.id));
          }
          return ListView(
            children: products.map((product) {
              return Card(
                child: ListTile(
                  title: Text(product.name),
                  subtitle: Text(
                    'Price: ${product.price.toString()}, Quantity: ${product.quantity.toString()}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailScreen(productdetail: product),
                            ),
                          );
                          setState(() {
                            if (result != null) {
                              product.favorite = result;
                              widget.dbHelper.updateProduct(product);
                            }
                          });
                        },
                        icon: Icon(
                          product.favorite == 1
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: product.favorite == 1 ? Colors.red : null,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          addToCart(product); // Implement addToCart function
                        },
                        icon: Icon(Icons.shopping_cart_checkout_outlined), // Use a shopping cart icon
                      )
                    ],
                  ),

                ),
              );
            }).toList(),
          ).animate().fadeIn().scale().move(delay: 300.ms, duration: 300.ms);
        },
      ),
       
    );
  }
}


// Rest of your code...


class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key, required this.productdetail}) : super(key: key);

  final Product productdetail;

  @override
  Widget build(BuildContext context) {
    var result = productdetail.favorite;
    return Scaffold(
      appBar: AppBar(
        title: Text(productdetail.name),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(10),
            child: Text(productdetail.description),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 10, top: 20.0),
            child: Text('Price: ${productdetail.price.toString()}'),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 10, top: 20.0),
            child: Text('Quantity: ${productdetail.quantity.toString()}'),
          ),
          Container(
            padding: const EdgeInsets.only(top: 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(120, 40),
                      primary: productdetail.favorite == 1
                          ? Colors.blueGrey
                          : Colors.redAccent),
                  child: productdetail.favorite == 1
                      ? const Text('Unfavorite')
                      : const Text('Favorite'),
                  onPressed: () {
                    result = productdetail.favorite == 1 ? 0 : 1;
                    Navigator.pop(context, result);
                  },
                ),
                ElevatedButton(
                  child: const Text('Close'),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(120, 40),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ModalProductForm {
  //
  // *** Edit #3 *** => parameter of ModalProductForm
  //
  ModalProductForm({Key? key, required this.dbHelper});

  DatabaseHelper dbHelper;

  String _name = '', _description = '';
  double _price = 0;
  double _quantity = 0;
  final int _favorite = 0;

  Future<dynamic> showModalInputForm(BuildContext context) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ListTile(
                  title: Center(
                    child: Text(
                      'Product input Form',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: TextFormField(
                        initialValue: '',
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'Product Name',
                          hintText: 'input your name of product',
                        ),
                        onChanged: (value) {
                          _name = value;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: TextFormField(
                        initialValue: '',
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'input description of product',
                        ),
                        onChanged: (value) {
                          _description = value;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: TextFormField(
                        initialValue: '0.00',
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          hintText: 'input price',
                        ),
                        onChanged: (value) {
                          _price = double.parse(value);
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: TextFormField(
                        initialValue: '0.00',
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                          hintText: 'input quantity',
                        ),
                        onChanged: (value) {
                          _quantity = double.parse(value);
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: ElevatedButton(
                          child: const Text('Add'),
                          onPressed: () async {
                            //
                            // *** Edit #4 *** => add product here
                            //
                         var newProduct = Product(
  name: _name,
  description: _description,
  price: _price,
  quantity: _quantity, // Include the quantity parameter
  favorite: _favorite,
  referenceId: null,
);

                            await dbHelper.insertProduct(newProduct).then(
                              (value) {
                                newProduct.referenceId = value.id;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${newProduct.name} is inserted complete...'),
                                  ),
                                  );
                              }
                              );

                            Navigator.pop(context);
                          }),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

//
// *** Edit #10 *** => Add new class modal form for updating
//

class ModalEditProductForm {
  ModalEditProductForm(
    {Key? key, required this.dbHelper, required this.editedProduct});

  DatabaseHelper dbHelper;
  Product editedProduct;

  String _name = '', _description = '';
  double _price = 0;
  double _quantity = 0;
  int _favorite = 0;
  String? _referenceId;

  Future<dynamic> showModalInputForm(BuildContext context) {
    _name =editedProduct.name;
    _description =editedProduct.description;
    _price = editedProduct.price;
    _favorite = editedProduct.favorite;
    _quantity =editedProduct.quantity;
    _referenceId = editedProduct.referenceId;

    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ListTile(
                  title: Center(
                    child: Text(
                      'Product input Form',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: TextFormField(
                        initialValue: _name,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'Product Name',
                          hintText: 'input your name of product',
                        ),
                        onChanged: (value) {
                          _name = value;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: TextFormField(
                        initialValue: _description,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'input description of product',
                        ),
                        onChanged: (value) {
                          _description = value;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: TextFormField(
                        initialValue: _price.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          hintText: 'input price',
                        ),
                        onChanged: (value) {
                          _price = double.parse(value);
                        },
                      ),
                    ),
                       Container(
                      margin: const EdgeInsets.all(15),
                      child: TextFormField(
                        initialValue: _quantity.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                          hintText: 'input quantity',
                        ),
                        onChanged: (value) {
                          _quantity = double.parse(value);
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: ElevatedButton(
                          child: const Text('Update'),
                          onPressed: () async {
                          var newProduct = Product(
  name: _name,
  description: _description,
  price: _price,
  quantity: _quantity, // Include the quantity parameter
  favorite: _favorite,
  referenceId: _referenceId,
);
                            dbHelper.updateProduct(newProduct);
                            Navigator.pop(context);
                          }),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
  //ต่อ
