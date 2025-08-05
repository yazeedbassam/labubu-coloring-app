class DrawingModel {
  final String id;
  final String name;
  final String lineArtPath;
  final String coloredSamplePath;
  final bool isFree;
  final double? price;
  final String? productId;

  DrawingModel({
    required this.id,
    required this.name,
    required this.lineArtPath,
    required this.coloredSamplePath,
    required this.isFree,
    this.price,
    this.productId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lineArtPath': lineArtPath,
      'coloredSamplePath': coloredSamplePath,
      'isFree': isFree,
      'price': price,
      'productId': productId,
    };
  }

  factory DrawingModel.fromJson(Map<String, dynamic> json) {
    return DrawingModel(
      id: json['id'],
      name: json['name'],
      lineArtPath: json['lineArtPath'],
      coloredSamplePath: json['coloredSamplePath'],
      isFree: json['isFree'],
      price: json['price']?.toDouble(),
      productId: json['productId'],
    );
  }
}