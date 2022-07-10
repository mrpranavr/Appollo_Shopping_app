import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping/models/http_exception.dart';
import 'dart:convert';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Jacket',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://i.pinimg.com/originals/54/ee/47/54ee47a91ef0d10cece4ed09197ab030.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Blue Shirt',
    //   description: 'Care Instructions:\n- Machine Wash\n'
    //       '-Fit Type: Regular Fit\n'
    //       '-Wash Care: Machine Wash\n'
    //       '-Fabric Type: cotton\n'
    //       '-Pattern name: Solid\n'
    //       '-Closure Type: Buttoned\n'
    //       '-Sleeve Type: short sleeve; Collar Style: Chinese Collar\n',
    //   price: 59.99,
    //   imageUrl:
    //       'https://img3.junaroad.com/uiproducts/13989269/pri_175_p-1502361440.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Mens Hoodie',
    //   description: 'Care Instructions:\n-Machine Wash\n'
    //       '-Fit Type: Regular Fit\n'
    //       '-Main Material: 100% Cotton , 320Gsm (Bio-Washed & Pre-Shrunk For Minimum Shrinkage)\n'
    //       '-Actual Products Color May Vary With Product Due To Monitor Settings\n'
    //       '-Wash Care: Machine Wash Cold, Tumble Dry Low, Do Not Bleach. Check Our Size Chart To Get Your Best Fit\n'
    //       '-Sleeve Type: Full Sleeve Sweatshirts, Neck Type: Hooded Sweatshirt, Fitting Type: Regular Fit Hoodies, Occasion: Casual\n',
    //   price: 19.99,
    //   imageUrl:
    //       'https://i.pinimg.com/originals/47/b6/29/47b629ea05e0440d8f46cfaac6daa36d.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Mens Jacket',
    //   description:
    //       'Care Instructions:\n-Do Not Iron;\n-Hand Wash\n-Fit Type: Regular Fit\n-Fabric: 100% Nylon\n-Wash Care: Do Not Iron; Hand Wash\n-Style: Bomber Jacket; Pattern: Quilted\n-Closure: Buttoned; Occasion: Casual',
    //   price: 49.99,
    //   imageUrl:
    //       'https://images-na.ssl-images-amazon.com/images/I/51ylk6F0rfL._AC_UY741_.jpg',
    // ),
  ];
  var _showFavouritesOnly = false;

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    // if (_showFavouritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavourite).toList();
    // }
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((element) => element.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavouritesOnly() {
  //   _showFavouritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavouritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts() async {
    var url = Uri.https('Enter firebase server link here', '/products.json',
        {'auth': '$authToken'});
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url = Uri.https('Enter firebase server link here',
          '/userFavourites/$userId.json', {'auth': '$authToken'});
      final favouriteResponse = await http.get(url);
      final favouritedata = json.decode(favouriteResponse.body);
      final List<Product> loadedProduct = [];
      extractedData.forEach((prodId, prodData) {
        loadedProduct.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavourite:
                favouritedata == null ? false : favouritedata[prodId] ?? false,
          ),
        );
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.https('Enter firebase server link here', '/products.json',
        {'auth': '$authToken'});
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        }),
      );
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);

      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      // print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.https('Enter firebase server link here',
          '/products/$id.json', {'auth': '$authToken'});
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('....');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.https('Enter firebase server link here',
        '/products/$id.json', {'auth': '$authToken'});
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }
}
