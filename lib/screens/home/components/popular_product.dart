import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../components/product_card.dart';
import '../../../constants.dart';
import '../../../models/Product.dart';
import '../../../providers/sdk_provider.dart';

import '../../../size_config.dart';
import 'section_title.dart';

class PopularProducts extends StatefulWidget {
  const PopularProducts({super.key});

  @override
  State<PopularProducts> createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
  late Future<List<Product>> getPopularProducts;

  @override
  void initState() {
    getPopularProducts = context.read<SdkProvider>().getPopularProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(title: "Popular Products", press: () {}),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: FutureBuilder<List<Product>>(
            future: getPopularProducts,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final demoProducts = snapshot.data!;
                return Row(
                  children: [
                    ...List.generate(
                      demoProducts.length,
                      (index) => ProductCard(product: demoProducts[index]),
                    ),
                    SizedBox(width: getProportionateScreenWidth(20)),
                  ],
                );
              } else if (snapshot.hasError) {
                return const Text('Some Error Occured');
              } else {
                return const CircularProgressIndicator(color: kPrimaryColor);
              }
            },
          ),
        )
      ],
    );
  }
}
