import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply/core/data/local_data/cart_local_data.dart';
import 'package:shoply/core/model/response/product_response.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  static CartCubit get(context) => BlocProvider.of(context);

  List<ProductResponse> cartProducts = [];
  double totalPrice = 0.0;

  Future<void> getCartProducts() async {
    emit(CartLoading());
    try {
      final cartLocalData = await CartLocalData.instance;
      cartProducts = await cartLocalData.getCart();
      calculateTotalPrice();
      emit(CartSuccess());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> addToCart(ProductResponse product) async {
    try {
      final cartLocalData = await CartLocalData.instance;
      
      int existingIndex = cartProducts.indexWhere((item) => item.id == product.id);
      
      if (existingIndex != -1) {
        // المنتج موجود بالفعل - زيادة الكمية فقط
        cartProducts[existingIndex].quantity++;
        await cartLocalData.updateToCart(cartProducts[existingIndex]);
        calculateTotalPrice();
        // إرسال حالة واحدة فقط
        emit(ProductAddedToCart("Product quantity increased"));
      } else {
        // منتج جديد - إضافته
        product.quantity = 1;
        await cartLocalData.addToCart(product);
        cartProducts.add(product);
        calculateTotalPrice();
        // إرسال حالة واحدة فقط
        emit(ProductAddedToCart("Product added to cart"));
      }
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> increaseQuantity(ProductResponse product) async {
    try {
      final cartLocalData = await CartLocalData.instance;
      product.quantity++;
      await cartLocalData.updateToCart(product);
      calculateTotalPrice();
      emit(CartSuccess());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> decreaseQuantity(ProductResponse product) async {
    try {
      final cartLocalData = await CartLocalData.instance;
      if (product.quantity > 1) {
        product.quantity--;
        await cartLocalData.updateToCart(product);
        calculateTotalPrice();
        emit(CartSuccess());
      }
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> removeFromCart(ProductResponse product) async {
    try {
      final cartLocalData = await CartLocalData.instance;
      await cartLocalData.deleteToCart(product.id!);
      cartProducts.removeWhere((item) => item.id == product.id);
      calculateTotalPrice();
      emit(CartSuccess());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> clearCart() async {
    try {
      final cartLocalData = await CartLocalData.instance;
      await cartLocalData.clearCart();
      cartProducts.clear();
      totalPrice = 0.0;
      emit(CartSuccess());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void calculateTotalPrice() {
    totalPrice = 0.0;
    for (var product in cartProducts) {
      totalPrice += (product.price ?? 0) * product.quantity;
    }
  }

  bool isInCart(int productId) {
    return cartProducts.any((product) => product.id == productId);
  }

  int getProductQuantity(int productId) {
    final product = cartProducts.firstWhere(
      (product) => product.id == productId,
      orElse: () => ProductResponse(quantity: 0),
    );
    return product.quantity;
  }
}