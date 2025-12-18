import 'package:get/get.dart';
import 'package:mechine_test/controller/auth_controller.dart';
import 'package:mechine_test/controller/cart_controller.dart';
import 'package:mechine_test/controller/checkout_controller.dart';
import 'package:mechine_test/controller/home_screen_controller.dart';
import 'package:mechine_test/controller/myorder_controller.dart';
import 'package:mechine_test/controller/product_controller.dart';
import 'package:mechine_test/controller/profile_controller.dart';
import 'package:mechine_test/controller/splash_controller.dart';
import 'package:mechine_test/roots/approot.dart';
import 'package:mechine_test/view/cart_screen.dart';
import 'package:mechine_test/view/checkout_screen.dart';
import 'package:mechine_test/view/home_screen.dart';
import 'package:mechine_test/view/login_screen.dart';
import 'package:mechine_test/view/myorder_screen.dart';
import 'package:mechine_test/view/productdetails_screen.dart';
import 'package:mechine_test/view/profile_screen.dart';
import 'package:mechine_test/view/signup_screen.dart';
import 'package:mechine_test/view/splash_screen.dart';
import 'package:mechine_test/widgets/ordersuccess_screen.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: BindingsBuilder(() {
        Get.put(SplashController());
      }),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupPage(),
      binding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: BindingsBuilder(() {
        Get.put(HomeController());
        Get.put(CartController());
      }),
    ),
    GetPage(
      name: AppRoutes.productDetails,
      page: () => const ProductDetailsPage(),
      binding: BindingsBuilder(() {
        Get.put(ProductController());
        Get.put(CartController());
      }),
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartPage(),
      binding: BindingsBuilder(() {
        Get.put(CartController());
      }),
    ),
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutPage(),
      binding: BindingsBuilder(() {
        Get.put(CheckoutController());
        Get.put(CartController());
      }),
    ),
    GetPage(name: AppRoutes.orderSuccess, page: () => const OrderSuccessPage()),
    GetPage(
      name: AppRoutes.myOrders,
      page: () => const MyOrdersPage(),
      binding: BindingsBuilder(() {
        Get.put(OrderController());
      }),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
      binding: BindingsBuilder(() {
        Get.put(ProfileController());
      }),
    ),
    // GetPage(
    //   name: AppRoutes.categoryProducts,
    //   page: () => const CategoryProductsPage(),
    // ),
    // GetPage(
    //   name: AppRoutes.search,
    //   page: () => const SearchPage(),
    // ),
  ];
}
