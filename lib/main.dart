import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shoply/core/common/screens/product_details_screen.dart';
import 'package:shoply/core/model/response/product_response.dart';
import 'package:shoply/core/storage_helper/app_shared_preference_helper.dart';
import 'package:shoply/feature/app_section/app_section.dart';
import 'package:shoply/feature/auth/view/login_screen.dart';
import 'package:shoply/feature/auth/view/register_screen.dart';
import 'package:shoply/feature/cart/controller/cart_cubit.dart';
import 'package:shoply/feature/favorite/controller/favorite_cubit.dart';
import 'package:shoply/feature/home/view/product_of_category_screen.dart';
import 'package:shoply/feature/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:shoply/core/dialogs/app_toasts.dart';
import 'package:shoply/feature/auth/controller/login/login_cubit.dart';
import 'package:shoply/feature/auth/controller/register/register_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper.init();
  await Hive.initFlutter();
  Hive.registerAdapter<ProductResponse>(ProductResponseAdapter());
  runApp(const Shoply());
}

class Shoply extends StatelessWidget {
  const Shoply({super.key});

  @override
  Widget build(BuildContext context) {
    final bool onboardingSeen =
        SharedPreferencesHelper.getData(key: 'onboarding_seen') as bool? ??
            false;
    final String? accessToken =
        SharedPreferencesHelper.getData(key: 'accessToken') as String?;

    String initialRoute;
    if (!onboardingSeen) {
      initialRoute = OnboardingScreen.routeName;
    } else if (accessToken == null || accessToken.isEmpty || accessToken == 'null') {
      initialRoute = LoginScreen.routeName;
    } else {
      initialRoute = AppSection.routeName;
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<CartCubit>(
          create: (context) => CartCubit()..getCartProducts(),
          lazy: false,
        ),
        BlocProvider<FavoriteCubit>(
          create: (context) => FavoriteCubit()..getFavoriteProducts(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "User App",
        initialRoute: initialRoute,
        builder: (context, child) {
          return ToastificationWrapper(
            child: MultiBlocListener(
              listeners: [
                BlocListener<CartCubit, CartState>(
                  listener: (context, state) {
                    if (state is ProductAddedToCart) {
                      AppToast.showToast(
                        context: context,
                        title: "Cart",
                        description: state.message,
                        type: ToastificationType.success,
                      );
                    }
                  },
                ),
                BlocListener<FavoriteCubit, FavoriteState>(
                  listener: (context, state) {
                    if (state is ProductAddedToFavorite) {
                      AppToast.showToast(
                        context: context,
                        title: "Favorite",
                        description: state.message,
                        type: ToastificationType.success,
                      );
                    } else if (state is ProductRemovedFromFavorite) {
                      AppToast.showToast(
                        context: context,
                        title: "Favorite",
                        description: state.message,
                        type: ToastificationType.warning,
                      );
                    }
                  },
                ),
              ],
              child: child!,
            ),
          );
        },
        routes: {
          OnboardingScreen.routeName: (context) => const OnboardingScreen(),
          LoginScreen.routeName: (context) => BlocProvider(
                create: (context) => LoginCubit(),
                child: const LoginScreen(),
              ),
          RegisterScreen.routeName: (context) => BlocProvider(
                create: (context) => RegisterCubit(),
                child: RegisterScreen(),
              ),
          AppSection.routeName: (context) => const AppSection(),
          ProductOfCategoryScreen.routeName: (context) =>
              const ProductOfCategoryScreen(),
          ProductDetailsScreen.routeName: (context) =>
              const ProductDetailsScreen.screen(),
        },
      ),
    );
  }
}
