import 'package:shoply/core/model/response/category_response.dart';
import 'package:shoply/feature/home/controller/home_cubit.dart';
import 'package:shoply/feature/home/view/product_of_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabContainerWidget extends StatelessWidget {
  const TabContainerWidget({
    super.key,
    required this.categories,
  });
  final List<CategoryResponse> categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider<HomeCubit>(
                    create: (context) => HomeCubit(),
                    child: const ProductOfCategoryScreen(),
                  ),
                  settings: RouteSettings(
                    name: ProductOfCategoryScreen.routeName,
                    arguments: category,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Column(
                children: [
                  Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        color: const Color(0xffF0F0F0),
                        width: 1.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(33),
                      child: Image.network(
                        category.image ?? 'https://via.placeholder.com/100',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.category_outlined,
                            color: Colors.grey,
                            size: 32,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.name ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff212121),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
