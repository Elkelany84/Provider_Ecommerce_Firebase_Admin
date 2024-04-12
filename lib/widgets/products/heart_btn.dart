import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:hadi_ecommerce_firebase_admin/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

class HeartButtonWidget extends StatefulWidget {
  const HeartButtonWidget({
    super.key,
    this.bgColor = Colors.transparent,
    this.size = 20,
    required this.productId,
    // this.isInWishlist = false
  });
  final Color bgColor;
  final double size;
  final String productId;
  // final bool? isInWishlist;

  @override
  State<HeartButtonWidget> createState() => _HeartButtonWidgetState();
}

class _HeartButtonWidgetState extends State<HeartButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(
      context,
    );
    // final wishlistModel = Provider.of<WishListModel>(
    //   context,
    // );
    return Container(
      decoration: BoxDecoration(color: widget.bgColor, shape: BoxShape.circle),
      child: IconButton(
        style: IconButton.styleFrom(elevation: 10),
        onPressed: () async {
          // wishlistProvider.addOrRemoveFromWishlist(
          //   productId: widget.productId,
          // );
          if (wishlistProvider.wishlistItems.containsKey(widget.productId)) {
            await wishlistProvider.deleteProductFromWishListFirebase(
                wishListId: wishlistProvider
                    .wishlistItems[widget.productId]!.wishListId,
                productId: widget.productId);
          } else {
            await wishlistProvider.addToWishListFirebase(
                productId: widget.productId, context: context);
          }
          await wishlistProvider.getWishListItemsFromFirebase();
        },
        icon: Icon(
          wishlistProvider.isProductInWishlist(productId: widget.productId)
              ? IconlyBold.heart
              : IconlyLight.heart,
          size: widget.size,
          color:
              wishlistProvider.isProductInWishlist(productId: widget.productId)
                  ? Colors.red
                  : Colors.grey,
        ),
      ),
    );
  }
}
