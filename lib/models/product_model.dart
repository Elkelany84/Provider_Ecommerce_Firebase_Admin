class ProductModel {
  final String productId,
      productTitle,
      productPrice,
      productDescription,
      productQuantity,
      productImage,
      productCategory;

  ProductModel(
      {required this.productId,
      required this.productTitle,
      required this.productPrice,
      required this.productDescription,
      required this.productQuantity,
      required this.productImage,
      required this.productCategory});
}
