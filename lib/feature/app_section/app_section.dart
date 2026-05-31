// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shoply/feature/cart/controller/cart_cubit.dart';
// import 'package:shoply/feature/cart/view/cart_screen.dart';
// import 'package:shoply/feature/favorite/controller/favorite_cubit.dart';
// import 'package:shoply/feature/favorite/view/favorite_screen.dart';
// import 'package:shoply/feature/home/controller/home_cubit.dart';
// import 'package:shoply/feature/home/view/home_screen.dart';
// import 'package:shoply/feature/profile/controller/profile_cubit.dart';
// import 'package:shoply/feature/profile/view/profile_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// class AppSection extends StatefulWidget {
//   static const String routeName = 'InitApp';
//   const AppSection({super.key});

//   @override
//   State<AppSection> createState() => _AppSectionState();
// }

// class _AppSectionState extends State<AppSection> {
//   int index = 0;

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<HomeCubit>(
//           create: (context) => HomeCubit()
//             ..getCategories()
//             ..getProducts(),
//         ),
//         BlocProvider<CartCubit>(
//           create: (context) => CartCubit()..getCartProducts(),
//         ),
//         BlocProvider<FavoriteCubit>(
//           create: (context) => FavoriteCubit()..getFavoriteProducts(),
//         ),
//         BlocProvider<ProfileCubit>(
//           create: (context) => ProfileCubit()
//             ..getDataProfile(
//                 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjY2LCJpYXQiOjE3NTk5NDUwNjUsImV4cCI6MTc2MTY3MzA2NX0.8pSD6qXPQuQzt3Tc49K-DtVqCVqcjItdBNCi0jI1W0g'),
//         ),
//       ],
//       child: Scaffold(
//         backgroundColor: const Color(0xffEBEBEB),
//         bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
//           builder: (context, cartState) {
//             return BlocBuilder<FavoriteCubit, FavoriteState>(
//               builder: (context, favoriteState) {
//                 final cartCubit = CartCubit.get(context);
//                 final favoriteCubit = FavoriteCubit.get(context);

//                 return BottomNavigationBar(
//                   backgroundColor: const Color(0xffEBEBEB),
//                   unselectedFontSize: 13,
//                   selectedFontSize: 14,
//                   selectedItemColor: const Color(0xff212121),
//                   unselectedItemColor: const Color(0xff5C5C5C),
//                   type: BottomNavigationBarType.fixed,
//                   showSelectedLabels: true,
//                   selectedLabelStyle: const TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 16,
//                     color: Color(0xff212121),
//                   ),
//                   unselectedLabelStyle: const TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 15,
//                     color: Color(0xff5C5C5C),
//                   ),
//                   currentIndex: index,
//                   onTap: (selectedIndex) {
//                     setState(() {
//                       index = selectedIndex;
//                     });
//                   },
//                   items: [
//                     BottomNavigationBarItem(
//                       icon: SvgPicture.asset(
//                         'assets/icons/icon-home.svg',
//                         height: 23,
//                         width: 23,
//                         fit: BoxFit.cover,
//                         color: index == 0
//                             ? const Color(0xff212121)
//                             : const Color(0xff5C5C5C),
//                       ),
//                       label: 'Home',
//                     ),
//                     BottomNavigationBarItem(
//                       icon: Stack(
//                         children: [
//                           SvgPicture.asset(
//                             'assets/icons/icon-cart.svg',
//                             height: 23,
//                             width: 23,
//                             fit: BoxFit.cover,
//                             color: index == 1
//                                 ? const Color(0xff212121)
//                                 : const Color(0xff5C5C5C),
//                           ),
//                           if (cartCubit.cartProducts.isNotEmpty)
//                             Positioned(
//                               right: 0,
//                               top: 0,
//                               child: Container(
//                                 padding: const EdgeInsets.all(2),
//                                 decoration: BoxDecoration(
//                                   color: Colors.red,
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 constraints: const BoxConstraints(
//                                   minWidth: 16,
//                                   minHeight: 16,
//                                 ),
//                                 child: Text(
//                                   '${cartCubit.cartProducts.length}',
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                       label: 'Cart',
//                     ),
//                     BottomNavigationBarItem(
//                       icon: Stack(
//                         children: [
//                           SvgPicture.asset(
//                             'assets/icons/icon-favourite.svg',
//                             height: 23,
//                             width: 23,
//                             fit: BoxFit.cover,
//                             color: index == 2
//                                 ? const Color(0xff212121)
//                                 : const Color(0xff5C5C5C),
//                           ),
//                           if (favoriteCubit.favoriteProducts.isNotEmpty)
//                             Positioned(
//                               right: 0,
//                               top: 0,
//                               child: Container(
//                                 padding: const EdgeInsets.all(2),
//                                 decoration: BoxDecoration(
//                                   color: Colors.red,
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 constraints: const BoxConstraints(
//                                   minWidth: 16,
//                                   minHeight: 16,
//                                 ),
//                                 child: Text(
//                                   '${favoriteCubit.favoriteProducts.length}',
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                       label: 'Favorite',
//                     ),
//                     BottomNavigationBarItem(
//                       icon: SvgPicture.asset(
//                         'assets/icons/icon-profile.svg',
//                         height: 23,
//                         width: 23,
//                         fit: BoxFit.cover,
//                         color: index == 3
//                             ? const Color(0xff212121)
//                             : const Color(0xff5C5C5C),
//                       ),
//                       label: 'Profile',
//                     ),
//                   ],
//                 );
//               },
//             );
//           },
//         ),
//         body: SafeArea(
//           child: IndexedStack(
//             index: index,
//             children: [
//               BlocProvider<HomeCubit>(
//                 create: (context) => HomeCubit()
//                   ..getCategories()
//                   ..getProducts(),
//                 child: const HomeScreen(),
//               ),
//               const CartScreen(),
//               const FavoriteScreen(),
//               BlocProvider<ProfileCubit>(
//                 create: (context) => ProfileCubit()
//                   ..getDataProfile(
//                       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjY2LCJpYXQiOjE3NTk5NDUwNjUsImV4cCI6MTc2MTY3MzA2NX0.8pSD6qXPQuQzt3Tc49K-DtVqCVqcjItdBNCi0jI1W0g'),
//                 child: ProfileScreen(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply/feature/cart/controller/cart_cubit.dart';
import 'package:shoply/feature/cart/view/cart_screen.dart';
import 'package:shoply/feature/favorite/controller/favorite_cubit.dart';
import 'package:shoply/feature/favorite/view/favorite_screen.dart';
import 'package:shoply/feature/home/controller/home_cubit.dart';
import 'package:shoply/feature/home/view/home_screen.dart';
import 'package:shoply/feature/profile/controller/profile_cubit.dart';
import 'package:shoply/feature/profile/view/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shoply/core/storage_helper/app_shared_preference_helper.dart';

class AppSection extends StatefulWidget {
  static const String routeName = 'InitApp';
  const AppSection({super.key});

  @override
  State<AppSection> createState() => _AppSectionState();
}

class _AppSectionState extends State<AppSection> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit()
            ..getCategories()
            ..getProducts(),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit()
            ..getDataProfile(
                SharedPreferencesHelper.getData(key: 'accessToken') as String? ?? ''),
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xffEBEBEB),
        bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
          builder: (context, cartState) {
            return BlocBuilder<FavoriteCubit, FavoriteState>(
              builder: (context, favoriteState) {
                final cartCubit = CartCubit.get(context);
                final favoriteCubit = FavoriteCubit.get(context);
                return BottomNavigationBar(
                  backgroundColor: const Color(0xffEBEBEB),
                  unselectedFontSize: 13,
                  selectedFontSize: 14,
                  selectedItemColor: const Color(0xff212121),
                  unselectedItemColor: const Color(0xff5C5C5C),
                  type: BottomNavigationBarType.fixed,
                  showSelectedLabels: true,
                  selectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xff212121),
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Color(0xff5C5C5C),
                  ),
                  currentIndex: index,
                  onTap: (selectedIndex) {
                    setState(() {
                      index = selectedIndex;
                    });
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/icons/icon-home.svg',
                        height: 23,
                        width: 23,
                        fit: BoxFit.cover,
                        color: index == 0
                            ? const Color(0xff212121)
                            : const Color(0xff5C5C5C),
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Stack(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/icon-cart.svg',
                            height: 23,
                            width: 23,
                            fit: BoxFit.cover,
                            color: index == 1
                                ? const Color(0xff212121)
                                : const Color(0xff5C5C5C),
                          ),
                          if (cartCubit.cartProducts.isNotEmpty)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '${cartCubit.cartProducts.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                      label: 'Cart',
                    ),
                    BottomNavigationBarItem(
                      icon: Stack(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/icon-favourite.svg',
                            height: 23,
                            width: 23,
                            fit: BoxFit.cover,
                            color: index == 2
                                ? const Color(0xff212121)
                                : const Color(0xff5C5C5C),
                          ),
                          if (favoriteCubit.favoriteProducts.isNotEmpty)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '${favoriteCubit.favoriteProducts.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                      label: 'Favorite',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/icons/icon-profile.svg',
                        height: 23,
                        width: 23,
                        fit: BoxFit.cover,
                        color: index == 3
                            ? const Color(0xff212121)
                            : const Color(0xff5C5C5C),
                      ),
                      label: 'Profile',
                    ),
                  ],
                );
              },
            );
          },
        ),
        body: SafeArea(
          child: IndexedStack(
            index: index,
            children: [
              const HomeScreen(),
              const CartScreen(),
              const FavoriteScreen(),
              ProfileScreen(),
            ],
          ),
        ),
      ),
    );
  }
}