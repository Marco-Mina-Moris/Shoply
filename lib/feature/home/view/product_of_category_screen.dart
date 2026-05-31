import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:shoply/core/model/response/product_response.dart';
import 'package:shoply/core/common/widget/product_item_widget.dart';
import 'package:shoply/core/model/response/category_response.dart';
import 'package:shoply/feature/home/controller/home_cubit.dart';

class ProductOfCategoryScreen extends StatefulWidget {
  static const String routeName = 'ProductOfCategoryScreen';
  const ProductOfCategoryScreen({super.key});

  @override
  State<ProductOfCategoryScreen> createState() => _ProductOfCategoryScreenState();
}

class _ProductOfCategoryScreenState extends State<ProductOfCategoryScreen> {
  late HomeCubit cubit;
  CategoryResponse? category;

  @override
  void initState() {
    super.initState();
    cubit = HomeCubit.get(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (category == null) {
      category = ModalRoute.of(context)?.settings.arguments as CategoryResponse?;
      if (category != null) {
        // تحميل منتجات هذه الفئة
        cubit.getProductsOfCategory(category!.id.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEBEBEB),
      appBar: AppBar(
        backgroundColor: const Color(0xffEBEBEB),
        title: Text(
          category?.name ?? 'Products',
          style: const TextStyle(
            color: Color(0xff212121),
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeProductOfCategoryLoading) {
            return Skeletonizer(
              enabled: true,
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
            );
          } else if (state is HomeProductOfCategoryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.messageError,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (category != null) {
                        cubit.getProductsOfCategory(category!.id.toString());
                      }
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          } else if (cubit.productsOfCategory.isEmpty) {
            return const Center(
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
                    'لا توجد منتجات في هذه الفئة',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }
          
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemCount: cubit.productsOfCategory.length,
            itemBuilder: (context, index) => ProductItemWidget(
              product: cubit.productsOfCategory[index],
            ),
          );
        },
      ),
    );
  }
}