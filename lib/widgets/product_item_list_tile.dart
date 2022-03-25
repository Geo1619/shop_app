import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

import '../providers/product_data.dart';

class ProductItemListTile extends StatelessWidget {
  const ProductItemListTile(
      {Key? key, required this.title, required this.imageUrl, required this.id})
      : super(key: key);

  final String id;
  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100.0,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName, arguments: id);
                },
                icon: const Icon(Icons.edit),
                color: Theme.of(context).colorScheme.primary),
            IconButton(
              onPressed: () async {
                final shouldDelete = await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: const Text('Confirm action'),
                          content:
                              Text('Are you sure you want to delete "$title"'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop(false);
                              },
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop(true);
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        ));
                if (shouldDelete) {
                  try {
                    await Provider.of<ProductData>(context, listen: false)
                        .deleteProduct(id);
                    scaffoldMessenger.showSnackBar(
                        SnackBar(content: Text('"$title" deleted!')));
                  } catch (e) {
                    // using .of(context) directly inside a Future causes
                    // Unhandled Exception: Looking up a deactivated widget's ancestor is unsafe.
                    // store it in variable inside the build method

                    // ScaffoldMessenger.of(context)
                    scaffoldMessenger.showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              },
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
