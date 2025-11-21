/// Represents a single vegetable product.
class Vegetable {
  final String nameEn;
  final String nameHi;
  final int marketPrice;
  final int ourPrice;
  final String emoji;

  Vegetable({
    required this.nameEn,
    required this.nameHi,
    required this.marketPrice,
    required this.ourPrice,
    required this.emoji,
  });

  // Override equality to correctly compare Vegetable objects in lists/sets
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vegetable &&
          runtimeType == other.runtimeType &&
          nameEn == other.nameEn &&
          nameHi == other.nameHi;

  @override
  int get hashCode => nameEn.hashCode ^ nameHi.hashCode;
}

