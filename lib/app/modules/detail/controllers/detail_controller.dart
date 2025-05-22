import 'package:get/get.dart';

class DetailController extends GetxController {
  var quantity = 1.obs;

  void increment() {
    quantity.value++;
  }

  void decrement() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void addToCart(Map<String, dynamic> product) {
    // Simulasi penambahan ke keranjang
    Get.snackbar("Berhasil", "${product['title']} ditambahkan sebanyak ${quantity.value} ke keranjang");
  }
}
