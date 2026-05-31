import 'package:shoply/feature/home/controller/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:shoply/core/model/response/category_response.dart';
import 'package:shoply/core/model/response/product_response.dart';
import 'package:shoply/core/common/widget/product_item_widget.dart';
import 'package:shoply/feature/home/widgets/tab_container_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = 'HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = HomeCubit.get(context);
    cubit.getCategories();
    cubit.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text.rich(
                    const TextSpan(
                      text: 'Hi !,\n',
                      style: TextStyle(
                        color: Color(0xff212121),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(
                          text: 'Lets start your shopping',
                          style: TextStyle(
                            color: Color(0xff212121),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Categories",
                    style: TextStyle(
                      color: Color(0xff212121),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  
                  // عرض الفئات
                  if (state is HomeCategoryLoading) ...[
                    Skeletonizer(
                      enabled: true,
                      child: TabContainerWidget(
                        categories: List.generate(
                          5,
                          (index) => CategoryResponse(
                            id: index,
                            name: 'Loading Category',
                            image: 'https://via.placeholder.com/100',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ] else if (state is HomeCategoryError) ...[
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 32,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Error loading categories",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else if (cubit.categories.isNotEmpty) ...[
                    TabContainerWidget(categories: cubit.categories),
                    const SizedBox(height: 16),
                  ],

                  // عنوان المنتجات
                  const Text(
                    "Products",
                    style: TextStyle(
                      color: Color(0xff212121),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // عرض المنتجات
                  if (state is HomeProductLoading) ...[
                    Expanded(
                      child: Skeletonizer(
                        enabled: true,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: 4,
                          itemBuilder: (context, index) => ProductItemWidget(
                            product: ProductResponse(
                              id: index,
                              title: 'Loading Product Name Placeholder',
                              price: 1500,
                              images: ['https://via.placeholder.com/150'],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ] else if (state is HomeProductError) ...[
                    const Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Error loading products",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else if (cubit.products.isNotEmpty) ...[
                    Expanded(
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: cubit.products.length,
                        itemBuilder: (context, index) => ProductItemWidget(
                          product: cubit.products[index],
                        ),
                      ),
                    ),
                  ] else ...[
                    const Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "No products available",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}