import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/execeptions/http_exception.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {

  final Product product;
  const ProductItem(this.product,{super.key});

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.name),
      // ignore: sized_box_for_whitespace
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.PRODUCT_FORM,
                  arguments: product,
                );
              }, 
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.primary,
              )
            ),
            IconButton(
              icon: Icon(
                color: Theme.of(context).colorScheme.error,
                Icons.delete
              ),
              onPressed: () {
                 showDialog<bool>(
                  context: context,
                   builder: (ctx) => AlertDialog(
                    title: const Text('Confirmar exclusão'),
                    content: const Text('Deseja realmente excluir este item?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                        }, 
                        child: const Text('Sim')
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        }, 
                        child: const Text('Não')
                      ),
                    ],
                   ),
                 ).then((value) async{
                  if(value ?? false) {
                    try {
                    await Provider.of<ProductList>(
                      context,
                      listen: false,
                    ).removeProduct(product);
                    } on HttpException catch(error) {
                      msg.showSnackBar(
                        SnackBar(
                          content: Text(error.toString()),
                        ),
                      );
                    }
                  }
                 });
              }, 
            ),
          ],
        ),
      ),
    );
  }
}